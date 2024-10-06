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
        "php$php_version" upgrade.php "$current_version" "$new_version"
        sleep 5

        "php$php_version" upgrade2.php "$current_version" "$new_version"
        sleep 5

        "php$php_version" step5.php "$current_version" "$new_version"
        sleep 5
    popd
}
