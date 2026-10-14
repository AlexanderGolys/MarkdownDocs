-- -*- coding: utf-8 -*-
newPackage(
    "MarkdownDocs",
    Version => "0.2",
    Date => "October 15, 2026",
    Headline => "Markdown documentation from Macaulay2 package documentation",
    Authors => {{Name => "Alexander Golys", Email => "alexandergolys@gmail.com"}},
    Keywords => {"Documentation"},
    PackageExports => {"Text"},
    DebuggingMode => false
    )

export {
    "markdownBlocks",
    "markdownInline",
    "markdownPage",
    "writePackageMarkdown",
    "writeMarkdownIndex",
    "LinkedPackages"
    }

-- The documentation internals that Core's own html renderer and installPackage use;
-- the hypertext types come from Text.
coreInternal := name -> value Core#"private dictionary"#name
getPrimaryTag         := coreInternal "getPrimaryTag"
fixup                 := coreInternal "fixup"
isMissingDoc          := coreInternal "isMissingDoc"
isUndocumented        := coreInternal "isUndocumented"
isSecondaryTag        := coreInternal "isSecondaryTag"
fetchRawDocumentation := coreInternal "fetchRawDocumentation"
redoMENU              := coreInternal "redoMENU"
deepSelect            := coreInternal "deepSelect"
toFilename            := coreInternal "toFilename"
toURL                 := coreInternal "toURL"
removeFiles           := coreInternal "removeFiles"
headline              := coreInternal "headline"

-----------------------------------------------------------------------------
-- Markdown rendering of Hypertext
--
-- The same per-type dispatch Core uses for `html`, `info` and `net`, written for
-- CommonMark as mdBook reads it: text is escaped, examples and usage lines become
-- fenced `m2` blocks, non-hypertext values become `$texMath$` exactly as
-- `html Thing` does, and documentation links resolve to Markdown pages. Core's own `markdown` targets Jekyll (Liquid raw tags, kramdown
-- attributes, links to installed .html files), hence separate methods.
-----------------------------------------------------------------------------

markdownBlocks = method(Dispatch => Thing, TypicalValue => List)
markdownInline = method(Dispatch => Thing, TypicalValue => String)

