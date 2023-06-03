# Twitch Config

This script creates symbolic links for specific Twitch config files from the current directory to the Twitch Studio config directory.

## Prerequisites

- This script is designed for macOS systems.
- You should have the necessary permissions to create symbolic links in the target directory.

## Usage

1. Place the script file (`symlink_twitch_config`) in the same directory as your Twitch config files.
2. Open a terminal and navigate to the directory where the script and the config files are located.
3. Make the script executable by running the following command:

   ```bash
   chmod +x symlink_twitch_config
   ```
4. Run the script using the following command:

   ```bash 
   ./symlink_twitch_config
   ```
5. The script will create symbolic links for the following files:

    hotkeys.json
    layouts.bak.json
    layouts.json
6. After running the script, the symbolic links will be created in the Twitch Studio config directory at the following location:

   ```bash
   /Users/$USER/Library/Application Support/Twitch Studio
   ```
Note: If the symbolic links already exist in the target directory, the script will overwrite them.

7. Verify that the symbolic links were created successfully by checking the target directory.

### Disclaimer

Please use this script at your own risk. It is recommended to backup your original config files before running the script.

_P.S. This script is only tested on MacOS._

