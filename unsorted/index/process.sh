#!/bin/bash

getVol() {

[ -z "$1" ] && read -p "Volume number: " vol || vol="$1"

start=$vol
end=$(expr 1 + $vol)

sed -n "/^Volume $start/,/Volume $end/p; /Volume $end/q" /mnt/nas/library/periodicals/electronotes/index/full.txt | sed "/^Volume $end/d; /^$/d; 1d;" # s/EN#/$start/"

}


getIssue() {

issue=$1

printf "===== EN%s =====\n\n| Page | Title | Author | Notes |\n" "$issue"
sed "/EN#\t$issue\t"'/!d; '"s/^.*EN#\t$issue\t/| /; s/\t/ | /g; s/$/ |/; s/(/ | /; s/)//" /mnt/nas/library/periodicals/electronotes/index/full.txt
printf '\n'

}
# count=1
# 
# while [ $count -lt 23 ]; do
# getVol "$count"
# # echo $count
# count=$(expr 1 + $count)
# done
# 
getTable() {
    for x in {
}
