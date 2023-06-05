if not vim.fn.isdirectory(vim.fn.system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/thesaurus"')) then
    print "Downloading dictionary ..."
    vim.cmd("silent !sudo pacman -S words --noconfirm")
    print "Downloading thesaurus ..."
    vim.cmd("silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/thesaurus/")
    vim.cmd("silent !curl 'https://www.gutenberg.org/files/3202/files/mthesaur.txt' > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/thesaurus/mthesaur.txt")

    -- Other alternatives
    -- vim.cmd("silent !curl 'https://raw.githubusercontent.com/words/moby/master/words.txt' > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/thesaurus/words.txt")
    -- vim.cmd("silent !curl 'https://raw.githubusercontent.com/moshahmed/vim/master/thesaurus/thesaurii.txt' > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/thesaurus/thesaurii.txt")
end

local home_dir = vim.fn.expand "$HOME"
local thesaurus_path = home_dir .. "/.config/nvim/thesaurus/mthesaur.txt"
vim.g.tq_mthesaur_file = thesaurus_path
vim.opt.thesaurus = thesaurus_path
vim.g.tq_python_version = 3
vim.opt.dictionary = "/usr/share/dict/words"

-- local tq_enabled_backends=["openoffice_en", "datamuse_com", "mthesaur_txt"]
-- Preventing thesaurus_query from binding any keys, will map custom keys using whichkey
vim.g.tq_map_keys = 0
