# Dolibarr pour YunoHost

[![Integration level](https://dash.yunohost.org/integration/Dolibarr.svg)](https://dash.yunohost.org/appci/app/Dolibarr)  
[![Install Dolibarr with YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=Dolibarr)

*[Read this readme in english.](./README.md)* 

> *Ce package vous permet d'installer Dolibarr rapidement et simplement sur un serveur Yunohost.  
Si vous n'avez pas YunoHost, regardez [ici](https://yunohost.org/#/install) pour savoir comment l'installer et en profiter.*

## Vue d'ensemble
Dolibarr ERP & CRM est un logiciel moderne de gestion de votre activité professionnelle ou associative (contacts, factures, commandes, stocks, agenda, etc...).

**Version incluse:** 9.0.3

## Captures d'écran

![Screenshot](http://www.dolibarr.org/images/dolibarr_screenshot1_640x400.png)

## Démo

* [Démo officielle](https://www.dolibarr.fr/demo-en-ligne)

## Configuration

Utilisez le panneau d'administration de votre dolibarr pour configurer cette application.

## Documentation

 * Documentation officielle: https://www.dolibarr.fr/documentation

## Caractéristiques spécifiques YunoHost

#### Support multi-utilisateurs

L'authentification LDAP et HTTP est prise en charge
L'application peut être utilisée par plusieurs utilisateurs.

#### Supported architectures

* x86-64b - [![Build Status](https://ci-apps.yunohost.org/ci/logs/Dolibarr%20%28Apps%29.svg)](https://ci-apps.yunohost.org/ci/apps/Dolibarr/)
* ARMv8-A - [![Build Status](https://ci-apps-arm.yunohost.org/ci/logs/Dolibarr%20%28Apps%29.svg)](https://ci-apps-arm.yunohost.org/ci/apps/Dolibarr/)
* Jessie x86-64b - [![Build Status](https://ci-stretch.nohost.me/ci/logs/Dolibarr%20%28Apps%29.svg)](https://ci-stretch.nohost.me/ci/apps/Dolibarr/)

## Limitations

Dolibarr doit être une application non publique pour pouvoir lier les comptes yunohost.
La suppression d'un compte n'est pas prise en compte dans Dolibarr.

## Informations additionnelles



## Liens

 * Signaler un bug: https://github.com/YunoHost-Apps/Dolibarr_ynh/issues
 * Site de l'application: https://www.dolibarr.fr
 * Dépôt de l'application principale: Lien vers le dépôt officiel de l'application principale
 * Site web YunoHost: https://yunohost.org/

---

Informations pour les développeurs
----------------

**Seulement si vous voulez utiliser une branche de test pour le codage, au lieu de fusionner directement dans la banche principale.**
Merci de faire vos pull request sur la [branche testing](https://github.com/YunoHost-Apps/Dolibarr_ynh/tree/testing).

Pour essayer la branche testing, procédez comme suit.
```
sudo yunohost app install https://github.com/YunoHost-Apps/Dolibarr_ynh/tree/testing --debug
ou
sudo yunohost app upgrade Dolibarr -u https://github.com/YunoHost-Apps/Dolibarr_ynh/tree/testing --debug
```
