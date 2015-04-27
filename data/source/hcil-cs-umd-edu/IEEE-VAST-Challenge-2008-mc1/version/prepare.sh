#!/bin/bash
#
#3> <> a conversion:PreparationTrigger; # Could also be conversion:Idempotent;
#3>    foaf:name "prepare.sh";
#3>    rdfs:seeAlso
#3>     <https://github.com/timrdf/csv2rdf4lod-automation/wiki/Automated-creation-of-a-new-Versioned-Dataset>,
#3>     <https://github.com/timrdf/csv2rdf4lod-automation/wiki/Triggers>,
#3>     <https://github.com/timrdf/csv2rdf4lod-automation/wiki/Conversion-trigger>,
#3>     <https://github.com/timrdf/csv2rdf4lod-automation/wiki/Conversion-cockpit>;
#3> .
#
# This script is responsible for processing files in source/ and storing their modified forms
# as files in the manual/ directory. These modified files should be ready for conversion.
# 
# This script is also responsible for constructing the conversion trigger
#   (e.g., with cr-create-conversion-trigger.sh -w manual/*.csv)
#
# When this script resides in a cr:directory-of-versions directory,
# (e.g. source/datahub-io/corpwatch/version)
# it is invoked by retrieve.sh (or cr-retrieve.sh).
#   (see https://github.com/timrdf/csv2rdf4lod-automation/wiki/Directory-Conventions)
#
# When this script is invoked, the conversion cockpit is the current working directory.
#

if [[ "$1" == 'clean' ]]; then
   echo rm -rf source/VASTchallenge08-20080315-Deinosuchus manual/ automatic publish convert-IEEE-VAST-Challenge-2008-mc1.sh 
        rm -rf source/VASTchallenge08-20080315-Deinosuchus manual/ automatic publish convert-IEEE-VAST-Challenge-2008-mc1.sh 
   exit
fi

mkdir -p 'source' 'manual'

  zipped='source/VASTchallenge08-20080315-Deinosuchus.zip'
unzipped='source/VASTchallenge08-20080315-Deinosuchus'

if [[ ! -e $unzipped ]]; then
   unzip -d source $zipped
   #justify.sh "$zipped" "$unzipped" uncompress
fi
echo $txt

txt='manual/paraiso-edits.txt'
edits='WIKI EDITS PAGE/Paraiso Edits.txt'
if [[ -e $unzipped && ! -e "$txt" ]]; then
   cp "$unzipped/$edits" $txt
   perl -pi -e 's/\r\n/\n/' $txt
   perl -pi -e 's/\r/\n/g'  $txt
   justify.sh "$zipped"           $txt uncompress # Short circuit from zip to the file that we need from the zip.
   #justify.sh "$unzipped/$edits" $txt redelimit
fi
echo $txt

csv='manual/paraiso-edits.csv'
if [[ -e $unzipped && -e "$txt" && ! -e $csv ]]; then
   cat $txt | awk -f ../../src/paraiso-edits.awk > $csv
   justify.sh $txt $csv csvify
fi
echo $csv

trigger='convert-IEEE-VAST-Challenge-2008-mc1.sh'
if [[ ! -e $trigger ]]; then
   cr-create-conversion-trigger.sh -w $csv
fi
echo $trigger
