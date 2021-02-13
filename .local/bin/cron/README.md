# Important Note

These cronjobs have components that require information about your current display to display notifications correctly.

When you add them as cronjobs, I recommend you precede the command with commands as those below:

```
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u $USER)/bus; export DISPLAY=:0; . $HOME/.zprofile;  then_command_goes_here
```

This ensures that notifications will display, xdotool commands will function and environmental variables will work as well.

To backup user cron jobs to a file
```
crontab -l > $HOME/.local/bin/cron/jobs-backup.text
```

To restore user cron jobs from a file
```
crontab $HOME/.local/bin/cron/jobs-backup.text
```
