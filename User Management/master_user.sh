#!/bin/bash

# Prompt for action
echo
echo "Select an action:"
echo "1. Add User"
echo "2. Remove User"
echo "3. Exit"
read -p "Enter your choice (1/2/3): " action

case $action in
    1)
        # Adding a new user

        echo
        echo "Adding a New User"
        echo "-----------------"

        # Display existing usernames
        existing_users=$(awk -F':' '{if ($3 >= 1000 && $1 != "admin") print $1}' /etc/passwd)
        echo "Existing users:"
        echo "$existing_users"

        # Prompt for username
        echo
        read -p "Enter username: " username

        # Check if username is already taken
        if [[ "$existing_users" =~ "$username" ]]; then
            echo "Username '$username' is already taken. Please choose a different username."
            sleep 2
            exec "$0" # Re-run the script
        fi

        # Prompt for full name
        echo
        read -p "Enter full name: " full_name

        # Prompt for password (will not be displayed)
        echo
        read -s -p "Enter password: " password
        echo

        # Add the user with provided information
        sudo useradd -m -c "$full_name" "$username"
        echo "User '$username' added."

        # Set the password for the user
        echo "$username:$password" | sudo chpasswd
        echo "Password set for user '$username'."

        # Prompt for user access type
        echo
        echo "Select user access type:"
        echo "1. Standard User"
        echo "2. Admin Group"
        echo "3. Sudoers File"
        echo "4. Admin Group and Sudoers File"
        read -p "Enter your choice (1/2/3/4): " access_type

        case $access_type in
            1)
                echo "User '$username' added as a standard user."
                ;;
            2)
                sudo usermod -aG sudo "$username"
                echo "User '$username' added to the admin group for super user access."
                ;;
            3)
                echo "$username ALL=(ALL) ALL" | sudo tee -a /etc/sudoers.d/"$username"
                echo "User '$username' added to the sudoers file for super user access."
                ;;
            4)
                sudo usermod -aG sudo "$username"
                echo "$username ALL=(ALL) ALL" | sudo tee -a /etc/sudoers.d/"$username"
                echo "User '$username' added to the admin group and the sudoers file for super user access."
                ;;
            *)
                echo "Invalid option. User added as a standard user."
                ;;
        esac

        ;;

    2)
        # Removing a user

        echo
        echo "Removing a User"
        echo "----------------"

        # Get a list of all users
        all_users=($(awk -F':' '{if ($3 >= 1000 && $1 != "admin") print $1}' /etc/passwd))

        # Display all users
        echo "All users (excluding default admin user):"
        for ((i=0; i<${#all_users[@]}; i++)); do
            echo "$(($i+1)). ${all_users[$i]}"
        done

        # Prompt for user selection
        echo
        read -p "Enter the number of the user to remove (1-${#all_users[@]}): " selection

        # Check if the selection is a valid number
        if [[ ! "$selection" =~ ^[0-9]+$ ]]; then
            echo "Invalid selection. Please enter a number."
            exit 1
        fi

        # Convert selection to an array index
        index=$((selection - 1))

        # Ensure the index is within bounds
        if [ $index -ge 0 ] && [ $index -lt ${#all_users[@]} ]; then
            user_to_remove="${all_users[$index]}"

            # Ask for confirmation
            echo
            read -p "Are you sure you want to remove user '$user_to_remove'? (yes/no): " confirm

            if [ "$confirm" == "yes" ]; then
                # Remove the user and their home directory
                sudo userdel -r "$user_to_remove"
                echo "User '$user_to_remove' has been removed."
            else
                echo "User removal process canceled."
            fi
        else
            echo "Invalid selection. Please enter a valid number within the specified range."
            exit 1
        fi

        ;;

    3)
        # Exiting the script
        echo "Exiting the script."
        ;;

    *)
        echo "Invalid choice. Exiting the script."
        ;;
esac
