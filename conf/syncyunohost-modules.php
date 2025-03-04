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
require_once $path."../../htdocs/main.inc.php";
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
            
            dolibarr_install_syslog("syncyunohost: {$action} module file=" . $file);
            
            // Check if module file exists before including
            if (file_exists(DOL_DOCUMENT_ROOT . "/core/modules/" . $file)) {
                dol_include_once("/core/modules/" . $file);
                
                $res = ($action == 'activate') ? activateModule($modtoactionnew, 1) : deactivateModule($modtoactionnew, 1);
                
                if ($res === false || (is_array($res) && !empty($res['errors']))) {
                    echo "ERROR: failed to {$action} module file=" . $file . "\n";
                }
            } else {
                echo "WARNING: File not found: " . DOL_DOCUMENT_ROOT . "/core/modules/" . $file . "\n";
            }
        }
    }
    
    // Print optional parameters if provided
    if (!empty($base_domain)) {
        echo "Base Domain: $base_domain\n";
    }
    if (!empty($main_group)) {
        echo "Main Group: $main_group\n";
    }
    if (!empty($old_members)) {
        echo "Old Members: $old_members\n";
    }
} else {
    echo "Error: Invalid action. Use 'activate' or 'deactivate'.\n";
    exit(1);
}
?>
