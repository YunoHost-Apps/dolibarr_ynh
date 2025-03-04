#!/usr/bin/env php
<?php
if (!defined('NOSESSION')) {
	define('NOSESSION', '1');
}

$sapi_type = php_sapi_name();
$script_file = basename(__FILE__);
$path = __DIR__.'/';

// Test if batch mode
if (substr($sapi_type, 0, 3) == 'cgi') {
	echo "Error: You are using PHP for CGI. To execute ".$script_file." from command line, you must use PHP for CLI mode.\n";
	exit(1);
}
require_once $path."../../htdocs/master.inc.php";
require $path."../../htdocs/main.inc.php";
require_once DOL_DOCUMENT_ROOT.'/core/lib/admin.lib.php';
$action = GETPOST('action', 'aZ09');
$value = GETPOST('value', 'alpha');
$modtoactivatenew = preg_replace('/\.class\.php$/i', '', $modtoactivate);
$file = $modtoactivatenew.'.class.php';
dolibarr_install_syslog('step5: activate module file='.$file);
$res = dol_include_once("/core/modules/".$file);
$res = activateModule($modtoactivatenew, 1);
if (!empty($res['errors'])) {
		print 'ERROR: failed to activateModule() file='.$file;
}
