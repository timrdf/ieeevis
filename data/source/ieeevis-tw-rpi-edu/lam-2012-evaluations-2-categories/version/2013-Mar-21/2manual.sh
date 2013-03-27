file="lodspeakr-basic-menu.svg"
depicts.sh -w -od manual $file --start-to --follow sio:has-member dcterms:subject skos:broader skos:broader skos:broader | tee manual/`basename $file`.ttl.out
