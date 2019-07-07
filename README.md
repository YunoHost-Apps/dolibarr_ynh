# Dolibarr for YunoHost

[![Integration level](https://dash.yunohost.org/integration/dolibarr.svg)](https://dash.yunohost.org/appci/app/dolibarr)  
[![Install Dolibarr with YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=dolibarr)

*[Lire ce readme en français.](./README_fr.md)*

> *This package allow you to install Dolibarr quickly and simply on a YunoHost server.  
If you don't have YunoHost, please see [here](https://yunohost.org/#/install) to know how to install and enjoy it.*

## Overview
Dolibarr ERP & CRM is a modern software for managing your professional or associative activity (contacts, invoices, orders, stocks, agenda, etc...).

**Shipped version:** 9.0.3

## Screenshots

![Screenshot](http://www.dolibarr.org/images/dolibarr_screenshot1_640x400.png)

## Demo

* [Official demo](https://www.dolibarr.org/onlinedemo)

## Configuration

Use the admin panel of your dolibarr to configure this app.

## Documentation

 * Official documentation: https://www.dolibarr.org/documentation-home

## YunoHost specific features

#### Multi-users support

LDAP and HTTP auth supported.
The app can be used by multiple users.

#### Supported architectures

* x86-64b - [![Build Status](https://ci-apps.yunohost.org/ci/logs/dolibarr%20%28Apps%29.svg)](https://ci-apps.yunohost.org/ci/apps/dolibarr/)
* ARMv8-A - [![Build Status](https://ci-apps-arm.yunohost.org/ci/logs/dolibarr%20%28Apps%29.svg)](https://ci-apps-arm.yunohost.org/ci/apps/dolibarr/)
* Jessie x86-64b - [![Build Status](https://ci-stretch.nohost.me/ci/logs/dolibarr%20%28Apps%29.svg)](https://ci-stretch.nohost.me/ci/apps/dolibarr/)

## Limitations

Dolibarr must be a non-public application to be able to link yunohost accounts.
The deletion of an account is not taken into account in Dolibarr.

## Additional information



## Links

 * Report a bug: https://github.com/YunoHost-Apps/dolibarr_ynh/issues
 * App website: https://www.dolibarr.org
 * Upstream app repository: Link to the official repository of the upstream app
 * YunoHost website: https://yunohost.org/

---

Developers info
----------------

**Only if you want to use a testing branch for coding, instead of merging directly into master.**
Please do your pull request to the [testing branch](https://github.com/YunoHost-Apps/dolibarr_ynh/tree/testing).

To try the testing branch, please proceed like that.
```
sudo yunohost app install https://github.com/YunoHost-Apps/dolibarr_ynh/tree/testing --debug
or
sudo yunohost app upgrade dolibarr -u https://github.com/YunoHost-Apps/dolibarr_ynh/tree/testing --debug
```
