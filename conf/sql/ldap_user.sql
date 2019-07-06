REPLACE INTO llx_const (`name`, `value`, `type`) VALUES 
('LDAP_USER_DN', 'ou=users,dc=yunohost,dc=org', 'chaine'),
('LDAP_USER_OBJECT_CLASS', 'organizationalUnit,top', 'chaine'),
('LDAP_FILTER_CONNECTION', '&(objectClass=posixAccount)', 'chaine'),
('LDAP_SYNCHRO_ACTIVE', 'ldap2dolibarr', 'chaine');
