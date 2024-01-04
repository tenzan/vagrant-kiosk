#!/bin/bash

# Update sources.list with the closest mirror and install required packages
newMirror='https://ftp.udx.icscoe.jp/Linux/ubuntu/'
sudo sed -i "s|deb [a-z]*://[^ ]* |deb ${newMirror} |g" /etc/apt/sources.list
sudo apt-get update
sudo apt install -y xorg openbox unclutter xdotool xdg-utils xvfb chromium-browser python3-xdg xinit menu fonts-takao fonts-ipafont fonts-ipaexfont
sudo fc-cache -fv

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

echo -e "\nunclutter -display 0:0 -noevents -grab # this hides mouse" | sudo tee -a /home/kiosk/.profile
echo -e "startx /etc/X11/Xsession /home/kiosk/startx.sh -- :0" | sudo tee -a /home/kiosk/.profile

# Copy startx.sh to kiosk's home directory and make it executable
sudo cp /vagrant/scripts/startx.sh /home/kiosk/startx.sh
sudo chmod +x /home/kiosk/startx.sh
sudo chown kiosk:kiosk /home/kiosk/startx.sh

# Auto-login configuration for 'kiosk' user
# Configure auto-login for the 'kiosk' user on TTY1
AUTOLOGIN_CONF="/etc/systemd/system/getty@tty1.service.d/autologin.conf"
sudo mkdir -p $(dirname "$AUTOLOGIN_CONF")
sudo bash -c "echo -e '[Service]\nExecStart=\nExecStart=-/sbin/agetty --autologin kiosk --noclear %I \$TERM' > '$AUTOLOGIN_CONF'"

# Remove unwanted directories for the 'kiosk' user
for dir in Desktop Documents Downloads Music Pictures Public Templates Videos; do
    sudo rm -rf /home/kiosk/"$dir"
done

sudo reboot
