file="source/ScenarioPaperopencodingcleancopy.txt.xml.ttl.v6.graffle"
depicts.sh -w -od manual $file --start-to --follow sio:has-member dcterms:subject skos:broader skos:broader skos:broader 2>&1 | tee manual/`basename $file`.ttl.out
