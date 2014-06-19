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

# (cur) (last) 23:44, 15 January 2007 Alonzo (Talk | contribs) m (100,571 bytes) (?Scientific criticism of Paraiso beliefs - link)
# (cur) (last) 03:21, 14 January 2007 Alfonso (Talk | contribs) (100,552 bytes) (?External links - pruning links (see talk))

if [[ ! -e manual/paraiso-edits.txt ]]; then
   cp source/VASTchallenge08-20080315-Deinosuchus/WIKI\ EDITS\ PAGE/Paraiso\ Edits.txt manual/paraiso-edits.txt
fi

if [[ -e manual/paraiso-edits.txt ]]; then
   perl -pi -e 's/\r\n/\n/' manual/paraiso-edits.txt 
   perl -pi -e 's/\r/\n/g'  manual/paraiso-edits.txt 

   echo manual/paraiso-edits.csv
   cat manual/paraiso-edits.txt | grep '^# (cur) (last)' | awk -f ../../src/paraiso-edits.awk > manual/paraiso-edits.csv
fi
