$env.TRANSIENT_PROMPT_COMMAND = ""
$env.YAZI_FILE_ONE = ([$env.PROGRAMFILES Git usr bin file.exe] | path join)
$env.MYVIMRCLSP = ([$env.LOCALAPPDATA nvim lua initlsp.lua] | path join)
$env.EDITOR = nvim
$env.MY_DOTFILES_DIR = ([$env.HOMEPATH windots] | path join)
# Use nushell/pwsh if not using WSL
$env.SHELL = nu

$env.BINPATH = ([$env.USERPROFILE .bin] | path join)

# Check if BINPATH is not already in PATH
if not ($env.PATH | split row (char esep) | any { str contains $env.BINPATH }) {
    # Append BINPATH to PATH
    $env.PATH = ($env.PATH | split row (char esep) | append $env.BINPATH)
}


$env.SCOOP_SHIMS = ([$env.USERPROFILE scoop shims] | path join)

# Check if SCOOP_SHIMS is not already in PATH
if not ($env.PATH | split row (char esep) | any { str contains $env.SCOOP_SHIMS }) {
    # Append SCOOP_SHIMS to PATH
    $env.PATH = ($env.PATH | split row (char esep) | append $env.SCOOP_SHIMS)

    # Reset Scoop to fix paths for binaries in $env.HOMEPATH\scoop\apps
    scoop reset *
}

export const STARSHIP_INIT_PATH = ($nu.cache-dir | path join starship init.nu)

# Creates an `init.nu` file via `starship init …` at `STARSHIP_INIT_PATH`.
export def init-starship [] {
	mkdir ($STARSHIP_INIT_PATH | path dirname)
	starship init nu | save -f $STARSHIP_INIT_PATH
}

export const ZOXIDE_INIT_PATH = ($nu.cache-dir | path join zoxide init.nu)

# Creates an `init.nu` file via `zoxide init …` at `ZOXIDE_INIT_PATH`.
export def init-zoxide [] {
	mkdir ($ZOXIDE_INIT_PATH | path dirname)
	zoxide init nushell --hook prompt | save -f $ZOXIDE_INIT_PATH
}

