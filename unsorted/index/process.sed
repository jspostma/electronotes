
# make the first line a header
#1s/^/==== /
#1s/$/ ====/

#add pipes to the beginning of each entry
#s/^EN/|EN/

#concatenate the first two columns
s/#\t/ /
#replace tabs with pipes
#s/\t/|/g

#insert horizontal spacers between issues
# s/^$/----/
# add pipes to the end of every line
# s/$/|/
# remove pipes from horizontal spacers and header
# s/----|/\n----\n/
# s/=|/=/

/^Volume $start/,/Volume $end/p;
/Volume $end/q" full.txt | sed "/^Volume $end/d; /^$/d; 1d; s/EN#/$start/
