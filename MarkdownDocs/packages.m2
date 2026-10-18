-- Package documentation as directories of Markdown pages, laid out as "Markdown
-- documentation layout" says, shared by the two layouts (docsLayout.m2 and
-- bookLayout.m2): the documentation nodes of a package, its table of contents,
-- the package directory written in a layout, and the index of packages.

coreInternal := name -> value Core#"private dictionary"#name
getPrimaryTag := coreInternal "getPrimaryTag"
fixup := coreInternal "fixup"
isMissingDoc := coreInternal "isMissingDoc"
isUndocumented := coreInternal "isUndocumented"
isSecondaryTag := coreInternal "isSecondaryTag"
fetchRawDocumentation := coreInternal "fetchRawDocumentation"
deepSelect := coreInternal "deepSelect"
deepApply' := coreInternal "deepApply'"
removeFiles := coreInternal "removeFiles"

-----------------------------------------------------------------------------
-- The documentation nodes of a package
-----------------------------------------------------------------------------

-- The nodes installHTML writes a page for.
hasPage = tag -> not (isUndocumented tag or isSecondaryTag tag or isMissingDoc tag)

-- The raw documentation of every key a package documents; a package loaded from
-- its source, not an install, has no database.
packageRawDocumentation = pkg -> (
    db := if pkg#?"raw documentation database" then pkg#"raw documentation database";
    join(values pkg#"raw documentation", if db =!= null then apply(keys db,
        fkey -> value db#fkey) else {})
)

-- The exported symbols of a package, as tags.
packageSymbolTags = pkg -> apply(select(pairs pkg.Dictionary, (name, sym) ->
        not match("\\$", name)),
    (name, sym) -> makeDocumentTag(sym, Package => pkg))

-- The nodes of a package with a page, as installPackage's packageTagList finds them.
packageTags = pkg -> (
    top := makeDocumentTag(pkg#"pkgname", Package => pkg);
    byKey := new MutableHashTable;
    scan(join({top}, packageSymbolTags pkg, apply(packageRawDocumentation pkg,
        rawdoc -> rawdoc.DocumentTag)),
        tag -> if not byKey#?(format tag) then byKey#(format tag) = tag);
    select(values byKey, hasPage)
)

-----------------------------------------------------------------------------
-- Package pages and table of contents, as installPackage builds them
-----------------------------------------------------------------------------

-- The subnode graph and depth-first forest of installPackage's
-- assembleTree/makeForest. Core gives a node reached from several parents an
-- empty subtree after the first; here later occurrences are dropped, so that each
-- page appears once in the table of contents.
subnodeSections := {Description, Acknowledgement, Contributors, References, Caveat}

-- A node's subnodes in menu order. A String is the heading of the menu section
-- holding the subnodes after it, as redoMENU lays the menu out.
subnodesOf := (pkg, tag) -> (
    rawdoc := fetchRawDocumentation tag;
    if rawdoc === null then
        return {};
    content := apply(select(subnodeSections, section -> rawdoc#?section), section ->
            rawdoc#section);
    isSubnodeLink := e -> instance(e, BasicList) and #e > 0 and e#0 === ("class" => "subnode");
    sublinks := deepSelect(content, isSubnodeLink);
    menuItems := if rawdoc#?Subnodes then
        deepApply'(rawdoc.Subnodes, identity, item -> instance(item, BasicList) and not isLink item)
        else {};
    entries := join(deepSelect(sublinks, DocumentTag), flatten apply(menuItems, item ->
            if instance(item, String) then {item} else deepSelect(item, DocumentTag)));
    flatten apply(entries, entry -> (
        if instance(entry, String) then
            return {entry};
        node := fixup entry;
        if package node === pkg then {getPrimaryTag node} else {}
    ))
)

-- {(entry, depth)} in table-of-contents order, the top node's page first at depth
-- 0. An entry is a page, the (name, title) pageOf gives the tag it shows, or the
-- String heading of a menu section, entered above the subnodes it holds; a
-- section without subnodes left to list is dropped. A page's subnodes are those
-- of the tags it shows, in the order of tags; pageOf is null for a node without
-- a page. Pages showing no node, the extra pages, have no subnodes. The pages
-- no menu lists are listed below the top node's subnodes, under the headings of
-- the sections sectionOf puts them in, in their order, or before them when it
-- gives null.
packageOutline := (pkg, tags, pageOf, extraPages, sections, sectionOf) -> (
    top := pageOf makeDocumentTag(pkg#"pkgname", Package => pkg);
    subpages := new MutableHashTable;
    scan(extraPages, page -> subpages#page = {});
    scan(tags, tag -> subpages#(pageOf tag) = join(if subpages#?(pageOf tag) then subpages#(pageOf tag) else {},
        select(apply(subnodesOf(pkg, tag), entry -> if instance(entry, String) then entry else pageOf entry),
            entry -> entry =!= null)));
    graph := new HashTable from subpages;
    roots := unique prepend(top, sort toList(set keys graph - set flatten values graph));
    listed := new MutableHashTable;
    visit := (page, depth) -> (
        if listed#?page or not graph#?page then
            return {};
        listed#page = true;
        entries := graph#page;
        headings := positions(entries, entry -> instance(entry, String));
        sectionBounds := append(headings, #entries);
        sectionEnds := drop(sectionBounds, 1);
        unsectioned := flatten apply(take(entries, first sectionBounds), child ->
                visit(child, depth + 1));
        menuSections := flatten apply(headings, sectionEnds, (start, end) -> (
            children := flatten apply(take(entries, {start + 1, end - 1}), child ->
                    visit(child, depth + 2));
            if #children == 0 then {} else prepend((entries#start, depth + 1), children)
        ));
        join({(page, depth)}, unsectioned, menuSections)
    );
    others := drop(roots, 1);
    join(visit(top, 0),
        flatten apply(select(others, page -> sectionOf page === null), page -> visit(page, 1)),
        flatten apply(sections, section -> (
            pages := flatten apply(select(others, page -> sectionOf page === section), page -> visit(page, 2));
            if #pages == 0 then {} else prepend((section, 1), pages))))
)

-----------------------------------------------------------------------------
-- Writing directories. <dir>/<package>/ holds a page for each documentation
-- node, the top node as index.md, a table of contents as contents.md and the
-- images the pages show. Package directories sit side by side, with the index
-- of packages in a directory of its own beside them, laid out the same way.
-----------------------------------------------------------------------------

directoryIn := (dir, name) -> replace("/+\\z", "", dir) | "/" | name

introductionPage := "index"

-- A Markdown file: the text of a document, ending with a newline.
writeMarkdownFile := (file, document) -> file << toString document << "\n" << close
contentsPage := "contents.md"

-- The outline as nested list items, each of the shallowest entries holding the
-- deeper entries after it; a menu section is an item without a link.
outlineItems := outline -> (
    if #outline == 0 then
        return {};
    depth := min apply(outline, last);
    starts := positions(outline, entry -> last entry == depth);
    apply(starts, append(drop(starts, 1), #outline), (start, end) -> (
        entry := first outline#start;
        label := if instance(entry, String) then entry
            else MdLink {entry#0 | ".md", entry#1};
        children := outlineItems take(outline, {start + 1, end - 1});
        if #children == 0 then {label} else {label, MdList children}
    ))
)

-- The introduction (the directory's index.md) as a link of its own, then the
-- nested list of the other pages. Always Markdown links: the layout's format.
writeContents := (dir, introduction, outline) -> (
    contents := MdDocument join(
        {MdHeading(1, "Contents"),
            MdParagraph MdLink {introductionPage | ".md", introduction}},
        if #outline > 0 then {MdList outlineItems outline} else {}
    );
    writeMarkdownFile(dir | "/" | contentsPage, contents)
)

-- A layout of a package's pages, given its nodes (tags): Documents, page name =>
-- a function making the page's document; PageOf, a node's (name, title), as
-- packageOutline takes it; OutlineOrder, the nodes in the order their subnodes
-- are listed; ExtraPages, the (name, title) of the pages showing no node; and
-- Sections, the headings of the table of contents for pages no menu lists, each
-- a String or a page (name, title), and SectionOf, the heading of such a page,
-- (name, title), or null; and
-- ResolveLink, as resolveDocumentationLink takes its arguments.
protect Documents
protect PageOf
protect OutlineOrder
protect ExtraPages
protect Sections
protect SectionOf

-- A headline, or another note, as a GitHub note callout, "> [!NOTE]" above it.
noteCallout = text -> MdQuote {MdParagraph {new MarkdownInline from "[!NOTE]\n", text}}

-- The options of the writers of package directories.
packageDirectoryOptions = {
    LinkedPackages => {},
    LinkStyle => "markdown"
}

-- The package directory dir/<package>, written in a layout.
writePackageDirectory = (pkg, dir, opts, layout) -> (
    name := pkg#"pkgname";
    packageDir := directoryIn(dir, name);
    removeFiles packageDir;
    makeDirectory packageDir;
    linked := if opts.LinkedPackages === true then true else prepend(name, opts.LinkedPackages);
    scan(keys installedImages, file -> remove(installedImages, file));
    -- render keys unqualified within their own package, as installHTML does
    enclosingPackage := currentPackage;
    currentPackage = pkg;
    (outline, failure) := trap (
        tags := packageTags pkg;
        pages := layout(pkg, tags);
        resolveLink := link -> pages.ResolveLink(link, linked, opts.LinkStyle, name);
        scan(pairs pages.Documents, (page, document) -> writeMarkdownFile(packageDir | "/" | page | ".md",
            render(document(), ResolveLink => resolveLink)));
        drop(packageOutline(pkg, pages.OutlineOrder, pages.PageOf, pages.ExtraPages,
                pages.Sections, pages.SectionOf), 1)
    );
    currentPackage = enclosingPackage;
    if failure =!= null then
        error toString failure;
    writeContents(packageDir, name, outline);
    if #installedImages > 0 then
        makeDirectory(packageDir | "/images");
    scan(pairs installedImages, (file, image) -> copyFile(file, packageDir | "/" | image));
    packageDir
)

-- Packages with installed documentation, as makePackageIndex finds them
-- (the first prefix providing a package wins).
documentedPackages := () -> (
    found := new MutableHashTable;
    flatten apply(prefixPath, prefix -> flatten apply(values Layout, layout -> (
        docdir := prefix | layout#"docdir";
        if not isDirectory docdir then
            return {};
        names := select(sort readDirectory docdir, name ->
                not found#?name
            and fileExists(prefix | replace("PKG", name, layout#"packagehtml") | "index.html"));
        scan(names, name -> found#name = true);
        names
    )))
)

indexName := "index"
indexTitle := "Macaulay2 documentation"

writeMarkdownIndex = method(Options => {LinkStyle => "markdown"})
writeMarkdownIndex (List, String) := String => opts -> (names, dir) -> (
    entry := (name, link) -> (
        headline := (readPackage name).Headline;
        if headline === null then {link} else {link, " -- " | headline}
    );
    listed := set names;
    others := select(documentedPackages(), name -> not listed#?name);
    indexDir := directoryIn(dir, indexName);
    makeDirectory indexDir;
    index := MdDocument join(
        {MdHeading(1, indexTitle), MdHeading(2, "Packages"),
            MdList apply(sort names, name ->
                    entry(name, packagePageLink(opts.LinkStyle, name, introductionPage, {name})))},
        if #others > 0 then {MdHeading(2, "Other installed packages"),
            MdParagraph {"Documented on the ", MdLink {onlineDocumentation, "Macaulay2 website"},"."},
            MdList apply(others, name ->
                    entry(name, MdLink {onlinePage(name, "index"), name}))} else {}
    );
    writeMarkdownFile(indexDir | "/" | introductionPage | ".md", index);
    writeContents(indexDir, indexTitle, {});
    indexDir
)
