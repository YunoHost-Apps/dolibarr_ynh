<?php
require_once DOL_DOCUMENT_ROOT.'/core/triggers/dolibarrtriggers.class.php';
class InterfaceSyncYunoHostTriggers extends DolibarrTriggers
{
	public function __construct($db)
	{
		$this->db = $db;
		$this->name = preg_replace('/^Interface/i', '', get_class($this));
		$this->family = "hr";
		$this->description = "SyncYunoHost triggers.";
		$this->version = '1.0.0';
		$this->picto = 'syncyunohost@syncyunohost';
	}
	public function getName()
	{
		return $this->name;
	}
	public function getDesc()
	{
		return $this->description;
	}
	public function runTrigger($action, $object, User $user, Translate $langs, Conf $conf)
	{
	    if (!isModEnabled('syncyunohost')) {
	        return 0; // Exit if the module is disabled
	    }

	    // Retrieve YunoHost configuration values
	    $yunohostBaseDomain = $conf->global->YUNOHOST_BASE_DOMAIN;
	    $yunohostMainGroup = $conf->global->YUNOHOST_MAIN_GROUP;
	    $check_dont_sync_with_yunohost = $this->check_dont_sync_with_yunohost($object);
	    if($check_dont_sync_with_yunohost){
		    $this->removeSubDontSync($object, $yunohostBaseDomain, $yunohostMainGroup);
		    return 0;
	    }
		// Handle actions using a switch statement
		switch ($action) {
			case 'MEMBER_CREATE':
				$fullName = $this->getFullName($object);
				$this->memberToUser($object->id);
				$this->runCommand('create', $object->login, $object->pass, $fullName, $object->email, $yunohostBaseDomain);
				$this->updateMemberExtraField($object->id, 'synced_with_yunohost', 1);
			break;

			case 'MEMBER_SUBSCRIPTION_CREATE':
				$this->handleSubscriptionCreate($object, $yunohostBaseDomain, $yunohostMainGroup);
			break;

			case 'MEMBER_SUBSCRIPTION_DELETE':
			case 'MEMBER_SUBSCRIPTION_EXPIRED': // custum trigger by Syncyunohost
				$this->handleSubscriptionDelete($object, $yunohostBaseDomain, $yunohostMainGroup);
			break;

			case 'MEMBER_VALIDATE':
			case 'MEMBER_RESILIATE':
			case 'MEMBER_NEW_PASSWORD':
				$get_synced_with_yunohost = $this->get_synced_with_yunohost($object);
				if (!$get_synced_with_yunohost) {
					$fullName = $this->getFullName($object);
					$newPass = $this->generateSecurePassword(20);
					$create_output = $this->runCommand('create', $object->login, $newPass, $fullName, $object->email, $yunohostBaseDomain);
					if ($this->check_user_exist($create_output, $object->login)) {
						$this->updateMemberExtraField($object->id, 'synced_with_yunohost', 1);
						$get_synced_with_yunohost = 1;
						$this->member_subscription($object, $yunohostMainGroup);
					}
				}
				if ($get_synced_with_yunohost) {
					if ($action === 'MEMBER_NEW_PASSWORD') {
						$this->runCommand('password', $object->login, $object->pass);
					}
				}
			break;

			case 'MEMBER_MODIFY':
				$this->handleMemberModify($object, $yunohostBaseDomain, $yunohostMainGroup);
			break;

			case 'MEMBER_DELETE':
				$get_synced_with_yunohost = $this->get_synced_with_yunohost($object);
				if ($get_synced_with_yunohost) {
					$this->runCommand('delete', $object->login);
					$this->deleteMemberUser($object);
				}
			break;

		        default:
			// Log unmatched actions
	        	// dol_syslog("No matching action for DebianSync trigger: $action", LOG_WARNING);
	        	return 0;
		}
		return 0;
	}
	private function get_synced_with_yunohost($object) {
		return isset($object->array_options) ? ($object->array_options['options_synced_with_yunohost'] ?? 0) : 0;
	}
	private function check_dont_sync_with_yunohost($object) {
		return isset($object->array_options) ? ($object->array_options['options_dont_sync_with_yunohost'] ?? 0) : 0;
	}
	private function getFullName($object)
	{
		// Generate full name based on company or personal name
		return $object->company 
	        ? sprintf("%s", $object->company) 
	        : sprintf("%s %s", $object->firstname, $object->lastname);
	}
	private function handleSubscriptionCreate($object, $baseDomain, $mainGroup)
	{
		$member = new Adherent($this->db);
		if ($member->fetch($object->fk_adherent) > 0) {
			$check_dont_sync_with_yunohost = $this->check_dont_sync_with_yunohost($member);
			if($check_dont_sync_with_yunohost){
				return 0;
			}
			$synced_with_yunohost = $this->get_synced_with_yunohost($member);
			if (!$synced_with_yunohost) {
				$fullName = $this->getFullName($member);
				$newPass = $this->generateSecurePassword(20);
				$create_output = $this->runCommand('create', $member->login, $newPass, $fullName, $member->email, $baseDomain);
				if ($this->check_user_exist($create_output, $object->login)) {
		        		$this->memberToUser($object->fk_adherent);
		           		$synced_with_yunohost = 1;
		           		$this->updateMemberExtraField($object->fk_adherent, 'synced_with_yunohost', 1);
		        	}
			}
			if($synced_with_yunohost){
				$this->member_subscription($member, $mainGroup);
			}
		}
	}
	private function handleSubscriptionDelete($object, $baseDomain, $mainGroup)
	{
		$member = new Adherent($this->db);
		if ($member->fetch($object->fk_adherent) > 0) {
			$check_dont_sync_with_yunohost = $this->check_dont_sync_with_yunohost($member);
			if($check_dont_sync_with_yunohost){
				return 0;
			}
			$synced_with_yunohost = $this->get_synced_with_yunohost($member);
			if (!$synced_with_yunohost) {
				$fullName = $this->getFullName($member);
				$newPass = $this->generateSecurePassword(20);
				$create_output = $this->runCommand('create', $member->login, $newPass, $fullName, $member->email, $baseDomain);
				if ($this->check_user_exist($create_output, $object->login)) {
					$this->memberToUser($object->fk_adherent);
					$synced_with_yunohost = 1;
					$this->updateMemberExtraField($object->fk_adherent, 'synced_with_yunohost', 1);
				}
			}
			if($synced_with_yunohost){
				$this->runCommand('deactivate', $member->login, $baseDomain, $mainGroup);
			}
		}
	}
	private function removeSubDontSync($object, $baseDomain, $mainGroup){
		$synced_with_yunohost = $this->get_synced_with_yunohost($object);
		if($synced_with_yunohost){
			$this->runCommand('deactivate', $object->login, $baseDomain, $mainGroup);
			$this->updateMemberExtraField($object->id, 'synced_with_yunohost', 0);
		}
	}
	private function handleMemberModify($object, $baseDomain, $mainGroup)
	{
		$synced_with_yunohost = $this->get_synced_with_yunohost($object);
		if (!$synced_with_yunohost) {
			$oldFullName = $this->getFullName($object->oldcopy);
			$newPass = $this->generateSecurePassword(20);
			$create_output = $this->runCommand('create', $object->login, $newPass, $oldFullName, $object->oldcopy->email, $baseDomain);
			dol_syslog("create_output from modSyncYunoHost = $create_output", LOG_DEBUG);
			if ($this->check_user_exist($create_output, $object->login)) {
				$this->memberToUser($object->id);
				$synced_with_yunohost = 1;
				$this->updateMemberExtraField($object->id, 'synced_with_yunohost', 1);
				$this->member_subscription($object, $mainGroup);
			}
		}
		if($synced_with_yunohost){
			$fullName = $this->getFullName($object);

			// Update email if it has changed
			if ($object->oldcopy->email !== $object->email) {
				$this->runCommand('modify_email', $object->login, $object->email, $object->oldcopy->email);
			}
			
			// Update full name if it has changed
			if ($fullName !== $this->getFullName($object->oldcopy)) {
				$this->runCommand('modify_fullname', $object->login, $fullName);
			}
			
			// Update password if provided
			if ($object->pass) {
				$this->runCommand('password', $object->login, $object->pass);
			}
		}
	}
	private function member_subscription($object, $mainGroup){
		$activate =  false;
		$now = dol_now();
		if($object->subscriptions){
			foreach ($object->subscriptions as $subscription) {
				if($subscription->datef > $now){
					$activate =  true;
				}
			}
			if($activate){
				$this->runCommand('activate', $object->login, $mainGroup);
			}
		}
	}
	private function check_user_exist($create_output, $username){
		if (strpos($create_output, 'User '.trim($username).' exists already') !== false) {
			return true;
		} else{
			return false;
		}
	}
	private function generateSecurePassword($length = 12)
	{
		$chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-=';
		$password = '';
		$charsLength = strlen($chars) - 1;
		for ($i = 0; $i < $length; $i++) {
			$password .= $chars[random_int(0, $charsLength)];
		}
		return $password;
	}
	private function updateMemberExtraField($member_id, $field_key, $field_value)
	{
		$sql = "UPDATE ".MAIN_DB_PREFIX."adherent_extrafields 
			SET ".$field_key." = ".$this->db->escape($field_value)."
   			WHERE fk_object = ".$this->db->escape($member_id);
		$this->db->query($sql);
	}
	private function memberToUser($member_id){
		$found = 0;
		$sql = "SELECT COUNT(rowid) as nb FROM ".MAIN_DB_PREFIX."user WHERE fk_member = ".((int) $member_id);
		$resqlcount = $this->db->query($sql);
		if ($resqlcount) {
			$objcount = $this->db->fetch_object($resqlcount);
			if ($objcount) {
				$found = $objcount->nb;
			}
		}
		if (!$found) {
			$member = new Adherent($this->db);
			if ($member->fetch($member_id) > 0) {
				// Creation user
				$nuser = new User($this->db);
				$tmpuser = dol_clone($member, 0);
				$result = $nuser->create_from_member($tmpuser, $member->login);
			}
		}
	}
	private function deleteMemberUser($object){
		global $user;
		if($object->user_id){
			$userToDelete = new User($this->db);
			if ($userToDelete->fetch($object->user_id) > 0) {
				$userToDelete->delete($user);
			}
		}
	}
	private function runCommand($action, $username, $param1 = null, $param2 = null, $param3 = null, $param4 = null)
	{
		// Sanitize arguments to prevent injection
		$username = escapeshellarg($username);
		$param1Arg = $param1 ? escapeshellarg($param1) : '';
		$param2Arg = $param2 ? escapeshellarg($param2) : '';
		$param3Arg = $param3 ? escapeshellarg($param3) : '';
		$param4Arg = $param4 ? escapeshellarg($param4) : '';

		// Construct the command
		$cmd = "/usr/local/bin/syncyunohost.sh $action $username $param1Arg $param2Arg $param3Arg $param4Arg";

		// Execute the command and return output
		return shell_exec($cmd);
	}
}
