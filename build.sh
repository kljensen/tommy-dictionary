#!/bin/sh
#
# Create output directory
mkdir -p output/terms

# Check for required software
command -v pandoc >/dev/null 2>&1 || { echo >&2 "I require pandoc but it's not installed.  Aborting."; exit 1; }
command -v parallel >/dev/null 2>&1 || { echo >&2 "I require parallel but it's not installed.  Aborting."; exit 1; }
command -v pdflatex >/dev/null 2>&1 || { echo >&2 "I require pdflatex but it's not installed.  Aborting."; exit 1; }


# Make tex files from markdown files
find data -type f -name "*.md" | \
    parallel pandoc -t latex --template templates/term.tex {} -o output/terms/{/.}.tex

# Get list of tex files
find output/terms -type f -name "*.tex" | \
    sort | \
    sed 's/^/\\input{/;s/$/}/' > output/terms.md

# Create main.tex
pandoc -t latex --standalone output/terms.md -o output/main.tex

# Compile main.tex to pdf
pdflatex -output-directory=output output/main.tex 
