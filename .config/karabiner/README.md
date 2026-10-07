# karabiner

The live configuration is `~/.config/karabiner/karabiner.json`. Karabiner-Elements
writes it in place, the GUI has no export button, and `karabiner_cli` (16.3.0) has
no export command either. The app owns the file; this directory tracks a copy.

## Never symlink karabiner.json itself

Karabiner saves by writing a new file and renaming it over the old one. A rename
replaces the name, so a symlink at that path is replaced by a regular file: the
link is gone, Karabiner keeps writing to the new file, and the copy here goes
stale with no error anywhere. Linking the containing directory is safe, because
the rename then happens inside the real directory and the link itself survives.

The docs say the same:

> Ensure you create a symbolic link to the ~/.config/karabiner directory, not
> directly to the `karabiner.json` file. Karabiner-Elements will fail to detect
> configuration file changes and reload the configuration if `karabiner.json` is
> a symbolic link.

## Shape

    ~/.config/karabiner  ->  ~/voidrice/.config/karabiner      (absolute path)

Track karabiner.json, and assets/ if you add complex modifications. Karabiner's
own rotating copies land in automatic_backups/ and are generated: ignore them.

## Setting it up

Karabiner recreates ~/.config/karabiner and its contents when they are missing,
so move the generated directory aside and put the link in its place:

    # 1. keep what the live folder holds, config and assets alike
    rsync -a ~/.config/karabiner/ ~/voidrice/.config/karabiner/
    # 2. swap the folder for a directory symlink, absolute path
    mv ~/.config/karabiner ~/.config/karabiner.pre-symlink-$(date +%F)
    ln -s ~/voidrice/.config/karabiner ~/.config/karabiner
    # 3. once: Karabiner only watches the new location after this agent restarts
    launchctl kickstart -k gui/$(id -u)/org.pqrs.service.agent.Karabiner-Console-User-Server

## install.sh must skip this path

install.sh expands ~/.config into per-file symlinks (symlink_only_dir_files), so
`./install.sh -i` puts the broken shape straight back: a symlink at
~/.config/karabiner/karabiner.json. With the directory link in place it is worse,
because that target path resolves back into the repo and `ln -sf` then points the
configuration at itself.

Until install.sh has a skip for it, redo step 2 after every install and confirm:

    ls -l ~/.config/karabiner                  # a directory symlink
    ls -l ~/.config/karabiner/karabiner.json   # a regular file, not a link

## When a GUI change does not reach this repo

1. Run the two `ls -l` checks above. If either is wrong, redo step 2.
2. Re-run step 3.
3. Permissions matter only if the target sits in Desktop, Documents, Downloads or
   parts of Library: those need Full Disk Access for Karabiner-Elements,
   Karabiner-Console-User-Server and Karabiner-Core-Service. A path under $HOME,
   like this one, needs nothing.

## References

- https://karabiner-elements.pqrs.org/docs/manual/misc/configuration-file-path/
- Karabiner-Elements issues #3248 and #4366: the same symptom, by design
