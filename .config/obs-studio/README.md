# OBS Studio Config

This script creates symbolic links for specific OBS Studio config files from the current directory to the OBS Studio config directory.

## Usage

1. The script will create symbolic links for the following files and directories:

    basic/
2. After running the script, the symbolic links will be created in the OBS Studio config directory at the following location:

   ```bash
   /Users/$USER/Library/Application Support/obs-studio
   ```
Note: If the symbolic links already exist in the target directory, the script will overwrite them.

