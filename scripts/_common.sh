#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================

upgrade_dolibarr() {
    ynh_setup_source --source_id="$source_id" --dest_dir="$install_dir"
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
# PERSONAL HELPERS
#=================================================

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
