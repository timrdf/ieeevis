#!/bin/bash
#
#3> <> a conversion:ConversionTrigger; # Could also be conversion:Idempotent;
#3>    foaf:name    "convert.sh";
#3>    rdfs:seeAlso <https://github.com/timrdf/csv2rdf4lod-automation/wiki/Triggers#wiki-3-computation-triggers>;
#3> .
#

vsr-follow.sh -w -od manual automatic/lod-cloud-wave-of-arrivals.ttl --start-to --follow vsr:depicts

rapper -i turtle -o ntriples manual/lod-cloud-wave-of-arrivals.ttl.ttl | java edu.rpi.tw.data.rdf.io.nquads.SplitNVC - p > manual/lod-cloud-wave-of-arrivals.ttl.ttl.p

cat manual/lod-cloud-wave-of-arrivals.ttl.ttl.p | java $BTE_PACKAGE.StringTreeEntry - + + > manual/lod-cloud-wave-of-arrivals.ttl.ttl.p.str
