#!/bin/bash

tmp_dir=$(mktemp -d)

cleanup() {
    rm -rf "$tmp_dir"
}

trap cleanup EXIT

in_file=${1:?No input file specified}
out_file=${2:?No output file specified}

in_file=$(realpath "$in_file")
out_file=$(realpath "$out_file")

cd "$tmp_dir"

mkdir figures

echo "Input: $in_file"
echo "Output: $out_file"

cat <<EOT >> out.tex
\documentclass{article}
\usepackage{tikz}
\usetikzlibrary{external}
\tikzexternalize[prefix=figures/]
\begin{document}
\begin{tikzpicture}  
$(cat $in_file)
\end{tikzpicture}
\end{document}
EOT

pdflatex -synctex=1 -interaction=nonstopmode --shell-escape out.tex

mv "${tmp_dir}/figures/out-figure0.pdf" "$out_file"

