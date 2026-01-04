#!/bin/bash

# Exit immediately on error, unset variables, or failed pipe commands
set -euo pipefail

ACTION="$1"
USERNAME="$2"
PARAM1="${3:-}"
PARAM2="${4:-}"
PARAM3="${5:-}"
PARAM4="${6:-}"

# ===== Input Validation =====

# Allowed actions
ALLOWED_ACTIONS=(create activate modify_email modify_fullname deactivate delete password)
if [[ ! " ${ALLOWED_ACTIONS[*]} " =~ " ${ACTION} " ]]; then
    echo "Invalid action $ACTION. Allowed actions: ${ALLOWED_ACTIONS[*]}"
    exit 1
fi

# Valid username: lowercase letters, digits, and underscores
if ! [[ "$USERNAME" =~ ^[a-z0-9_]{1,32}$ ]]; then
    echo "Invalid username format: $USERNAME"
    exit 1
fi

# ===== Helper Functions =====

# Check if Yunohost user exists
ynh_user_exists() {
    sudo yunohost user list --output-as json | jq -e ".users | has(\"$1\")" &>/dev/null
}

# ===== User Operations =====

# Create Yunohost user
ynh_create_user() {
    local password="$1"
    local fullname="$2"
    local forward_email="$3"

sudo DISABLE_HOOK=true yunohost user create "$USERNAME" \
        -p "$password" \
        -F "$fullname" \
        -d "$PARAM4"

    # Optional: add mail forward
    if [[ -n "$forward_email" ]]; then
        sudo yunohost user update "$USERNAME" --add-mailforward "$forward_email"
    fi

    unset DISABLE_HOOK
    echo "User $USERNAME created successfully"
}

# Activate user and add to group
ynh_activate_user() {
    sudo yunohost user group add "$PARAM1" "$USERNAME"
    echo "User $USERNAME added to group $PARAM1"
}

# Modify user's mail forwarding settings
ynh_modify_user_forward_email() {
    [[ -n "$1" ]] && sudo yunohost user update "$USERNAME" --add-mailforward "$1"
    [[ -n "$2" ]] && sudo yunohost user update "$USERNAME" --remove-mailforward "$2"
    echo "User $USERNAME mail forwarding updated"
}

# Modify user's full name
ynh_modify_user_fullname() {
    sudo yunohost user update "$USERNAME" -F "$1"
    echo "User $USERNAME full name updated"
}

# Modify user's password
ynh_modify_user_password() {
    sudo yunohost user update "$USERNAME" -p "$1"
    echo "User $USERNAME password updated"
}

# Deactivate user (remove from group)
ynh_deactivate_user() {
    sudo yunohost user group remove "$PARAM2" "$USERNAME"
    echo "User $USERNAME removed from group $PARAM2"
}

# Delete user
ynh_delete_user() {
    sudo yunohost user delete "$USERNAME"
    echo "User $USERNAME deleted"
}

# ===== Main Execution Flow =====

case "$ACTION" in
    create)
        if [[ -z "$PARAM1" || -z "$PARAM2" ]]; then
            echo "Password and FullName are required to create a user."
            exit 1
        fi
        if ynh_user_exists "$USERNAME"; then
            echo "User $USERNAME exists already"
            exit 1
        fi
        ynh_create_user "$PARAM1" "$PARAM2" "$PARAM3"
        ;;
    activate)
        if ! ynh_user_exists "$USERNAME"; then
            echo "User $USERNAME does not exist"
            exit 1
        fi
        ynh_activate_user
        ;;
    modify_email)
        ynh_modify_user_forward_email "$PARAM1" "$PARAM2"
        ;;
    modify_fullname)
        ynh_modify_user_fullname "$PARAM1"
        ;;
    deactivate)
        if ! ynh_user_exists "$USERNAME"; then
            echo "User $USERNAME does not exist"
            exit 1
        fi
        ynh_deactivate_user
        ;;
    delete)
        if ! ynh_user_exists "$USERNAME"; then
            echo "User $USERNAME does not exist"
            exit 1
        fi
        ynh_delete_user
        ;;
    password)
        ynh_modify_user_password "$PARAM1"
        ;;
esac
