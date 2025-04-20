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
    # Check if source directory exists
    if [ -d "../sources/extra_files/app/syncyunohost/" ]; then
        mkdir -p "$install_dir/htdocs/custom/syncyunohost/" # Ensure destination directory exists
        cp -r "../sources/extra_files/app/syncyunohost/"* "$install_dir/htdocs/custom/syncyunohost/"
        chown dolibarr:www-data -R "$install_dir/htdocs/custom/syncyunohost/"
        ynh_print_info --message="Files copied successfully to $install_dir/htdocs/custom/"
    else
        ynh_print_warn --message="Source directory ../sources/extra_files/app/syncyunohost/ does not exist. Skipping copy."
    fi

    #=================================================
    # COPY SCRIPT TO /scripts/members
    #=================================================
    cp "../conf/syncyunohost-modules.php" "$install_dir/scripts/members/syncyunohost-modules.php"
    chown dolibarr:www-data -R "$install_dir/scripts/members/syncyunohost-modules.php"

    #=================================================
    # COPY BASH SCRIPT TO /usr/local/bin
    #=================================================
    ynh_add_config --template="syncyunohost.sh" --destination="/usr/local/bin/syncyunohost.sh"

    chown root:root /usr/local/bin/syncyunohost.sh
    chmod 750 /usr/local/bin/syncyunohost.sh

    #=================================================
    # GRANT SUDO ACCESS (Safe method using sudoers.d)
    #=================================================
    echo "dolibarr ALL=(ALL) NOPASSWD: /usr/local/bin/syncyunohost.sh" > /etc/sudoers.d/dolibarr_syncyunohost
    chmod 440 /etc/sudoers.d/dolibarr_syncyunohost

    # Validate sudoers configuration
    visudo -c

    ynh_print_info --message="syncyunohost.sh installed and sudo permissions granted safely."
}

syncyunohost_scripts_remove(){

    #=================================================
    # REMOVE CUSTOM SCRIPTS
    #=================================================
    ynh_secure_remove --file="$install_dir/scripts/members/syncyunohost-modules.php"
    
    ynh_secure_remove --file="/usr/local/bin/syncyunohost.sh"

    #=================================================
    # REMOVE SUDOERS ENTRY
    #=================================================
    if grep -q '^dolibarr ALL=(ALL) NOPASSWD: /usr/local/bin/syncyunohost.sh' /etc/sudoers; then
        sed -i '/dolibarr ALL=(ALL) NOPASSWD: \/usr\/local\/bin\/syncyunohost.sh/d' /etc/sudoers
    fi
}

# Activate Syncyunohost module
syncyunohost_modules_activate(){
    php "$install_dir/scripts/members/syncyunohost-modules.php" --action=activate --modules=modAdherent,modCron,modSyncYunoHost --base_domain=$syncyunohost_base_domain --main_group=$syncyunohost_main_group
}

# Deactivate Syncyunohost module
syncyunohost_modules_deactivate(){
    php "$install_dir/scripts/members/syncyunohost-modules.php" --action=deactivate --modules=modSyncYunoHost
}
