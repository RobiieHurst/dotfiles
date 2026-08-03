# 💤 LazyVim

A customized Neovim configuration built on [LazyVim](https://github.com/LazyVim/LazyVim).

## Highlights

- Language support for Elixir, Git, Markdown, Python, SQL, Tailwind CSS,
  TypeScript, and Zig through LazyVim extras.
- Formatting with StyLua, rustfmt, gofumpt, Biome, and Prettier.
- JavaScript and TypeScript debugging with `nvim-dap`, plus Vitest support
  through Neotest.
- File navigation with Telescope, Oil, Neo-tree, and Yazi.
- Optional OpenCode and Claude Code integrations.
- Automatic theme hot-reloading for Omarchy, with Rose Pine as the default.
- Large-file safeguards that disable expensive editor features when necessary.

## Requirements

- A [LazyVim-compatible Neovim version](https://lazyvim.github.io/installation)
- [Git](https://git-scm.com/)
- A [Nerd Font](https://www.nerdfonts.com/) for icons
- [`ripgrep`](https://github.com/BurntSushi/ripgrep) and
  [`fd`](https://github.com/sharkdp/fd) for file and text search

Some features also depend on optional command-line tools:

- `yazi` for terminal file management
- `tmux` and `tmux-sessionizer` for session shortcuts
- `opencode` and `claude` for AI integrations
- `chromium` and `js-debug-adapter` for browser debugging
- `markdownlint-cli2` and `~/.markdownlint.yaml` for Markdown linting

## Installation

Back up any existing Neovim configuration, then clone this repository:

```sh
mv ~/.config/nvim ~/.config/nvim.bak
git clone <repository-url> ~/.config/nvim
nvim
```

Skip the `mv` command if `~/.config/nvim` does not exist. On first launch,
`lazy.nvim` bootstraps itself and installs the configured plugins. Run
`:checkhealth lazy` afterward to check the installation.

## Structure

| Path | Purpose |
| --- | --- |
| `init.lua` | Loads the LazyVim bootstrap configuration |
| `lua/config/lazy.lua` | Bootstraps `lazy.nvim` and imports plugins |
| `lua/config/options.lua` | Defines editor options |
| `lua/config/keymaps.lua` | Defines custom keymaps |
| `lua/config/autocmds.lua` | Defines custom autocommands |
| `lua/plugins/` | Contains plugin specifications and overrides |
| `lazyvim.json` | Tracks enabled LazyVim extras |
| `lazy-lock.json` | Pins plugin revisions for reproducible installs |

## Selected Keymaps

The leader key is `Space`.

| Keymap | Action |
| --- | --- |
| `-` | Open Oil at the parent directory |
| `<leader>-` | Open Yazi at the current file |
| `<C-s>` | Save the current file |
| `<C-a>` | Ask OpenCode about the current context |
| `<C-.>` | Toggle the OpenCode terminal |
| `<leader>ac` | Toggle Claude Code |
| `<F5>` | Start or continue debugging |
| `<F10>` / `<F11>` / `<F12>` | Step over, into, or out while debugging |
| `<leader>zig` | Restart the active LSP clients |
| `<leader>pE` | Find `.env` files |

Use `<leader>sk` inside Neovim to search all active keymaps, including the
defaults provided by LazyVim.

## Customization

- Add or override plugins with a spec in `lua/plugins/`.
- Change editor behavior in `lua/config/options.lua`.
- Add mappings and autocommands in `lua/config/keymaps.lua` and
  `lua/config/autocmds.lua`.
- Run `:LazyExtras` to manage LazyVim extras.
- Run `:Lazy` to inspect, update, or synchronize plugins.

See the [LazyVim documentation](https://lazyvim.github.io/) for the complete
configuration reference.
