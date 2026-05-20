# uuidx: Modern UUIDs for R in Scientific Workflows

## Summary

`uuidx` is an R package for generating, parsing, validating, and inspecting
modern UUIDs from R using a Rust backend. The package implements RFC 9562 UUID
workflows through the Rust `uuid` crate and exposes a small R-facing API built
with `extendr` and `rextendr`. Its core design choice is to make version 7
UUIDs the default for new identifiers while still supporting version 4,
deterministic version 5, sortable version 6, and legacy version 1 identifiers.

The package is intentionally narrow in scope. Rather than providing a large
abstraction layer around metadata systems or databases, `uuidx` focuses on a
small set of reliable identifier operations that scientific software can reuse
across data ingestion, computation, and publication workflows.

## Statement of Need

Scientific projects routinely need identifiers for samples, observations,
simulation runs, intermediate artifacts, derived datasets, and released
products. In practice, these identifiers often begin as ad hoc file names,
row-level integers, or handwritten string conventions that do not travel well
across systems. This becomes a problem when projects grow beyond a single
script or analyst and begin to rely on distributed processing, archival
storage, database indexing, or multi-language pipelines.

Base R does not provide first-class support for the newer RFC 9562 UUID
variants that are useful in modern data systems. Researchers and research
software engineers therefore need a lightweight tool that can generate
standards-based identifiers, validate them during data intake, convert them to
binary form when compact storage is needed, and preserve deterministic behavior
when identifiers must be reproduced from known inputs.

`uuidx` addresses this need by giving R users access to modern UUID versions in
a package that is both small enough for routine scripting and robust enough for
larger computational projects.

## Package Overview

The main entry point is `uuid_generate()`, which defaults to version 7 UUIDs.
This is a practical choice for new work because version 7 combines strong
uniqueness properties with time ordering, which improves the behavior of sorted
logs, append-heavy stores, and database keys relative to purely random version 4
identifiers. The package also exposes explicit helpers for version-specific
generation: `uuid_v7()`, `uuid_v4()`, `uuid_v5()`, `uuid_v6()`, and `uuid_v1()`.

For deterministic workflows, `uuid_v5()` generates stable identifiers from a
namespace UUID and a name. `uuidx` accepts the standard namespace aliases
`"dns"`, `"url"`, `"oid"`, and `"x500"`, which makes it easy to create
reproducible identifiers for external resources, ontology terms, or project
defined names. This is particularly useful when a workflow must regenerate the
same identifier across repeated analyses or across collaborating systems.

The package also supports validation and structural inspection through
`uuid_validate()`, `uuid_version()`, and `uuid_parse()`. Parsing can return
canonical character strings, 16-byte raw values, or a structured field view.
These multiple output forms matter in practice: character values are convenient
for user-facing interfaces, raw vectors are helpful for compact binary storage
or system interoperability, and field-level parsing supports auditing and
quality-control tasks.

Implementation is delegated to the Rust `uuid` crate, with the R interface
provided through `extendr` and `rextendr`. This keeps parsing, formatting,
validation, and byte conversion in one backend while allowing the R layer to
remain small and easy to understand. For privacy-sensitive time-based UUIDs,
the package uses randomly generated node identifiers for versions 1 and 6
rather than exposing a hardware MAC address.

## Value for Scientific Workflows

The scientific value of `uuidx` comes less from UUID generation itself than
from what stable, portable identifiers enable in downstream workflows.

First, version 7 UUIDs provide a simple default for time-aware provenance. A
workflow manager can assign a new UUID to each run, task, or artifact and then
retain identifiers that sort naturally by creation time. This is useful for
laboratory data collection, simulation campaigns, sensor ingest pipelines, and
iterative model training where events are often reviewed chronologically.

Second, version 5 UUIDs support reproducible identifier assignment. If a
project derives identifiers from a namespace and a known name, then the same
sample, input file, or controlled vocabulary term can receive the same UUID on
every run. This helps reduce accidental duplication and simplifies joins across
tables, APIs, and data products created on different machines or at different
times.

Third, raw 16-byte output is useful for high-volume scientific data systems.
Many projects need identifiers that move efficiently between R, databases,
Arrow or Parquet-based storage layers, web services, and other languages. A
package that can expose both canonical strings and raw bytes gives users a
clear path from exploratory scripting to more performance-sensitive
infrastructure.

Finally, explicit validation and version detection are valuable for data
quality. Scientific workflows often ingest identifiers from heterogeneous
sources, including manual spreadsheets, vendor exports, APIs, and legacy
archives. Being able to check validity, canonicalize formatting, and inspect
UUID structure inside R reduces ambiguity early in the pipeline and makes
downstream errors easier to diagnose.

## Conclusion

`uuidx` fills a focused but important role in the R ecosystem by bringing modern
RFC 9562 UUID support to scientific and engineering workflows. Its small API,
Rust-backed implementation, deterministic and time-ordered UUID support, and
ability to expose both textual and binary representations make it a practical
building block for reproducible, distributed, and provenance-aware research
software.

## References

- Davis, K., Peabody, B., and Leach, P. (2024). *RFC 9562: Universally Unique
  IDentifiers (UUIDs)*. Internet Engineering Task Force.
  <https://datatracker.ietf.org/doc/html/rfc9562>
- Kieffer, R., and contributors. *uuid* crate documentation.
  <https://docs.rs/uuid/latest/uuid/>
- Ushey, K., Vaughan, D., and the extendr authors. *rextendr: Call Rust code
  from R using the extendr crate*.
  <https://extendr.rs/rextendr/>
