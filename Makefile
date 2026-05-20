PKG := uuidx
R := Rscript
CRAN := https://cloud.r-project.org
TARBALL := $(shell ls -t $(PKG)_*.tar.gz 2>/dev/null | head -n 1)

.PHONY: deps document test build check paper-html paper-pdf

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

paper-html:
	cd paper && pandoc paper.md --from markdown --to html --standalone --citeproc --output paper.html

paper-pdf:
	docker run --rm --platform linux/amd64 --volume "$$(pwd)/paper:/data" --user $$(id -u):$$(id -g) --env JOURNAL=joss openjournals/inara
