#!/bin/bash
#
#3> <> a conversion:ConversionTrigger; # Could also be conversion:Idempotent;
#3>    foaf:name    "convert.sh";
#3>    rdfs:seeAlso <https://github.com/timrdf/csv2rdf4lod-automation/wiki/Triggers#wiki-3-computation-triggers>;
#3> .
#

source ../../../../csv2rdf4lod-source-me-for-ieeevis.sh 

if [[ "$1" == "clean" ]]; then
   echo rm -rf automatic/ ../../src/edits-absolute.vsr.xsl
        rm -rf automatic/ ../../src/edits-absolute.vsr.xsl
   exit
fi

mkdir -p automatic manual

# Tally
plan='https://github.com/timrdf/ieeevis/blob/master/data/source/ieeevis-tw-rpi-edu/IEEE-VAST-Challenge-2008-mc2-reverts-social-tally/src/group-by.xsl'

saxon.sh ../../src/group-by.xsl xml ttl -v `cr-sdv.sh --attribute-value` group='revert' dim1='reverter' dim2='against'  -in source/reverts.rq.xml > automatic/against.ttl
justify.sh source/reverts.rq.xml automatic/against.ttl $plan

saxon.sh ../../src/group-by.xsl xml ttl -v `cr-sdv.sh --attribute-value` group='revert' dim1='reverter' dim2='supports' -in source/reverts.rq.xml > automatic/supports.ttl
justify.sh source/reverts.rq.xml automatic/supports.ttl $plan

cat automatic/against.ttl automatic/supports.ttl > automatic/against-and-supports.ttl
echo automatic/against-and-supports.ttl

# Visualize tally
plan='https://github.com/timrdf/vsr/blob/master/src/xsl/from/template.vsr.xsl'
#vsr2grf.sh template.vsr.xsl graffle -w -od automatic  automatic/against-and-supports.ttl
# TODO we collide with what it already says; append if there? : justify.sh automatic/against-and-supports.ttl automatic/against-and-supports.ttl.graffle $plan

turtle=automatic/against-and-supports.ttl
  auto=automatic/against-and-supports.ttl.graffle
   manual=manual/against-and-supports.ttl.graffle
vis_strategy='../../src/edits-absolute.vsr.xsl'
if [[ ! -e "$manual" ]]; then
   VSR_HOME=${VSR_HOME:?"must be set."}
   cp ../../src/edits.vsr.xsl $vis_strategy
   # //\\
   # TODO: push this into VSR, since already done at
   # https://github.com/timrdf/ieeevis/blob/master/data/source/ieeevis-tw-rpi-edu/IEEE-VAST-Challenge-2008-mc1-reverts/version/2015-Apr-22/prepare.sh
   # \\//
   perl -pi -e "s|href=\"\.\.|href=\"$VSR_HOME/src/xsl|g" $vis_strategy
   vsr2grf.sh $vis_strategy 'graffle' -w -od automatic/ $turtle
   echo $auto

   cp "$auto" "$manual"
   #justify.sh $auto $manual 'file_copy'
   # TODO we collide with what it already says; append if there? : justify.sh automatic/against-and-supports.ttl automatic/against-and-supports.ttl.graffle $plan
   echo $manual
else
   echo "$manual already exists."
fi

#cp         'automatic'/against-and-supports.ttl.graffle 'manual'/against-and-supports.ttl.graffle
#justify.sh 'automatic'/against-and-supports.ttl.graffle 'manual'/against-and-supports.ttl.graffle 'http://dbpedia.org/resource/File_copying'
