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
        $this->version = '1.0';
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
        $this->config_page_url = array("setup.php@syncyunohost");
        $this->hidden = false;
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
                'class' => '/syncyunohost/class/syncyunohostobject.class.php',
                'objectname' => 'SyncyunohostObject',
                'method' => 'doScheduledJob',
                'parameters' => '',
                'comment' => 'Comment',
                'frequency' => 1,
                'unitfrequency' => 3600,
                'status' => 0,
                'test' => 'isModEnabled("syncyunohost")',
                'priority' => 50,
            ),
        );
        $this->rights = array();

        $this->menu = array();
        $this->menu[0] = array(
            'fk_menu' => '',
            'type' => 'top',
            'titre' => 'ModuleSyncYunoHostName',
            'prefix' => img_picto('', $this->picto, 'class="pictofixedwidth valignmiddle"'),
            'mainmenu' => 'syncyunohost',
            'leftmenu' => '',
            'url' => '/syncyunohost/syncyunohostindex.php',
            'langs' => 'syncyunohost@syncyunohost',
            'position' => 1000,
            'enabled' => 'isModEnabled("syncyunohost")',
            'perms' => '1',
            'target' => '',
            'user' => 2,
        );
    }

    public function init($options = '')
    {
        global $conf, $langs;
        $sql = array();
        return $this->_init($sql, $options);
    }

    public function remove($options = '')
    {
        $sql = array();
        return $this->_remove($sql, $options);
    }
}