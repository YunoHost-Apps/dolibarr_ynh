<?php
function syncyunohostAdminPrepareHead()
{
	global $langs, $conf;
	$langs->load("syncyunohost@syncyunohost");
	$h = 0;
	$head = array();
	$head[$h][0] = dol_buildpath("/syncyunohost/admin/setup.php", 1);
	$head[$h][1] = $langs->trans("Settings");
	$head[$h][2] = 'settings';
	$h++;
	$head[$h][0] = dol_buildpath("/syncyunohost/admin/about.php", 1);
	$head[$h][1] = $langs->trans("About");
	$head[$h][2] = 'about';
	$h++;
	complete_head_from_modules($conf, $langs, null, $head, $h, 'syncyunohost@syncyunohost');
	complete_head_from_modules($conf, $langs, null, $head, $h, 'syncyunohost@syncyunohost', 'remove');
	return $head;
}
