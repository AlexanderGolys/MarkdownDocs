#!/usr/bin/env bash
# Test build of a documentation site: Macaulay2 documentation -> Markdown
# (MarkdownDocs, one M2 process per package) -> mdBook books, side by side.
# This script is the only place where the Macaulay2 side and the mdBook side meet.
#
#   ./test-build/build.sh                 # Macaulay2Doc and the packages M2 preloads
#   ./test-build/build.sh Graphs Jets     # these packages
#
#   M2_BIN      Macaulay2 executable (default: ~/.local/bin/M2)
#   M2_GRAMMAR  tree-sitter-macaulay2 checkout for highlighting
#               (default: ~/m2/tree-sitter-macaulay2; highlighting is off without it)
#   JOBS        parallel processes (default: number of CPUs)
#
# Needs mdbook; mdbook-tsitter for highlighting and mdbook-katex for math.
# Output: test-build/out/{markdown,site}; open site/index/index.html.
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
m2="${M2_BIN:-$HOME/.local/bin/M2}"
grammar_repo="${M2_GRAMMAR:-$HOME/m2/tree-sitter-macaulay2}"
jobs="${JOBS:-$(nproc)}"
out="$here/out"
markdown="$out/markdown"
site="$out/site"
logs="$out/logs"
render=(--script "$here/render.m2")

rm -rf -- "$out"
mkdir -p "$markdown" "$site" "$logs"

# Highlighting: the grammar compiled for mdbook-tsitter, or none.
library="" highlights=""
if [[ -f "$grammar_repo/src/parser.c" ]]; then
  scanner=(); [[ -f "$grammar_repo/src/scanner.c" ]] && scanner=("$grammar_repo/src/scanner.c")
  library="$out/grammar/macaulay2.so" highlights="$out/grammar/highlights.scm"
  mkdir -p "$out/grammar"
  cc -O2 -shared -fPIC -I "$grammar_repo/src" "$grammar_repo/src/parser.c" "${scanner[@]}" -o "$library"
  cp "$grammar_repo/queries/macaulay2/highlights.scm" "$highlights"
fi

if (( $# > 0 )); then packages=("$@"); else mapfile -t packages < <("$m2" "${render[@]}" packages); fi
echo "markdown for ${#packages[@]} packages"

export m2 here markdown site library highlights logs
packages_line="${packages[*]}"
export packages_line
printf '%s\n' "${packages[@]}" | xargs -P "$jobs" -I{} bash -c '
  # shellcheck disable=SC2086 # the linked packages are words
  "$m2" --script "$here/render.m2" package "$markdown" "$library" "$highlights" "$1" $packages_line \
    > "$logs/$1.log" 2>&1 || echo "FAILED $1 (see $logs/$1.log)"' _ {}
"$m2" "${render[@]}" index "$markdown" "$library" "$highlights" "${packages[@]}"

# The mdBook side.
[[ -n "$library" ]] && mdbook-tsitter css > "$markdown/treesitter.css"
books=(index "${packages[@]}")
echo "building ${#books[@]} books"
printf '%s\n' "${books[@]}" | xargs -P "$jobs" -I{} bash -c '
  [[ -f "$markdown/$1/book.toml" ]] || exit 0
  mdbook build "$markdown/$1" -d "$site/$1" > "$logs/$1.mdbook.log" 2>&1 ||
    echo "FAILED mdbook $1 (see $logs/$1.mdbook.log)"' _ {}

echo "site: $site/index/index.html"
