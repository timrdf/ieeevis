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


mkdir -p source/homepage && pushd source/homepage
   # InfoVis Challenges 2003-2006
   # (NOTE: this says 2005, but we get all of the years.)
   #web_directory='http://www.cs.umd.edu/hcil/InfovisRepository/contest-2005' 
   #wget --mirror -e robots=off --no-parent $web_directory

   # VAST 2009
   #web_directory='http://hcil.cs.umd.edu/localphp/hcil/vast/index.php'
   #wget --mirror -e robots=off --no-parent $web_directory

   # VAST 2010
   web_directory='http://hcil.cs.umd.edu/localphp/hcil/vast10/index.php'
   wget --mirror -e robots=off --no-parent $web_directory
popd
