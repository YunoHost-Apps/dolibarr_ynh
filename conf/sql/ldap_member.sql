REPLACE INTO llx_const (`name`, `value`, `type`) VALUES 
('LDAP_MEMBER_DN', 'ou=users,dc=yunohost,dc=org', 'chaine'),
('LDAP_MEMBER_FILTER', '&(objectClass=posixAccount)', 'chaine'),
('LDAP_MEMBER_OBJECT_CLASS', 'organizationalUnit,top', 'chaine'),
('LDAP_MEMBER_ACTIVE', 'ldap2dolibarr', 'chaine');

REPLACE INTO llx_adherent_type (`rowid`, `libelle`, `subscription`, `vote`) VALUES 
('1', 'yunohost', '0', '0');
