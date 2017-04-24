REPLACE INTO ynh_const (`name`, `value`, `type`) VALUES 
('LDAP_USER_DN', 'ou=users,dc=yunohost,dc=org', 'chaine'),
('LDAP_USER_OBJECT_CLASS', 'organizationalUnit,top', 'chaine'),
('LDAP_FILTER_CONNECTION', '&(objectClass=posixAccount)', 'chaine'),
('LDAP_FIELD_FULLNAME', 'cn', 'chaine'),
('LDAP_FIELD_LOGIN', 'uid', 'chaine'),
('LDAP_FIELD_NAME', 'sn', 'chaine'),
('LDAP_FIELD_FIRSTNAME', 'givenName', 'chaine'),
('LDAP_FIELD_MAIL', 'mail', 'chaine'),
('LDAP_KEY_USERS', 'uid', 'chaine'),
('LDAP_FIELD_PASSWORD_CRYPTED', 'userPassword', 'chaine'),
('LDAP_SYNCHRO_ACTIVE', 'ldap2dolibarr', 'chaine');
