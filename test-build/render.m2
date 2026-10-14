-- The Macaulay2 side of the test build: Markdown from MarkdownDocs, loaded from
-- this checkout. Driven by build.sh.
--   M2 --script render.m2 packages
--       Macaulay2Doc and the packages M2 preloads that have installed documentation
--   M2 --script render.m2 package <markdownDir> <library> <highlights> <name> <linked>...
--   M2 --script render.m2 index <markdownDir> <library> <highlights> <name>...

preloaded := apply(loadedPackages, pkg -> if pkg === Core then "Macaulay2Doc" else pkg#"pkgname")

path = prepend(currentFileDirectory | "../", path)

hasInstalledDocumentation := name -> any(prefixPath, prefix -> any(values Layout, layout ->
    fileExists(prefix | replace("PKG", name, layout#"packagehtml") | "index.html")))

scriptArgs := drop(scriptCommandLine, 1)
command := first scriptArgs
if command === "packages" then (scan(select(unique preloaded, hasInstalledDocumentation), print); exit 0)

-- Names are bound when an expression is parsed, so the package is loaded in a
-- statement of its own, before the code using its exports.
(markdownDir, library, highlights) := toSequence take(drop(scriptArgs, 1), 3)
needsPackage("MarkdownDocs",
    Configuration => {"TreeSitterLibrary" => library, "TreeSitterHighlights" => highlights})
names := drop(scriptArgs, 4)
(
    if command === "package" then writePackageMarkdown(first names, markdownDir, LinkedPackages => drop(names, 1))
    else if command === "index" then writeMarkdownIndex(names, markdownDir)
    else error("render.m2: unknown command ", command))
exit 0
