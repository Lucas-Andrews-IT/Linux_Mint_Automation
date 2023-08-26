#!/bin/bash


# 'chmod +x Remove_user.sh' | before running the script in terminal

# './Remove_user.sh' | run the script


# Get a list of known users (excluding default admin user)
known_users=($(awk -F':' '{if ($3 >= 1000 && $1 != "admin") print $1}' /etc/passwd))

# Check if there are any known users
if [ ${#known_users[@]} -eq 0 ]; then
    echo "No known users found (excluding default admin user)."
    exit 1
fi

# Display known users
echo "Known users (excluding default admin user):"
for ((i=0; i<${#known_users[@]}; i++)); do
    echo "$(($i+1)). ${known_users[$i]}"
done

# Prompt for user selection
read -p "Enter the number of the user to remove (1-${#known_users[@]}): " selection

# Check if the selection is a valid number
if [[ ! "$selection" =~ ^[0-9]+$ ]]; then
    echo "Invalid selection. Please enter a number."
    exit 1
fi

# Convert selection to an array index
index=$((selection - 1))

# Ensure the index is within bounds
if [ $index -ge 0 ] && [ $index -lt ${#known_users[@]} ]; then
    user_to_remove="${known_users[$index]}"

    # Ask for confirmation
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
