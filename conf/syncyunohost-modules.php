#!/usr/bin/env php
<?php
if (!defined('NOSESSION')) {
    define('NOSESSION', '1');
}
set_time_limit(0);
$sapi_type = php_sapi_name();
$script_file = basename(__FILE__);
$path = __DIR__.'/';

// Check if the script is running in CLI mode
if (substr($sapi_type, 0, 3) == 'cgi') {
    echo "Error: You are using PHP for CGI. To execute " . $script_file . " from command line, you must use PHP for CLI mode.\n";
    exit(1);
}

// Load required Dolibarr files
require_once $path."../../htdocs/master.inc.php";
// require_once $path."../../htdocs/main.inc.php";
require_once DOL_DOCUMENT_ROOT.'/core/lib/admin.lib.php';

// Check if the required parameters are passed
if ($argc < 2) { // Only checking if action is passed
    echo "Usage: php script.php --action=<action> --modules=<modules> --base_domain=<domain> --main_group=<group> --old_members=<members>\n";
    exit(1);
}

// Initialize variables
$action = '';
$modules = '';
$base_domain = '';
$main_group = '';
$old_members = '';

// Process command-line arguments
foreach ($argv as $val) {
    if (preg_match('/--action=["\']?([^"\']+)["\']?$/', $val, $reg)) {
        $action = $reg[1];
    }
    if (preg_match('/--modules=["\']?([^"\']+)["\']?$/', $val, $reg)) {
        $modules = $reg[1];
    }
    if (preg_match('/--base_domain=["\']?([^"\']+)["\']?$/', $val, $reg)) {
        $base_domain = $reg[1];
    }
    if (preg_match('/--main_group=["\']?([^"\']+)["\']?$/', $val, $reg)) {
        $main_group = $reg[1];
    }
    if (preg_match('/--old_members=["\']?([^"\']+)["\']?$/', $val, $reg)) {
        $old_members = $reg[1];
    }
}

// Validate action parameter
if (empty($action)) {
    echo "Error: Action is required.\n";
    exit(1);
}

// Process action
if ($action == 'activate' || $action == 'deactivate') {
    if (!empty($modules)) {
        $modulesArray = explode(',', $modules);
        foreach ($modulesArray as $modtoaction) {
            $modtoactionnew = str_replace('.class.php', '', $modtoaction);
            $file = $modtoactionnew . '.class.php';
            if($modtoaction =='modSyncYunoHost'){
                $module_dir = "/custom//core/modules/";
            } else {
                $module_dir = "/core/modules/";
            }
            // Check if module file exists before including
            if (file_exists(DOL_DOCUMENT_ROOT . $module_dir . $file)) {
                dol_include_once($module_dir . $file);               
                $res = ($action == 'activate') ? activateModule($modtoactionnew, 1) : deactivateModule($modtoactionnew, 1);
                if ($res === false || (is_array($res) && !empty($res['errors']))) {
                    echo "ERROR: failed to {$action} module file=" . $file . "\n";
                } else {
                    if($action == 'activate' && $modtoaction =='modAdherent'){
                        syncyunohost_adherent_required_fields($db, $conf);
                    }
                }
            } else {
                echo "WARNING: File not found: " . DOL_DOCUMENT_ROOT . $module_dir. $file . "\n";
            }
        }
    }
    
    syncyunohost_update_settings($db, $conf, $base_domain, $main_group, $old_members);
} else {
    echo "Error: Invalid action. Use 'activate' or 'deactivate'.\n";
    exit(1);
}
function syncyunohost_adherent_required_fields($db, $conf){
	$db->begin();
	$res1 = $res2 = 0;
	$res1 = dolibarr_set_const($db, 'ADHERENT_LOGIN_NOT_REQUIRED', 0, 'chaine', 0, '', $conf->entity);
	$res2 = dolibarr_set_const($db, 'ADHERENT_MAIL_REQUIRED', 1, 'chaine', 0, '', $conf->entity);
	if ($res1 < 0 || $res2 < 0 ) {
		setEventMessages('ErrorFailedToSaveData', null, 'errors');
		$db->rollback();
	} else {
		setEventMessages('RecordModifiedSuccessfully', null, 'mesgs');
		$db->commit();
	}	
}
function syncyunohost_update_settings($db, $conf, $base_domain = null, $main_group = null, $old_members = null) {
    if (!empty($base_domain) || !empty($main_group) || !empty($old_members)) {
        $db->begin();
        $errors = false;

        if (!empty($base_domain)) {
            if (dolibarr_set_const($db, 'YUNOHOST_BASE_DOMAIN', $base_domain, 'chaine', 0, '', $conf->entity) < 0) {
                $errors = true;
            }
        }
        if (!empty($main_group)) {
            if (dolibarr_set_const($db, 'YUNOHOST_MAIN_GROUP', $main_group, 'chaine', 0, '', $conf->entity) < 0) {
                $errors = true;
            }
        }
        if (!empty($old_members)) {
            if (dolibarr_set_const($db, 'YUNOHOST_OLD_MEMBERS', $old_members, 'chaine', 0, '', $conf->entity) < 0) {
                $errors = true;
            }
        }

        if ($errors) {
            setEventMessages('ErrorFailedToSaveData', null, 'errors');
            $db->rollback();
        } else {
            setEventMessages('RecordModifiedSuccessfully', null, 'mesgs');
            $db->commit();
        }
    }
}
?>
