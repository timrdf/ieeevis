#!/bin/bash

file="source/lodspeakr-basic-menu.svg"
depicts.sh -w -od manual $file --start-to --follow sio:has-member dcterms:subject skos:broader skos:broader skos:broader 2>&1 | tee manual/`basename $file`.ttl.out
aggregate-source-rdf.sh manual/*.ttl
