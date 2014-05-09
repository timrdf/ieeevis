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

mkdir -p manual automatic

BIBTEX_NG=`cr-dataset-uri.sh --abstract`/bibtex
GRAFFLE_NG=`cr-dataset-uri.sh --abstract`/previous-graffle

java -jar ../../src/siberski/bibtex2rdf.jar -baseuri `cr-dataset-uri.sh --uri`/ source/papers3.bib automatic/papers3.rdf; mv bibtex2rdf.log automatic/
rdf2ttl.sh automatic/papers3.rdf                   > automatic/papers3.rdf.ttl
rapper -i rdfxml -o ntriples automatic/papers3.rdf > automatic/papers3.rdf.nt
tdbloader --loc=automatic/papers3.rdf.tdb --graph $BIBTEX_NG automatic/papers3.rdf

if [[ -e ../graffle/source/papers3.graffle ]]; then
   grddl.sh ../graffle/source/papers3.graffle | grep -v 'depictsBlank' | grep -v on__value | grep -v '__value>' > automatic/papers3.graffle.ttl
   rapper -i turtle -o ntriples automatic/papers3.graffle.ttl -I `cr-dataset-uri.sh --uri` > automatic/papers3.graffle.ttl.ttl
   tdbloader --loc=automatic/papers3.rdf.tdb --graph $GRAFFLE_NG automatic/papers3.graffle.ttl.ttl
else
   # We're starting fresh; there is no graffle.
   tdbquery  --loc=automatic/papers3.rdf.tdb --query=../../src/new-pubs.rq > automatic/papers3.rdf.missing.ttl
   vsr2grf.sh rdf graffle -w -od automatic automatic/papers3.rdf.missing.ttl
fi

tdbquery  --loc=automatic/papers3.rdf.tdb --query=../../src/new-pubs.rq > automatic/new-papers.ttl
vsr2grf.sh $VSR_HOME/src/xsl/from/template.vsr.xsl graffle -w -od automatic automatic/new-papers.ttl
