# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line, and also
# from the environment for the first two.
SPHINXOPTS    ?=
SPHINXBUILD   ?= python3 sphinx-build
<<<<<<< HEAD
SOURCEDIR     = .
BUILDDIR      = build
GENERATEDDIR  = pages/13.01.apireference/generated
=======
SOURCEDIR     = source
BUILDDIR      = build
>>>>>>> 324355be65bff257eecbf05c0c8c2569f3d3a5e3

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

<<<<<<< HEAD
clean:
	rm -rf $(BUILDDIR)/* 
	rm -rf $(GENERATEDDIR)/*

=======
>>>>>>> 324355be65bff257eecbf05c0c8c2569f3d3a5e3
.PHONY: help Makefile

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
