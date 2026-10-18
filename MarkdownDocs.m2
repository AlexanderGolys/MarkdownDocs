-- -*- coding: utf-8 -*-
newPackage(
    "MarkdownDocs",
    Version => "0.3",
    Date => "October 18, 2026",
    Headline => "Markdown documentation from Macaulay2 package documentation",
    Authors => {{
        Name => "Alexander Golys",
        Email => "alexandergolys@gmail.com"
    }},
    HomePage => "https://github.com/AlexanderGolys/MarkdownDocs",
    Keywords => {"Documentation"},
    PackageExports => {"Text"},
    AuxiliaryFiles => true,
    Configuration => {
        "BookTemplate" => "",
        "TreeSitterGrammar" => ""
    },
    DebuggingMode => false
)

export {
    -- Markdown
    "Markdown",
    "MarkdownBlock",
    "MdType",
    "MarkdownInline",
    "MdDocument",
    "MdParagraph",
    "MdHeading",
    "MdCodeBlock",
    "MdList",
    "MdOrderedList",
    "MdQuote",
    "MdTable",
    "MdRule",
    "MdCode",
    "MdEmphasis",
    "MdStrong",
    "MdLink",
    "Wikilink",
    "MdImage",
    "MdMath",
    "MdHTML",
    "render",
    "ResolveLink",
    "MdDocLink",
    -- Macaulay2 markup as Markdown
    "markdown",
    "toMarkdown",
    -- the documentation of an object, in two layouts
    "mdDocsPage",
    "mdBookPage",
    -- documentation directories
    "writeMdDocs",
    "writeMdBook",
    "LinkedPackages",
    "LinkStyle",
    "writeMarkdownIndex",
    -- mdBook sources
    "writeBookFiles",
    "BookTitle",
    -- books in the browser
    "mdDocs",
    "mdBook"
}

-- Markdown: its constructs as types, and their text
load "./MarkdownDocs/markdown.m2"
-- Macaulay2 markup converted to Markdown
load "./MarkdownDocs/hypertext.m2"
-- package documentation as directories of Markdown pages, in either layout
load "./MarkdownDocs/packages.m2"
-- the installed documentation's layout: a page for each documentation node
load "./MarkdownDocs/docsLayout.m2"
-- the book layout: methods as chapters, a page for every symbol
load "./MarkdownDocs/bookLayout.m2"
-- mdBook sources, made from the directories written
load "./MarkdownDocs/mdbook.m2"
-- the books built, served and opened in the browser
load "./MarkdownDocs/viewer.m2"

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

      It is built in layers. Markdown itself is a type for each construct, see
      @TO "Markdown syntax"@, whose @TO toString@ is its text.
      @TO markdown@ converts Macaulay2 markup (@TO "Macaulay2Doc :: hypertext list format"@)
      to Markdown. The documentation of an object is a page in one of two layouts:
      @TO mdDocsPage@ is the page @TO help@ shows, as the installed documentation
      has it, and @TO mdBookPage@ shows the installed methods of a function as
      chapters of its page. @TO writeMdDocs@ and @TO writeMdBook@ write the pages of
      a package in these layouts, with a table of contents, and
      @TO writeBookFiles@ makes a directory written an
      @HREF{"https://rust-lang.github.io/mdBook/", "mdBook"}@ source.
      @TO mdDocs@ and @TO mdBook@ do all of this and show the book in the browser,
      as @TO viewHelp@ shows the HTML documentation.

      Mathematics stays raw TeX between dollar signs, the convention of math-aware
      Markdown viewers and preprocessors. Links between pages are Markdown file
      links or wikilinks, see @TO LinkStyle@.
    Example
      markdown UL {"one", TT "ring R", TO "ring"}
  Subnodes
    :Markdown
    "Markdown syntax"
    render
    :Macaulay2 markup as Markdown
    markdown
    MdDocLink
    :The documentation of an object
    mdDocsPage
    mdBookPage
    :Documentation directories
    writeMdDocs
    writeMarkdownIndex
    "Markdown documentation layout"
    :mdBook sources
    writeBookFiles
    "mdBook configuration"
    :Books in the browser
    mdDocs
