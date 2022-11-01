#!/bin/bash
str=$1
docker run -it --rm -v "`pwd`":/workdir plass/mdtopdf pandoc ${str%.*}.md -o ${str%.*}.pdf -V 'mainfont:DejaVuSerif' -V 'sansfont:DejaVuSans' --pdf-engine=lualatex  -V geometry:margin=.4in
