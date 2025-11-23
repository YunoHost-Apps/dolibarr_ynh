## Module SyncYunoHost

By activating the SyncYunoHost module in the config panel, you will need to choose:
* a  Yunohost group previously created for the members,
* the domain for creating e-mails for YunoHost users.

Dolibarr will then activate the Membership module.
* You'll first need to create a membership fee in the Membership module, with a price and duration.
* By adding a membership, you add a user with his personal e-mail address, which will create a Yunohost user.
* When his subscription is up to date, he is automatically added to the Group selected in the LDAP directory.
* When the user's subscription is no longer up to date, he/she will be removed from the chosen Group.
* By deleting it from Dolibarr, the Yunohost user is deleted (for security reasons, it is not possible to delete a user from the admins group).
