#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================

upgrade_dolibarr() {
    ynh_setup_source --source_id="$source_id" --dest_dir="$install_dir" --full_replace \
        --keep="htdocs/conf/conf.php htdocs/install/install.forced.php"
    chmod -R o-rwx "$install_dir"
    chown -R "$app:www-data" "$install_dir"

    # Remove the lock if it exists
    lock=$install_dir/documents/install.lock
    if [ -f "$lock" ]; then
        ynh_safe_rm "$lock"
    fi

    pushd "$install_dir/htdocs/install/"
        "php${php_version}" upgrade.php "$current_version" "$new_version"
        sleep 5

        "php${php_version}" upgrade2.php "$current_version" "$new_version"
        sleep 5

        "php${php_version}" step5.php "$current_version" "$new_version"
        sleep 5
    popd
}

syncyunohost_module_install(){
    #=================================================
    # COPY FOLDER TO DESTINATION
    #=================================================
    # Check if source directory exists
    if [ -d "../sources/syncyunohost/" ]; then
        mkdir -p "$install_dir/htdocs/custom/syncyunohost/" # Ensure destination directory exists
        cp -r "../sources/syncyunohost/"* "$install_dir/htdocs/custom/syncyunohost/"
        chown dolibarr:www-data -R "$install_dir/htdocs/custom/syncyunohost/"
        ynh_print_info "Files copied successfully to $install_dir/htdocs/custom/"
    else
        ynh_print_warn "Source directory ../sources/syncyunohost/ does not exist. Skipping copy."
    fi

    #=================================================
    # COPY SCRIPT TO /scripts/members
    #=================================================
    cp "../conf/syncyunohost-modules.php" "$install_dir/scripts/members/syncyunohost-modules.php"
    chown dolibarr:www-data -R "$install_dir/scripts/members/syncyunohost-modules.php"

    #=================================================
    # COPY SCRIPT TO /usr/local/bin
    #=================================================
    ynh_config_add --template="syncyunohost.sh" --destination="/usr/local/bin/syncyunohost.sh"
    chmod 550 /usr/local/bin/syncyunohost.sh
}

syncyunohost_scripts_remove(){
    #=================================================
    # REMOVE CUSTOM SCRIPTS
    #=================================================
    ynh_safe_rm "$install_dir/scripts/members/syncyunohost-modules.php"

    ynh_safe_rm "/usr/local/bin/syncyunohost.sh"

    #=================================================
    # REMOVE SUDOERS ENTRY
    #=================================================
    ynh_safe_rm "/etc/sudoers.d/dolibarr_syncyunohost"
}

# Activate Syncyunohost module
syncyunohost_modules_activate(){
    "php${php_version}" "$install_dir/scripts/members/syncyunohost-modules.php" --action=activate --modules=modAdherent,modCron,modSyncYunoHost --base_domain=$syncyunohost_base_domain --main_group=$syncyunohost_main_group

    #=================================================
    # SYSTEM SETUP: GRANT PERMISSIONS TO `dolibarr` USER
    #=================================================
    # Add dolibarr user to sudoers to allow running syncyunohost.sh without a password
    echo "dolibarr ALL=(ALL) NOPASSWD: /usr/bin/yunohost user list --output-as json, /usr/bin/yunohost user create * -p * -F * -d *, /usr/bin/yunohost user update * --add-mailforward *, /usr/bin/yunohost user update * --remove-mailforward *, /usr/bin/yunohost user update * -F *, /usr/bin/yunohost user update * -p *, /usr/bin/yunohost user delete *, /usr/bin/yunohost user group add * *, !/usr/bin/yunohost user group add admins *, /usr/bin/yunohost user group remove * *, !/usr/bin/yunohost user group remove admins *" > "/etc/sudoers.d/dolibarr_syncyunohost"
    chmod 440 /etc/sudoers.d/dolibarr_syncyunohost

    # Check sudoers file syntax
    visudo -c

    ynh_print_info "syncyunohost.sh activated and sudo permissions granted safely."
}

# Deactivate Syncyunohost module
syncyunohost_modules_deactivate(){
    "php${php_version}" "$install_dir/scripts/members/syncyunohost-modules.php" --action=deactivate --modules=modSyncYunoHost

    #=================================================
    # REMOVE SUDOERS ENTRY
    #=================================================
    ynh_safe_rm "/etc/sudoers.d/dolibarr_syncyunohost"
}
