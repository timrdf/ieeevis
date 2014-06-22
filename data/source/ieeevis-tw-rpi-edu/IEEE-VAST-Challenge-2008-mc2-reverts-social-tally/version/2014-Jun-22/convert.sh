#!/bin/bash
#
#3> <> a conversion:ConversionTrigger; # Could also be conversion:Idempotent;
#3>    foaf:name    "convert.sh";
#3>    rdfs:seeAlso <https://github.com/timrdf/csv2rdf4lod-automation/wiki/Triggers#wiki-3-computation-triggers>;
#3> .
#

# reverter,against;reverter,supports
saxon.sh ../../src/group-by.xsl xml ttl -v `cr-sdv.sh --attribute-value` group='revert' dim1='reverter' dim2='against'  -in source/reverts.rq.xml > automatic/against.ttl
saxon.sh ../../src/group-by.xsl xml ttl -v `cr-sdv.sh --attribute-value` group='revert' dim1='reverter' dim2='supports' -in source/reverts.rq.xml > automatic/supports.ttl
