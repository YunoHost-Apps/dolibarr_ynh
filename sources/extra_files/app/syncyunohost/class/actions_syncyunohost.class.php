<?php
require_once DOL_DOCUMENT_ROOT.'/core/class/commonhookactions.class.php';
class ActionsSyncYunoHost extends CommonHookActions
{
	/**
	 * @var DoliDB Database handler.
	 */
	public $db;

	/**
	 * @var string Error code (or message)
	 */
	public $error = '';

	/**
	 * @var array Errors
	 */
	public $errors = array();


	/**
	 * @var array Hook results. Propagated to $hookmanager->resArray for later reuse
	 */
	public $results = array();

	/**
	 * @var string String displayed by executeHook() immediately after return
	 */
	public $resprints;

	/**
	 * @var int		Priority of hook (50 is used if value is not defined)
	 */
	public $priority;


	/**
	 * Constructor
	 *
	 *  @param		DoliDB		$db      Database handler
	 */
	public function __construct($db)
	{
		$this->db = $db;
	}
	public function doActions($parameters, &$object, &$action, $hookmanager)
	{
		global $langs;

		$context = explode(':', $parameters['context'] ?? '');
		// Public member form
		if ($action == 'add' && in_array('publicnewmembercard', $context, true)) {
			$login = GETPOST('login', 'alphanohtml');
			if ($login !== '' && !preg_match('/^[a-z0-9_.]+$/', $login)) {
				$langs->loadLangs(array('syncyunohost@syncyunohost'));
				$this->errors[] = $langs->trans('SyncYunoHostLoginInvalidCharacters');
				$action = 'create';
				return -1;
			}
		}

		// Internal member form
		if ($action == 'add' && in_array('membercard', $context, true)) {
			$login = GETPOST('member_login', 'alphanohtml');
			if ($login !== '' && !preg_match('/^[a-z0-9_.]+$/', $login)) {
				$langs->loadLangs(array('syncyunohost@syncyunohost'));
				$this->errors[] = $langs->trans('SyncYunoHostLoginInvalidCharacters');
				$action = 'create';
				return -1;
            }
        }
		return 0; // or return 1 to replace standard code
	}
}
