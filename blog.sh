#!/bin/bash

rm -rf ./html
mkdir ./html

SALVEIFS=$IFS
IFS=$(echo -en "\n\b")

# head
if [[ -d './static' ]] && [[ -r './static/head.md' ]]
then
		cat ./static/head.md > README.md
		echo -e '---\n' >> README.md
else
		echo -e "\033[31mWARNING: No ./static/head.md\033[0m"
fi

# body
for i in `ls -r ./`
do
		if [[ $i != 'static' ]] && [[ $i != 'html' ]] && [[ -d $i ]]
		then
				echo -e "\033[32mDIR\033[0m $i"
				echo -e "## $i\n" >> README.md 

				rm ./$i/*.html
				
				for j in `ls $i`
				do
						if [[ -r "./$i/$j" ]] && [[ ! -d "./$i/$j" ]]
						then
								echo -e "  \033[33mFILE\033[0m $j"

								pandoc -s --toc --css ../static/normal.css ./$i/$j -o ./$i/$j.html
								
								s="- [${j%.*}]"
								a=`echo "(./html/$j.html)\n" | sed "s/ /%20/g"`
								echo -e "$s$a" >> README.md
						fi

						if [[ -d "./$i/$j" ]]
						then
								cp -r ./$i/$j ./html/
						fi
						

				done

				mv ./$i/*.html ./html/

				echo -e "\n" >> README.md
		fi
done

# tail
if [[ -d './static' ]] && [[ -r './static/tail.md' ]]
then
		echo -e '\n---\n' >> README.md
		cat ./static/tail.md > README.md
else
		echo -e "\033[31mWARNING: No ./static/tail.md\033[0m"
fi

# foot note
echo -e '\n---\n' >> README.md
echo -e "Made with [BASH](https://www.gnu.org/software/bash/) and [Pandoc](https://www.pandoc.org/).\n" >> README.md
echo Generate Time: \`$(date -u --iso-8601=seconds)\` >> README.md

pandoc -s --css ./static/normal.css README.md -o index.html

IFS=$SAVEIFS

