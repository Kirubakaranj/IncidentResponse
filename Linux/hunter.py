import os

# Define the path to search
path = '/mnt/'

# Define the file extension to look for
file_extension = '.foxtrot25'

# List to hold found files
found_files = []

# Walk through the directory
for subdir, dirs, files in os.walk(path):
    for file in files:
        if file.endswith(file_extension):
            # Append full file path to the list
            found_files.append(os.path.join(subdir, file))

# Print the found files
for file in found_files:
    print(file)

# Print the total number of files found
print(f"\nTotal .foxtrot25 files found: {len(found_files)}")