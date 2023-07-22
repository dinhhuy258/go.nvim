# go.nvim

A tiny plugin for Neovim Golang development written in Lua. This plugin is for personal purpose only, most of the code was copied from [go.nvim](https://github.com/ray-x/go.nvim) plugin.

## Install

Using vim plug

```sh
Plug 'dinhhuy258/go.nvim'
```

## Requirements

- Neovim >= 0.5.0
- `nvim-treesitter` plugin
- `nvim-dap`, `nvim-dap-ui` plugins (optional)

## Features

### IntelliSense

Not support, you can use LSP

### Code Navigation

- Toggle between code and tests with `:GoSwitch`

### Code Editing

- Format the code with `:GoFormat`

### Code Generation

- Add or remove struct tags with `:GoAddTags`, `:GoRemoveTags` and `GoClearTag`
- Generate unit tests for  current function `GoAddTest`
- Gererate unit tests for current file `GoAddTests`

### Run tests

- Run single unit test for current function `:GoTest`
- Run all tests for current file `:GoTests`

### Debug

- Start debugger using `:GoDebugStart`
- Stop debugger using `:GoDebugStop`

### Command

- Run Go command with `:Go`, Eg: `:Go mod tidy`
- Run Make command with `:GoMake`, Eg: `:GoMake lint`
