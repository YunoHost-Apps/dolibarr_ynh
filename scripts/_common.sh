#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================

upgrade_dolibarr() {
    ynh_setup_source --source_id="$source_id" --dest_dir="$install_dir" --full_replace \
        --keep="htdocs/conf/conf.php htdocs/install/install.forced.php"
    #REMOVEME? Assuming the install dir is setup using ynh_setup_source, the proper chmod/chowns are now already applied and it shouldn't be necessary to tweak perms | chmod -R o-rwx "$install_dir"
    #REMOVEME? Assuming the install dir is setup using ynh_setup_source, the proper chmod/chowns are now already applied and it shouldn't be necessary to tweak perms | chown -R "$app:www-data" "$install_dir"
    # Remove the lock if it exists
    lock=$install_dir/documents/install.lock
    if [ -f "$lock" ]; then
        ynh_safe_rm "$lock"
    fi

    pushd "$install_dir/htdocs/install/"
        "php$php_version" upgrade.php "$current_version" "$new_version"
        sleep 5

        "php$php_version" upgrade2.php "$current_version" "$new_version"
        sleep 5

        "php$php_version" step5.php "$current_version" "$new_version"
        sleep 5
    popd
}
