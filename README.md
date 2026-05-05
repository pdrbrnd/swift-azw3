# AZW3

A Swift package that writes valid AZW3/KF8 files (Amazon's Kindle Format 8) from a structured book manifest.

> **AI-assisted code.** This library was written with AI assistance. Use accordingly.

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/pdrbrnd/swift-azw3", from: "0.1.0")
]
```

Then add `AZW3` to your target's dependencies.

## Usage

```swift
import AZW3

let manifest = BookManifest(
    title: "Frankenstein",
    authors: ["Mary Shelley"],
    language: "en-GB",
    chunks: [
        "<p>It was on a dreary night of November...</p>",
        "<p>The next morning I delivered my letters...</p>",
    ],
    cover: ImageData(bytes: jpegData, mimeType: "image/jpeg"),
    toc: [
        TocEntry(title: "Chapter 1", chunkIndex: 0),
        TocEntry(title: "Chapter 2", chunkIndex: 1),
    ]
)

let bytes = AZW3Writer(manifest: manifest).encode()
try bytes.write(to: outputURL)
```

## Public API

- **`BookManifest`** — input. Title, authors, language (BCP 47), HTML chunks, cover, body images, CSS flows, TOC, and optional date and identifier.
- **`ImageData`** — JPEG, PNG, or GIF bytes with MIME type.
- **`TocEntry`** — chapter title plus an index into `BookManifest.chunks`.
- **`AZW3Writer`** — `init(manifest:)` then `.encode() -> Data`.

### Chunk shape

Each entry in `BookManifest.chunks` is the *inner* HTML of one spine document's `<body>` — without `<html>`, `<head>`, or `<body>` wrappers. The writer emits the structural HTML the KF8 reader expects around each chunk.

### Body images and CSS

Body images are referenced from chunks via `kindle:embed:NNNN` URIs. The `NNNN` is the 1-based, 4-hex-digit index into the combined image array (cover at index 1 if present, then body images). The caller is responsible for rewriting chunk HTML to point at these indices.

CSS flows are referenced via `kindle:flow:NNNN` URIs (1-based, 4-decimal-digit) into the `cssFlows` array.

## Supported

- Cover image record + EXTH cover entries
- NCX table of contents from `TocEntry` array
- CSS flows (`kindle:flow:NNNN`)
- Body images (`kindle:embed:NNNN`)
- BCP 47 language tags → Microsoft locale codes
- `<dc:identifier>`-style stable IDs → MOBI uniqueID + pseudo-ASIN
- Publishing date → ISO-8601 EXTH

## Not supported

Use a fork or send a PR if you need any of these:

- PalmDoc compression (output is uncompressed; 2–3× larger but Kindle accepts it)
- Embedded fonts
- MOBI 6 dual format
- Furigana / RTL EXTH fields (522, 525, 527)
- Older-firmware thumbnail-folder hack (`/Volumes/Kindle/system/thumbnails/`)
- Chunk splitting for large spine items

## License

MIT. See [LICENSE](LICENSE).

## Acknowledgments

Ported from [leotaku/mobi](https://github.com/leotaku/mobi) (Go). Calibre's MOBI writer was consulted as a cross-reference for binary layout details where the Go library and the format spec disagreed.
