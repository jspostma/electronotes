#!/usr/bin/env bash

count=0


findtiffs() {
for f in *; do
[[ -d "$f" ]] && [[ -f "$f/$f.tiff" ]] && echo "$f"
done
}

process() {
ntiffs=$(findtiffs | wc -l)

for f in $(findtiffs); do
((count++))
tiffpath="$(readlink -f $f/$f.tiff)"
outpath="$(pwd)/$f.pdf"
echo -e "[$count/$ntiffs]\t$f"
echo -e "\tInput: $tiffpath"
echo -e "\tOutput: $outpath"

time ocrmypdf "$tiffpath" "$outpath"
done

}
process
