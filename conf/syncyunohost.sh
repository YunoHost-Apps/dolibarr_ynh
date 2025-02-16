#!/bin/bash

# First parameter is the action, second is the username, the rest are optional
ACTION=$1
USERNAME=$2
PARAM1=$3
PARAM2=$4
PARAM3=$5
PARAM4=$6

# Helper function to check if a user exists in YunoHost
ynh_user_exists() {
    yunohost user list --output-as json | jq -e ".users | has(\"$1\")" &>/dev/null
}

# Helper function to remove a user from all groups
remove_from_all_groups() {
    local username="$1"
    yunohost user group add "$PARAM1" "$username" &>/dev/null
    yunohost user group remove "$PARAM2" "$username" &>/dev/null
}

ynh_create_user() {
    local password="$1"
    local fullname="$2"
    local forward_email="$3"
    DOMAIN=$(sudo yunohost domain list | head -1 | awk '{print $2}')
    sudo yunohost user create "$USERNAME" \
        -p "$password" \
        -F "$fullname" \
        -d "$DOMAIN"  

    # Add mail forward if provided
    if [ -n "$forward_email" ]; then
        sudo yunohost user update "$USERNAME" \
            --add-mailforward "$forward_email"
    fi
    yunohost user group add "$PARAM4" "$USERNAME" &>/dev/null

    echo "User $username created successfully."
}

# Activate a user and add them to the all_users group
ynh_activate_user() {
    # Activate the user
    yunohost user group remove "$PARAM1" "$USERNAME" &>/dev/null
    yunohost user group add "$PARAM2" "$USERNAME" &>/dev/null
    # Add to the all_users group
    echo "User $USERNAME activated and added to the "$PARAM1" group."
}

# Modify user details
ynh_modify_user_forward_email() {
    local new_forward_email=$1
    local old_forward_email=$2
    # add mailforward if provided
    if [ -n "$new_forward_email" ]; then
        yunohost user update "$USERNAME" --add-mailforward "$new_forward_email" &>/dev/null
    fi
    # remove mailforward if provided
    if [ -n "$old_email" ]; then
        yunohost user update username --remove-mailforward "$old_forward_email" &>/dev/null 
    fi

    echo "Email $USERNAME updated."
}
# Modify user details
ynh_modify_user_fullname() {
    local fullname=$1
    # Update fullname if provided
    if [ -n "$fullname" ]; then
        yunohost user update "$USERNAME" -F "$fullname" &>/dev/null
    fi
    echo "FullName $USERNAME updated."
}
# Modify user details
ynh_modify_user_password() {
    local new_password=$1
    # Update password if provided
    if [ -n "$new_password" ]; then
        yunohost user update "$USERNAME" -p "$new_password" &>/dev/null
    fi
    echo "Password $USERNAME updated."
}

# Deactivate a user
ynh_deactivate_user() {
    # Remove from all groups
    remove_from_all_groups "$USERNAME"

    echo "User $USERNAME deactivated and removed from all groups."
}

# Delete a user
ynh_delete_user() {
    yunohost user delete "$USERNAME" &>/dev/null
    echo "User $USERNAME deleted."
}


# Main logic for handling actions
case $ACTION in
    create)
        if [ -z "$PARAM1" ] || [ -z "$PARAM2" ]; then
            echo "Error: Domain And FullName and Password are required for user creation."
            exit 1
        fi
        ynh_create_user "$PARAM1" "$PARAM2" "$PARAM3" 
        ;;

    activate)
        if ! ynh_user_exists "$USERNAME"; then
            echo "Error: User $USERNAME does not exist."
            exit 1
        fi
        ynh_activate_user
        ;;

    modify_email)
        if [ -z "$PARAM1" ]; then
            echo "Error: New Email is required."
            exit 1
        fi
        ynh_modify_user_email "$PARAM1" "$PARAM2"
        ;;
    modify_fullname)
        if [ -z "$PARAM1" ]; then
            echo "Error: New FullName is required."
            exit 1
        fi
        ynh_modify_user_fullname "$PARAM1"
        ;;
    deactivate)
        if ! ynh_user_exists "$USERNAME"; then
            echo "Error: User $USERNAME does not exist."
            exit 1
        fi
        ynh_deactivate_user
        ;;

    delete)
        if ! ynh_user_exists "$USERNAME"; then
            echo "Error: User $USERNAME does not exist."
            exit 1
        fi
        ynh_delete_user
        ;;

    password)
        if [ -z "$PARAM1" ]; then
            echo "Error: New password is required."
            exit 1
        fi
        ynh_modify_user_password "$PARAM1"
        ;;

    *)
        echo "Invalid action. Supported actions: create, activate, modify, deactivate, delete, password."
        exit 1
        ;;
esac
