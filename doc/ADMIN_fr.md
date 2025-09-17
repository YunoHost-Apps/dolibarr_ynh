## Module SyncYunoHost

En activant dans le config panel le module SyncYunoHost, vous devrez choisir:
* un Groupe préalablement créé dans l'annuaire YunoHost pour les adhérents,
* le domaine pour la création des e-mails des utilisateurs YunoHost.

Dolibarr va ensuite activer le module Adhérents. 
* Il faudra d'abord créer une Cotisation dans le module Adhérents avec un tarif et une durée. 
* En Ajoutant une cotisation, vous ajoutez un utilisateur avec son mail personnel, cela va créer un utilisateur Yunohost. 
* Quand sa cotisation est à jour, il est automatiquement ajouter au Groupe choisi dans l'annuaire LDAP. 
* Quand sa cotisation n'est plus à jour, il sera retiré du Groupe choisi.
* En le supprimant depuis Dolibarr, l'utilisateur Yunohost est supprimé (par sécurité, il n'est pas possible de supprimer un utilisateur du groupe admins)
