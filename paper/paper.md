---
title: 'uuidx: Modern RFC 9562 UUIDs for R in scientific workflows'
tags:
  - R
  - UUID
  - RFC 9562
  - data provenance
  - research software
authors:
  - name: Thomas Bryce Kelly
    corresponding: true
    affiliation: 1
affiliations:
  - index: 1
    name: Icy Seas Co-Laboratory LLC, Fairbanks, Alaska, United States of America
date: 11 April 2026
bibliography: paper.bib
---

# Summary

Reliable identifiers are a small but essential part of modern scientific
computing. Research workflows routinely need stable identifiers for samples,
observations, simulation runs, intermediate files, derived data products, and
published artifacts. `uuidx` is an R package that brings modern UUID support to
these workflows through a compact API for generating, parsing, validating, and
inspecting UUIDs from R. The package implements the current UUID standard,
RFC 9562 [@rfc9562], using the Rust `uuid` crate [@uuidcrate] behind an R
interface built with `extendr` and `rextendr` [@rextendr].

The package is designed for routine use in data pipelines rather than as a
large framework. `uuidx` makes version 7 UUIDs the default for new identifiers,
while also supporting version 4, deterministic version 5, sortable version 6,
and legacy version 1 UUIDs. In addition to canonical string output, it can
return raw 16-byte representations and structured parsed fields. This makes the
package useful both for everyday scripting and for more demanding research
software tasks such as data provenance, distributed job tracking, archival
storage, and system interoperability.

# Statement of need

Scientific workflows often begin with identifiers that are convenient in the
moment but fragile over time: row numbers, sequential file names, or ad hoc
string conventions created within a single script. These approaches become
error-prone when a project expands across multiple analysts, storage systems,
programming languages, or execution environments. The need for robust
identifiers is especially strong in settings where data products are created
incrementally and repeatedly, such as sensor ingest pipelines, laboratory
information management, simulation studies, parameter sweeps, and model
training workflows.

R users have long had access to UUID generation, but modern research software
needs more than a minimal random identifier generator. It benefits from
standards-based support for newer UUID variants, deterministic generation when
identifiers must be reproduced from known inputs, validation at data-ingest
boundaries, and byte-level access when identifiers need to move efficiently
between R, databases, files, and networked services. These concerns are not
specialized edge cases; they are common requirements in reproducible and
distributed scientific workflows.

`uuidx` was created to meet this need with a small package that exposes modern
UUID operations directly in R. The target audience includes research software
engineers, data scientists, and domain researchers who need identifiers that
can be created consistently, validated early, and carried safely through
analysis and publication pipelines.

# State of the field

Several R packages already address parts of the identifier problem. The
longstanding `uuid` package [@uuidpkg] provides generation, parsing, and
validation functionality built around `libuuid`, and remains a useful general
tool for conventional UUID workflows. The `ids` package [@idspkg] includes a
`uuid()` helper as part of a broader toolkit for generating random and
human-readable identifiers. `RcppUUID` [@rcppuuid] exposes version 4, version
5, and version 7 UUID generation through Boost.

`uuidx` was developed as a separate package rather than as an extension of
these tools because it fills a specific gap at the intersection of modern UUID
standards support and research-pipeline ergonomics. First, it targets RFC 9562
directly, including versions 6 and 7, which are particularly relevant to
time-ordered workflows. Second, it provides deterministic, raw-byte, and
field-inspection paths through the same small API rather than treating UUIDs
only as random strings. Third, it includes parsing, version detection,
canonicalization, nil and max UUID helpers, and raw 16-byte output in the same
package, which reduces the amount of glue code needed in pipeline-oriented
projects. Fourth, it uses the Rust `uuid` crate rather than a system
`libuuid` dependency, which keeps generation, parsing, formatting, and
validation in one backend and simplifies portability for package-managed
installations [@uuidcrate; @rextendr].

The result is not a replacement for every existing identifier package in R.
Instead, `uuidx` occupies a narrower role: it is a standards-focused UUID tool
for projects that need modern version support, validation and parsing as
first-class operations, and a clean path from exploratory R code to more
structured scientific software.

# Software design

`uuidx` is intentionally small at the R layer and pushes low-level UUID logic
into a single Rust backend. This design reflects two priorities. The first is
correctness: parsing, version detection, canonicalization, and raw-byte
conversion all rely on the same implementation rather than on a mix of R code
and external utilities. The second is usability: the public R API is compact
enough that researchers can adopt it quickly without learning a new object
system or framework.

The main entry point, `uuid_generate()`, defaults to version 7 UUIDs. This is a
deliberate design choice. Version 7 combines randomness with a timestamp-based
layout, so newly generated identifiers sort more naturally by creation time
than version 4 identifiers while remaining standards-based [@rfc9562]. In
practice, this is helpful for append-heavy scientific logs, artifact
registries, and workflow systems where chronological ordering is routinely used
for debugging and provenance reconstruction.

The package also exposes explicit version-specific helpers. Version 5 UUIDs are
important for deterministic workflows because the same namespace and name pair
always yields the same UUID. This supports reproducible identifiers for samples,
external resources, ontology terms, or controlled workflow inputs. Version 6 is
included for users who need a sortable descendant of version 1, while legacy
version 1 remains available for compatibility work. For privacy-sensitive
time-based UUIDs, `uuidx` uses random node identifiers for versions 1 and 6
rather than exposing a hardware MAC address.

The output design is similarly pragmatic. Most users will work with canonical
character strings, but `uuidx` can also return raw 16-byte vectors and
structured field views. These alternate representations matter in scientific
software because identifiers often need to move between human-facing reports,
storage-efficient binary systems, and diagnostic or auditing tools. By exposing
all three from the same package, `uuidx` reduces the need for downstream
re-implementation.

# Research impact statement

`uuidx` is an early-stage package and does not yet have a publication or
citation record. Its case for JOSS therefore rests on credible near-term
significance rather than on accumulated downstream citations. That significance
comes from the specific role the package plays in research software: it brings
current RFC 9562 UUID functionality to R in a form that is directly useful for
provenance-aware and reproducible workflows.

The repository already includes user-facing documentation, examples,
package-level manuals, automated `testthat` coverage for generation,
deterministic version 5 behavior, validation, parsing, and raw/field outputs,
and platform-specific build configuration for Unix-like systems and Windows.
These materials make the package immediately usable in research codebases that
need dependable identifier handling without introducing a larger dependency
stack. The package is also aligned with a research software use case that is
broader than any single scientific domain: assigning and transporting stable
identifiers across ingest, transformation, analysis, and publication steps.

Near-term impact is especially plausible because identifier handling is one of
the recurring low-level problems that many projects solve repeatedly and
inconsistently. A focused package that offers time-ordered UUIDs by default,
deterministic identifiers where required, and standards-based parsing and
inspection reduces duplicated engineering effort across labs and applied
research teams. `uuidx` is therefore best understood as infrastructure: small
in scope, but potentially high leverage in scientific data systems that depend
on robust provenance and interoperability.

# AI usage disclosure

Generative AI assistance was used in the preparation of this manuscript and
supporting documentation. The tool used was OpenAI Codex (GPT-5-class
assistant), and its role was limited to drafting and revising manuscript text
and related explanatory documentation. The human author reviewed, edited, and
validated all AI-assisted outputs against the package source code,
documentation, tests, and cited external references, and retained full
responsibility for the design, technical claims, and final wording of the
submission materials.

# Acknowledgements

This work received no specific external grant funding. The author acknowledges
institutional support from Icy Seas Co-Laboratory LLC.

# References
