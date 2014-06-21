#!/bin/bash
#
#3> <> a conversion:ConversionTrigger; # Could also be conversion:Idempotent;
#3>    foaf:name    "convert.sh";
#3>    rdfs:seeAlso <https://github.com/timrdf/csv2rdf4lod-automation/wiki/Triggers#wiki-3-computation-triggers>;
#3> .
#

# Requires manual creation of graffle.

grddl.sh manual/reverts.graffle > manual/reverts.graffle.ttl
justify.sh manual/reverts.graffle manual/reverts.graffle.ttl 'https://github.com/timrdf/csv2rdf4lod-automation/blob/master/bin/util/grddl.sh'

tdbloader --loc=manual/reverts.graffle.ttl.tdb manual/reverts.graffle.ttl
justify.sh manual/reverts.graffle.ttl     manual/reverts.graffle.ttl.tdb 'http://jena.apache.org/documentation/javadoc/tdb/com/hp/hpl/jena/tdb/TDBLoader'

tdbquery  --loc=manual/reverts.graffle.ttl.tdb --query=../../src/reverts.rq > manual/reverts.graffle.ttl.tdb.ttl
justify.sh manual/reverts.graffle.ttl.tdb manual/reverts.graffle.ttl.tdb.ttl 'https://jena.apache.org/documentation/javadoc/tdb/tdb/tdbquery'
