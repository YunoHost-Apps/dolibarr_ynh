#!/bin/bash

# Exit immediately on error, unset variables, or failed pipe commands
set -euo pipefail

newfile="$(ls -t /dev/shm/dolibarr/ | head -n1)"

filename="/dev/shm/dolibarr/$newfile"
ACTION="$(cat "$filename" | jq -r .action)"
USERNAME="$(cat "$filename" | jq -r .username)"
PASSWORD="$(cat "$filename" | jq -r .password)"
FULLNAME="$(cat "$filename" | jq -r .fullname)"
EMAIL="$(cat "$filename" | jq -r .email)"
OLDEMAIL="$(cat "$filename" | jq -r .oldemail)"
DOMAIN="$(cat "$filename" | jq -r .domain)"
GROUP="$(cat "$filename" | jq -r .maingroup)"

# ===== Input Validation =====

# Allowed actions
ALLOWED_ACTIONS=(create modify_email modify_fullname modify_password delete activate deactivate)
if [[ ! " ${ALLOWED_ACTIONS[*]} " =~ " ${ACTION} " ]]; then
    echo "Invalid action $ACTION. Allowed actions: ${ALLOWED_ACTIONS[*]}"
	rm $filename
    exit 1
fi

# Valid username: lowercase letters, digits, and underscores
if ! [[ "$USERNAME" =~ ^[a-z0-9_]{1,32}$ ]]; then
    echo "Invalid username format: $USERNAME"
	rm $filename
    exit 1
fi

# ===== Helper Functions =====

# Check if Yunohost user exists
ynh_user_exists() {
    sudo yunohost user list --output-as json | jq -e ".users | has(\"$USERNAME\")" &>/dev/null
}

# ===== User Operations =====

# Create Yunohost user
ynh_create_user() {
#    local password="$1"
#    local fullname="$2"
#    local forward_email="$3"

sudo DISABLE_HOOK=true yunohost user create "$USERNAME" \
        -p "$PASSWORD" \
        -F "$FULLNAME" \
        -d "$DOMAIN"  --debug

    # Optional: add mail forward
    if [[ -n "$EMAIL" ]]; then
        sudo yunohost user update "$USERNAME" --add-mailforward "$EMAIL"
    fi

    unset DISABLE_HOOK
    echo "User $USERNAME created successfully"
}

# Activate user and add to group
ynh_activate_user() {
    sudo yunohost user group add "$GROUP" "$USERNAME"
    echo "User $USERNAME added to group $GROUP"
}

# Modify user's mail forwarding settings
ynh_modify_user_forward_email() {
    [[ -n "$EMAIL" ]] && sudo yunohost user update "$USERNAME" --add-mailforward "$EMAIL"
    [[ -n "$OLDEMAIL" ]] && sudo yunohost user update "$USERNAME" --remove-mailforward "$OLDEMAIL"
    echo "User $USERNAME mail forwarding updated"
}

# Modify user's full name
ynh_modify_user_fullname() {
    sudo yunohost user update "$USERNAME" -F "$FULLNAME"
    echo "User $USERNAME full name updated"
}

# Modify user's password
ynh_modify_user_password() {
    sudo yunohost user update "$USERNAME" -p "$PASSWORD"
    echo "User $USERNAME password updated"
}

# Deactivate user (remove from group)
ynh_deactivate_user() {
    sudo yunohost user group remove "$GROUP" "$USERNAME"
    echo "User $USERNAME removed from group $GROUP"
}

# Delete user
ynh_delete_user() {
    sudo yunohost user delete "$USERNAME"
    echo "User $USERNAME deleted"
}

# ===== Main Execution Flow =====

case "$ACTION" in
    create)
        if [[ -z "$PASSWORD" || -z "$FULLNAME" ]]; then
            echo "Password and FullName are required to create a user."
			rm $filename
            exit 1
        fi
        if ynh_user_exists "$USERNAME"; then
            echo "User $USERNAME exists already"
			rm $filename
            exit 0
        fi
        ynh_create_user
        ;;
    modify_email)
        if ! ynh_user_exists "$USERNAME"; then
            echo "User $USERNAME does not exist"
            ynh_create_user
        else
            ynh_modify_user_forward_email
	fi
        ;;
    modify_fullname)
        if ! ynh_user_exists "$USERNAME"; then
            echo "User $USERNAME does not exist"
            ynh_create_user
        else
            ynh_modify_user_fullname
	fi
        ;;
    modify_password)
        if ! ynh_user_exists "$USERNAME"; then
            echo "User $USERNAME does not exist"
            ynh_create_user
        else
            ynh_modify_user_password
        fi
        ;;
    delete)
        if ! ynh_user_exists "$USERNAME"; then
            echo "User $USERNAME does not exist"
			rm $filename
            exit 0
        fi
        ynh_delete_user
        ;;
    activate)
        if ! ynh_user_exists "$USERNAME"; then
            echo "User $USERNAME does not exist"
            ynh_create_user
        fi
        ynh_activate_user
        ;;
    deactivate)
        if ! ynh_user_exists "$USERNAME"; then
            echo "User $USERNAME does not exist"
			rm $filename
            exit 0
        fi
        ynh_deactivate_user
        ;;
esac
rm $filename
