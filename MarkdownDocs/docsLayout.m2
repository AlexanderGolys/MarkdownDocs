-- The installed documentation's layout: a page for each documentation node.
-- mdDocsPage is the page help shows for a key, writeMdDocs the pages of a package.

-----------------------------------------------------------------------------
-- The page of an object
-----------------------------------------------------------------------------

-- The page of a documentation key from the hypertext help shows for it. A page
-- is always a document, even when help produces only inline markup.
nodeDocument := (key, body) -> (
    children := if instance(body, Hypertext) then select(
        deepSplice toList body, e -> not instance(e, Option)
    ) else {};
    -- Core's page heading stores the name and " -- headline" separately.
    -- Use that structure rather than splitting names that may contain dashes.
    document := if #children > 0 and instance(first children, HEADER1) and
        #first children > 0 then (
            heading := toList first children;
            description := replace(///\A -- ///, "", concatenate apply(drop(
                heading, 1
            ), plainText));
            MdDocument join({MdHeading(1, first heading)},
                if description == "" then {} else {noteCallout description},
                {markdown drop(children, 1)})
        ) else markdown body;
    page := documentationPage makeDocumentTag key;
    MdDocument join({document}, if page === null then {} else {
        MdParagraph {"Original documentation: ",
            MdLink {onlinePage(page#0, page#1), "Macaulay2 website"}, "."}
    })
)

-- A method key, such as (degree, Digraph, Thing), is one key, as for help.
mdDocsPage = method(Dispatch => Thing)
mdDocsPage Thing := MdDocument => key -> nodeDocument(key, help key)

-----------------------------------------------------------------------------
-- The pages of a package
-----------------------------------------------------------------------------

pageName := tag -> (documentationPage tag)#1

docsLayout := (pkg, tags) -> (
    pages := hashTable apply(tags, tag -> pageName tag => tag);
    if #pages != #tags then
        error("MarkdownDocs: page names collide in ", pkg#"pkgname");
    new HashTable from {
        symbol Documents => applyValues(pages, tag -> () -> mdDocsPage tag),
        symbol PageOf => tag -> if hasPage tag then (pageName tag, format tag),
        symbol OutlineOrder => tags,
        symbol ExtraPages => {},
        symbol Sections => {},
        symbol SectionOf => page -> null,
        symbol ResolveLink => resolveDocumentationLink}
)

writeMdDocs = method(Options => packageDirectoryOptions)
writeMdDocs (String, String) := String => opts -> (name, dir) -> writeMdDocs(needsPackage name, dir, opts)
writeMdDocs (Package, String) := String => opts -> (pkg, dir) -> writePackageDirectory(pkg, dir, opts, docsLayout)
