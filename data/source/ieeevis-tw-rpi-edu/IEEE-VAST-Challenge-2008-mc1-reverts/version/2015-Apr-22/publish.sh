#!/bin/bash
#
#3> <> a conversion:PublicationTrigger; # Could also be conversion:Idempotent;
#3>    foaf:name    "publish.sh";
#3>    rdfs:seeAlso <https://github.com/timrdf/csv2rdf4lod-automation/wiki/Triggers#wiki-4-publication-triggers>;
#3> .
#


# source/edits.rq.turtle
#    source/edits.rq.turtle.prov.ttl
#
#    manual/edits.rq.turtle.graffle.prov.ttl
#    manual/reverts.graffle.prov.ttl
#
# automatic/reverts.graffle.ttl
# automatic/reverts.graffle.ttl.tdb.ttl
#    automatic/edits.rq.turtle.graffle.prov.ttl
#    automatic/reverts.graffle.ttl.tdb.ttl.prov.ttl
#    automatic/reverts.graffle.ttl.prov.ttl
#    automatic/reverts.graffle.ttl.tdb.prov.ttl

aggregate-source-rdf.sh automatic/reverts.graffle.ttl automatic/reverts.graffle.ttl.tdb.ttl */*.prov.ttl
