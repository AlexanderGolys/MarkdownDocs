-- mdBook sources. A directory of Markdown documentation, as markdown.m2 writes
-- it, becomes an mdBook source from its own files: SUMMARY.md from contents.md,
-- book.toml from a template, and the math macros beside the directories.

-- The head of Core's HTML documentation pages, holding its KaTeX setup.
defaultHEAD := value Core#"private dictionary"#"defaultHEAD"

-----------------------------------------------------------------------------
-- The table of contents. SUMMARY.md is the directory's contents.md in mdBook's
-- format: the introduction is the prefix chapter, the nested list the numbered
-- chapters, and an item without a link (a menu section) a draft chapter.
-----------------------------------------------------------------------------

contentsHeading := "# Contents"
introductionLink := ///\A# Contents\n\n\[([^\n]*)\]\(index\.md\)\n///

unescapeMarkdown := s -> replace(///\\(.)///, "$1", s)

-- The introduction's title, as the reader sees it.
introductionTitle := contents -> (
    link := regex(introductionLink, contents);
    if link === null then
        error "MarkdownDocs: contents.md does not start with a heading and a link to index.md";
    unescapeMarkdown substring(link#1, contents)
)

summaryMarkdown := contents -> "# Summary" | replace(///(?m)^( *- )(?!\[)([^\n]*)$///, ///$1[$2]()///,
    substring(#contentsHeading, contents))

-----------------------------------------------------------------------------
-- book.toml, from a template (the bundled one, or the configured "BookTemplate")
-----------------------------------------------------------------------------

configuration := () -> (options MarkdownDocs).Configuration

bundledBookTemplate := get(currentFileDirectory | "book.toml")
bundledBookStyle := get(currentFileDirectory | "book.css")

-- The contents of a TOML basic string.
tomlString := s -> replace(///[\\"]///, ///\\$&///, s)

-- Each @PLACEHOLDER@ replaced by its text, taken literally: replace reads its
-- replacement as a format, where backslashes and dollar signs are special.
fillTemplate := (template, placeholders) -> fold((filled, placeholder) -> replace(placeholder,
    replace(///[\\$]///, ///\\$&///, placeholders#placeholder), filled), template, keys placeholders)

bookTemplate := () -> (
    template := (configuration())#"BookTemplate";
    if template == "" then
        bundledBookTemplate
    else get template
)

-- The source of mdbook-tsitter's Macaulay2 grammar: its built-in list's pinned
-- release, or the configured git repository (a URL or a local checkout) at its
-- HEAD, since a listed language otherwise keeps the pinned revision.
grammarSource := () -> (
    grammar := (configuration())#"TreeSitterGrammar";
    if grammar == "" then
        ""
    else concatenate("git = \"", tomlString grammar, "\"\nrev = \"HEAD\"\n")
)

bookConfiguration := (name, title) -> fillTemplate(bookTemplate(), hashTable {
    "@NAME@" => name,
    "@TITLE@" => tomlString title,
    "@GRAMMAR@" => grammarSource()})

-----------------------------------------------------------------------------
-- Math macros
-----------------------------------------------------------------------------

-- mdbook-katex renders math into the page before mdBook parses the Markdown, and
-- KaTeX draws \tilde as a literal "~", so two of them in a paragraph become
-- strikethrough around everything between them; \widetilde is drawn as SVG.
strikethroughSafeMacros := ///\tilde:\widetilde/// | "\n"

-- \name:definition lines, the macros file format of mdbook-katex, from the macros
-- object of the KaTeX setup in defaultHEAD (JavaScript string literals), followed
-- by the overrides Markdown needs.
katexMacros := () -> (
    katex := html first select(toList defaultHEAD "", node -> instance(node, LITERAL) and match(
        "katex", html node
    ));
    macrosObject := substring((regex(///var macros = \{([\s\S]*?)\n\s*\}///, katex))#1, katex);
    unescape := s -> replace(///\\\\///, ///\\///, s);
    concatenate apply(select(///"[^"]*":\s*"[^"]*"///, macrosObject), pair -> (
        (name, definition) := toSequence apply(select(///"[^"]*"///, pair), q -> unescape substring(
            1, #q - 2, q
        ));
        name | ":" | definition | "\n"
    )) | strikethroughSafeMacros
)

-----------------------------------------------------------------------------

writeBookFiles = method(Options => {BookTitle => null})
writeBookFiles String := String => opts -> dir -> (
    bookDir := replace("/+\\z", "", dir);
    contents := get(bookDir | "/contents.md");
    title := opts.BookTitle ?? introductionTitle contents;
    (bookDir | "/SUMMARY.md") << summaryMarkdown contents << close;
    (bookDir | "/book.toml") << bookConfiguration(baseFilename bookDir, title) << close;
    (bookDir | "/book.css") << bundledBookStyle << close;
    (bookDir | "/../katex-macros.txt") << katexMacros() << close;
    bookDir
)