escapeMarkdown := s -> replace(///[\\`*_\[\]<>|~&]///, ///\\$&///, s)

-- A paragraph is one line; a leading list/heading/quote marker is escaped so it
-- stays text.
paragraph := s -> (
    line := replace(///\A\s+|\s+\z///, "", replace(///\s+///, " ", s));
    replace(///\A([#>+=-]|\d+[.)])///, ///\\$1///, line))

longestBacktickRun := s -> max prepend(0, apply(select(///`+///, s), r -> #r))

codeSpan := s -> (
    if not match(///\S///, s) then return "";
    ticks := concatenate(longestBacktickRun s + 1 : "`");
    padding := if match(///\A`|`\z///, s) then " " else "";
    concatenate(ticks, padding, s, padding, ticks))

-- Leading and trailing blank lines removed, line by line: a whitespace regex
-- anchored at the end exceeds Boost's complexity bound on long example output.
trimBlankLines := s -> (
    textLines := lines s;
    nonBlank := positions(textLines, l -> match(///\S///, l));
    if #nonBlank == 0 then "" else demark("\n", take(textLines, {first nonBlank, last nonBlank})))

codeFence := (language, s) -> (
    ticks := concatenate(max(3, longestBacktickRun s + 1) : "`");
    concatenate(ticks, language, newline, trimBlankLines s, newline, ticks))

-- Literal text of a subtree, ignoring markup and attributes.
plainText = method(Dispatch => Thing)
plainText String    := identity
plainText Option    :=
plainText Nothing   := String => x -> ""
plainText Hypertext := String => x -> concatenate apply(toList x, plainText)
plainText Thing     := toString

hypertextAttribute := (x, name) -> (
    found := select(toList x, e -> instance(e, Option) and e#0 === name);
    if #found > 0 then (last found)#1)

contents := x -> select(toList x, e -> not instance(e, Option))

isBlock = x -> (
    instance(x, HypertextParagraph) or instance(x, HypertextContainer) or instance(x, HR)
    or instance(x, Hypertext) and not instance(x, HypertextVoid) and any(contents x, isBlock))

codeTypes := {TT, CODE, KBD, SAMP, VAR}
isLink := x -> instance(x, TO) or instance(x, TO2) or instance(x, TOH) or instance(x, HREF)
isPlainCode := x -> any(codeTypes, T -> instance(x, T)) and not any(contents x, isLink)

-- Inline content; adjacent code elements share one span, since touching code
-- spans do not parse as two.
inlineRun := children -> concatenate sublists(children, isPlainCode,
    run -> codeSpan replace(///\s+///, " ", concatenate apply(run, plainText)),
    markdownInline)

-- Mixed content: each maximal run of inline nodes is one paragraph.
blocksOf := children -> select(
    flatten sublists(children, c -> not isBlock c,
        run -> {paragraph inlineRun run},
        markdownBlocks),
    b -> match(///\S///, b))

-----------------------------------------------------------------------------
-- Links. Each package's pages sit in a directory of their own, the directories
-- side by side. Links within the package being rendered are page links, links
-- into a linked package (one whose pages sit beside it) are ../<package>/ page
-- links, and any other link goes to the package's page on the Macaulay2 website,
-- which serves the installed documentation tree under this root.
-----------------------------------------------------------------------------

onlineDocumentation := "https://macaulay2.com/doc/Macaulay2/"

-- Rendering state, set by writePackageMarkdown: the linked packages, and the
-- installed images the pages show (installed file => path in the package directory).
linkedPackages := new MutableHashTable
pageImages := new MutableHashTable

onlinePage := (pkgname, stem) -> concatenate(
    onlineDocumentation, replace("PKG", pkgname, Layout#1#"packagehtml"), stem, ".html")

-- Package and page name (file stem) of a tag's documentation, or null when the
-- node has no page (missing or undocumented), mirroring html TO2. The page names
-- are those of the installed HTML.
documentationPage := tag -> (
    if tag.Format != tag.Package then tag = getPrimaryTag fixup tag;
    if isUndocumented tag or isMissingDoc tag then return null;
    fkey := format tag;
    (tag.Package, if fkey === tag.Package then "index" else toFilename fkey))

-- Page file of a tag within its package's directory.
pageFile := tag -> (documentationPage tag)#1 | ".md"

-- A page of the current package, of a linked package, or of the website.
pageTarget := (pkgname, stem) -> (
    if pkgname === currentPackage#"pkgname" then stem | ".md"
    else if linkedPackages#?pkgname then concatenate("../", pkgname, "/", stem, ".md")
    else onlinePage(pkgname, stem))

markdownLink := (tag, text) -> (
    page := documentationPage tag;
    if page === null then return text | " (missing documentation)";
    concatenate("[", text, "](<", pageTarget page, ">)"))

linkText := x -> escapeMarkdown concatenate(format x#0, if x#?1 then x#1)

markdownInline TO  := x -> markdownLink(x#0, linkText x)
markdownInline TO2 := x -> markdownLink(x#0, escapeMarkdown x#1)
markdownInline TOH := x -> concatenate(
    markdownInline TO toList x,
    if (h := headline x#0) =!= null then (" -- ", escapeMarkdown h))

-- A path relative to an install prefix as the website names it: the website
-- serves a single-tree install (Layout#1), a local install is split (Layout#2).
onlineInstallPath := path -> (
    splitPrefixes := select(keys Layout#2, key -> match("\\A" | regexQuote Layout#2#key, path));
    if #splitPrefixes == 0 then return path;
    key := last sort(splitPrefixes, key -> #Layout#2#key);
    Layout#1#key | substring(#Layout#2#key, path))

-- Files installed with a package are named relative to its install prefix.
installedFiles := path -> select(apply(prefixPath, prefix -> prefix | path), fileExists)

-- An installed documentation page named by its path; captures package and page name.
installedPagePattern := replace("PKG", "([^/]+)", regexQuote Layout#1#"packagehtml") | ///([^/#]+)\.html\z///

-- Links to installed documentation pages resolve like documentation links;
-- links to other files installed with a package point to them on the website.
hrefTarget := url -> (
    page := regex(installedPagePattern, url);
    if page =!= null then pageTarget(substring(page#1, url), substring(page#2, url))
    else if #installedFiles url > 0 then onlineDocumentation | onlineInstallPath url
    else toURL url)

markdownInline HREF := x -> (
    url := hrefTarget first x;
    text := if #x > 1 then inlineRun drop(toList x, 1) else escapeMarkdown url;
    concatenate("[", text, "](<", url, ">)"))

markdownInline IMG := x -> (
    src := hypertextAttribute(x, "src");
    installed := installedFiles src;
    target := if #installed == 0 then toURL src else (
        pageImages#(first installed) = "images/" | baseFilename first installed);
    concatenate("![", escapeMarkdown(hypertextAttribute(x, "alt") ?? ""), "](<", target, ">)"))

-----------------------------------------------------------------------------
-- Inline markup
-----------------------------------------------------------------------------

markdownInline String  := escapeMarkdown
markdownInline Nothing :=
markdownInline Option  :=
markdownInline COMMENT :=
markdownInline ANCHOR  :=
markdownInline SCRIPT  :=
markdownInline STYLE   := x -> ""
markdownInline LITERAL := x -> concatenate contents x
markdownInline BR      := x -> "<br>"
markdownInline LATER   := x -> markdownInline x#0()
markdownInline Thing   := x -> "$" | escapeMarkdown texMath x | "$"

markdownInline Hypertext := x -> (
    if isBlock x then demark(" ", markdownBlocks x)
    else inlineRun contents x)

emphasis := delimiter -> x -> (
    inner := inlineRun contents x;
    if match(///\S///, inner) then delimiter | inner | delimiter else inner)
markdownInline BOLD   :=
markdownInline STRONG := emphasis "**"
markdownInline EM     :=
markdownInline ITALIC := emphasis "*"

scan({SUB, SUP, SMALL}, T -> markdownInline T := x -> (
    tag := toLower toString T;
    concatenate("<", tag, ">", inlineRun contents x, "</", tag, ">")))

-- Code spans; a link inside code keeps working and the text around it stays code.
scan(codeTypes, T -> markdownInline T := x -> (
    if not any(contents x, isLink) then codeSpan replace(///\s+///, " ", plainText x)
    else concatenate apply(contents x, c -> if isLink c then markdownInline c else codeSpan plainText c)))

-----------------------------------------------------------------------------
-- Blocks
-----------------------------------------------------------------------------

markdownBlocks Thing     := x -> {paragraph markdownInline x}
markdownBlocks Nothing   :=
markdownBlocks Option    :=
markdownBlocks COMMENT   :=
markdownBlocks SCRIPT    :=
markdownBlocks STYLE     := x -> {}
markdownBlocks LATER     := x -> markdownBlocks x#0()
markdownBlocks Hypertext := x -> blocksOf contents x
markdownBlocks MENU      := x -> markdownBlocks redoMENU x
markdownBlocks HR        := x -> {"***"}
markdownBlocks IFRAME    := x -> {html x}

heading := (level, x) -> {concatenate(level : "#", " ", paragraph inlineRun contents x)}
headingLevels := {HEADER1, HEADER2, HEADER3, HEADER4, HEADER5, HEADER6}
scan(#headingLevels, i -> (T := headingLevels#i; markdownBlocks T := x -> heading(i + 1, x)))
markdownBlocks SUBSECTION := x -> heading(2, x)

codeLanguages := hashTable {"language-macaulay2" => "m2"}
languageOf := x -> (
    code := select(contents x, c -> instance(c, CODE));
    language := if #code > 0 then hypertextAttribute(first code, "class");
    if codeLanguages#?language then codeLanguages#language else "text")
markdownBlocks PRE         := x -> {codeFence(languageOf x, plainText x)}
markdownBlocks ExampleItem := x -> {codeFence("m2", plainText x)}

markdownBlocks BLOCKQUOTE := x -> {
    replace("(?m)^", "> ", demark("\n>\n", blocksOf contents x))}

-- List items continue on lines indented past their marker.
listItem := (marker, item) -> (
    itemLines := separate("\n", demark("\n", blocksOf contents item));
    indent := concatenate(#marker : " ");
    demark("\n", prepend(marker | first itemLines,
        apply(drop(itemLines, 1), l -> if l == "" then l else indent | l))))
markdownBlocks UL := x -> {demark("\n", apply(contents x, item -> listItem("- ", item)))}
markdownBlocks OL := x -> {demark("\n", apply(#contents x, i -> listItem(toString(i + 1) | ". ", (contents x)#i)))}

-- Definition lists: a term in bold. Usage lists (terms whose descriptions are
-- lone code) collect their code into one highlighted block.
isLoneCode := dd -> (c := contents dd; #c == 1 and instance(first c, CODE))
markdownBlocks DL := x -> flatten apply(
    sublists(contents x, e -> instance(e, DD), identity, identity),
    group -> (
        if instance(group, DT) then {"**" | paragraph markdownInline(new SPAN from contents group) | "**"}
        else if all(group, isLoneCode) then {codeFence("m2", demark("\n", apply(group, plainText)))}
        else flatten apply(group, dd -> blocksOf contents dd)))

-- Example sessions are a table of one-cell rows; anything else is a GFM table.
markdownBlocks TABLE := x -> (
    rows := select(contents x, r -> instance(r, TR));
    if hypertextAttribute(x, "class") === "examples" then return flatten apply(rows, r -> blocksOf contents r);
    cells := apply(rows, r -> apply(select(contents r, c -> instance(c, TD)), c ->
            paragraph markdownInline new SPAN from contents c));
    cells = select(cells, r -> #r > 0);
    if #cells == 0 then return {};
    width := max apply(cells, r -> #r);
    row := r -> "| " | demark(" | ", join(r, (width - #r) : "")) | " |";
    {demark("\n", join({row first cells, concatenate("|", width : "---|")}, apply(drop(cells, 1), row)))})

-- mdBook expands `{{#...}}` anywhere in a chapter, code included; `\{{#` is its escape.
protectDirectives := s -> replace(///\{\{#///, ///\\{{#///, s)

markdownPage = method(TypicalValue => String)
markdownPage DocumentTag := tag -> protectDirectives(demark("\n\n", markdownBlocks help tag) | "\n")
markdownPage Thing := key -> markdownPage makeDocumentTag key

-----------------------------------------------------------------------------
-- Package pages and table of contents, as installPackage builds them
-----------------------------------------------------------------------------

-- The nodes installHTML writes a page for.
hasPage := tag -> not (isUndocumented tag or isSecondaryTag tag or isMissingDoc tag)

packageTags := pkg -> (
    db := pkg#"raw documentation database";
    rawTags := join(
        apply(values pkg#"raw documentation", rawdoc -> rawdoc.DocumentTag),
        if db =!= null then apply(keys db, fkey -> (value db#fkey).DocumentTag) else {});
    symbolTags := apply(select(pairs pkg.Dictionary, (name, sym) -> not match("\\$", name)),
        (name, sym) -> makeDocumentTag(sym, Package => pkg));
    top := makeDocumentTag(pkg#"pkgname", Package => pkg);
    byKey := new MutableHashTable;
    scan(join({top}, symbolTags, rawTags), tag -> if not byKey#?(format tag) then byKey#(format tag) = tag);
    select(values byKey, hasPage))

-- The subnode graph and depth-first forest of installPackage's
-- assembleTree/makeForest. Core gives a node reached from several parents an
-- empty subtree after the first; here later occurrences are dropped, since a
-- chapter can appear only once in a book.
subnodeSections := {Description, Acknowledgement, Contributors, References, Caveat}

subnodesOf := (pkg, tag) -> (
    rawdoc := fetchRawDocumentation tag;
    if rawdoc === null then return {};
    content := apply(select(subnodeSections, section -> rawdoc#?section), section -> rawdoc#section);
    isSubnodeLink := e -> instance(e, BasicList) and #e > 0 and e#0 === ("class" => "subnode");
    sublinks := deepSelect(content, isSubnodeLink);
    subnodes := deepSelect(join(sublinks, if rawdoc#?Subnodes then rawdoc.Subnodes else ()), DocumentTag);
    getPrimaryTag \ select(fixup \ subnodes, node -> package node === pkg))

-- {(tag, depth)} in table-of-contents order, the top node first at depth 0.
packageOutline := (pkg, tags) -> (
    top := makeDocumentTag(pkg#"pkgname", Package => pkg);
    graph := hashTable apply(tags, tag -> tag => subnodesOf(pkg, tag));
    roots := unique prepend(top, sort toList(set keys graph - set flatten values graph));
    listed := new MutableHashTable;
    visit := (tag, depth) -> (
        if listed#?tag or not graph#?tag then return {};
        listed#tag = true;
        prepend((tag, depth), flatten apply(graph#tag, child -> visit(child, depth + 1))));
    flatten apply(roots, root -> visit(root, if root === top then 0 else 1)))

-----------------------------------------------------------------------------
-- Writing Markdown. <dir>/<package>/ holds a package's pages, its SUMMARY.md
-- (the table of contents, in mdBook's format, so the directory is a ready mdBook
-- source) and the images the pages show. Package directories sit side by side.
-----------------------------------------------------------------------------

directoryIn := (dir, name) -> replace("/+\\z", "", dir) | "/" | name

writePackageMarkdown = method(Options => {LinkedPackages => {}})
writePackageMarkdown(String, String)  := opts -> (name, dir) -> writePackageMarkdown(needsPackage name, dir, opts)
writePackageMarkdown(Package, String) := opts -> (pkg, dir) -> (
    name := pkg#"pkgname";
    packageDir := directoryIn(dir, name);
    removeFiles packageDir;
    makeDirectory packageDir;
    scan(keys linkedPackages, key -> remove(linkedPackages, key));
    scan(opts.LinkedPackages, linked -> linkedPackages#linked = true);
    scan(keys pageImages, key -> remove(pageImages, key));
    -- render keys unqualified within their own package, as installHTML does
    enclosingPackage := currentPackage;
    currentPackage = pkg;
    (summary, failure) := trap (
        tags := packageTags pkg;
        pages := apply(tags, pageFile);
        if #unique pages != #pages then error("MarkdownDocs: page names collide in ", name);
        scan(tags, pages, (tag, page) -> (packageDir | "/" | page) << markdownPage tag << close);
        outline := packageOutline(pkg, tags);
        summaryEntry := (tag, depth) -> concatenate(
            (depth - 1) : "  ", "- [", escapeMarkdown format tag, "](<", pageFile tag, ">)");
        concatenate(
            "# Summary\n\n[", escapeMarkdown name, "](<", pageFile (first outline)#0, ">)\n\n",
            demark("\n", apply(drop(outline, 1), summaryEntry)), "\n"));
    currentPackage = enclosingPackage;
    if failure =!= null then error toString failure;
    (packageDir | "/SUMMARY.md") << summary << close;
    if #pageImages > 0 then makeDirectory(packageDir | "/images");
    scan(pairs pageImages, (file, image) -> copyFile(file, packageDir | "/" | image));
    packageDir)

-- Packages with installed documentation, as makePackageIndex finds them
-- (the first prefix providing a package wins).
documentedPackages := () -> (
    found := new MutableHashTable;
    flatten apply(prefixPath, prefix -> flatten apply(values Layout, layout -> (
        docdir := prefix | layout#"docdir";
        if not isDirectory docdir then return {};
        names := select(sort readDirectory docdir, name ->
            not found#?name
            and fileExists(prefix | replace("PKG", name, layout#"packagehtml") | "index.html"));
        scan(names, name -> found#name = true);
        names))))

writeMarkdownIndex = method()
writeMarkdownIndex(List, String) := (names, dir) -> (
    entry := (name, target) -> (
        headline := (readPackage name).Headline;
        concatenate("- [", name, "](<", target, ">)",
            if headline =!= null then (" -- ", escapeMarkdown headline), "\n"));
    listed := set names;
    others := select(documentedPackages(), name -> not listed#?name);
    file := directoryIn(dir, "index.md");
    makeDirectory replace("[^/]*\\z", "", file);
    file << concatenate("# Macaulay2 documentation\n\n",
        "## Packages\n\n",
        apply(sort names, name -> entry(name, name | "/index.md")),
        if #others > 0 then ("\n## Other installed packages\n\n",
            "Documented on the [Macaulay2 website](<", onlineDocumentation, ">).\n\n",
            apply(others, name -> entry(name, onlinePage(name, "index"))))) << close;
    file)

-----------------------------------------------------------------------------

beginDocumentation()

doc ///
Node
  Key
    MarkdownDocs
  Headline
    Markdown documentation from Macaulay2 package documentation
  Description
    Text
      This package writes the documentation of Macaulay2 packages as Markdown: one
      directory of pages per package, with a table of contents, the way
      @TO installPackage@ writes one directory of HTML pages per package.

      A page is exactly what @TO installPackage@ renders to HTML -- the hypertext
      @TO help@ assembles for a documentation node, with usage, inputs, outputs,
      examples and their stored output -- serialized by @TO markdownBlocks@
      instead of @TO html@. The table of contents follows the package's
      documentation tree, and is written in the {\tt SUMMARY.md} format of
      @HREF{"https://rust-lang.github.io/mdBook/", "mdBook"}@, so each package
      directory is a ready mdBook source; building books from it is left to mdBook.
    Example
      markdownInline TT "ring R"
      first markdownBlocks UL {"one", TO "ring"}
  Subnodes
    writePackageMarkdown
    writeMarkdownIndex
    markdownPage
    markdownBlocks
Node
  Key
    writePackageMarkdown
    (writePackageMarkdown, String, String)
    (writePackageMarkdown, Package, String)
    [writePackageMarkdown, LinkedPackages]
    LinkedPackages
  Headline
    write a package's documentation as Markdown
  Usage
    writePackageMarkdown(name, dir)
  Inputs
    name:String
      a package, loaded if needed
    dir:String
      the directory the package directory is written in
    LinkedPackages => List
      the names of the packages whose directories sit beside this one
  Outputs
    :String
      the package directory, {\tt dir/name}
  Consequences
    Item
      the package directory holds a Markdown page for each documentation node,
      named as in the installed HTML documentation, a {\tt SUMMARY.md} with the
      package's top node as introduction and the documentation tree as chapters,
      and an {\tt images} directory with the images the pages show
  Description
    Text
      Links to the package's own pages are relative page links, links into a
      linked package go to {\tt ../package/page.md}, and links into any other
      package go to its page on the Macaulay2 website. Mathematics is written
      between dollar signs, as in the HTML documentation.
    CannedExample
      i1 : writePackageMarkdown("Graphs", "docs", LinkedPackages => {"Macaulay2Doc"})

      o1 = docs/Graphs
  SeeAlso
    writeMarkdownIndex
Node
  Key
    writeMarkdownIndex
    (writeMarkdownIndex, List, String)
  Headline
    write an index of package documentation
  Usage
    writeMarkdownIndex(names, dir)
  Inputs
    names:List
      the names of the packages whose directories are in {\tt dir}
    dir:String
  Outputs
    :String
      the index page, {\tt dir/index.md}
  Description
    Text
      The index lists the given packages, linked to their directories, and then
      every other installed package with documentation, linked to the Macaulay2
      website.
    CannedExample
      i1 : writeMarkdownIndex({"Graphs", "Macaulay2Doc"}, "docs")

      o1 = docs/index.md
Node
  Key
    markdownPage
    (markdownPage, DocumentTag)
    (markdownPage, Thing)
  Headline
    a documentation page as Markdown
  Usage
    markdownPage key
  Inputs
    key:
      a documentation key, such as a function, a method key, or a string
  Outputs
    :String
      the page @TO help@ shows for the key, as Markdown
  Description
    Example
      print markdownPage "VerticalSpace"
Node
  Key
    markdownBlocks
    markdownInline
  Headline
    render hypertext as Markdown
  Usage
    markdownBlocks x
    markdownInline x
  Inputs
    x:
      hypertext, or any other value
  Outputs
    :
      for {\tt markdownBlocks}, a @TO List@ of Markdown blocks; for
      {\tt markdownInline}, a @TO String@ of inline Markdown
  Description
    Text
      Like @TO html@, these are methods with a case for each hypertext type, and
      can be extended to new types. Paragraph and container hypertext renders as
      blocks, the rest inline; text is escaped for CommonMark, and other values
      render as $\TeX$ math, as in the HTML documentation.
    Example
      markdownInline SPAN {"see ", TO "ideal", " and ", TT "I_0"}
      markdownBlocks DIV {HEADER2 "Ideals", PARA {"generated by ", TT "x"}}
      markdownInline (QQ[x])
///

TEST ///
  assert(markdownInline TT "ring R" == "`ring R`")
  assert(markdownInline "a_b*c" == "a\\_b\\*c")
  assert(markdownInline SPAN {TT "f", TT "(x)"} == "`f(x)`")
  assert(markdownBlocks UL {"one", "two"} == {"- one\n- two"})
  assert(markdownBlocks PRE "x = 1" == {"```text\nx = 1\n```"})
  assert(markdownBlocks HEADER2 "Ideals" == {"## Ideals"})
  assert(markdownBlocks DIV {"a", PARA "b"} == {"a", "b"})
  assert(markdownInline TT "a`b" == "``a`b``")
  -- an installed documentation page named by path links like a documentation key
  installedLink := markdownInline HREF {"/usr/share/doc/Macaulay2/Complexes/html/_free__Resolution.html", "f"};
  assert match("Complexes.*_free__Resolution\\.html>\\)\\z", installedLink);
  assert not match("/usr/share", installedLink)
///

TEST ///
  dir := temporaryFileName();
  packageDir := writePackageMarkdown("FirstPackage", dir);
  assert(packageDir == dir | "/FirstPackage");
  summary := get(packageDir | "/SUMMARY.md");
  assert match("\\[FirstPackage\\]\\(<index.md>\\)", summary);
  assert match("firstFunction", summary);
  assert fileExists(packageDir | "/index.md");
  indexPage := writeMarkdownIndex({"FirstPackage"}, dir);
  assert match("\\(<FirstPackage/index.md>\\)", get indexPage)
///

TEST ///
  -- links into a linked package are Markdown page links beside the package
  dir := temporaryFileName();
  packageDir := writePackageMarkdown("FirstPackage", dir, LinkedPackages => {"Macaulay2Doc"});
  page := get(packageDir | "/" | first select(readDirectory packageDir, f -> match("first__Function", f)));
  assert match("\\(<\\.\\./Macaulay2Doc/[^>]*\\.md>\\)", page)
///

end--

restart
debug needsPackage "MarkdownDocs"
check "MarkdownDocs"
writePackageMarkdown("Graphs", "docs")
