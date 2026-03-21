# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A personal Neovim configuration built on [LazyVim](https://lazyvim.github.io/) (the LazyVim starter template). It also has a separate VSCode-Neovim mode (`config/vscode.lua`).

## Formatting

Lua files are formatted with [StyLua](https://github.com/JohnnyMorganz/StyLua): 2-space indent, 120 column width. Run `stylua .` from the repo root.

## Architecture

- `init.lua` — Entry point. Branches between VSCode mode (`config/vscode`) and full Neovim mode (`config/lazy`).
- `lua/config/lazy.lua` — Bootstraps lazy.nvim and defines the plugin spec. LazyVim extras enabled: prettier, eslint, docker, json, terraform, typescript, yaml.
- `lua/config/` — Options, keymaps, autocmds. These extend/override LazyVim defaults.
- `lua/plugins/` — Per-plugin override files. Each returns a lazy.nvim plugin spec that merges with LazyVim's defaults via `opts`.

Plugin customizations are **overrides on top of LazyVim**, not standalone configs. To understand the full behavior of any plugin, check the corresponding [LazyVim plugin spec](https://github.com/LazyVim/LazyVim/tree/main/lua/lazyvim/plugins) first, then look at the local override.

## Key Customizations

- **TypeScript/JavaScript**: 4-space tabs (autocmd in `autocmds.lua`), vtsls with 16GB memory limit, Prisma LSP enabled.
- **Spell checking**: Disabled by default (`spell = false`), configured for en_us + ru with camel-case awareness. cspell runs via nvim-lint on all file types.
- **blink.cmp**: Uses Lua fuzzy implementation (not native) to avoid macOS crashes.
- **Neo-tree**: `h`/`l` for vim-style directory navigation, hidden files visible, narrow 35-col window.
- **Snacks**: Scroll animation disabled.

## Adding a New Plugin Override

Create `lua/plugins/<plugin-name>.lua` returning a lazy.nvim spec table. The `opts` table deep-merges with LazyVim's defaults — you only need to specify what you're changing.
