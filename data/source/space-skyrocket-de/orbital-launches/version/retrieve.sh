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

for year in {1957..2013}; do
   page="http://space.skyrocket.de/doc_chr/lau$year.htm"
   retrieved="source/lau$year.html"
   if [[ ! -e $retrieved ]]; then
      echo curl --progress-bar -L $page
           curl --progress-bar -L $page > $retrieved
      sec=$(($RANDOM%15))
      sleep $sec
   else
      echo $page
   fi
done
