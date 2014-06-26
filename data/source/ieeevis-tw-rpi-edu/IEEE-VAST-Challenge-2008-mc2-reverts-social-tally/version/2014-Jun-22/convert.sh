#!/bin/bash
#
#3> <> a conversion:ConversionTrigger; # Could also be conversion:Idempotent;
#3>    foaf:name    "convert.sh";
#3>    rdfs:seeAlso <https://github.com/timrdf/csv2rdf4lod-automation/wiki/Triggers#wiki-3-computation-triggers>;
#3> .
#


mkdir -p automatic

# Tally
plan='https://github.com/timrdf/ieeevis/blob/master/data/source/ieeevis-tw-rpi-edu/IEEE-VAST-Challenge-2008-mc2-reverts-social-tally/src/group-by.xsl'

saxon.sh ../../src/group-by.xsl xml ttl -v `cr-sdv.sh --attribute-value` group='revert' dim1='reverter' dim2='against'  -in source/reverts.rq.xml > automatic/against.ttl
justify.sh source/reverts.rq.xml automatic/against.ttl $plan

saxon.sh ../../src/group-by.xsl xml ttl -v `cr-sdv.sh --attribute-value` group='revert' dim1='reverter' dim2='supports' -in source/reverts.rq.xml > automatic/supports.ttl
justify.sh source/reverts.rq.xml automatic/supports.ttl $plan

cat automatic/against.ttl automatic/supports.ttl > automatic/against-and-supports.ttl

# Visualize tally
plan='https://github.com/timrdf/vsr/blob/master/src/xsl/from/template.vsr.xsl'
vsr2grf.sh template.vsr.xsl graffle -w -od automatic  automatic/against-and-supports.ttl
# TODO we collide with what it already says; append if there? : justify.sh automatic/against-and-supports.ttl automatic/against-and-supports.ttl.graffle $plan

cp         'automatic'/against-and-supports.ttl.graffle 'manual'/against-and-supports.ttl.graffle
justify.sh 'automatic'/against-and-supports.ttl.graffle 'manual'/against-and-supports.ttl.graffle 'http://dbpedia.org/resource/File_copying'
