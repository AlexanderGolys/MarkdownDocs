# MarkdownDocs

A Macaulay2 package that writes the documentation of Macaulay2 packages as
Markdown: one directory of pages per package, with a table of contents, the way
`installPackage` writes one directory of HTML pages per package.

Every page is exactly what the HTML documentation shows — the hypertext `help`
assembles for a documentation node, with usage, inputs, outputs, examples and
their stored output, ways to use, and so on — serialized as Markdown instead of
HTML. Nothing is scraped from the installed HTML.

The table of contents is written in mdBook's `SUMMARY.md` format, so each package
directory is a ready [mdBook](https://rust-lang.github.io/mdBook/) source.
Building books, themes and sites from it is left to mdBook and the tooling around
it; this package only produces Markdown.

## Usage

```m2
needsPackage "MarkdownDocs"

-- docs/Graphs: a page per documentation node, SUMMARY.md, images/
writePackageMarkdown("Graphs", "docs", LinkedPackages => {"Macaulay2Doc"})
writePackageMarkdown("Macaulay2Doc", "docs", LinkedPackages => {"Graphs"})

-- docs/index.md: the given packages, then every other installed package
writeMarkdownIndex({"Graphs", "Macaulay2Doc"}, "docs")

-- a single page, or any hypertext
markdownPage "det"
markdownInline TT "ring R"
```

Core is documented by the `Macaulay2Doc` package.

## Output

```
docs/
├── index.md
├── Graphs/
│   ├── SUMMARY.md          # top node as introduction, documentation tree as chapters
│   ├── index.md            # the package's top node
│   ├── _add__Edge.md       # page names are those of the installed HTML
│   └── images/
└── Macaulay2Doc/
```

- Links to the package's own pages are relative page links; links into a package
  listed in `LinkedPackages` go to `../Package/page.md`; links into any other
  package go to its page on the [Macaulay2 website](https://macaulay2.com/doc/Macaulay2/).
- Examples and usage lines are fenced ` ```m2 ` blocks.
- Mathematics is written between `$…$`, as in the HTML documentation, for a math
  renderer such as KaTeX.

## Installation

```m2
installPackage("MarkdownDocs", FileName => "/path/to/MarkdownDocs/MarkdownDocs.m2")
check "MarkdownDocs"
```

## License

[MIT](LICENSE)
