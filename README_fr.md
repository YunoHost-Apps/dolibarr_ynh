# Dolibarr pour YunoHost

[![Integration level](https://dash.yunohost.org/integration/dolibarr.svg)](https://dash.yunohost.org/appci/app/dolibarr) ![](https://ci-apps.yunohost.org/ci/badges/dolibarr.status.svg) ![](https://ci-apps.yunohost.org/ci/badges/dolibarr.maintain.svg)  
[![Installer Dolibarr avec YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=dolibarr)

*[Read this readme in english.](./README.md)* 

> *Ce package vous permet d'installer Dolibarr rapidement et simplement sur un serveur YunoHost.  
Si vous n'avez pas YunoHost, regardez [ici](https://yunohost.org/#/install) pour savoir comment l'installer et en profiter.*

## Vue d'ensemble
Dolibarr ERP & CRM est un logiciel moderne de gestion de votre activité professionnelle ou associative (contacts, factures, commandes, stocks, agenda, etc.).

**Version incluse :** 14.0.1

## Captures d'écran

![Screenshot](http://www.dolibarr.org/images/dolibarr_screenshot1_640x400.png)

## Démo

* [Démo officielle](https://www.dolibarr.fr/demo-en-ligne)

## Configuration

Utilisez le panneau d'administration de votre Dolibarr pour configurer cette application.

## Documentation

 * Documentation officielle : https://www.dolibarr.fr/documentation

## Caractéristiques spécifiques YunoHost

#### Support multi-utilisateurs

* L'authentification LDAP et HTTP est prise en charge
* L'application peut être utilisée par plusieurs utilisateurs.

#### Supported architectures

* x86-64 - [![Build Status](https://ci-apps.yunohost.org/ci/logs/dolibarr%20%28Apps%29.svg)](https://ci-apps.yunohost.org/ci/apps/dolibarr/)
* ARMv8-A - [![Build Status](https://ci-apps-arm.yunohost.org/ci/logs/dolibarr%20%28Apps%29.svg)](https://ci-apps-arm.yunohost.org/ci/apps/dolibarr/)

## Limitations

* Dolibarr doit être une application non publique pour pouvoir lier les comptes YunoHost.
* La suppression d'un compte n'est pas prise en compte dans Dolibarr.

## Informations additionnelles

## Liens

 * Signaler un bug : https://github.com/YunoHost-Apps/dolibarr_ynh/issues
 * Site de l'application : https://www.dolibarr.fr
 * Dépôt de l'application principale : https://github.com/Dolibarr/dolibarr
 * Site web YunoHost : https://yunohost.org/

---

## Informations pour les développeurs

Merci de faire vos pull request sur la [branche testing](https://github.com/YunoHost-Apps/dolibarr_ynh/tree/testing).

Pour essayer la branche testing, procédez comme suit.
```
sudo yunohost app install https://github.com/YunoHost-Apps/dolibarr_ynh/tree/testing --debug
ou
sudo yunohost app upgrade dolibarr -u https://github.com/YunoHost-Apps/dolibarr_ynh/tree/testing --debug
```
