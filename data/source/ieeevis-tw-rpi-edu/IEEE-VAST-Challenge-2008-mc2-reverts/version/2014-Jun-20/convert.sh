#!/bin/bash
#
#3> <> a conversion:ConversionTrigger; # Could also be conversion:Idempotent;
#3>    foaf:name    "convert.sh";
#3>    rdfs:seeAlso <https://github.com/timrdf/csv2rdf4lod-automation/wiki/Triggers#wiki-3-computation-triggers>;
#3> .
#

# Requires editing of manual/edits.rq.turtle.graffle, copying it to manual/reverts.graffle, then deleting everything but reverts.

reverts='manual/reverts.graffle'

echo
read -p "Q: Have you categorized the edits' comments in manual/edits.rq.turtle.graffle, copied it to $reverts, and deleted all non-revert edits in the former file? [y/n] " -u 1 manual_stuff_was_done

if [[ "$manual_stuff_was_done" == [yY] ]]; then

   if [[ ! -e $reverts.prov.ttl ]]; then
      justify.sh manual/edits.rq.turtle.graffle $reverts manual_organization_then_manual_deletion
   fi

   reverts2='automatic/reverts.graffle'

   grddl.sh $reverts > $reverts2.ttl
   justify.sh $reverts $reverts2.ttl 'https://github.com/timrdf/csv2rdf4lod-automation/blob/master/bin/util/grddl.sh'

   rm -rf $reverts2.ttl.tdb
   tdbloader --loc=$reverts2.ttl.tdb $reverts2.ttl
   justify.sh $reverts2.ttl     $reverts2.ttl.tdb 'http://jena.apache.org/documentation/javadoc/tdb/com/hp/hpl/jena/tdb/TDBLoader'

   tdbquery  --loc=$reverts2.ttl.tdb --query=../../src/reverts.rq > $reverts2.ttl.tdb.ttl
   justify.sh $reverts2.ttl.tdb $reverts2.ttl.tdb.ttl 'https://jena.apache.org/documentation/javadoc/tdb/tdb/tdbquery'
else
   echo
   echo "Okay, go do that and run this script again."
fi
