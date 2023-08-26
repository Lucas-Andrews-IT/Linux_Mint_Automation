#!/bin/bash

# 'chmod +x Add_user_without_access.sh' | before running the script in terminal

# './Add_user_without_access.sh' | run the script


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

# Print a message indicating success
echo "User '$username' added successfully."
