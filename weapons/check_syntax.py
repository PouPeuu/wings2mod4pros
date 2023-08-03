import os
import glob
import subprocess

# Get the current directory path
folder_path = os.getcwd()

# Recursive function to find all .lua files
def find_lua_files(folder):
    lua_files = []
    for file in glob.glob(os.path.join(folder, '*.lua')):
        lua_files.append(file)
    for subfolder in os.scandir(folder):
        if subfolder.is_dir():
            lua_files.extend(find_lua_files(subfolder.path))
    return lua_files

# Get all .lua files
lua_files = find_lua_files(folder_path)

# Process the files
for file in lua_files:
    command = f"luac -p \"{file}\""
    try:
        output = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT, universal_newlines=True)
        #print(f"Command '{command}' executed successfully for {file}")
        print(output)
    except subprocess.CalledProcessError as e:
        print(f"Command '{command}' failed for {file}")
        print(e.output)
