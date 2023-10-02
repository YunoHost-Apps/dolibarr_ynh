$dolibarr_main_document_root="__INSTALL_DIR__/htdocs";
$dolibarr_main_data_dir="__DATA_DIR__";
$dolibarr_main_url_root="http://__DOMAIN____PATH__";
$dolibarr_main_db_type="mysqli";
$dolibarr_main_db_host="localhost";
$dolibarr_main_db_port="3306";
$dolibarr_main_db_name="__DB_NAME__";
$dolibarr_main_db_user="__DB_USER__";
$dolibarr_main_db_pass="__DB_PWD__";


// Authentication settings
//$dolibarr_main_authentication='dolibarr';

$dolibarr_main_authentication='ldap,dolibarr,http';

$dolibarr_main_auth_ldap_host='ldap:localhost';

$dolibarr_main_auth_ldap_port='389';

$dolibarr_main_auth_ldap_version='3';

$dolibarr_main_auth_ldap_servertype='openldap';

$dolibarr_main_auth_ldap_login_attribute='uid';  // Ex: uid or samaccountname for active directory

$dolibarr_main_auth_ldap_dn='ou=users,dc=yunohost,dc=org';

$dolibarr_main_auth_ldap_filter = '&(objectClass=posixAccount)';

//$dolibarr_main_auth_ldap_admin_login='uid=admin,dc=yunohost,dc=org';
//$dolibarr_main_auth_ldap_admin_pass='secret';
//$dolibarr_main_auth_ldap_debug='false';
