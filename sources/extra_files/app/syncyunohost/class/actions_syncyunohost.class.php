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
		$context = explode(':', $parameters['context'] ?? '');
		if ($action == 'add' && in_array('publicnewmembercard', $context, true)) {
			$login = GETPOST('login', 'alphanohtml');
			if ($this->rejectInvalidYunoHostLogin($login)) {
				$action = 'create'; //to remain on the same page keeping values
				return -1;
			}
		}
		if (in_array('membercard', $context, true)) {
			if ($action == 'add') {
				$login = GETPOST('member_login', 'alphanohtml');
				if ($this->rejectInvalidYunoHostLogin($login)) {
					$action = 'create'; //to remain on the same page keeping values
					return -1;
				}
			}
			if ($action == 'update') {
				$login = GETPOST('login', 'alphanohtml');
				if ($this->rejectInvalidYunoHostLogin($login)) {
					$action = 'edit'; //to remain on the same page keeping values
					return -1;
				}
			}
		}

		return 0; // or return 1 to replace standard code
	}
	private function rejectInvalidYunoHostLogin($login)
	{
		global $langs;

		if ($login !== '' && !preg_match('/^[a-z0-9_.]+$/', $login)) {
			$langs->loadLangs(array('syncyunohost@syncyunohost'));
			$this->errors[] = $langs->trans('SyncYunoHostLoginInvalidCharacters');
			return true;
		}

		return false;
	}
}
