#!/bin/bash
#
#3> <> a conversion:ConversionTrigger; # Could also be conversion:Idempotent;
#3>    foaf:name    "convert.sh";
#3>    rdfs:seeAlso <https://github.com/timrdf/csv2rdf4lod-automation/wiki/Triggers#wiki-3-computation-triggers>;
#3> .
#

saxon.sh ../../src/reverts.xsl sparql ttl -w -od automatic source/reverts.rq.sparql
justify.sh source/reverts.rq.sparql automatic/reverts.rq.sparql.ttl 'https://github.com/timrdf/ieeevis/blob/master/data/source/ieeevis-tw-rpi-edu/IEEE-VAST-Challenge-2008-mc2-reverts-social/src/reverts.xsl'
