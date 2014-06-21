#!/bin/bash

mkdir -p automatic
rm -f automatic/usages.ttl
sdv=`cr-dataset-uri.sh --uri`
for ((commit=3; commit<=1010; commit++)); do
   let "prev=$commit-1"
   echo "<$sdv/commit/$commit>"                >> automatic/usages.ttl
   echo "   prov:used <$sdv/revision/$prev> ." >> automatic/usages.ttl
done

./convert-IEEE-VAST-Challenge-2008-mc2.sh
