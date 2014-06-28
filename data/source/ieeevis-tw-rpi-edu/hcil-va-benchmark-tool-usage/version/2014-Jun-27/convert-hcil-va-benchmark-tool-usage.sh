#!/bin/bash
#
#3 <#> a <http://purl.org/twc/vocab/conversion/ConversionTrigger> ;
#3     rdfs:seeAlso <https://github.com/timrdf/csv2rdf4lod-automation/wiki/Conversion-trigger>,
#3                  <https://github.com/timrdf/csv2rdf4lod-automation/blob/master/bin/cr-create-convert-sh.sh> .
#
# datasetID versionID (lastModDate):
# hcil-va-benchmark-tool-usage 2014-Jun-27 ()
#--------------------------------------------------------------

see="https://github.com/timrdf/csv2rdf4lod-automation/wiki/CSV2RDF4LOD-not-set"
CSV2RDF4LOD_HOME=${CSV2RDF4LOD_HOME:?"not set; source my-csv2rdf4lod-source-me.sh or see \$see"}

# The identifiers used to name the dataset that will be converted.
#            (see https://github.com/timrdf/csv2rdf4lod-automation/wiki/Conversion-process-phase:-name)
surrogate="http://ieeevis.tw.rpi.edu" # Came from $CSV2RDF4LOD_BASE_URI when cr-create-conversion-trigger.sh created this script.
sourceID="ieeevis-tw-rpi-edu"               # Came from directory name ../../../ (see https://github.com/timrdf/csv2rdf4lod-automation/wiki/Directory-Conventions)
datasetID="hcil-va-benchmark-tool-usage"             # Came from directory name ../../ (see https://github.com/timrdf/csv2rdf4lod-automation/wiki/Directory-Conventions)
datasetVersion="2014-Jun-27"        # DEPRECATED
versionID="2014-Jun-27"             # Came from directory name ../ (see https://github.com/timrdf/csv2rdf4lod-automation/wiki/Directory-Conventions) renaming datasetVersion (deprecating datasetVersion)
eID="1"                             # enhancement identifier
if [[ "$1" == "-e" && $# -ge 2 ]]; then
   eID="$2" # see https://github.com/timrdf/csv2rdf4lod-automation/wiki/Generating-enhancement-parameters
   shift 2
fi

cr_justdoit="no"
if [[ "$1" == "--force" ]]; then
   cr_justdoit="yes" # see https://github.com/timrdf/csv2rdf4lod-automation/wiki/Conversion-trigger#--force
   shift
fi

if [ -d doc/logs ]; then
   dateInXSDDateTime.sh > doc/logs/conversion-trigger-last-pulled
fi

destDir="automatic"                 # convention has led to always be 'automatic'; the directory where the converted RDF is put.
#--------------------------------------------------------------


#-----------------------------------
# manual/submissions.rq.xlsx.csv
sourceDir="manual"
datafile="submissions.rq.xlsx.csv"
data="$sourceDir/$datafile"
# Bootstrap conversion parameters (see https://github.com/timrdf/csv2rdf4lod-automation/wiki/Conversion-trigger):
subjectDiscriminator=""             # Additional part of URI for subjects created; must be URI-ready (e.g., no spaces).
commentCharacter=""                 # ONLY one character; complain to http://sourceforge.net/projects/javacsv/ otherwise.
cellDelimiter=","                   # ONLY one character; complain to http://sourceforge.net/projects/javacsv/ otherwise.
header=                             # Line that header is on; only needed if not '1'. '0' means no header.
dataStart=                          # Line that data starts; only needed if not immediately after header.
repeatAboveIfEmptyCol=              # 'Fill in' value from row above for this column.
onlyIfCol=                          # Do not process if value in this column is empty
interpretAsNull=                    # NO SPACES
dataEnd=                            # Line on which data stops; only needed if non-data bottom matter (legends, footnotes, etc).
source $CSV2RDF4LOD_HOME/bin/convert.sh


#-----------------------------------
source $CSV2RDF4LOD_HOME/bin/convert-aggregate.sh
# ^^ Note, this step can also be done manually using publish/bin/publish.sh
