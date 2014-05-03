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

if [ ! -e source/SatelliteDatabase/doc.kml ]; then
   unzip -d source/SatelliteDatabase -o source/SatelliteDatabase.kmz
   # ^^
   # Archive:  source/SatelliteDatabase.kmz
   #   inflating: source/SatelliteDatabase/doc.kml  
   #   inflating: source/SatelliteDatabase/banner.jpg  
   #   inflating: source/SatelliteDatabase/logo.png  
   #   inflating: source/SatelliteDatabase/logo_small.gif  
   #   inflating: source/SatelliteDatabase/satellite.png 
else
   echo source/SatelliteDatabase/doc.kml
fi

if [ -e source/SatelliteDatabase/doc.kml ]; then
   echo manual/SatelliteDatabase.csv
   if [ ! -e manual/SatelliteDatabase.csv ]; then
      saxon.sh ../../src/grddl.xsl a a source/SatelliteDatabase/doc.kml > manual/SatelliteDatabase.csv
   fi
else
   echo need source/SatelliteDatabase/doc.kml
fi

if [ ! -e convert-satellite-database.sh ]; then
   cr-create-conversion-trigger.sh -w manual/SatelliteDatabase.csv
else
   echo convert-satellite-database.sh
fi
