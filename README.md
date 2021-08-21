# go-tools.nvim

A tiny plugin for Neovim Golang development written in Lua. This plugin is for personal purpose only, most of the code was copied from [go.nvim](https://github.com/ray-x/go.nvim) plugin.

## Install

Using vim plug

```sh
Plug 'dinhhuy258/go-tools.nvim'
```

## Requirements

- Neovim >= 0.5.0
- `nvim-treesitter` plugin
- `nvim-dap`, `nvim-dap-ui` plugins (optional)

## Features

### IntelliSense

Not support, you can use LSP

### Code Navigation

- Toggle between code and tests with `:GoSwitch` command

### Code Editing

- Format the code with `:GoFormat` command

### Code Generation

- Add or remove struct tags with `:GoAddTags`,  `:GoRemoveTags` and `GoClearTag` commands
- Generate unit tests with `:GoAddTest` and `:GoAddTests` commands

### Run tests

- Run tests with `:GoTest` and `:GoTests` commands

### Debug

- Start debugger using `:GoDebugStart` command
- Start debugger using `:GoDebugStop` command

### Command

- Run Go command with `:Go`, Eg: `:Go mod tidy`
- Run Make command with `:GoMake`, Eg: `:GoMake lint`
