<?php

$conf['endpoint']['local'] = 'http://ieeevis.tw.rpi.edu/sparql';
$conf['home'] = '/var/www/lodspeakr/';
$conf['basedir'] = 'http://ieeevis.tw.rpi.edu/';
$conf['debug'] = false;

$conf['ns']['local']   = 'http://ieeevis.tw.rpi.edu/';


$conf['mirror_external_uris'] = false;

# https://github.com/timrdf/prizms/issues/12
$conf['components']['services'][] = '/home/ieeevis/opt/prizms/lodspeakrs/twc-healthdata/lodspeakr/components/services/namedGraphs';
$conf['components']['services'][] = '/home/ieeevis/opt/prizms/lodspeakrs/twc-healthdata/lodspeakr/components/services/graph';
$conf['components']['services'][] = '/home/ieeevis/opt/prizms/lodspeakrs/twc-healthdata/lodspeakr/components/services/statistics';

//Variables in  can be used to store user info.
//For examples, 'title' will be used in the header
//(you can forget about all conventions and use your own as well)
$lodspk['title'] = 'IEEE VIS Source Data';
?>
