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

mkdir source &> /dev/null

function chill {
   sec=$(($RANDOM%10))
   sleep $sec
}

function retrieve {
   year="$1"
   month="$2"
   echo $year $month "http://www.n2yo.com/browse/?y=$year&m=$month"
   if [[ ! -e source/$year-$month.html ]]; then
      url="http://www.n2yo.com/browse/?y=$year&m=$month"
      curl --progress-bar $url > source/$year-$month.html
      justify.sh          $url   source/$year-$month.html 'http://dbpedia.org/resource/CURL'
      chill
   fi
}

if [ ! -e source/browse.html ]; then
   curl --progress-bar 'http://www.n2yo.com/browse/' > source/browse.html
   justify.sh http://www.n2yo.com/browse/ source/browse.html 'http://dbpedia.org/resource/CURL'
fi

retrieve 1958 10
retrieve 1958 11
for year in `seq 1959 \`date +%Y\``; do
   end='12'
   if [[ $year -eq `date +%Y` && \
         $end  -gt `date +%m` ]]; then
      end=`date +%m`
   fi
   for month in `seq 1 $end`; do
      if [[ $month -lt 10 ]]; then
         month="0$month"
      fi
      retrieve $year $month
   done
done
