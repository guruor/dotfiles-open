# Rollback yabai
# https://gist.github.com/shendypratamaa/4eb54aee0a2544531b365df1bbd8d1a0
commit_id=$(curl -s "https://api.github.com/repos/koekeishiya/homebrew-formulae/commits?per_page=20" |
jq -r '.[] | select(.commit.message | contains("yabai")) | .sha + " " + .commit.message' |
fzf --preview 'echo {}' | awk '{print $1}')

echo "Selected Commit ID: $commit_id"

brew uninstall yabai

curl -O "https://raw.githubusercontent.com/koekeishiya/homebrew-formulae/${commit_id}/yabai.rb"

brew install yabai.rb && rm yabai.rb
