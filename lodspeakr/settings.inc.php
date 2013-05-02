<?php

$conf['endpoint']['local'] = 'http://ieeevis.tw.rpi.edu/sparql';
$conf['home'] = '/var/www/lodspeakr/';
$conf['basedir'] = 'http://ieeevis.tw.rpi.edu/';
$conf['debug'] = false;

$conf['ns']['local']   = 'http://ieeevis.tw.rpi.edu/';


$conf['mirror_external_uris'] = false;

// Cherry-picked components (see https://github.com/alangrafu/lodspeakr/wiki/Reuse-cherry-picked-components-from-other-repositories)
$conf['components']['types'][] = '/home/ieeevis/opt/prizms/lodspeakrs/twc-healthdata/lodspeakr/components/types/conv:VersionedDataset';
$conf['components']['types'][] = '/home/ieeevis/opt/prizms/lodspeakrs/twc-healthdata/lodspeakr/components/types/rdfs:Resource';
$conf['components']['types'][] = '/home/ieeevis/opt/prizms/lodspeakrs/twc-healthdata/lodspeakr/components/types/conv:MetaDataset';
// $conf['components']['types'][] = '/home/ieeevis/opt/prizms/lodspeakrs/twc-healthdata/lodspeakr/components/types/old.conv';
$conf['components']['types'][] = '/home/ieeevis/opt/prizms/lodspeakrs/twc-healthdata/lodspeakr/components/types/void:Dataset';
$conf['components']['types'][] = '/home/ieeevis/opt/prizms/lodspeakrs/twc-healthdata/lodspeakr/components/types/conv:AbstractDataset';
$conf['components']['types'][] = '/home/ieeevis/opt/prizms/lodspeakrs/twc-healthdata/lodspeakr/components/types/conv:LayerDataset';
$conf['components']['services'][] = '/home/ieeevis/opt/prizms/lodspeakrs/twc-healthdata/lodspeakr/components/services/vocabularies';
$conf['components']['services'][] = '/home/ieeevis/opt/prizms/lodspeakrs/twc-healthdata/lodspeakr/components/services/ckan-mirror-status';
$conf['components']['services'][] = '/home/ieeevis/opt/prizms/lodspeakrs/twc-healthdata/lodspeakr/components/services/sanity-checks';
$conf['components']['services'][] = '/home/ieeevis/opt/prizms/lodspeakrs/twc-healthdata/lodspeakr/components/services/dataset-sample-graphs';
$conf['components']['services'][] = '/home/ieeevis/opt/prizms/lodspeakrs/twc-healthdata/lodspeakr/components/services/search';
$conf['components']['services'][] = '/home/ieeevis/opt/prizms/lodspeakrs/twc-healthdata/lodspeakr/components/services/instances';
// $conf['components']['services'][] = '/home/ieeevis/opt/prizms/lodspeakrs/twc-healthdata/lodspeakr/components/services/tim';
$conf['components']['services'][] = '/home/ieeevis/opt/prizms/lodspeakrs/twc-healthdata/lodspeakr/components/services/triples';
$conf['components']['services'][] = '/home/ieeevis/opt/prizms/lodspeakrs/twc-healthdata/lodspeakr/components/services/datasets';
$conf['components']['services'][] = '/home/ieeevis/opt/prizms/lodspeakrs/twc-healthdata/lodspeakr/components/services/classes';
$conf['components']['services'][] = '/home/ieeevis/opt/prizms/lodspeakrs/twc-healthdata/lodspeakr/components/services/namedGraphs';
$conf['components']['services'][] = '/home/ieeevis/opt/prizms/lodspeakrs/twc-healthdata/lodspeakr/components/services/graph';
$conf['components']['services'][] = '/home/ieeevis/opt/prizms/lodspeakrs/twc-healthdata/lodspeakr/components/services/statistics';

//Variables in  can be used to store user info.
//For examples, 'title' will be used in the header
//(you can forget about all conventions and use your own as well)
$lodspk['title'] = 'IEEE VIS Source Data';
?>
