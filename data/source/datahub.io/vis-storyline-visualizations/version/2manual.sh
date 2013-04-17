#!/bin/bash
#
#3> <> a conversion:PreparationTrigger;
#3>    foaf:name "2manual.sh";
#3> rdfs:seeAlso
#3>  <https://github.com/timrdf/csv2rdf4lod-automation/wiki/Automated-creation-of-a-new-Versioned-Dataset>,
#3>  <https://github.com/timrdf/csv2rdf4lod-automation/wiki/Conversion-trigger>,
#3>  <https://github.com/timrdf/csv2rdf4lod-automation/wiki/Conversion-cockpit>;
#3> .
#
# This script is responsible for processing files in source/ and storing their modified forms
# as files in the manual/ directory. These modified files should be ready for conversion.
# 
# This script is also responsible for constructing the conversion trigger
#   (e.g., with cr-create-conversion-trigger.sh -w manual/*.csv)
#
# When this script resides in a cr:directory-of-versions directory,
# it is invoked by retrieve.sh (or cr-retrieve.sh).
#   (see https://github.com/timrdf/csv2rdf4lod-automation/wiki/Directory-Conventions)
#
# When this script is invoked, the conversion cockpit is the current working directory.
#

# cr-retrieve.sh created source/story_data.tar
pushd source/ &> /dev/null
   tar -xf story_data.tar # creates movie_data/
popd &> /dev/null

for session in `find source/movie_data -name "*_sessions.txt"`; do
   # ^ e.g. source/movie_data/TheMatrix_interaction_sessions.txt
   base=`basename $session` 
   cat $session | awk -f ../../src/2csv.awk > manual/$base.csv
done

cr-create-conversion-trigger.sh -w manual/*.csv
