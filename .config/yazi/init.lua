require("full-border"):setup()
require("session"):setup({
    sync_yanked = true,
})

th.git = th.git or {}
th.git.ignored_sign = " " -- Gitignored
th.git.untracked_sign = "?"
th.git.modified_sign = "M"
th.git.added_sign = "A"
th.git.deleted_sign = "D"
th.git.updated_sign = "U"

th.git.modified = ui.Style():fg("blue")
th.git.added = ui.Style():fg("green")
th.git.deleted = ui.Style():fg("red"):bold()
th.git.updated = ui.Style():fg("green")
