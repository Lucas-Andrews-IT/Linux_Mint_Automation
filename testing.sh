#!/bin/bash

################################################################################
# Title: testing.sh
# Description: This script represents my most recent project in active development.
#              It will be frequently committed to version control to keep everyone
#              updated about the ongoing work.
# Author: Lucas Andrews
# Usage: ./testing.sh
################################################################################

#!/usr/bin/env python3

import csv
import subprocess

def create_user(username, full_name, password, access_type):
    subprocess.run(["sudo", "useradd", "-m", "-c", full_name, username])
    subprocess.run(["echo", f"{username}:{password}", "|", "sudo", "chpasswd"])

    if access_type == "admin":
        subprocess.run(["sudo", "usermod", "-aG", "sudo", username])
        subprocess.run(["echo", f"{username} ALL=(ALL) ALL", "|", "sudo", "tee", "-a", f"/etc/sudoers.d/{username}"])
    elif access_type == "sudoers":
        subprocess.run(["echo", f"{username} ALL=(ALL) ALL", "|", "sudo", "tee", "-a", f"/etc/sudoers.d/{username}"])
    elif access_type == "admin_sudoers":
        subprocess.run(["sudo", "usermod", "-aG", "sudo", username])
        subprocess.run(["echo", f"{username} ALL=(ALL) ALL", "|", "sudo", "tee", "-a", f"/etc/sudoers.d/{username}"])

def main():
    spreadsheet_path = "user_data.csv"

    with open(spreadsheet_path, "r") as csv_file:
        reader = csv.DictReader(csv_file)
        for row in reader:
            username = row["Username"]
            full_name = row["Full Name"]
            password = row["Password"]
            access_type = row["Access Type"]

            create_user(username, full_name, password, access_type)
            print(f"User '{username}' created with access type '{access_type}'.")

if __name__ == "__main__":
    main()
