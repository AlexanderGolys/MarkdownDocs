# MarkdownDocs

A Macaulay2 package that writes the documentation of Macaulay2 packages as
Markdown: one directory of pages per package, with a table of contents, the way
`installPackage` writes one directory of HTML pages per package.

Every page is exactly what the HTML documentation shows — the hypertext `help`
assembles for a documentation node, with usage, inputs, outputs, examples and
their stored output, ways to use, and so on — serialized as Markdown instead of
HTML. Nothing is scraped from the installed HTML.

Mathematics stays raw TeX between `$…$`, the convention of math-aware Markdown
tools, so the pages read well anywhere Markdown with math is understood. The
first target is [mdBook](https://rust-lang.github.io/mdBook/): every directory
written is also a ready mdBook source, with a `SUMMARY.md` table of contents and a
`book.toml` that declares the preprocessors rendering it. The package only writes
files — building books is left to mdBook and its preprocessors.

## Usage

```m2
needsPackage "MarkdownDocs"

-- docs/Graphs: a page per documentation node, SUMMARY.md, images/
writePackageMarkdown("Graphs", "docs", LinkedPackages => {"Macaulay2Doc"})
writePackageMarkdown("Macaulay2Doc", "docs", LinkedPackages => {"Graphs"})

-- docs/index: the given packages, then every other installed package
writeMarkdownIndex({"Graphs", "Macaulay2Doc"}, "docs")

-- a single page, or any hypertext
markdownPage "det"
markdownInline TT "ring R"
```

Core is documented by the `Macaulay2Doc` package.

## Output

```
docs/
├── katex-macros.txt        # the math macros of the HTML documentation (\ZZ, \Hom, …)
├── index/                  # README.md, SUMMARY.md, book.toml
├── Graphs/
│   ├── SUMMARY.md          # top node as introduction, documentation tree as chapters
│   ├── book.toml           # src = ".", preprocessors
│   ├── index.md            # the package's top node
│   ├── _add__Edge.md       # page names are those of the installed HTML
│   └── images/
└── Macaulay2Doc/
```

- Links to the package's own pages are relative page links; links into a package
  listed in `LinkedPackages` go to `../Package/page.md`; links into any other
  package go to its page on the [Macaulay2 website](https://macaulay2.com/doc/Macaulay2/).
- Examples and usage lines are fenced ` ```m2 ` blocks.
- Mathematics is raw TeX between `$…$` (display `$$…$$`); a literal dollar sign is `\$`.

## mdBook

Build each directory into a directory named like it, all side by side, so that
links between packages resolve:

```sh
mdbook build docs/Graphs -d "$PWD/site/Graphs"
```

The bundled `book.toml` declares [mdbook-katex](https://github.com/lzanini/mdbook-katex)
(optional, with `katex-macros.txt`). Configuration options of the package
(`init-MarkdownDocs.m2`) adjust it:

- `"TreeSitterLibrary"`, `"TreeSitterHighlights"` — a compiled tree-sitter
  Macaulay2 grammar and its highlights query; the book then declares
  [mdbook-tsitter](https://github.com/AlexanderGolys/mdbook-tsitter) for `m2` code,
  with its stylesheet expected as `treesitter.css` beside the directories.
- `"BookTemplate"` — your own template instead of the bundled one, for any other
  preprocessors and settings; `@TITLE@`, `@NAME@` and `@TREESITTER@` are filled in.

`test-build/build.sh` builds a site end to end: Markdown for `Macaulay2Doc` and the
packages Macaulay2 preloads (or the packages named), then a book for each.

Known issue: mdbook-katex pre-renders `\tilde` with a literal `~`, and mdBook's
strikethrough can pair two of them across a paragraph.

## Installation

```m2
installPackage("MarkdownDocs", FileName => "/path/to/MarkdownDocs/MarkdownDocs.m2")
check "MarkdownDocs"
```

## License

[MIT](LICENSE)
