#!/bin/bash
#
#3> <> a conversion:ConversionTrigger; # Could also be conversion:Idempotent;
#3>    foaf:name    "convert.sh";
#3>    rdfs:seeAlso <https://github.com/timrdf/csv2rdf4lod-automation/wiki/Triggers#wiki-3-computation-triggers>;
#3> .
#

mkdir -p automatic
echo '@prefix prov: <http://www.w3.org/ns/prov#>.' > automatic/usages.ttl
sdv=`cr-dataset-uri.sh --uri`
for ((commit=5; commit<=1013; commit++)); do
   let "prev=$commit+1"
   echo "<$sdv/commit/$commit>"                        >> automatic/usages.ttl
   echo "   prov:used          <$sdv/revision/$prev>;" >> automatic/usages.ttl
   echo "   prov:wasInformedBy <$sdv/commit/$prev> ."  >> automatic/usages.ttl
done

./convert-`cr-dataset-id.sh`.sh # e.g. IEEE-VAST-Challenge-2008-mc1
