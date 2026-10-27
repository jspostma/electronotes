#!/bin/bash

# rename scantailor output files and move them to pages folder
# run with the base folder of the issue as the argument

basefolder="$(echo $1 | sed 's/\/$//')" 
echo "basefolder: $basefolder"
tailordir="$basefolder/scans/out"
echo "tailored: $tailordir"
[[ -d "$tailordir/out" ]] && tailordir="$tailordir/out"
echo "$tailordir"

pagesdir="$basefolder/pages"

mkdir -p "$pagesdir"

for f in $tailordir/*.tif; do
  bname="$(basename $f | sed 's/[3 6]00dpi_raw_//')"
  outfile="$pagesdir/$bname"
  printf "\tmoving \033[1;94m%s\033[0m to \033[1;93m%s\033[0m\n" "$f" "$outfile"
  mv "$f" "$outfile"
done

printf "\n\tremoving scantailor cruft\n"
# printf "rm -rf %s\n" "$basefolder/scans/out"
rm -rf "$basefolder/scans/out"
echo "done"