Node
  Key
    "Markdown syntax"
    Markdown
    MarkdownBlock
    MarkdownInline
    MdType
    MdDocument
    MdParagraph
    MdHeading
    MdCodeBlock
    MdList
    MdOrderedList
    MdQuote
    MdTable
    MdRule
    MdCode
    MdEmphasis
    MdStrong
    MdLink
    Wikilink
    MdImage
    MdMath
    MdHTML
    (toString, Markdown)
    (net, Markdown)
  Headline
    Markdown text and its constructs
  Description
    Text
      Markdown constructs retain their contents as a tree. Each construct is an
      @TO MdType@, applied to a list or a single element, as hypertext types are.
      Constructors store these contents without rendering. @TO render@
      produces the final text; @TO toString@ renders with the default settings.
      @TO Markdown@ itself can hold raw text, and @TO MarkdownInline@ can
      group inline contents. As in CommonMark, content is blocks
      (@TO MarkdownBlock@), on lines of their own, separated by blank lines, or
      inline (@TO MarkdownInline@), within a block. In contents, Markdown text is
      taken as it is, and a @TO String@ is text, escaped as Markdown, except
      mathematics between dollar signs, which stays raw TeX. Blocks are
    Code
      UL {
          {TT "MdDocument {blocks...}", ": blocks separated by blank lines"},
          {TT "MdParagraph {inlines...}"},
          {TT "MdHeading(level, inlines...)"},
          {TT "MdCodeBlock(language, code)"},
          {TT "MdList {items...}", ", ", TT "MdOrderedList {items...}",
              ": an item is a list of its contents, or its only element; it may hold blocks, such as a nested list"},
          {TT "MdQuote {blocks...}"},
          {TT "MdTable {rows...}", ": a row is a list of cells, the first row the header"},
          {TT "MdRule()"}}
    Text
      and inline elements (@TO MarkdownInline@) are
    Code
      UL {
          {TT "MdCode {text...}", ", ", TT "MdEmphasis {inlines...}", ", ",
              TT "MdStrong {inlines...}"},
          {TT "MdLink(url, inlines...)"},
          {TT "Wikilink(target, inlines...)", ": ", TT "[[target|text]]", "; ",
              TT "Wikilink target", " is ", TT "[[target]]"},
          {TT "MdImage(source, alt)"},
          {TT "MdMath tex", ": inline mathematics"},
          {TT "MdHTML html", ": raw HTML"}}
    Text
      Wherever blocks are expected, a run of inline elements, or a list of them, is
      a paragraph.
    Example
      MdDocument {
          MdHeading(2, "Ideals"),
          {"generated by ", MdCode "x", " and $y^2$, see ", Wikilink("Ideals/_x", "x")},
          MdList {"one", {"two", MdList {MdStrong "nested"}}}}
      toString MdList {"a_1", "b"}
  SeeAlso
    markdown
Node
  Key
    markdown
    toMarkdown
    (markdown, Thing)
    (markdown, Markdown)
    (markdown, String)
    (markdown, Nothing)
    (markdown, Option)
    (markdown, COMMENT)
    (markdown, ANCHOR)
    (markdown, SCRIPT)
    (markdown, STYLE)
    (markdown, Hypertext)
    (markdown, HypertextParagraph)
    (markdown, Sequence)
    (markdown, List)
    (markdown, LATER)
    (markdown, TO)
    (markdown, TO2)
    (markdown, TOH)
    (markdown, HREF)
    (markdown, IMG)
    (markdown, LITERAL)
    (markdown, BR)
    (markdown, BOLD)
    (markdown, STRONG)
    (markdown, EM)
    (markdown, ITALIC)
    (markdown, SUB)
    (markdown, SUP)
    (markdown, SMALL)
    (markdown, TT)
    (markdown, CODE)
    (markdown, KBD)
    (markdown, SAMP)
    (markdown, VAR)
    (markdown, MENU)
    (markdown, HR)
    (markdown, IFRAME)
    (markdown, HEADER1)
    (markdown, HEADER2)
    (markdown, HEADER3)
    (markdown, HEADER4)
    (markdown, HEADER5)
    (markdown, HEADER6)
    (markdown, PRE)
    (markdown, ExampleItem)
    (markdown, BLOCKQUOTE)
    (markdown, UL)
    (markdown, OL)
    (markdown, DL)
    (markdown, TABLE)
  Headline
    convert values to Markdown
  Usage
    markdown x
  Inputs
    x:
      hypertext, or any other value
  Outputs
    :Markdown
  Description
    Text
      Existing @TO Markdown@ is returned unchanged. Strings become escaped
      inline prose. Each markup type converts directly to its corresponding
      Markdown construct: @TT "TT"@ becomes @TO MdCode@, @TT "PARA"@ becomes
      @TO MdParagraph@, @TT "UL"@ becomes @TO MdList@, and so on. Containers,
      lists of content, and sequences become documents. Other values become
      @TO MdMath@ using their TeX representation.
      @TT "toMarkdown"@ is an alias for @TO markdown@.

      Each hypertext type converts to its Markdown construct: paragraphs,
      headings, lists, tables, code, links and so on. Examples and usage lines
      become @TT "m2"@ code blocks, and other values, such as rings, become
      mathematics, as in the HTML documentation.

      Documentation links become @TO MdDocLink@ nodes retaining their target and
      label. They are resolved only by @TO render@. Package export
      supplies local file links; the default rendering uses website links.
    Example
      markdown SPAN {"see ", TO "ideal", " and ", TT "I_0"}
      link = markdown TO "ideal";
      class link
      render link
      markdown (QQ[x])
      class markdown TT "x_1"
      class markdown PARA {"a ", BOLD "word"}
  SeeAlso
    mdDocsPage
    "Markdown syntax"
