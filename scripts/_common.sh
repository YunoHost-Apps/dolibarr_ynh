#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================

upgrade_dolibarr() {
    ynh_setup_source --source_id="$source_id" --dest_dir="$install_dir" --full_replace \
        --keep="documents htdocs/custom htdocs/conf/conf.php htdocs/install/install.forced.php"
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
    if [ -d "../sources/extra_files/app/syncyunohost/" ]; then
        mkdir -p "$install_dir/htdocs/custom/syncyunohost/" # Ensure destination directory exists
        cp -r "../sources/extra_files/app/syncyunohost/"* "$install_dir/htdocs/custom/syncyunohost/"
        chown "$app:www-data" -R "$install_dir/htdocs/custom/syncyunohost/"
        ynh_print_info "Files copied successfully to $install_dir/htdocs/custom/"
    else
        ynh_print_warn "Source directory ../sources/extra_files/app/syncyunohost/ does not exist. Skipping copy."
    fi
}

# Activate Syncyunohost module
syncyunohost_modules_activate(){
    #=================================================
    # COPY SCRIPT TO /scripts/members
    #=================================================
    cp "../conf/syncyunohost-modules.php" "$install_dir/scripts/members/syncyunohost-modules.php"
    chown "$app:www-data" -R "$install_dir/scripts/members/syncyunohost-modules.php"

    #=================================================
    # COPY SCRIPT TO /usr/local/bin
    #=================================================
    ynh_config_add --template="syncyunohost.sh" --destination="/usr/local/bin/syncyunohost.sh"
    chmod 550 /usr/local/bin/syncyunohost.sh
    chown "$app:" /usr/local/bin/syncyunohost.sh

    maindomain=$(yunohost domain main-domain | awk '{print $2}')
    admin_mail="admin@$maindomain"
    ynh_app_setting_set --app="$app" --key=admin_mail --value="$admin_mail"
    ynh_config_add --template="syncyunohost_launcher.sh" --destination="/usr/local/bin/syncyunohost_launcher.sh"
    chmod 550 /usr/local/bin/syncyunohost_launcher.sh
    chown "$app:" /usr/local/bin/syncyunohost_launcher.sh

    #=================================================
    # SYSTEMD CONFIGURATION
    #=================================================
    ynh_script_progression "Adding systemd configurations related to syncyunohost $app module..."
    mkdir -p "/dev/shm/$app"
    chown "$app:" "/dev/shm/$app"
    ynh_config_add --template="dolibarr_syncyunohost.path" --destination="/etc/systemd/system/$app-syncyunohost.path"
    ynh_config_add_systemd --template="dolibarr_syncyunohost.service" --service="$app-syncyunohost"
    systemctl daemon-reload

    systemctl enable --now "$app-syncyunohost.path" --quiet

    #=================================================
    # INTEGRATE SERVICES IN YUNOHOST
    #=================================================
# Todo some day, when path will be managed by YNH
#    ynh_script_progression "Integrating services in YunoHost..."
#    yunohost service add "$app-syncyunohost.path" --description="$app's syncyunohost module"
    
    #=================================================
    # Activate module
    #=================================================
    ynh_script_progression "Activate syncyunohost $app module..."
    "php${php_version}" "$install_dir/scripts/members/syncyunohost-modules.php" --action=activate --modules=modAdherent,modCron,modSyncYunoHost --base_domain=$syncyunohost_base_domain --main_group=$syncyunohost_main_group
}

# Deactivate Syncyunohost module
syncyunohost_modules_deactivate(){
    #=================================================
    # REMOVE SERVICE INTEGRATION IN YUNOHOST
    #=================================================
# Todo some day, when path will be managed by YNH
#    ynh_script_progression "remove services integration in YunoHost..."
#    yunohost service remove "$app-syncyunohost.path"

    #=================================================
    # STOP AND REMOVE SYSTEMD SERVICES
    #=================================================
    ynh_script_progression "Stopping and removing systemd services..."

    # Remove the dedicated systemd config
    systemctl stop "$app-syncyunohost.path" --quiet
    systemctl disable "$app-syncyunohost.path" --quiet
    ynh_safe_rm "/etc/systemd/system/$app-syncyunohost.path"

    ynh_config_remove_systemd "$app-syncyunohost"

    ynh_safe_rm /dev/shm/$app

    #=================================================
    # Deactivate module
    #=================================================
    ynh_script_progression "Deactivating SyncYunohost module..."
    "php${php_version}" "$install_dir/scripts/members/syncyunohost-modules.php" --action=deactivate --modules=modSyncYunoHost

    #=================================================
    # REMOVE CUSTOM SCRIPTS
    #=================================================
    ynh_script_progression "Removing custom scripts..."
    ynh_safe_rm "/usr/local/bin/syncyunohost.sh"
    ynh_safe_rm "/usr/local/bin/syncyunohost_launcher.sh"
}
