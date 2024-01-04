#!/bin/bash

# Function to create a user with a password
create_user() {
    local username=$1
    local password=$2

    # Check if the user already exists
    if ! id "$username" &>/dev/null; then
        # Create the user with the specified password
        sudo adduser --disabled-password --gecos "" "$username"
        echo "${username}:${password}" | sudo chpasswd

        # Add the user to the sudo, tty, and video groups
        sudo usermod -aG sudo,tty,video "$username"
    else
        echo "User ${username} already exists."
    fi
}

# Create user 'ubuntu' with password 'ubuntu'
create_user "ubuntu" "ubuntu"

# Create user 'kiosk' with password 'kiosk'
create_user "kiosk" "kiosk"