Node
  Key
    render
    (render, Markdown)
    (render, MarkdownInline)
    (render, MdCode)
    (render, MdMath)
    (render, MdHTML)
    (render, MdEmphasis)
    (render, MdStrong)
    (render, MdLink)
    (render, Wikilink)
    (render, MdImage)
    (render, MdDocument)
    (render, MdParagraph)
    (render, MdHeading)
    (render, MdCodeBlock)
    (render, MdRule)
    (render, MdQuote)
    (render, MdList)
    (render, MdOrderedList)
    (render, MdTable)
    [render, ResolveLink]
    ResolveLink
  Headline
    render a Markdown tree as text
  Usage
    render document
  Inputs
    document:Markdown
    ResolveLink => Function
      a function taking an unresolved link and returning a concrete Markdown link
      or inline text; the default @TO null@ uses the link type's default rendering
  Outputs
    :String
      Markdown without a trailing newline
  Description
    Text
      Rendering preserves the input tree. A resolver is passed to nested contents,
      so the same document can be rendered for different destinations. Ordinary
      links with String targets are already concrete and keep their destinations.
      This renderer knows Markdown syntax only; documentation-specific links and
      their default website resolution are provided by the markup conversion layer.
    Example
      mdTree = MdParagraph {"See ", MdLink("page.md", "the page"), "."};
      render mdTree
  SeeAlso
    markdown
    MdDocLink
Node
  Key
    MdDocLink
    (render, MdDocLink)
  Headline
    an unresolved documentation link
  Description
    Text
      @TO markdown@ converts documentation references to these inline nodes.
      Entry zero retains the documentation target; the remaining entries are
      the label contents. Constructors do not look up the target's page or URL.
      @TO render@ uses website links by default. The package writer
      supplies a @TO ResolveLink@ function that uses local Markdown files for
      exported packages and website links otherwise.
  SeeAlso
    markdown
    render
    writeMdDocs
Node
  Key
    mdDocsPage
    (mdDocsPage, Thing)
  Headline
    the documentation page of an object as Markdown
  Usage
    mdDocsPage key
  Inputs
    key:
      a documentation key, such as a function, a method key, or a string
  Outputs
    :MdDocument
      the page @TO help@ shows for the key
  Description
    Text
      This converts @TT "help key"@ to structured Markdown and appends a link to
      the original page on the Macaulay2 website, below the source location.
      The page title contains only its name; the short description appears in
      a blockquote immediately below it. Synopsis sections such as Usage, Inputs,
      Outputs, Optional inputs and Function use level-three headings.
      This website link keeps its destination when other links are rendered
      as local Markdown links or wikilinks.
    Example
      mdDocsPage "VerticalSpace"
  SeeAlso
    mdBookPage
    markdown
    writeMdDocs
Node
  Key
    mdBookPage
    (mdBookPage, Thing)
  Headline
    the documentation page of an object, with installed methods as chapters
  Usage
    mdBookPage key
  Inputs
    key:
      a documentation key, such as a function, a method key, or a string
  Outputs
    :MdDocument
      the page showing the key, in the layout of @TO writeMdBook@
  Description
    Text
      An installed method documented on a page of its own, such as
      @TT "(degree, Digraph, Thing)"@ in the package @TT "Graphs"@, is not a page
      here but a chapter of the page of its method function: @TO mdDocsPage@ of the
      method, with every heading one level deeper, below @TO mdDocsPage@ of the
      function. When the function is documented in another package, or nowhere,
      the page is made in the method's package, named after the function: its
      title is the function, followed by a line linking to its documentation,
      then the chapters of the methods that package installs.

      For a method key the page is the page holding its chapter; for any other key
      it is the key's own page, with the chapters of the methods shown on it, in
      order of their names. A chapter's heading is the method, as in
      @TT "degree(Digraph,Thing)"@; @TO writeMdBook@ links a method to its page,
      followed by the identifier mdBook gives that heading.
    Example
      mdBookPage "VerticalSpace"
  SeeAlso
    mdDocsPage
    writeMdBook
