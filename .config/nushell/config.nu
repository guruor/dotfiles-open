$env.config = {
  show_banner: false
  rm: {
    always_trash: true
  }
  edit_mode: vi
  cursor_shape: {
    # block, underscore, line, blink_block, blink_underscore, blink_line
    vi_insert: blink_line
    vi_normal: blink_block
  }
  keybindings: [
    {
      name: open_tfm
      modifier: CONTROL
      keycode: Char_o
      mode: [vi_insert vi_normal emacs]
      event: {
        send: executehostcommand,
        cmd: "yazi"
      }
    }
  ]
}

$env.PROMPT_INDICATOR_VI_INSERT = { "" }
$env.PROMPT_INDICATOR_VI_NORMAL = { "" }

alias cf = cd ~/.config
alias q = exit

# Custom command for changing directories
def --env dot [] {
    cd $env.MY_DOTFILES_DIR
}
def --env udot [] {
    dot; cd dotfiles-open
}
def --env pdot [] {
    udot; cd Private
}
def doti [] {
    dot; pwsh install
}

alias c = nvim -u $env.MYVIMRCLSP
alias g = git

use $STARSHIP_INIT_PATH
source $ZOXIDE_INIT_PATH
