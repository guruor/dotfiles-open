# Twitch Config

This script creates symbolic links for specific Twitch config files from the current directory to the Twitch Studio config directory.

## Usage

1. The script will create symbolic links for the following files:

    hotkeys.json
    layouts.json
2. After running the script, the symbolic links will be created in the Twitch Studio config directory at the following location:

   ```bash
   /Users/$USER/Library/Application Support/Twitch Studio
   ```
Note: If the symbolic links already exist in the target directory, the script will overwrite them.

