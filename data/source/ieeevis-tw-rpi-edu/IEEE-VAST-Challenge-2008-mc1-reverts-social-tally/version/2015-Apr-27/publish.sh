#!/bin/bash
#
#3> <> a conversion:PublicationTrigger; # Could also be conversion:Idempotent;
#3>    foaf:name    "publish.sh";
#3>    rdfs:seeAlso <https://github.com/timrdf/csv2rdf4lod-automation/wiki/Triggers#wiki-4-publication-triggers>;
#3> .
#

if [[ ! -e manual/against-and-supports.ttl.graffle.prov.ttl ]]; then
   justify.sh 'automatic/against-and-supports.ttl.graffle' manual/against-and-supports.ttl.graffle 'copy_and_manual_edit'
fi

for exported in against-and-supports.ttl.graffle.pdf against-and-supports.ttl.graffle.svg; do
   if [[ -e manual/$exported ]]; then
      justify.sh against-and-supports.ttl.graffle manual/$exported 'export'
   fi
done

cr-publish.sh source/* automatic/* manual/*
