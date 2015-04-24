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

vis_strategy='../../src/edits-absolute.vsr.xsl'

if [[ "$1" == "clean" ]]; then
   echo rm -rf source automatic publish $vis_strategy
        rm -rf source automatic publish $vis_strategy
   exit
fi

auto='automatic/edits.rq.turtle.graffle'
VSR_HOME=${VSR_HOME:?"must be set."}
cp ../../src/edits.vsr.xsl $vis_strategy
perl -pi -e "s|href=\"..|href=\"$VSR_HOME|g" $vis_strategy
vsr2grf.sh $vis_strategy graffle -w -od automatic source/edits.rq.turtle
echo $auto

mkdir -p manual
manual='manual/edits.rq.turtle.graffle'
if [[ ! -e $manual ]]; then
   cp $auto $manual
   justify.sh automatic/edits.rq.turtle.graffle manual/edits.rq.turtle.graffle file_copy
fi
echo $manual

echo
echo
echo "AT THIS POINT: edit manual/edits.rq.turtle.graffle to categorize edits' comments,"
echo "               then copy the file to manual/reverts.graffle and run ./convert.sh"
