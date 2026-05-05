# Changelog

All notable changes to this package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this package adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-05-05

Initial release. Extracted from [Tomo](https://github.com/pdrbrnd/tomo).

### Added

- `BookManifest` input struct (title, authors, BCP 47 language, HTML chunks, cover, body images, CSS flows, TOC, publishing date, identifier).
- `AZW3Writer.encode() -> Data` producing AZW3/KF8 byte streams.
- Cover image record + EXTH cover entries (201, 203, 125, 129, 202).
- NCX table of contents from `TocEntry` arrays.
- CSS flow records referenced via `kindle:flow:NNNN`.
- Body image records referenced via `kindle:embed:NNNN`.
- BCP 47 → Microsoft locale code mapping.
- Stable identifier → MOBI uniqueID + pseudo-ASIN.
- ISO-8601 publishing date EXTH.
