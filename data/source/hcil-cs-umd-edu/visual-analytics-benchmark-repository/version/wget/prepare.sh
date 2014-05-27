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

mkdir -p automatic

tidy.sh -w -od automatic source/hcil2.cs.umd.edu/newvarepository/benchmarks.php
justify.sh source/hcil2.cs.umd.edu/newvarepository/benchmarks.php automatic/benchmarks.php.tidy http://dbpedia.org/resource/HTML_Tidy

saxon.sh ../../src/benchmarks.xsl html csv -w -od automatic automatic/benchmarks.php.tidy
justify.sh automatic/benchmarks.php.tidy automatic/benchmarks.php.tidy.csv ../../src/benchmarks.xsl

benchmarks=''
pushd automatic;
   # Note, we're missing the '/challenges/' constraint...
   # http://www.cyberciti.biz/tips/handling-filenames-with-spaces-in-bash.html
   find ../source -mindepth 6 -maxdepth 6 -name 'index.html' -print0 | while read -d $'\0' benchmark; do
      echo $benchmark
      benchmark_url=`echo ${benchmark#../source/} | sed 's/ /%20/g'`
      benchmark_url=${benchmark_url%index.html}
      echo BENCHMARK_URL: $benchmark_url
      hash=`md5.sh -qs "$benchmark_url"`
      ln -s "$benchmark"        benchmark-$hash.html
      tidy.sh                   benchmark-$hash.html > benchmark-$hash.html.tidy
      saxon.sh ../../../src/benchmark.xsl 'html' 'csv' -v "url-base=http://$benchmark_url" -in benchmark-$hash.html.tidy > benchmark-$hash.html.tidy.csv
      benchmarks="$benchmarks source/benchmark-$hash.html.tidy.csv"
   done
popd

cr-create-conversion-trigger.sh -w automatic/benchmarks.php.tidy.csv $benchmarks
