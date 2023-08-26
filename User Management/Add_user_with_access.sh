#!/bin/bash


# 'chmod +x Add_user_with_access.sh' | before running the script in terminal

# './Add_user_with_access.sh' | run the script


# Prompt for username
read -p "Enter username: " username

# Prompt for full name
read -p "Enter full name: " full_name

# Prompt for password (will not be displayed)
read -s -p "Enter password: " password
echo

# Add the user with provided information
sudo useradd -m -c "$full_name" "$username"

# Set the password for the user
echo "$username:$password" | sudo chpasswd

# Prompt for super user access type
read -p "Choose super user access type: (1) Admin Group, (2) Sudoers File: " access_type

# Add the user to the chosen super user access
if [ "$access_type" == "1" ]; then
    sudo usermod -aG sudo "$username"
    echo "User '$username' added to the admin group for super user access."
elif [ "$access_type" == "2" ]; then
    echo "$username ALL=(ALL) ALL" | sudo tee -a /etc/sudoers.d/"$username"
    echo "User '$username' added to the sudoers file for super user access."
else
    echo "Invalid option. No super user access type selected."
fi

# Print a message indicating success
echo "User '$username' added successfully with chosen super user access."
