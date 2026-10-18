# MarkdownDocs

A Macaulay2 package that writes the documentation of Macaulay2 packages as plain
Markdown: one directory of pages per package, with a table of contents, the way
`installPackage` writes one directory of HTML pages per package. Separately, it
makes such a directory an [mdBook](https://rust-lang.github.io/mdBook/) source: a
`SUMMARY.md` from the table of contents and a `book.toml` declaring the
preprocessors that render the pages, from the directory's files alone.

Every page is exactly what the HTML documentation shows — the hypertext `help`
assembles for a documentation node, with usage, inputs, outputs, examples and
their stored output, ways to use, and so on — serialized as Markdown instead of
HTML. Nothing is scraped from the installed HTML.

Pages come in two layouts. The docs layout mirrors the installed documentation:
a page for each documentation node. The book layout shows the installed methods
of a function as chapters of its page, and the methods a package installs on a
function documented elsewhere on a page made for that function in the package.

Mathematics stays raw TeX between `$…$`, the convention of math-aware Markdown
tools, so the pages read well anywhere Markdown with math is understood.

```m2
mdDocs "Graphs"   -- the docs layout, served by mdbook and opened in the browser
mdBook "Graphs"   -- the book layout
```

## Markdown

Markdown constructs (`MdParagraph`, `MdList`, `MdCode`, `Wikilink`, …) retain their
contents as a tree. `markdown` converts Macaulay2 markup into these nodes;
`mdDocsPage` converts the markup assembled by `help` for a documentation page, and
`mdBookPage` is the page in the book layout.
`render` produces text, and `toString` uses its default settings.

Documentation links retain their targets until rendering. The package writer
resolves them to local `.md` files for the packages being exported, with website
links for other packages. The Markdown module itself knows nothing about package
documentation or mdBook. A `ResolveLink` function can provide another destination
when rendering the same tree later.

```m2
needsPackage "MarkdownDocs"

-- Markdown
toString MdList {"one", {"two", MdList {MdCode "nested"}}}
toString Wikilink("Graphs/_add__Edge", "addEdge")

-- Convert markup objects themselves
markdown TT "x_1"
markdown PARA {"a ", BOLD "word"}
markdown UL {"one", TT "ring R", TO "ring"}

-- Render a documentation page; standalone rendering uses website links
render mdDocsPage "det"
needsPackage "Graphs"
render mdBookPage (degree, Digraph, Thing)   -- Graphs' page for degree

-- docs/Graphs: index.md, contents.md, a page per documentation node, images/
writeMdDocs("Graphs", "docs", LinkedPackages => {"Macaulay2Doc"})
writeMdDocs("Macaulay2Doc", "docs", LinkedPackages => {"Graphs"})

-- book/Graphs: the same, with installed methods as chapters
writeMdBook("Graphs", "book")

-- docs/index: the given packages, then every other installed package
writeMarkdownIndex({"Graphs", "Macaulay2Doc"}, "docs")

-- a vault of wikilinked pages, with the original website linked in each footer
writeMdDocs("Graphs", "vault", LinkStyle => "wikilink", LinkedPackages => true)
```

Core is documented by the `Macaulay2Doc` package.

```
docs/
├── index/                  # index.md, contents.md
├── Graphs/
│   ├── index.md            # the package's top node
│   ├── contents.md         # the documentation tree as a nested list
│   ├── _add__Edge.md       # page names are those of the installed HTML
│   └── images/
└── Macaulay2Doc/
```

- Links to the package's own pages and into packages listed in `LinkedPackages`
  (or every package, with `LinkedPackages => true`) are page links: `page.md` and
  `../Package/page.md`, or `[[Package/page|text]]` with `LinkStyle => "wikilink"`.
  Links into any other package go to its page on the
  [Macaulay2 website](https://macaulay2.com/doc/Macaulay2/).
- In the book layout a link to a method shown as a chapter points at its heading:
  `_degree.md#degreedigraphthing`, or `[[Graphs/_degree#degree(Digraph,Thing)]]`.
- Consecutive example commands and their output share one fenced ` ```m2 ` block;
  intervening prose separates sessions. Usage lines have their own code block.
- Mathematics is raw TeX between `$…$` (display `$$…$$`); a literal dollar sign is `\$`.
- `contents.md` is a `# Contents` heading, a link to `index.md`, then the
  documentation tree as a nested list; a menu section is an item without a link.

## mdBook

```m2
-- docs/Graphs/SUMMARY.md, docs/Graphs/book.toml, docs/katex-macros.txt
writeBookFiles "docs/Graphs"
writeBookFiles "docs/index"
```

Build each directory into a directory named like it, all side by side, so that
links between packages resolve:

```sh
mdbook build docs/Graphs -d "$PWD/site/Graphs"
```

The bundled `book.toml` turns off mdBook's own preprocessors (so `{{#…}}` in a page
stays text) and declares [mdbook-katex](https://github.com/lzanini/mdbook-katex)
(optional, with the math macros of the HTML documentation in `katex-macros.txt`)
and [mdbook-tsitter](https://github.com/AlexanderGolys/mdbook-tsitter) (optional,
for `m2` code and BibTeX citations, using its built-in grammars; it fetches the
grammar on the first build and embeds its own stylesheet). Configuration options of
the package (`init-MarkdownDocs.m2`, or `needsPackage`'s `Configuration`) adjust it:

- `"TreeSitterGrammar"` — the git repository of the Macaulay2 grammar, a URL or a
  local checkout, used at its `HEAD` instead of the release mdbook-tsitter pins.
- `"BookTemplate"` — your own template instead of the bundled one, for any other
  preprocessors and settings; `@TITLE@`, `@NAME@` and `@GRAMMAR@` (the grammar's
  `git` and `rev` lines) are filled in.

`mdDocs` and `mdBook` write a package below `~/.Macaulay2/MarkdownDocs/`, make it an
mdBook source and run `mdbook serve` in the background (port 3000, then 3001, …),
opening the browser as `viewHelp` does. Calling them again rewrites the pages and
the server reloads them; servers stop when Macaulay2 exits.

Known issue: mdbook-katex pre-renders `\tilde` with a literal `~`, and mdBook's
strikethrough can pair two of them across a paragraph; `katex-macros.txt` draws
`\tilde` as `\widetilde` to avoid it.

## Installation

```m2
installPackage("MarkdownDocs", FileName => "/path/to/MarkdownDocs/MarkdownDocs.m2")
check "MarkdownDocs"
```

## License

[MIT](LICENSE)
