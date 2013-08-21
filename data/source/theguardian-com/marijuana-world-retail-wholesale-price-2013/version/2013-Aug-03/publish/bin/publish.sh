#!/bin/bash

CSV2RDF4LOD_HOME=${CSV2RDF4LOD_HOME:?"not set; source csv2rdf4lod/source-me.sh or see https://github.com/timrdf/csv2rdf4lod-automation/wiki/CSV2RDF4LOD-not-set"}
#sourceID="theguardian-com"
#datasetID="marijuana-world-retail-wholesale-price-2013"
#versionID="2013-Aug-03"
eID="1"

#graph="http://purl.org/twc/lodcloud/source/theguardian-com/dataset/marijuana-world-retail-wholesale-price-2013/version/2013-Aug-03"

export CSV2RDF4LOD_FORCE_PUBLISH="true"
source $CSV2RDF4LOD_HOME/bin/convert-aggregate.sh
export CSV2RDF4LOD_FORCE_PUBLISH="false"
