# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS  :=
SPHINXBUILD := sphinx-build
ROOTDIR     := $(shell readlink -f ..)
DESTINATION := $(ROOTDIR)/docs
SOURCEDIR   := $(DESTINATION)/build-source
TARGETDIR   := $(DESTINATION)/build-target

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(TARGETDIR)" $(SPHINXOPTS) $(O)
.PHONY: help Makefile

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: import-all Makefile
	@ROOTDIR=$(ROOTDIR) $(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(TARGETDIR)" $(SPHINXOPTS) $(O)

# import all documentation easily
import-all:
	mkdir -p $(SOURCEDIR) $(TARGETDIR)
	# cp problem when overriding source in nix. Exclude few files.
	bash -O extglob -O dotglob -c "cp -rp $(ROOTDIR)/docs/content/!(examples) $(SOURCEDIR)"
	mkdir -p $(SOURCEDIR)/examples
	cp -p $(ROOTDIR)/examples/index.rst $(SOURCEDIR)/examples/index.rst
	# import data, files, notebook
	for notebooks in $(ROOTDIR)/examples/*.ipynb; do \
	  jupyter nbconvert $$notebooks --to rst --output-dir=$(SOURCEDIR)/examples ; \
	done

clean:
	rm -rf $(TARGETDIR)
	rm -rf $(SOURCEDIR)
.PHONY: clean
