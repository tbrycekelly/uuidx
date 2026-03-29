if (!requireNamespace("rextendr", quietly = TRUE)) {
    stop("Install `rextendr` before running this script.", call. = FALSE)
}

if (!requireNamespace("devtools", quietly = TRUE)) {
    stop("Install `devtools` before running this script.", call. = FALSE)
}

rextendr::document()
devtools::test()
