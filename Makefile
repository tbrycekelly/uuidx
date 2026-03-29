PKG := uuidx
R := Rscript
CRAN := https://cloud.r-project.org
TARBALL := $(shell ls -t $(PKG)_*.tar.gz 2>/dev/null | head -n 1)

.PHONY: deps document test build check

deps:
	$(R) -e 'install.packages(c("rextendr", "testthat"), repos = "$(CRAN)")'

document:
	$(R) -e 'rextendr::document()'

test:
	$(R) -e 'testthat::test_local()'

build:
	R CMD build .

check:
	R CMD check --as-cran $(TARBALL)
