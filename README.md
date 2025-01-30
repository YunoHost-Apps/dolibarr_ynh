# SYNCYUNOHOST FOR [DOLIBARR ERP CRM](https://www.dolibarr.org)

## Features

**SyncYunoHost** is a powerful integration module that connects Dolibarr ERP CRM members with YunoHost users. It offers comprehensive user management capabilities, allowing administrators to:

- Automatically synchronize Dolibarr members with YunoHost users.
- Create new YunoHost users directly from Dolibarr.
- Enable or disable user accounts.
- Assign or revoke user group permissions.
- Delete or renew user accounts seamlessly.
- Manage user access rights efficiently.

<!--
![Screenshot syncyunohost](img/screenshot_syncyunohost.png?raw=true "SyncYunoHost"){imgmd}
-->

Other external modules are available on [Dolistore.com](https://www.dolistore.com).

## Translations

Translations can be completed manually by editing files into directories *langs*.

<!--
This module contains also a sample configuration for Transifex, under the hidden directory [.tx](.tx), so it is possible to manage translation using this service.

For more information, see the [translator's documentation](https://wiki.dolibarr.org/index.php/Translator_documentation).

There is a [Transifex project](https://transifex.com/projects/p/dolibarr-module-template) for this module.
-->

## Installation

**Prerequisites:** You must have the Dolibarr ERP CRM software installed. You can download it from [Dolistore.org](https://www.dolibarr.org).
You can also get a ready-to-use instance in the cloud from [saas.dolibarr.org](https://saas.dolibarr.org).

### From the ZIP file and GUI interface

If the module is a ready-to-deploy zip file, so with a name module_xxx-version.zip (like when downloading it from a marketplace like [Dolistore](https://www.dolistore.com)),
go into menu ```Home - Setup - Modules - Deploy external module``` and upload the zip file.

Note: If this screen tells you that there is no "custom" directory, check that your setup is correct:

<!--
- In your Dolibarr installation directory, edit the ```htdocs/conf/conf.php``` file and check that the following lines are not commented:

    ```php
    //$dolibarr_main_url_root_alt ...
    //$dolibarr_main_document_root_alt ...
    ```

- Uncomment them if necessary (delete the leading ```//```) and assign a sensible value according to your Dolibarr installation

    For example:

    - UNIX:
        ```php
        $dolibarr_main_url_root_alt = '/custom';
        $dolibarr_main_document_root_alt = '/var/www/Dolibarr/htdocs/custom';
        ```

    - Windows:
        ```php
        $dolibarr_main_url_root_alt = '/custom';
        $dolibarr_main_document_root_alt = 'C:/My Web Sites/Dolibarr/htdocs/custom';
        ```
-->

<!--
### From a GIT repository

Clone the repository in ```$dolibarr_main_document_root_alt/syncyunohost```

```sh
cd ....../custom
git clone git@github.com:gitlogin/syncyunohost.git syncyunohost
```
-->

### Final steps

From your browser:

  - Log into Dolibarr as a super-administrator
  - Go to "Setup" -> "Modules"
  - You should now be able to find and enable the module

## Licenses

### Main code

This module is a **paid product** and is distributed under a commercial license. Purchasing a valid license is required for usage. Contact the developer for licensing details.

### Documentation

All texts and readmes are licensed under GFDL.

