#!/bin/bash

mkdir -p automatic
echo '@prefix prov: <http://www.w3.org/ns/prov#>.' > automatic/usages.ttl
sdv=`cr-dataset-uri.sh --uri`
for ((commit=3; commit<=1010; commit++)); do
   let "prev=$commit+1"
   echo "<$sdv/commit/$commit>"                        >> automatic/usages.ttl
   echo "   prov:used          <$sdv/revision/$prev>;" >> automatic/usages.ttl
   echo "   prov:wasInformedBy <$sdv/commit/$prev> ."  >> automatic/usages.ttl
done

./convert-`cr-dataset-id.sh`.sh # e.g. IEEE-VAST-Challenge-2008-mc1
