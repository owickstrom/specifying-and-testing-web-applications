TEX=xelatex

MASTER=src/master.tex
TEX_OPTIONS=options.tex
SRCS=$(shell find src -name '*.tex') \
     $(shell find src -name '*.bib') \
     $(shell find src -name '*.md') \
     $(shell find src -name '*.css')

PANDOC_FLAGS= -s \
						  -f markdown+multiline_tables \
						  --mathjax \
						  -fmarkdown-implicit_figures

PANDOC_BEAMER_FLAGS=$(PANDOC_FLAGS) \
										-t beamer \
										--slide-level=2 \
										-H src/customizations.tex \
										-Vurlcolor=linkcolor \
										--listings

IMAGES_SRCS=$(shell find src/images -name '*.*')
IMAGES=$(IMAGES_SRCS:src/images/%=target/images/%)

SLIDES_DIR=target/slides
SLIDES=$(SLIDES_DIR)/slides.pdf

SLIDES_NO_NOTES_DIR=target/slides-no-notes
SLIDES_NO_NOTES=$(SLIDES_NO_NOTES_DIR)/slides-no-notes.pdf

.PHONY: all
all: html-slides

.PHONY: html-slides
html-slides: target/html/index.html

target/html/index.html: $(SRCS) src/header.html src/theme.css $(IMAGES)
	mkdir -p target/html
	cp -r src/images target/html/
	cp -r src/theme.css target/html/
	pandoc $(PANDOC_FLAGS) \
		-s \
		--slide-level=2 \
		-t revealjs \
		-V theme=moon \
		-V controls=true \
		-V transition=slide \
		-V transitionSpeed=fast \
		--css theme.css \
		--css https://gist.githubusercontent.com/aarongodin/14cbfeda30e725dc6fb802e3dfb01231/raw/b370dd18211309ad1eb33f8ad2e637f6d5248887/cascadia-code.css \
		--highlight-style src/highlight.theme \
		src/slides.md \
		-o $@

serve: html-slides
	python -m http.server --directory target/html

.PHONY: pages
pages: html-slides
	rm -rf docs
	cp -r target/html/ docs

clean:
	rm -rf target
