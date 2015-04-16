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

abstract=`cr-dataset-uri.sh --abstract`
echo abstract: $abstract
BIBTEX='source/papers3.bib'
BIBTEX_NG=$abstract/bibtex

MASTER_GRAFFLE='../master/source/papers3.graffle'
GRAFFLE_NG=$abstract/previous-graffle

java -jar ../../src/siberski/bibtex2rdf.jar -baseuri $abstract/ $BIBTEX automatic/papers3.bib.rdf && mv bibtex2rdf.log automatic/
#rdf2ttl.sh automatic/papers3.bib.rdf                      > automatic/papers3.bib.rdf.ttl
#rapper -q -i rdfxml -o ntriples automatic/papers3.bib.rdf > automatic/papers3.bib.rdf.nt
tdbloader                                     --loc='automatic/papers3.bib.tdb' --graph $BIBTEX_NG automatic/papers3.bib.rdf

if [[ -e "$MASTER_GRAFFLE" ]]; then
   grddl.sh $MASTER_GRAFFLE | grep -v 'depictsBlank' | grep -v on__value | grep -v '__value>' > automatic/papers3.graffle.ttl
   rapper -q -i turtle -o ntriples automatic/papers3.graffle.ttl -I $abstract > automatic/papers3.graffle.ttl.nt
   tdbloader               --loc=automatic/papers3.bib.tdb \
             --graph $GRAFFLE_NG automatic/papers3.graffle.ttl.nt
else
   # We're starting fresh; there is no graffle.
   tdbquery  --loc=automatic/papers3.bib.tdb --query=../../src/new-pubs.rq > automatic/papers3.bib.rdf.missing.ttl
   vsr2grf.sh rdf graffle -w -od automatic automatic/papers3.bib.rdf.missing.ttl
fi

tdbquery  --loc=automatic/papers3.bib.tdb --query=../../src/new-pubs.rq > automatic/new-papers.ttl
vsr2grf.sh $VSR_HOME/src/xsl/from/siberski-bibtex.vsr.xsl graffle -w -od automatic automatic/new-papers.ttl

open automatic/new-papers.ttl.graffle

