#!/bin/bash
#
#3> @prefix doap:    <http://usefulinc.com/ns/doap#> .
#3> @prefix dcterms: <http://purl.org/dc/terms/> .
#3> @prefix rdfs:    <http://www.w3.org/2000/01/rdf-schema#> .
#3> 
#3> <> a conversion:RetrievalTrigger, doap:Project; # Could also be conversion:Idempotent;
#3>    dcterms:description 
#3>      "Script to retrieve and convert a new version of the dataset.";
#3>    rdfs:seeAlso 
#3>      <https://github.com/timrdf/csv2rdf4lod-automation/wiki/Automated-creation-of-a-new-Versioned-Dataset>,
#3>      <https://github.com/timrdf/csv2rdf4lod-automation/wiki/tic-turtle-in-comments>;
#3> .

if [[ "$1" == 'clean' ]]; then
   rm -rf source/edits.rq.turtle*
   ./prepare.sh clean all
   ./convert.sh clean all
   exit
fi

source ../../../../csv2rdf4lod-source-me-for-ieeevis.sh

cache-queries.sh ${CSV2RDF4LOD_PUBLISH_SPARQL_ENDPOINT:-'http://ieeevis.tw.rpi.edu/sparql'} -o turtle -q ../../src/edits.rq -od source
