#!/bin/bash

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
