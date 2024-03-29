#!/bin/bash

# Define the path to the main folder
main_folder="/Users/hassanalnajjar/development"

# Initialize arrays to store versions and their respective folders
declare -a flutter_versions=()
declare -a flutter_folders=()

# Loop through each subfolder
for folder in "$main_folder"/*/; do
    # Check if the folder contains a "version" file
    if [ -f "$folder/version" ]; then
        # Read the value from the "version" file
        version=$(cat "$folder/version")
        # Store version and its folder in arrays
        flutter_versions+=("$version")
        flutter_folders+=("$folder")
    fi
done

# Function to prompt user to select a version
select_flutter_version() {
    echo "Select a Flutter version to set as main:"
    for ((i=0; i<${#flutter_versions[@]}; i++)); do
        echo "$(($i+1)). ${flutter_versions[$i]}"
    done

    read -p "Enter the number corresponding to your choice: " version_choice

    if [[ $version_choice =~ ^[0-9]+$ && $version_choice -ge 1 && $version_choice -le ${#flutter_versions[@]} ]]; then
        selected_version=${flutter_versions[$(($version_choice-1))]}
        selected_folder=${flutter_folders[$(($version_choice-1))]}
        echo "You have selected $selected_version."
        update_main_version "$selected_version" "$selected_folder"
    else
        echo "Invalid choice. Please select a number between 1 and ${#flutter_versions[@]}."
        select_flutter_version
    fi
}

# Function to update the main version
update_main_version() {
    selected_version=$1
    selected_folder=$2
    
    # Check if selected version is already set as main
    current_version=$(cat "/Users/hassanalnajjar/development/flutter/version")
    if [ -f "$selected_folder/version" ]; then
        if [ "$current_version" == "$selected_version" ]; then
            echo "$selected_version is already the main version."
            return
        fi
    fi

    # Rename folders if necessary
        previous_folder="flutter-$current_version"
        if [ -d "$main_folder/flutter" ]; then
            mv "$main_folder/flutter" "$main_folder/$previous_folder"
        fi

    # Rename the selected folder
    selected_folder_new_name="flutter-$selected_version"
    if [ -d "$selected_folder" ]; then
        mv "$selected_folder" "$main_folder/flutter"
    fi

}

# Start script
select_flutter_version

flutter --version
