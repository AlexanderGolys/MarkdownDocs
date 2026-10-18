-- Structured Markdown, independent of Macaulay2 documentation and mdBook.
-- Constructors retain their contents. Strings in content are prose; Markdown
-- nodes retain their own syntax. Only render/toString produce text.
-- Markdown itself is a raw-text leaf; MarkdownInline can group inline nodes.
Markdown = new Type of BasicList
MarkdownBlock = new Type of Markdown
MarkdownInline = new Type of Markdown

render = method(Options => {ResolveLink => null})
render Markdown := String => opts -> x -> concatenate toList x
toString Markdown := x -> render x
net Markdown := x -> net toString x

-- Normalize construct, item, or cell contents to a list.
-- Example: contentsOf {1, 2}   -->   {1, 2}
--          contentsOf 1   -->   {1}
contentsOf := x -> if instance(x, VisibleList) then toList x else {x}

-- A construct stores a list, sequence, or single element as structured contents.
-- Example: instance(MdParagraph, MdType)   -->   true
MdType = new Type of Type

-- Example: toString MdLink("https://example.org", "site")   -->   [site](https://example.org)
-- Example: toString MdParagraph "one"   -->   one
MdType Thing := (T, x) -> new T from contentsOf x

-- Shared storage constructors do no rendering or link resolution.
new Markdown from List := (T, contents) -> newClass(T, contents)
new Markdown from String := (T, s) -> newClass(T, {s})
-- A raw String fragment remains verbatim; a List contains structured inlines.
new MarkdownInline from String := (T, s) -> new T from {new Markdown from s}

-----------------------------------------------------------------------------
-- Text
-----------------------------------------------------------------------------

-- Backslash-escapes the characters that CommonMark would read as markup.
-- Example: escapeMarkdown "a_b*c"   -->   a\_b\*c
escapeMarkdown := s -> replace(///[\\`*_\[\]<>|~&$]///, ///\\$&///, s)

-- The math delimiters of the HTML documentation's KaTeX setup that Markdown math
-- shares: display $$...$$ and inline $...$.
mathSpan := ///\$\$[\s\S]+?\$\$|\$[^$]+\$///

-- Prose: escaped for CommonMark, except mathematics, which stays raw TeX.
-- Example: escapeText "x_1 and $x_1$"   -->   x\_1 and $x_1$
escapeText := s -> (
    pieces := {};
    while (span := regex(mathSpan, s)) =!= null do (
        pieces = append(pieces, escapeMarkdown substring(0, span#0#0, s) |
                substring(span#0, s));
        s = substring(span#0#0 + span#0#1, s)
    );
    concatenate append(pieces, escapeMarkdown s)
)

-- Runs of whitespace in prose become one space: the line breaks and indentation
-- of the source are not part of the text. Code keeps its spaces.
-- Example: collapseSpaces "a \n  b"   -->   a b
collapseSpaces := s -> replace(///\s+///, " ", s)

-- The ends of a line of inline text trimmed, its inside left as it is.
-- Example: trimSpaces "  a `x  y` "   -->   a `x  y`
trimSpaces := s -> replace(///\A\s+|\s+\z///, "", s)

-- A paragraph is one line, its prose without line breaks; a leading
-- list/heading/quote marker is escaped so it stays text.
-- Example: paragraph "- not a list"   -->   \- not a list
paragraph := s -> replace(///\A([#>+=-]|\d+[.)])///, ///\\$1///, trimSpaces s)

-- The length of the longest run of backticks in s (0 if none).
-- Example: longestBacktickRun "a``b`"   -->   2
longestBacktickRun := s -> max prepend(0, apply(select(///`+///, s), r -> #r))

-- Leading and trailing blank lines removed, line by line: a whitespace regex
-- anchored at the end exceeds Boost's complexity bound on long example output.
-- Example: trimBlankLines "\n\na\n\nb\n\n"   -->   "a\n\nb"
trimBlankLines := s -> (
    textLines := lines s;
    nonBlank := positions(textLines, l -> match(///\S///, l));
    if #nonBlank == 0 then
        ""
    else demark("\n", take(textLines, {first nonBlank, last nonBlank}))
)

-----------------------------------------------------------------------------
-- Contents
-----------------------------------------------------------------------------

-- An element of inline content: Markdown text as it is, any other value its
-- text, escaped.
inlineText := method()
inlineText (Thing, OptionTable) := (e, opts) -> escapeText collapseSpaces toString e
inlineText (Markdown, OptionTable) := (e, opts) -> render(e, opts)
inlineText (MarkdownBlock, OptionTable) := (e, opts) ->
    error("MarkdownDocs: a block in inline content: ", toString e)

-- Example: contentText {"a*b", MdCode "x", MdMath "x^2"}   -->   a\*b`x`$x^2$
contentText := (elements, opts) -> concatenate apply(toList elements, e ->
        inlineText(e, opts))

-- Inline fragments without an enclosing construct, such as a SPAN's contents.
render MarkdownInline := String => opts -> contents -> contentText(contents, opts)

-- Mixed content: each maximal run of inline elements is one paragraph; a list
-- in it stands for its elements.
-- Example: blocksText {"a", MdRule(), "b"}   -->   {"a", "***", "b"}
blocksText := (elements, opts) -> select(
    sublists(flatten toList elements, e -> not instance(e, MarkdownBlock),
        run -> paragraph contentText(run, opts),
        b -> render(b, opts)),
    text -> match(///\S///, text)
)

-----------------------------------------------------------------------------
-- Inline constructs
-----------------------------------------------------------------------------

-- Inline code, fenced by more backticks than the contents contain; empty when
-- blank. The contents are taken as they are, spaces included; a line break is a
-- space, as CommonMark reads it. CommonMark strips one space from each end of
-- code that starts and ends with a space, and padding absorbs that, as it lets
-- code start or end with a backtick.
-- Example: toString MdCode "a`b"   -->   ``a`b``
--          toString MdCode "\"a  b\""   -->   `"a  b"`
MdCode = new MdType of MarkdownInline
render MdCode := String => opts -> contents -> (
    code := replace(///\r?\n///, " ", concatenate contents);
    if not match(///\S///, code) then
        return "";
    ticks := concatenate(longestBacktickRun code + 1 : "`");
    padding := if match(///\A`|`\z|\A [\s\S]* \z///, code) then " " else "";
    concatenate(ticks, padding, code, padding, ticks)
)

-- Inline math: raw TeX between $...$.
-- Example: toString MdMath "x^2"   -->   $x^2$
MdMath = new MdType of MarkdownInline
render MdMath := String => opts -> contents -> "$" | concatenate contents | "$"

-- Raw HTML, taken as it is.
-- Example: toString MdHTML("<b>", "x", "</b>")   -->   <b>x</b>
MdHTML = new MdType of MarkdownInline
render MdHTML := String => opts -> contents -> concatenate contents

-- Contents between delimiters, or nothing when they are blank.
-- Example: toString MdEmphasis "hi"   -->   *hi*
MdEmphasis = new MdType of MarkdownInline
render MdEmphasis := String => opts -> contents -> (
    inner := trimSpaces contentText(contents, opts);
    if inner == "" then
        inner
    else "*" | inner | "*"
)

-- Example: toString MdStrong("a", "b")   -->   **ab**
MdStrong = new MdType of MarkdownInline
render MdStrong := String => opts -> contents -> (
    inner := trimSpaces contentText(contents, opts);
    if inner == "" then
        inner
    else "**" | inner | "**"
)

-- MdLink(url, inlines...)
-- Example: toString MdLink("https://example.org", "site")   -->   [site](https://example.org)
MdLink = new MdType of MarkdownInline
render MdLink := String => opts -> contents -> (
    if not instance(contents#0, String) and opts.ResolveLink =!= null then
        return render(opts.ResolveLink contents, opts);
    concatenate("[", contentText(drop(contents, 1), opts), "](", toString contents#0, ")")
)

-- Wikilink(target, inlines...): [[target|text]], or [[target]] without text;
-- the text escapes | and ].
-- Example: toString Wikilink("Pkg/page", "text")   -->   [[Pkg/page|text]]
--          toString Wikilink "Pkg/page"   -->   [[Pkg/page]]
Wikilink = new MdType of MarkdownInline
render Wikilink := String => opts -> contents -> (
    if not instance(contents#0, String) and opts.ResolveLink =!= null then
        return render(opts.ResolveLink contents, opts);
    text := contentText(drop(contents, 1), opts);
    concatenate("[[", toString contents#0, if text != "" then ("|", text), "]]")
)

-- MdImage(source, alt)
-- Example: toString MdImage("a.png", "alt")   -->   ![alt](a.png)
MdImage = new MdType of MarkdownInline
render MdImage := String => opts -> contents ->
    concatenate("![", escapeMarkdown(if contents#?1 then contents#1 else ""),
        "](", contents#0, ")")

-----------------------------------------------------------------------------
-- Block constructs
-----------------------------------------------------------------------------

-- A whole document: its blocks separated by blank lines.
-- Example: toString MdDocument {"a", MdRule(), "b"}   -->   "a\n\n***\n\nb"
MdDocument = new MdType of MarkdownBlock
render MdDocument := String => opts -> contents -> demark("\n\n",
    blocksText(contents, opts))

-- Example: toString MdParagraph {"a  b"}   -->   a b
MdParagraph = new MdType of MarkdownBlock
render MdParagraph := String => opts -> contents ->
    paragraph contentText(contents, opts)

-- MdHeading(level, inlines...)
-- Example: toString MdHeading(2, "Title")   -->   ## Title
MdHeading = new MdType of MarkdownBlock
render MdHeading := String => opts -> contents ->
    concatenate(contents#0 : "#", " ", paragraph contentText(drop(contents, 1), opts))

-- MdCodeBlock(language, code): fenced by more backticks than the code contains.
-- Example: toString MdCodeBlock("m2", "1+1")   -->   "```m2\n1+1\n```"
MdCodeBlock = new MdType of MarkdownBlock
render MdCodeBlock := String => opts -> contents -> (
    (language, code) := (contents#0, contents#1);
    ticks := concatenate(max(3, longestBacktickRun code + 1) : "`");
    concatenate(ticks, language, newline, trimBlankLines code, newline, ticks)
)

-- A thematic break.
-- Example: toString MdRule()   -->   ***
MdRule = new MdType of MarkdownBlock
render MdRule := String => opts -> contents -> "***"

-- A block quote: its blocks, every line prefixed by "> ".
-- Example: toString MdQuote {MdParagraph "a"}   -->   "> a"
MdQuote = new MdType of MarkdownBlock
render MdQuote := String => opts -> contents ->
    replace("(?m)^", "> ", demark("\n>\n", blocksText(contents, opts)))

-- An item's lines continue indented past its marker.
-- Example: listItem("- ", {"a", MdList {"b"}})   -->   "- a\n  - b"
listItem := (marker, item, opts) -> (
    itemLines := separate("\n", demark("\n", blocksText(contentsOf item, opts)));
    indent := concatenate(#marker : " ");
    demark("\n", prepend(marker | first itemLines,
        apply(drop(itemLines, 1), l -> if l == "" then l else indent | l)))
)

-- A bulleted list: one item per element.
-- Example: toString MdList {"a", "b"}   -->   "- a\n- b"
MdList = new MdType of MarkdownBlock
render MdList := String => opts -> items -> 
    demark("\n", apply(toList items, item -> listItem("- ", item, opts)))

-- A numbered list: one item per element.
-- Example: toString MdOrderedList {"a", "b"}   -->   "1. a\n2. b"
MdOrderedList = new MdType of MarkdownBlock
render MdOrderedList := String => opts -> items ->
    demark("\n", apply(#items, i -> listItem(toString(i + 1) | ". ", items#i, opts)))

-- A row is a list of cells, the first row the header.
-- Example: toString MdTable {{"x", "y"}, {"1", "2"}}   -->   "| x | y |\n|---|---|\n| 1 | 2 |"
MdTable = new MdType of MarkdownBlock
render MdTable := String => opts -> rows -> (
    cells := apply(toList rows, r -> apply(r, c -> replace("[|]", "\\\\|",
        paragraph contentText(contentsOf c, opts))));
    if #cells == 0 then
        return "";
    width := max apply(cells, r -> #r);
    row := r -> "| " | demark(" | ", join(r, (width - #r) : "")) | " |";
    demark("\n", join({row first cells, concatenate("|", width : "---|")},
           apply(drop(cells, 1), row)))
)
