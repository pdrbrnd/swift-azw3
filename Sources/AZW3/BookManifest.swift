import Foundation

/// The AZW3 writer's input — a plain Sendable description of a book
/// ready to be encoded. Construct one of these and hand it to
/// `AZW3Writer`.
public struct BookManifest: Sendable, Equatable {
    /// User-facing title.
    public let title: String
    /// Author names in display order. Empty array allowed but Kindle
    /// shows "Unknown Author" if you do that.
    public let authors: [String]
    /// BCP 47 tag (`pt-PT`, `en-GB`, `und`, etc.). Drives the EXTH
    /// language entry and the MOBI header locale code.
    public let language: String
    /// HTML chunks in reading order. Each chunk is the *inner* HTML
    /// of one spine document's `<body>` — without `<html>`, `<head>`,
    /// or `<body>` wrappers. The skeleton template wraps each chunk
    /// with the structural HTML the KF8 reader expects.
    public let chunks: [String]

    /// Cover image, if available. Drives the cover image record and
    /// EXTH cover offset / has-fake-cover entries.
    public let cover: ImageData?
    /// Body images referenced from `chunks` via `kindle:embed:NNNN`
    /// URIs. Each entry's array index (1-based, with cover at 0)
    /// drives the URI's NNNN part — caller is responsible for having
    /// rewritten the chunks to point at these indices.
    public let bodyImages: [ImageData]
    /// CSS files in OPF manifest order. Bytes are appended to the
    /// combined text after HTML; the skeleton template references them
    /// via `kindle:flow:NNNN` URIs.
    public let cssFlows: [String]
    /// Table-of-contents entries pointing into `chunks`. Empty array
    /// produces a single fallback NCX entry covering the whole book.
    public let toc: [TocEntry]
    /// Publishing date, if known. Drives the EXTH publishing date entry.
    public let publishingDate: Date?
    /// Stable identifier (e.g. `<dc:identifier>` from an EPUB). Used as
    /// the MOBI uniqueID seed when present, falling back to a stable
    /// hash of title+authors.
    public let identifier: String?

    public init(
        title: String,
        authors: [String],
        language: String,
        chunks: [String],
        cover: ImageData? = nil,
        bodyImages: [ImageData] = [],
        cssFlows: [String] = [],
        toc: [TocEntry] = [],
        publishingDate: Date? = nil,
        identifier: String? = nil
    ) {
        self.title = title
        self.authors = authors
        self.language = language
        self.chunks = chunks
        self.cover = cover
        self.bodyImages = bodyImages
        self.cssFlows = cssFlows
        self.toc = toc
        self.publishingDate = publishingDate
        self.identifier = identifier
    }
}

/// An image to embed in the AZW3 (cover or body image).
public struct ImageData: Sendable, Equatable {
    /// Raw image bytes. JPEG, PNG, or GIF — KF8 supports all three.
    public let bytes: Data
    /// MIME type — `image/jpeg`, `image/png`, or `image/gif`.
    public let mimeType: String

    public init(bytes: Data, mimeType: String) {
        self.bytes = bytes
        self.mimeType = mimeType
    }
}

/// One TOC entry. `chunkIndex` selects which chunk in `BookManifest.chunks`
/// the chapter starts at; finer-grained anchors mid-chunk are not
/// represented (multiple TOC entries pointing into the same chunk
/// collapse to the first).
public struct TocEntry: Sendable, Equatable {
    public let title: String
    public let chunkIndex: Int

    public init(title: String, chunkIndex: Int) {
        self.title = title
        self.chunkIndex = chunkIndex
    }
}
