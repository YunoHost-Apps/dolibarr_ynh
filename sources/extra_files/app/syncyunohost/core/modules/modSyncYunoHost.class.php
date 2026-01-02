<?php
include_once DOL_DOCUMENT_ROOT.'/core/modules/DolibarrModules.class.php';
class modSyncYunoHost extends DolibarrModules
{
    public function __construct($db)
    {
        global $langs, $conf;
        $this->db = $db;

        $this->numero = 500403; 
        $this->rights_class = 'syncyunohost';
        $this->family = 'hr';
        $this->module_position = '90';
        $this->name = preg_replace('/^mod/i', '', get_class($this));
        $this->description = "SyncYunoHostDescription";
        $this->descriptionlong = "SyncYunoHostDescription";
        $this->editor_name = 'Auto Marketing';
        $this->editor_url = 'automarketing.tech';
        $this->version = '1.0.0';
        $this->const_name = 'MAIN_MODULE_'.strtoupper($this->name);
        $this->picto = 'fa-file-o';

        $this->module_parts = array(
            'triggers' => 1,
            'login' => 0,
            'substitutions' => 0,
            'menus' => 0,
            'tpl' => 0,
            'barcode' => 0,
            'models' => 0,
            'printing' => 0,
            'theme' => 0,
            'css' => array(),
            'js' => array(),
            'hooks' => array(),
            'moduleforexternal' => 0,
        );

        $this->dirs = array("/syncyunohost/temp");
        $this->config_page_url = false;
        $this->hidden = true;
        $this->depends = array();
        $this->requiredby = array();
        $this->conflictwith = array();
        $this->langfiles = array("syncyunohost@syncyunohost");
        $this->phpmin = array(7, 0);
        $this->need_dolibarr_version = array(11, -3);
        $this->need_javascript_ajax = 0;
        $this->warnings_activation = array();
        $this->warnings_activation_ext = array();
        $this->const = array();

        if (!isModEnabled("syncyunohost")) {
            $conf->syncyunohost = new stdClass();
            $conf->syncyunohost->enabled = 0;
        }

        $this->tabs = array();
        $this->dictionaries = array();
        $this->cronjobs = array(
            0 => array(
                'label' => 'Sync Yunohost',
                'jobtype' => 'method',
                'class' => '/syncyunohost/class/syncyunohost.class.php',
                'objectname' => 'Syncyunohost',
                'method' => 'doScheduledJob',
                'parameters' => '',
                'comment' => 'Comment',
                'frequency' => 1,
                'unitfrequency' => 3600*24,
                'status' => 1,
                'test' => 'isModEnabled("syncyunohost")',
                'priority' => 50,
            ),
        );
        $this->rights = array();
        $this->menu = array();
    }

    public function init($options = '')
    {
        global $conf, $langs;
        // Initialize ExtraFields
        require_once DOL_DOCUMENT_ROOT.'/core/class/extrafields.class.php';
        $extrafields = new ExtraFields($this->db);
        // Add extra field 'synced_with_yunohost' to members
        $result1 = $extrafields->addExtraField(
            'dont_sync_with_yunohost',
            "Don't sync with YunoHost",
            'boolean',
            100,
            1,
            'adherent',
            0,
            0,
            0,
            '',
            1,
            '',
            3,
            "Check this box if you do not want this member to be synchronized with YunoHost. When enabled, this user will be excluded from the synchronization process.",
            '',
            '',
            'syncyunohost@syncyunohost',
            'isModEnabled("syncyunohost")'
        );
        // Add extra field 'synced_with_yunohost' to members
        $result2 = $extrafields->addExtraField(
            'synced_with_yunohost',
            "Synced with YunoHost",
            'boolean',
            101,
            1,
            'adherent',
            0,
            0,
            0,
            '',
            1,
            '',
            5,
            "",
            '',
            '',
            'syncyunohost@syncyunohost',
            'isModEnabled("syncyunohost")',

        );
        // Remove old permissions and reapply
        $this->remove($options);        
        $sql = array();
        return $this->_init($sql, $options);
    }

    public function remove($options = '')
    {
        $sql = array();
        return $this->_remove($sql, $options);
    }
}