Node
  Key
    "Markdown documentation layout"
  Headline
    the files written for each package
  Description
    Text
      The package directories written by @TO writeMdDocs@ or @TO writeMdBook@ sit side by
      side, named like the packages, with the index written by
      @TO writeMarkdownIndex@ in a directory {\tt index} beside them. Every
      directory holds
    Code
      UL {
          {TT "index.md", ": the introduction, the top node of the package"},
          {TT "contents.md", ": the table of contents"},
          {"the other pages, named as in the installed HTML documentation; a page made for the methods of a function documented elsewhere is named after the function"},
          {TT "images", ": the images the pages show, when there are any"}}
    Text
      The table of contents is a heading {\tt # Contents}, a line linking to the
      introduction, then the documentation tree as a nested list, two spaces of
      indentation per level. An item is a link to a page, or the heading of a menu
      section, without a link, holding the pages of that section. Its links are
      always Markdown file links:
    Pre
      # Contents

      [FirstPackage](index.md)

      - [firstFunction](_first__Function.md)
      - Functions
        - [secondFunction](_second__Function.md)
    Text
      Each node appears once, where the depth-first walk of the menus, as
      @TO installPackage@ builds the documentation tree, reaches it first.
  SeeAlso
    writeMdDocs
    writeMarkdownIndex
Node
  Key
    writeMdDocs
    (writeMdDocs, String, String)
    (writeMdDocs, Package, String)
    [writeMdDocs, LinkedPackages]
    [writeMdDocs, LinkStyle]
    writeMdBook
    (writeMdBook, String, String)
    (writeMdBook, Package, String)
    [writeMdBook, LinkedPackages]
    [writeMdBook, LinkStyle]
    LinkedPackages
    LinkStyle
  Headline
    write a package's documentation as Markdown
  Usage
    writeMdDocs(name, dir)
    writeMdDocs(pkg, dir)
    writeMdBook(name, dir)
    writeMdBook(pkg, dir)
  Inputs
    name:String
      the name of a package, loaded if needed
    pkg:Package
    dir:String
      the directory the package directory is written in
    LinkedPackages => List
      the names of the packages whose directories sit beside this one, or
      @TO true@ for every package
    LinkStyle => String
      {\tt "markdown"} for Markdown file links, or {\tt "wikilink"} for wikilinks
  Outputs
    :String
      the package directory, {\tt dir/name}
  Consequences
    Item
      the package directory is replaced by the pages of the package, a table of
      contents and the images the pages show, as described in
      @TO "Markdown documentation layout"@
  Description
    Text
      @TT "writeMdDocs"@ writes @TO mdDocsPage@ of every documentation node, as
      the installed documentation has a page for each. @TT "writeMdBook"@ writes
      the pages of @TO mdBookPage@: a page for every node other than an installed
      method, which is a chapter of its function's page, and a page for each
      function documented elsewhere that the package installs documented methods
      for. Links to such a method point at its chapter's heading, as in
      {\tt _degree.md#degreedigraphthing}, or {\tt [[Graphs/_degree#degree(Digraph,Thing)]]}
      as a wikilink.

      Links within the package and into linked packages are page links; links into
      other packages go to their pages on the Macaulay2 website, which have a page
      for each node. Every page also links to its original website documentation
      below the source location. For wikilinks between packages:
    CannedExample
      i1 : writeMdDocs("Graphs", "vault", LinkStyle => "wikilink", LinkedPackages => true)

      o1 = vault/Graphs
  SeeAlso
    writeMarkdownIndex
    mdDocsPage
    mdBookPage
    mdDocs
Node
  Key
    writeMarkdownIndex
    (writeMarkdownIndex, List, String)
    [writeMarkdownIndex, LinkStyle]
  Headline
    write an index of package documentation
  Usage
    writeMarkdownIndex(names, dir)
  Inputs
    names:List
      the names of the packages whose directories are in {\tt dir}
    dir:String
    LinkStyle => String
      as for @TO writeMdDocs@
  Outputs
    :String
      the index directory, {\tt dir/index}
  Consequences
    Item
      the index directory holds the index as {\tt index.md} and a table of
      contents, as described in @TO "Markdown documentation layout"@
  Description
    Text
      The index lists the given packages, linked to their directories, and then
      every other installed package with documentation, linked to the Macaulay2
      website.
    CannedExample
      i1 : writeMarkdownIndex({"Graphs", "Macaulay2Doc"}, "docs")

      o1 = docs/index
  SeeAlso
    writeMdDocs
Node
  Key
    writeBookFiles
    (writeBookFiles, String)
    [writeBookFiles, BookTitle]
    BookTitle
  Headline
    make a directory of Markdown documentation an mdBook source
  Usage
    writeBookFiles dir
  Inputs
    dir:String
      a directory holding an {\tt index.md} and a {\tt contents.md}
    BookTitle => String
      the title of the book; by default the title of the introduction in
      {\tt contents.md}
  Outputs
    :String
      the directory
  Consequences
    Item
      the directory holds a {\tt SUMMARY.md}, a {\tt book.toml} and a
      {\tt book.css} for book presentation, and the
      directory containing it a {\tt katex-macros.txt}
  Description
    Text
      The table of contents in {\tt contents.md} is a heading {\tt # Contents}, a
      line linking to {\tt index.md}, then a nested list of links, where an item
      without a link holds a section of the items below it. In {\tt SUMMARY.md}
      the introduction is mdBook's prefix chapter, the list the numbered chapters,
      and an item without a link a draft chapter, numbered, without a page.
    CannedExample
      i1 : writeBookFiles("docs/index", BookTitle => "Macaulay2 documentation")

      o1 = docs/index
  SeeAlso
    "mdBook configuration"
Node
  Key
    "mdBook configuration"
  Headline
    the book.toml written with each directory
  Description
    Text
      Each directory is an mdBook source ({\tt src = "."}); books built from the
      directories must sit side by side, named like them, for links between the
      directories to resolve. The {\tt book.toml} turns off mdBook's own
      preprocessors, so that @TT "{{#...}}"@ in a page stays text, and declares
      the {\tt mdbook-katex} preprocessor, optional, with the math macros of the
      HTML documentation, written to {\tt katex-macros.txt} beside the directories.
      There {\tt \\tilde} is drawn as {\tt \\widetilde}: KaTeX draws it as a
      literal tilde, which Markdown would read as strikethrough.

      It also declares the {\tt mdbook-tsitter} preprocessor, optional, for
      {\tt m2} code, with the Macaulay2 grammar of its built-in list; it fetches
      and compiles the grammar on the first build and embeds its own stylesheet.

      The configuration options of this package, set in its configuration file
      (see @TO "Macaulay2Doc :: packages"@) or by @TO needsPackage@, adjust the {\tt book.toml}:
    Code
      UL {
          {TT "\"BookTemplate\"", ": a file to use instead of the bundled template; ",
              TT "@TITLE@", ", ", TT "@NAME@", " and ", TT "@GRAMMAR@",
              " are replaced by the book's title, its directory name, and the grammar's ",
              TT "git", " line"},
          {TT "\"TreeSitterGrammar\"", ": the git repository of the Macaulay2 grammar, a URL or ",
              "a local checkout, instead of the release ", TT "mdbook-tsitter", " pins"}}
  SeeAlso
    writeBookFiles
Node
  Key
    mdDocs
    (mdDocs, String)
    (mdDocs, Package)
    mdBook
    (mdBook, String)
    (mdBook, Package)
  Headline
    show a package's documentation as a book in the browser
  Usage
    mdDocs name
    mdDocs pkg
    mdBook name
    mdBook pkg
  Inputs
    name:String
      the name of a package, loaded if needed
    pkg:Package
  Outputs
    :String
      the address the book is served at
  Consequences
    Item
      the package directory is written by @TO writeMdDocs@ (for @TT "mdDocs"@) or
      @TO writeMdBook@ (for @TT "mdBook"@) below the application directory,
      in {\tt MarkdownDocs/docs/markdown} or {\tt MarkdownDocs/book/markdown},
      and made an mdBook source by @TO writeBookFiles@
    Item
      {\tt mdbook serve} serves the book in the background, and the browser opens it,
      as @TO viewHelp@ opens the HTML documentation
  Description
    Text
      The server keeps serving the book until Macaulay2 exits, and rebuilds it when
      its directory is written again, so that showing the package again reloads
      the page. Each book is served on its own port, the first on 3000. Links into
      other packages go to the Macaulay2 website. This needs {\tt mdbook} on the
      path; its output is written to {\tt MarkdownDocs/docs/<package>.log} or
      {\tt MarkdownDocs/book/<package>.log}.
    CannedExample
      i1 : mdBook "Graphs"

      o1 = http://127.0.0.1:3000/
  SeeAlso
    writeMdDocs
    writeBookFiles
///

TEST ///
  -- Markdown
  assert(instance(MdParagraph, MdType));
  assert(instance(MdParagraph "text", MarkdownBlock));
  assert(instance(MdCode "text", MarkdownInline));
  assert((toString new MdCode from {"x"}) == "`x`");
  assert((toString new MarkdownInline from "*raw*") == "*raw*");
  assert(toString MdParagraph("a", MdCode "b") == "a`b`");
  assert(toString MdParagraph(["a", "b"]) == "ab");
  -- prose whitespace collapses; code keeps its spaces
  assert(toString MdParagraph {"see \n   ", MdCode "\"a  b\"", "  now"} == "see `\"a  b\"` now");
  assert(toString MdStrong {MdCode "x  y"} == "**`x  y`**");
  assert(toString MdCode " a " == "`  a  `");
  assert(toString MdCode "a\nb" == "`a b`");
  assert(toString MdDocument {} == "");
  assert(toString MdList {"one", {"two", MdList {"three"}}} == "- one\n- two\n  - three");
  assert(toString MdOrderedList {"a", "b"} == "1. a\n2. b");
  assert(toString MdHeading(2, "a_b") == "## a\\_b");
  assert(toString MdTable {{"x", "y"}, {MdCode "a|b", "c"}} ==
      "| x | y |\n|---|---|\n| `a\\|b` | c |");
  assert(toString MdDocument {MdRule(), {"text"}} == "***\n\ntext");
  assert(toString MdParagraph {"- not a list"} == "\\- not a list");
  assert(toString MdLink("_f.md", "f_1") == "[f\\_1](_f.md)");
  assert(toString Wikilink("Pkg/_f", "f_1") == "[[Pkg/_f|f\\_1]]");
  assert(toString Wikilink "Pkg/_f" == "[[Pkg/_f]]");
  assert(toString Wikilink("P/p", "a|b") == "[[P/p|a\\|b]]")
///

TEST ///
  -- Macaulay2 markup
  md := x -> toString markdown x;
  assert(markdown === toMarkdown);
  inline := MdCode "a_b";
  block := MdParagraph "a_b";
  assert(markdown inline === inline);
  assert(markdown block === block);
  assert(md (QQ[x]) == toString MdMath texMath(QQ[x]));
  assert(md TT "ring R" == "`ring R`");
  assert(md "a_b*c" == "a\\_b\\*c");
  assert(md SPAN {TT "f", TT "(x)"} == "`f(x)`");
  assert(md UL {"one", "two"} == "- one\n- two");
  assert(md PRE "x = 1" == "```text\nx = 1\n```");
  assert(md PRE {"class" => "language-bib", CODE "@misc{Graphs}"} == "```bibtex\n@misc{Graphs}\n```");
  assert(md PRE {CODE {"class" => "language-macaulay2", "x = 1"}} == "```m2\nx = 1\n```");
  assert(md TABLE {"class" => "examples",
      TR {TD PRE {"class" => "language-macaulay2", CODE "i1 : 1\n\no1 = 1"}},
      TR {TD PRE {"class" => "language-macaulay2", CODE "i2 : 2\n\no2 = 2"}},
      TR {TD PARA "Explanation"},
      TR {TD PRE {"class" => "language-macaulay2", CODE "i3 : 3"}}} ==
      "```m2\ni1 : 1\n\no1 = 1\n\ni2 : 2\n\no2 = 2\n```\n\nExplanation\n\n```m2\ni3 : 3\n```");
  assert(md UL {DL {"class" => "element", DT "Usage:", DD CODE "f x"},
      LI {"Inputs:", UL {"x"}}, LI {"Outputs:", UL {"y"}}} ==
      "### Usage\n\n```m2\nf x\n```\n\n### Inputs\n\n- x\n\n### Outputs\n\n- y");
  assert match("\\A### Function\n\n\\[ring\\]", md UL {SPAN {"Function: ", TO "ring"}});
  assert(md HEADER2 "Ideals" == "## Ideals");
  assert match("\\A# ring\n\n> \\[!NOTE\\]\n> get the associated ring of an object\n\n", toString mdDocsPage "ring");
  assert(md DIV {"a", PARA "b"} == "a\n\nb");
  assert(md TT "a`b" == "``a`b``");
  assert(md PARA {"use ", TT "\"a  b\"", "\n   now"} == "use `\"a  b\"` now");
  -- mathematics stays raw TeX; an unpaired dollar sign is literal
  assert(md "map $a_b \\to c$ and x_y" == "map $a_b \\to c$ and x\\_y");
  assert(md "costs $5" == "costs \\$5");
  -- template syntax of site generators is plain text
  assert(md TT "{{#include x}}" == "`{{#include x}}`");
  -- documentation links: pages of linked packages, the website otherwise
  assert match("\\A\\[ring\\]\\(https://macaulay2\\.com/doc/.*/Macaulay2Doc/html/_ring\\.html\\)", md TO "ring");
  link := markdown TO "ring";
  assert(instance(link, MdDocLink));
  assert(render(link, ResolveLink => l -> MdLink {"../Macaulay2Doc/_ring.md", l#1}) ==
      "[ring](../Macaulay2Doc/_ring.md)");
  -- an installed documentation page named by path links like a documentation key
  installed := HREF {"/usr/share/doc/Macaulay2/Complexes/html/_free__Resolution.html", "f"};
  assert match("Complexes.*_free__Resolution\\.html\\)\\z", md installed);
  assert(instance(markdown installed, MdDocLink))
///

TEST ///
  -- A document retains the original target through every enclosing construct.
  source := TO "ring";
  link := markdown source;
  assert(link#0 === source#0);
  document := MdDocument {
      MdParagraph {"See ", MdStrong {link}},
      MdList {{link}},
      MdTable {{"heading"}, {link}},
      MdQuote {MdParagraph {link}}};
  assert(document#0#1#0 === link);
  calls := 0;
  localLinks := l -> (
      calls = calls + 1;
      assert(l#0 === source#0);
      MdLink prepend("_ring.md", drop(toList l, 1)));
  assert(calls == 0);
  localText := render(document, ResolveLink => localLinks);
  assert(calls == 4);
  assert match("_ring[.]md", localText);
  assert not match("https://", localText);
  -- Render the same tree again with a different destination, without rebuilding it.
  otherText := render(document, ResolveLink => l -> MdLink prepend(
      "https://docs.example/ring", drop(toList l, 1)));
  assert match("https://docs[.]example/ring", otherText);
  assert not match("_ring[.]md", otherText);
  assert(link#0 === source#0);
  assert(document#0#1#0 === link);
  assert match("macaulay2[.]com", render document)
///

TEST ///
  -- Every markup type exported by Text has a conversion, including types that
  -- inherit the generic Hypertext implementation. Supply valid special nodes.
  types := unique select(apply(values Text.Dictionary, value), T -> instance(T, Type) and member(Hypertext, ancestors T))
  special := hashTable {
      TO => TO "ring", TO2 => TO2 {"ring", "R"}, TOH => TOH "ring",
      HREF => HREF {"https://example.org", "site"},
      IMG => IMG {"src" => "image.png", "alt" => "plot"},
      LATER => LATER {() -> TT "later"}, MENU => MENU {TO "ring"},
      DL => DL {DT "term", DD "description"},
      UL => UL {LI "one", LI "two"}, OL => OL {LI "one", LI "two"},
      TABLE => TABLE {TR {TD "a", TD "b"}}}
  scan(types, T -> (
      node := if special#?T then special#T else new T from (if member(HypertextVoid, ancestors T) then {} else {"text"});
      assert(instance(markdown node, Markdown));
  ))
  -- Native Markdown types are retained, rather than wrapping everything in a document.
  scan({
      {TT "x", MdCode}, {CODE "x", MdCode}, {BOLD "x", MdStrong},
      {EM "x", MdEmphasis}, {PARA "x", MdParagraph}, {HEADER2 "x", MdHeading},
      {PRE "x", MdCodeBlock}, {UL {LI "x"}, MdList}, {OL {LI "x"}, MdOrderedList},
      {BLOCKQUOTE "x", MdQuote}, {HR {}, MdRule}, {BR {}, MdHTML},
      {HREF {"https://example.org", "x"}, MdLink},
      {TABLE {TR {TD "x"}}, MdTable}}, pair -> assert(class markdown(pair#0) === pair#1));
  assert(render(markdown PARA {"see ", BOLD {TO "ring"}},
      ResolveLink => l -> Wikilink {"Macaulay2Doc/_ring", l#1}) == "see **[[Macaulay2Doc/_ring|ring]]**");
  assert(toString markdown TABLE {TR {TD {PARA "a", PARA "b"}}} == "| a b |\n|---|");
  assert(toString markdown TT {"f(", TO "ring", ")"} ==
      "`f(`" | toString markdown(TO "ring") | "`)`");
  assert(toString markdown LATER {() -> TT "later"} == "`later`")
///

TEST ///
  dir := temporaryFileName();
  packageDir := writeMdDocs("FirstPackage", dir);
  assert(packageDir == dir | "/FirstPackage");
  contents := get(packageDir | "/contents.md");
  assert match("\\A# Contents\n\n\\[FirstPackage\\]\\(index.md\\)\n\n- \\[firstFunction", contents);
  assert(sort readDirectory packageDir ==
      sort {".", "..", "contents.md", "index.md", "_first__Function_lp__Z__Z_rp.md"});
  page := get(packageDir | "/_first__Function_lp__Z__Z_rp.md");
  assert match("The source of this document is in [^\n]+\n\nOriginal documentation:", page);
  assert match("Original documentation: \\[Macaulay2 website\\]\\(https://macaulay2[.]com/doc/.*/FirstPackage/html/_first__Function_lp__Z__Z_rp[.]html\\)[.]\n\\z", page);
  indexDir := writeMarkdownIndex({"FirstPackage"}, dir);
  assert match("\\(\\.\\./FirstPackage/index.md\\)", get(indexDir | "/index.md"));
  assert(get(indexDir | "/contents.md") == "# Contents\n\n[Macaulay2 documentation](index.md)\n")
///

TEST ///
  -- links into a linked package are Markdown page links beside the package
  dir := temporaryFileName();
  packageDir := writeMdDocs("FirstPackage", dir, LinkedPackages => {"Macaulay2Doc"});
  page := get(packageDir | "/_first__Function_lp__Z__Z_rp.md");
  assert match("\\(\\.\\./Macaulay2Doc/[^)]*\\.md\\)", page);
  -- Wikilinks between pages; the original-documentation footer stays a web link.
  packageDir = writeMdDocs("FirstPackage", dir, LinkStyle => "wikilink", LinkedPackages => true);
  page = get(packageDir | "/_first__Function_lp__Z__Z_rp.md");
  assert match("\\[\\[Macaulay2Doc/[^|]*\\|", page);
  assert not match("macaulay2\\.com", first separate("\n\nOriginal documentation:", page));
  assert match("Original documentation: \\[Macaulay2 website\\]\\(https://macaulay2[.]com/", page);
  assert match("\\(index.md\\)", get(packageDir | "/contents.md"))
///

TEST ///
  dir := temporaryFileName();
  bookDir := dir | "/Book";
  makeDirectory bookDir;
  (bookDir | "/index.md") << "# Book\n" << close;
  (bookDir | "/contents.md") << "# Contents\n\n[A\\_b \"c\"](index.md)\n\n" <<
      "- [first](first.md)\n- Section\n  - [second](second.md)\n" << close;
  assert(writeBookFiles(bookDir | "/") == bookDir);
  assert(get(bookDir | "/SUMMARY.md") == "# Summary\n\n[A\\_b \"c\"](index.md)\n\n" |
      "- [first](first.md)\n- [Section]()\n  - [second](second.md)\n");
  configuration := get(bookDir | "/book.toml");
  assert match("title = \"A_b \\\\\"c\\\\\"\"", configuration);
  assert match("src = \"\\.\"", configuration);
  assert match("use-default-preprocessors = false", configuration);
  assert match("\\[preprocessor\\.tsitter\\.languages\\.macaulay2\\]\naliases = \\[\"m2\", \"macaulay2\"\\]\n\n", configuration);
  assert not match("@[A-Z]+@", configuration);
  macros := get(dir | "/katex-macros.txt");
  assert match("\\\\ZZ:", macros);
  assert match("^\\\\tilde:\\\\widetilde$", macros);
  writeBookFiles(bookDir, BookTitle => "Other");
  assert match("title = \"Other\"", get(bookDir | "/book.toml"))
///

TEST ///
  -- the book layout: installed methods are chapters of their function's page
  needsPackage "Graphs";
  dir := temporaryFileName();
  packageDir := writeMdBook("Graphs", dir, LinkedPackages => {"Macaulay2Doc"});
  page := name -> get(packageDir | "/" | name | ".md");
  files := set readDirectory packageDir;
  assert not files#?"_degree_lp__Digraph_cm__Thing_rp.md";
  assert not files#?"_is__Cyclic_lp__Digraph_rp.md";
  -- a method on a function documented in Graphs: a section of its page's installations
  assert match("\n## Installations\n\n### `isCyclic\\(Digraph\\)`\n", page "_is__Cyclic");
  assert not match("Ways to use", page "_is__Cyclic");
  -- every method, documented or not, has a section; an alias's method says so
  addVertex := page "_add__Vertex";
  assert match("\n### `addVertices\\(Digraph,List\\)`\n\nA method of `addVertices`, an alias of `addVertex`; documented above\\.\n", addVertex);
  assert match("\n### `addVertices\\(Graph,List\\)`\n\n#### Details\n\n- \\*\\*Documentation:\\*\\* none\n", addVertex);
  -- the details below the headline: class and aliases, inputs and outputs
  assert match("\\A# `addVertex`\n\n> \\[!NOTE\\]\n> [^\n]*\n\n## Details\n\n- \\*\\*Class:\\*\\* a \\[method function\\]", addVertex);
  assert match("\n- \\*\\*Aliases:\\*\\* `addVertices`\n- \\*\\*Inputs:\\*\\*\n", addVertex);
  assert not match("For the programmer", addVertex);
  -- the footer at the bottom of the page, after the installations
  assert match("\n\\*\\*\\*\n\nThe source of this document is in [^\n]*\n\nOriginal documentation: [^\n]*\n\\z", addVertex);
  -- a method on a function documented in Macaulay2Doc: a page made for it in Graphs
  degreePage := page "_degree";
  assert match("\\A# `degree`\n\n## Details\n\n- \\*\\*Class:\\*\\* `MethodFunction`\n- \\*\\*Package:\\*\\* `Core`\n- \\*\\*Documentation:\\*\\* \\[`degree`\\]\\(\\.\\./Macaulay2Doc/_degree\\.md\\) in Macaulay2Doc\n", degreePage);
  assert match("\n### `degree\\(Digraph,Thing\\)`\n", degreePage);
  -- a type shows its ancestors below its title
  assert match("\\A# `Graph`\n\n<div align=\"center\">\n\n\\[`Graph`\\]\\(___Graph\\.md\\)&ensp;←&ensp;\\[`Digraph`\\]\\(___Digraph\\.md\\)&ensp;←&ensp;\\[`HashTable`\\]", page "___Graph");
  -- an exported symbol without documentation has a page
  assert match("\\A# `discoveryTime`\n\n## Details\n\n- \\*\\*Class:\\*\\* `Symbol`\n", page "_discovery__Time");
  -- links to a method point at its section's heading
  assert match("\\(_degree\\.md#degreedigraphthing\\)", page "___Digraph");
  -- the table of contents: a page for each section of the exports
  contents := get(packageDir | "/contents.md");
  assert match("\n- \\[Types\\]\\(types\\.md\\)\n  - \\[Digraph\\]\\(___Digraph\\.md\\)\n", contents);
  assert match("\n- \\[Methods\\]\\(methods\\.md\\)\n(  - [^\n]*\n)*  - \\[degree\\]\\(_degree\\.md\\)\n", contents);
  assert match("\\A# Types\n\nPart of the exports of \\[Graphs\\]\\(index\\.md\\)\\.\n", page "types");
  -- the page of a method key is the page holding its section
  assert match("\\A# `degree`\n", toString mdBookPage (degree, Digraph, Thing))
///
