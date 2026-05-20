## Test environments

- macOS 26.2, R 4.3.3, aarch64-apple-darwin20
- Rust toolchains tested locally:
  - rustc 1.94.1 / cargo 1.94.1
  - rustc 1.81.0 / cargo 1.81.0 for CRAN MSRV verification

## R CMD check results

- `R CMD check --as-cran --no-manual uuidx_0.0.1.tar.gz`:
  - 0 errors
  - 1 warning
  - 2 notes
- The warning and notes are environment-specific on the local machine:
  - `pandoc` and `checkbashisms` are not installed locally
  - the local check could not verify the current time
  - the package is a new submission
- A full local `R CMD check --as-cran` manual build is additionally blocked by
  missing `pdflatex` on the local machine.

## Notes

- This package vendors its Rust dependencies for offline CRAN builds via `rextendr::vendor_pkgs()`.
- The package includes a checked-in patch of `extendr-api` that gates non-API R internals behind the crate's `non-api` feature, preventing those symbols from being linked into the package DLL.
- The source tarball is approximately 3 MB because it includes `src/rust/vendor.tar.xz`.
- The vendored Rust dependency set was verified to build offline with Rust 1.81,
  matching CRAN's current MSRV guidance for Rust packages.
