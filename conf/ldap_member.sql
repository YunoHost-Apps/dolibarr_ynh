REPLACE INTO ynh_const (`name`, `value`, `type`) VALUES 
('LDAP_MEMBER_DN', 'ou=users,dc=yunohost,dc=org', 'chaine'),
('LDAP_MEMBER_FIELD_FULLNAME', 'cn', 'chaine'),
('LDAP_MEMBER_FIELD_FIRSTNAME', 'givenName', 'chaine'),
('LDAP_MEMBER_FIELD_NAME', 'sn', 'chaine'),
('LDAP_MEMBER_FIELD_LOGIN', 'uid', 'chaine'),
('LDAP_MEMBER_FIELD_MAIL', 'mail', 'chaine'),
('LDAP_MEMBER_FILTER', '&(objectClass=posixAccount)', 'chaine'),
('LDAP_MEMBER_OBJECT_CLASS', 'organizationalUnit,top', 'chaine'),
('LDAP_MEMBER_FIELD_MAIL', 'mail', 'chaine'),
('LDAP_MEMBER_ACTIVE', 'ldap2dolibarr', 'chaine');

REPLACE INTO ynh_adherent_type (`rowid`, `libelle`, `subscription`, `vote`) VALUES 
('1', 'yunohost', '0', '0');
