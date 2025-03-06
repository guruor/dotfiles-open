## Setup global config

Make sure to set the `VALE_CONFIG_PATH` as per this [doc](https://vale.sh/docs/vale-ini#global-configuration)
```bash
export VALE_CONFIG_PATH="${HOME}/.config/vale/.vale.ini"
```

## Fix for `vale linter setup exists with code 2`
[nvim-lint/issues/528](https://github.com/mfussenegger/nvim-lint/issues/528#issuecomment-2008187144)
```bash
# Initiate the sync
$XDG_DATA_HOME/nvim/mason/packages/vale/vale --config="$HOME/.config/vale/.vale.ini" sync
```
