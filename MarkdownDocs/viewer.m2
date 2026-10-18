-- A package's documentation as a book in the browser, as viewHelp shows the HTML
-- documentation: written in a layout below the application directory, made an
-- mdBook source, and served by mdbook serve in the background. A server keeps
-- serving its book, rebuilding it when it is written again, until M2 exits.

viewerDirectory := layout -> applicationDirectory() | "MarkdownDocs/" | layout | "/"

-- The port of the first server; each further book is served on the next port.
firstPort := 3000
-- book directory => (process id, port) of the server serving it
bookServers := new MutableHashTable

shellQuote := s -> "'" | replace("'", "'\\\\''", s) | "'"

-- The server of a book directory, started when there is none; its address.
bookAddress := (bookDir, layout) -> (
    if not bookServers#?bookDir then (
        port := firstPort + #bookServers;
        log := viewerDirectory layout | baseFilename bookDir | ".log";
        processId := value get concatenate("!mdbook serve --hostname 127.0.0.1 --port ", toString port,
            " --dest-dir ", shellQuote(viewerDirectory layout | "site/" | baseFilename bookDir), " ",
            shellQuote bookDir, " > ", shellQuote log, " 2>&1 & echo $!");
        -- mdbook serve builds the book before it listens, and exits when it fails
        sleep 1;
        if run("kill -0 " | toString processId) != 0 then
            error("MarkdownDocs: mdbook serve failed:\n", get log);
        bookServers#bookDir = (processId, port));
    concatenate("http://127.0.0.1:", toString last bookServers#bookDir, "/")
)

addEndFunction(() -> scan(values bookServers, server -> run("kill " | toString first server)))

-- Written by writePackage in the layout's directory, then shown.
viewPackageBook := (pkg, writePackage, layout) -> (
    bookDir := writeBookFiles writePackage(pkg, viewerDirectory layout | "markdown");
    address := bookAddress(bookDir, layout);
    show URL address;
    address
)

mdDocs = method()
mdDocs String := String => name -> mdDocs needsPackage name
mdDocs Package := String => pkg -> viewPackageBook(pkg, writeMdDocs, "docs")

mdBook = method()
mdBook String := String => name -> mdBook needsPackage name
mdBook Package := String => pkg -> viewPackageBook(pkg, writeMdBook, "book")
