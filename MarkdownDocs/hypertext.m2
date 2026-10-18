-- Macaulay2 markup as Markdown: the same per-type dispatch Core uses for `html`,
-- `info` and `net`, producing the Markdown constructs of markdown.m2. Examples and
-- usage lines become `m2` code blocks, mathematics stays raw TeX (non-hypertext
-- values become math, as `html Thing` does), and a documentation link becomes a
-- page link into its package's directory when that package is linked, and a link
-- to its page on the Macaulay2 website otherwise.

coreInternal := name -> value Core#"private dictionary"#name
getPrimaryTag := coreInternal "getPrimaryTag"
fixup := coreInternal "fixup"
isMissingDoc := coreInternal "isMissingDoc"
isUndocumented := coreInternal "isUndocumented"
redoMENU := coreInternal "redoMENU"
toFilename := coreInternal "toFilename"
toURL := coreInternal "toURL"
headline := coreInternal "headline"

needsPackage "Text"
-----------------------------------------------------------------------------
-- Documentation pages. A page is a package and a page name, the file stem of
-- its installed HTML page; the Macaulay2 website serves the installed
-- documentation tree under its root.
-----------------------------------------------------------------------------

onlineDocumentation = "https://macaulay2.com/doc/Macaulay2/"

onlinePage = (pkgname, page) -> concatenate(
    onlineDocumentation, replace("PKG", pkgname, Layout#1#"packagehtml"), page, ".html"
)

-- Package and page name of a tag's documentation, or null when the node has no
-- page (missing or undocumented), mirroring html TO2.
documentationPage = tag -> (
    if tag.Format != tag.Package then
        tag = getPrimaryTag fixup tag;
    if isUndocumented tag or isMissingDoc tag then
        return null;
    fkey := format tag;
    (tag.Package, if fkey === tag.Package then "index" else toFilename fkey)
)

linkStyles := set {"markdown", "wikilink"}

-- A page of a package directory, beside the directory of the current package:
-- "markdown" links it as a Markdown file, page.md within the current package and
-- ../package/page.md otherwise; "wikilink" as [[package/page|text]]. The link
-- text is a list of inline elements.
packagePageLink = (linkStyle, pkgname, page, text) -> (
    if linkStyle === "wikilink" then
        Wikilink prepend(pkgname | "/" | page, text)
    else MdLink prepend(
        if pkgname === currentPackage#"pkgname" then page | ".md" else concatenate("../", pkgname, "/", page, ".md"),
        text)
)

-----------------------------------------------------------------------------
-- Conversion stores Markdown nodes. Documentation targets stay unresolved until
-- rendering; the package writer supplies its local-file resolver at that point.
-----------------------------------------------------------------------------

markdown = method(Dispatch => Thing)
toMarkdown = markdown

-- Children of markup: a Sequence among them stands for its elements.
childrenOf := x -> deepSplice toList x

-- Literal text of a subtree, ignoring markup and attributes.
plainText = method(TypicalValue => String)
plainText String := identity
plainText Option := plainText Nothing := x -> ""
plainText Hypertext := x -> concatenate apply(childrenOf x, plainText)
plainText Thing := toString

hypertextAttribute := (x, name) -> (
    found := select(toList x, e -> instance(e, Option) and e#0 === name);
    if #found > 0 then (last found)#1
)

contents := x -> select(childrenOf x, e -> not instance(e, Option))

-- Markup that is a block itself, or holds one.
isBlock = method(TypicalValue => Boolean)
isBlock Thing := x -> false
isBlock Hypertext := x -> any(contents x, isBlock)
isBlock HypertextVoid := x -> false
isBlock MarkdownBlock :=
    isBlock HypertextParagraph :=
    isBlock HypertextContainer :=
    isBlock HR := x -> true

isLink = method(TypicalValue => Boolean)
isLink Thing := x -> false
isLink TO := isLink TO2 := isLink TOH := isLink HREF := x -> true

-- Code without links in it, which adjacent code joins into one span.
codeTypes := {TT, CODE, KBD, SAMP, VAR}
isPlainCode := method()
isPlainCode Thing := x -> false
scan(codeTypes, T -> isPlainCode T := x -> not any(contents x, isLink))

-- Assembly helpers, not conversion methods. Adjacent code shares one span.
-- Inline context reduces embedded blocks (e.g. a paragraph in a table cell)
-- to inline content, and renders preformatted blocks as inline code.
inlineOf := method()
inlineRun := children -> flatten sublists(children, isPlainCode,
    run -> {MdCode concatenate apply(run, plainText)},
    c -> inlineOf(c))

inlineOf Thing := x -> {markdown x}
inlineOf Hypertext := x -> (
    if isBlock x then
        flatten between(" ", sublists(contents x, c -> not isBlock c,
            run -> inlineRun(run), c -> inlineOf(c)))
    else {markdown(x)}
)
inlineOf PRE := inlineOf ExampleItem := x -> {MdCode plainText x}

-- Each maximal run of inline content is one paragraph.
blocksOf := children -> flatten sublists(children, c -> not isBlock c,
    run -> {MdParagraph inlineRun(run)},
    c -> {markdown(c)})

-- Values already in Markdown pass through. Strings are escaped prose; other
-- non-markup values use their TeX representation, as in Core's html Thing.
markdown Markdown := Markdown => identity
markdown String := MarkdownInline => s -> new MarkdownInline from {s}
markdown Thing := MdMath => x -> MdMath texMath x
markdown Nothing :=
    markdown Option :=
    markdown COMMENT :=
    markdown ANCHOR :=
    markdown SCRIPT :=
    markdown STYLE := MarkdownInline => x -> new MarkdownInline from ""

-- Unrecognized markup still converts recursively through its contents.
markdown Hypertext := Markdown => x -> (
    if isBlock x then MdDocument blocksOf(contents x)
    else new MarkdownInline from inlineRun(contents x)
)
markdown HypertextParagraph := MdParagraph => x -> MdParagraph inlineRun(contents x)
markdown Sequence :=
    markdown List := MdDocument => x -> MdDocument blocksOf(childrenOf x)
markdown LATER := Markdown => x -> markdown(x#0())

-- Links

linkText := x -> concatenate(format x#0, if x#?1 then x#1)
-- A documentation link retains its tag (or an installed page's package/page
-- pair) and label. It is still an inline Markdown link, not a rendered URL.
MdDocLink = new MdType of MdLink
documentationLink := (target, text) -> MdDocLink {target, text}

-- Resolve only at output. Kept outside markdown.m2: these rules depend on M2's
-- documentation layout. A renderer may instead supply another ResolveLink.
resolveDocumentationLink = (link, linked, style, sourcePackage) -> (
    target := first link;
    page := if instance(target, Sequence) then target else documentationPage target;
    text := drop(toList link, 1);
    if page === null then
        return new MarkdownInline from append(text, " (missing documentation)");
    if not linkStyles#?style then
        error("MarkdownDocs: unknown LinkStyle ", toString style);
    if linked === true or member(page#0, linked) then (
        if style === "wikilink" then Wikilink prepend(page#0 | "/" | page#1, text)
        else MdLink prepend(
            if page#0 === sourcePackage then page#1 | ".md"
            else concatenate("../", page#0, "/", page#1, ".md"), text)
    )
    else MdLink prepend(onlinePage(page#0, page#1), text)
)

render MdDocLink := String => opts -> link -> (
    resolved := if opts.ResolveLink === null then
        resolveDocumentationLink(link, {}, "markdown", "")
        else opts.ResolveLink link;
    if instance(resolved, MdDocLink) then
        error "MarkdownDocs: ResolveLink must return a resolved link or inline text";
    render(resolved, opts)
)

markdown TO := MarkdownInline => x -> documentationLink(x#0, linkText x)
markdown TO2 := MarkdownInline => x -> documentationLink(x#0, x#1)
markdown TOH := MarkdownInline => x -> new MarkdownInline from {
    markdown(TO toList x),
    if (h := headline x#0) =!= null then " -- " | h else ""}

-- The website serves a single-tree install (Layout#1); local installs are split
-- (Layout#2). Map prefix-relative installed paths to their website locations.
onlineInstallPath := path -> (
    splitPrefixes := select(keys Layout#2, key -> match("\\A" | regexQuote Layout#2#key, path));
    if #splitPrefixes == 0 then return path;
    key := last sort(splitPrefixes, key -> #Layout#2#key);
    Layout#1#key | substring(#Layout#2#key, path)
)
installedFiles := path -> select(apply(prefixPath, prefix -> prefix | path), fileExists)
installedPagePattern := replace("PKG", "([^/]+)", regexQuote Layout#1#"packagehtml") |
    ///([^/#]+)\.html\z///

markdown HREF := MarkdownInline => x -> (
    url := first x;
    text := if #x > 1 then inlineRun(drop(childrenOf x, 1)) else {url};
    page := regex(installedPagePattern, url);
    if page =!= null then new MdDocLink from prepend((substring(page#1, url), substring(page#2, url)), text)
    else MdLink prepend(
        if #installedFiles url > 0 then onlineDocumentation | onlineInstallPath url else toURL url,
        text)
)

-- The writer copies installed images beside the pages using these names.
installedImages = new MutableHashTable
markdown IMG := MdImage => x -> (
    src := hypertextAttribute(x, "src");
    installed := installedFiles src;
    source := if #installed == 0 then toURL src else (
        installedImages#(first installed) = "images/" | baseFilename first installed);
    MdImage(source, hypertextAttribute(x, "alt") ?? "")
)

-- Inline constructs

markdown LITERAL := MdHTML => x -> MdHTML concatenate contents x
markdown BR := MdHTML => x -> MdHTML "<br>"
markdown BOLD := markdown STRONG := MdStrong => x -> MdStrong inlineRun(contents x)
markdown EM := markdown ITALIC := MdEmphasis => x -> MdEmphasis inlineRun(contents x)

scan({SUB, SUP, SMALL}, T -> markdown T := MarkdownInline => x -> (
    tag := toLower toString T;
    new MarkdownInline from join(
        {MdHTML("<" | tag | ">")}, inlineRun(contents x), {MdHTML("</" | tag | ">")})
))

-- A link inside code remains a link; the text around it stays code.
scan(codeTypes, T -> markdown T := MarkdownInline => x -> (
    if not any(contents x, isLink) then MdCode plainText x
    else new MarkdownInline from apply(contents x, c ->
        if isLink c then markdown(c) else MdCode plainText c)
))

-- Block constructs

markdown MENU := Markdown => x -> markdown(redoMENU x)
markdown HR := MdRule => x -> MdRule()
markdown IFRAME := MdParagraph => x -> MdParagraph MdHTML html x

headingLevels := {HEADER1, HEADER2, HEADER3, HEADER4, HEADER5, HEADER6}
scan(#headingLevels, i -> markdown headingLevels#i := MdHeading => x ->
    MdHeading prepend(i + 1, inlineRun(contents x)))
markdown SUBSECTION := MdHeading => x -> MdHeading prepend(2, inlineRun(contents x))

codeLanguages := hashTable {"macaulay2" => "m2", "bib" => "bibtex"}
languageOf := x -> (
    code := select(contents x, c -> instance(c, CODE));
    classes := demark(" ", select({hypertextAttribute(x, "class"),
        if #code > 0 then hypertextAttribute(first code, "class")}, c -> instance(c, String)));
    found := regex(///(?:\A|\s)language-([^\s]+)///, classes);
    if found === null then return "text";
    language := substring(found#1, classes);
    if codeLanguages#?language then codeLanguages#language else "text"
)
markdown PRE := MdCodeBlock => x -> MdCodeBlock(languageOf x, plainText x)
markdown ExampleItem := MdCodeBlock => x -> MdCodeBlock("m2", plainText x)
markdown BLOCKQUOTE := MdQuote => x -> MdQuote blocksOf(contents x)
markdown UL := MarkdownBlock => x -> (
    makeList := items -> MdList apply(items, item -> blocksOf(contents item));
    -- Core groups the synopsis sections in a UL. Present their labels as
    -- headings, keeping each section's own list or code block below it.
    element := c -> if instance(c, LI) and #contents c == 1 then first contents c else c;
    isElement := c -> instance(element c, DL) and hypertextAttribute(element c, "class") === "element";
    titleOf := c -> (
        e := element c;
        if not instance(e, Hypertext) or #contents e < 2 then return null;
        label := first contents e;
        if instance(label, String) and member(replace(///:\s*\z///, "", label),
            {"Inputs", "Outputs", "Consequences", "Function", "Operator", "Scripted functor"}) then
            replace(///:\s*\z///, "", label)
        else if instance(label, TO2) and label#1 === "Optional inputs" then markdown label
    );
    isSection := c -> isElement c or titleOf c =!= null;
    if any(contents x, isSection) then
        MdDocument flatten sublists(contents x, c -> not isSection c,
            run -> {makeList run}, c -> {
                if isElement c then markdown element c
                else MdDocument prepend(MdHeading(3, titleOf c),
                    blocksOf drop(contents element c,
                        if instance(first contents element c, TO2) then 2 else 1))})
    else makeList contents x
)
markdown OL := MdOrderedList => x -> MdOrderedList apply(contents x, item -> blocksOf(contents item))

-- Definition lists: bold terms, with consecutive lone-code descriptions sharing
-- a code block. Other descriptions retain their blocks.
isLoneCode := dd -> (c := contents dd; #c == 1 and instance(first c, CODE))
markdown DL := MdDocument => x -> MdDocument flatten apply(
    sublists(contents x, e -> instance(e, DD), identity, identity),
    group -> (
        if instance(group, DT) then {
            if hypertextAttribute(x, "class") === "element" then
                MdHeading(3, replace(///:\s*\z///, "", plainText group))
            else MdParagraph MdStrong inlineRun(contents group)}
        else if all(group, isLoneCode) then {MdCodeBlock("m2", demark("\n", apply(group, plainText)))}
        else flatten apply(group, dd -> blocksOf(contents dd)))
)

-- Example sessions are a table of one-cell rows; anything else is a Markdown table.
-- Remove structural document wrappers so adjacent example blocks can be grouped.
exampleBlocks := x -> if instance(x, MdDocument) then
    flatten apply(toList x, exampleBlocks) else {x}

markdown TABLE := MarkdownBlock => x -> (
    rows := select(contents x, r -> instance(r, TR));
    if hypertextAttribute(x, "class") === "examples" then (
        blocks := flatten apply(rows, r -> flatten apply(blocksOf(contents r), exampleBlocks));
        return MdDocument flatten sublists(blocks,
            b -> instance(b, MdCodeBlock) and b#0 === "m2",
            run -> {MdCodeBlock("m2", demark("\n\n", apply(run, b -> b#1)))},
            b -> {b})
    );
    cells := select(apply(rows, r -> apply(select(contents r, c -> instance(c, TD)), c ->
        inlineOf(new SPAN from contents c))), r -> #r > 0);
    MdTable cells
)
