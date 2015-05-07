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

source ../../../../csv2rdf4lod-source-me-for-ieeevis.sh

vis_strategy='../../src/edits-absolute.vsr.xsl'

if [[ "$1" == "clean" ]]; then
   echo rm -rf source automatic publish $vis_strategy
        rm -rf source automatic publish $vis_strategy
   exit
fi

echo

turtle='source/edits.rq.turtle'
if [[ ! -e "$turtle" ]]; then
   echo "$turtle ?"

   echo
   read -p "Q: Cannot find $turtle, run ./retrieve.sh now? [y/n] " -u 1 do_retrieve

   if [[ "$do_retrieve" == [yY] ]]; then
      echo
      echo "= = = = = = retrieve.sh = = = = = = ="
      ./retrieve.sh
      echo
      echo "= = = = = = prepare.sh = = = = = = ="
   else
      exit
   fi
fi

mkdir -p manual
manual='manual/edits.rq.turtle.graffle'
if [[ ! -e "$manual" ]]; then
   auto='automatic/edits.rq.turtle.graffle'
   if [[ ! -e "$VSR_HOME" && -e ~/opt/prizms/repos/vsr ]]; then
      # Thanks, Prizms ---------^^^^^^^^^^^^^^^^^^^^^^
      export VSR_HOME=~/opt/prizms/repos/vsr 
   fi
   VSR_HOME=${VSR_HOME:?"must be set."}
   cp ../../src/edits.vsr.xsl $vis_strategy
   perl -pi -e "s|href=\"\.\.|href=\"$VSR_HOME/src/xsl|g" $vis_strategy
   vsr2grf.sh $vis_strategy 'graffle' -w -od automatic $turtle
   echo $auto

   cp "$auto" "$manual"
   justify.sh $auto $manual 'file_copy'
   echo $manual
else
   echo "$manual already exists."
fi

echo
echo
echo "AT THIS POINT: edit $manual to categorize edits' comments,"
echo "               then copy the file to manual/reverts.graffle and run ./convert.sh"
