#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================

#=================================================
# PERSONAL HELPERS
#=================================================

upgrade_dolibarr() {
    ynh_setup_source --source_id="$source_id" --dest_dir="$install_dir" --full_replace=1 \
        --keep="htdocs/conf/conf.php htdocs/install/install.forced.php"
    chmod -R o-rwx "$install_dir"
    chown -R "$app:www-data" "$install_dir"

    # Remove the lock if it exists
    lock=$install_dir/documents/install.lock
    if [ -f "$lock" ]; then
        ynh_secure_remove --file="$lock"
    fi

    pushd "$install_dir/htdocs/install/"
        "php$phpversion" upgrade.php "$current_version" "$new_version"
        ynh_exec_fully_quiet sleep 5

        "php$phpversion" upgrade2.php "$current_version" "$new_version"
        ynh_exec_fully_quiet sleep 5

        "php$phpversion" step5.php "$current_version" "$new_version"
        ynh_exec_fully_quiet sleep 5
    popd
}

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
syncyunohost_module_install(){
    #=================================================
    # COPY FOLDER TO DESTINATION
    #=================================================
    ynh_script_progression --message="Copying syncyunohost folder to destination..." --weight=1
    
    # Check if source directory exists
    if [ -d "../sources/extra_files/app/syncyunohost/" ]; then
        mkdir -p "$install_dir/htdocs/custom/syncyunohost/" # Ensure destination directory exists
        cp -r "../sources/extra_files/app/syncyunohost/"* "$install_dir/htdocs/custom/syncyunohost/"
        ynh_print_info --message="Files copied successfully to $install_dir/htdocs/custom/"
    else
        ynh_print_warn --message="Source directory ../sources/extra_files/app/syncyunohost/ does not exist. Skipping copy."
    fi
    
    #=================================================
    # COPY SCRIPT TO /scripts/members
    #=================================================
    ynh_script_progression --message="Copying syncyunohost-modules.php to dolibarr $install_dir/scripts/members directory ..." --weight=1
    cp "../conf/syncyunohost-modules.php" "$install_dir/scripts/members/syncyunohost-modules.php"
    #=================================================
    #=================================================
    # COPY SCRIPT TO /usr/local/bin
    #=================================================
    ynh_script_progression --message="Copying syncyunohost.sh to /usr/local/bin/..." --weight=1
    ynh_add_config --template="syncyunohost.sh" --destination="/usr/local/bin/syncyunohost.sh"
    #=================================================
    
    # SYSTEM SETUP: GRANT PERMISSIONS TO `dolibarr` USER
    #=================================================
    # Add dolibarr user to sudoers to allow running syncyunohost.sh without a password
    echo "dolibarr ALL=(ALL) NOPASSWD: /usr/local/bin/syncyunohost.sh" | tee -a /etc/sudoers > /dev/null
    
    # Check sudoers file syntax
    visudo -c
    # Change ownership of the file to dolibarr after creation
    chown dolibarr:dolibarr /usr/local/bin/syncyunohost.sh
    chmod 750 /usr/local/bin/syncyunohost.sh
    # Active modAdherent,modCron,modSyncYunoHost
    syncyunohost_modules_activate
}
syncyunohost_module_remove(){
    # Deactive modSyncYunoHost
    syncyunohost_modules_deactivate
    #=================================================
    # REMOVE CUSTOM FILES
    #=================================================
    ynh_script_progression --message="Removing custom files from /htdocs/custom/syncyunohost/..." --weight=1
    # Remove the custom directory securely
    ynh_secure_remove --file="$install_dir/htdocs/custom/syncyunohost"
    #=================================================
    # REMOVE CUSTOM SCRIPTS
    #=================================================
    ynh_script_progression --message="Removing syncyunohost-modules.php script from $install_dir/scripts/members/ ..." --weight=1
    ynh_secure_remove --file="$install_dir/scripts/members/syncyunohost-modules.php"
    
    ynh_script_progression --message="Removing syncyunohost.sh script from /usr/local/bin/..." --weight=1
    ynh_secure_remove --file="/usr/local/bin/syncyunohost.sh"
    #=================================================
    # REMOVE SUDOERS ENTRY
    #=================================================
    ynh_script_progression --message="Removing sudoers entry for dolibarr user..." --weight=1
    sudo sed -i '/dolibarr ALL=(ALL) NOPASSWD: \/usr\/local\/bin\/syncyunohost.sh/d' /etc/sudoers
}
syncyunohost_modules_activate(){
    ynh_script_progression --message="Active modAdherent,modCron,modSyncYunoHost ..." --weight=1
    php "$install_dir/scripts/members/syncyunohost-modules.php" --action=activate --modules=modAdherent,modCron,modSyncYunoHost --base_domain=$syncyunohost_base_domain --main_group=$syncyunohost_main_group --old_members=yes;
}
syncyunohost_modules_deactivate(){
    ynh_script_progression --message="Deactive modSyncYunoHost ..." --weight=1
    php "$install_dir/scripts/members/syncyunohost-modules.php" --action=deactivate --modules=modSyncYunoHost;
}
