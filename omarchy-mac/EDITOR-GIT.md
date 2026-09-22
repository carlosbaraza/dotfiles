# AstroNvim and Git migration — 2026-09-22

## Installed editor

The active `~/.config/nvim` is based on `~/dotfiles/nvim`, with the original
AstroNvim v6 configuration and its lockfile. Installed AstroNvim version: **v6.1**.
The original source profile remains unchanged; the adapted live version is saved
under `omarchy-mac/files/.config/nvim`.

Features carried over:

- Catppuccin Mocha theme.
- Absolute and relative line numbers, no wrapping, system clipboard register.
- AstroNvim completion, diagnostics, navigation, buffer picker and normal keybindings.
- Neo-tree shows dotfiles and Git-ignored files.
- CSVView table rendering and field text objects / Tab navigation.
- Render Markdown.
- TypeScript `ts_ls`, including the existing 8192 MB maximum server-memory setting.
- Original disabled example files remain disabled.
- AstroNvim's default format-on-save is enabled. This differs from the previous
  Omarchy LazyVim profile, which explicitly disabled autoformat.

Linux adaptations:

- `lua/polish.lua` loads `omarchy_clipboard.lua`. Local sessions use the normal
  Wayland clipboard provider; tmux/SSH sessions retain the earlier OSC 52 copy
  integration, with local Wayland paste where available.
- Activated the Mason tool installer for `lua-language-server`,
  `typescript-language-server`, and `stylua`. All three installed successfully.
- Treesitter parsers installed for the default languages and TypeScript when tested.
- The old Omarchy theme override is not loaded into AstroNvim: the editor follows
  the requested Catppuccin theme rather than desktop theme changes.

### Validation

- Plugin restore finished without reported errors.
- A fresh headless Neovim session loaded AstroNvim, CSVView, Neo-tree, Markdown
  rendering, and AstroLSP; checked Catppuccin and relative numbering.
- Checked Neo-tree's hidden-file settings and all three Mason package receipts.
- Opened a TypeScript fixture project and verified that `ts_ls` attached.
- The first synchronous Mason installation runner remained waiting after all tools
  had installed. That test process was terminated; independent subsequent checks
  verified the installed tools and working TypeScript server.
- No physical interactive editor session was used to test every keybinding.

## Git configuration

Installed **Delta 0.19.2** and adapted `~/dotfiles/git/gitconfig` into
`~/.config/git/config`, tracked in the Omarchy profile.

- Identity: Carlos Baraza Haro, `carlos.baraza@ieee.org`, from the original dotfiles.
- Preserved the personal aliases (`a`, `co`, `nb`, `changes`, `short`, `snapshot`,
  `unstage`, `uncommit`, stash aliases, and others).
- `core.editor = nvim`; Delta as pager and interactive diff filter.
- `pull.rebase = false`, `push.default = upstream`, `init.defaultBranch = main`.
- Patience diff algorithm, moved-line highlighting, diff3 conflicts and rerere.
- Replaced macOS DiffMerge, MacVim and Sourcetree commands with Git's built-in
  `nvimdiff` support. Removed Mac-only paths and the old safe-directory entry.
- GitHub/Gist credentials use `!gh auth git-credential` from PATH instead of
  `/opt/homebrew/bin/gh`. No credentials or tokens were copied into Git.
- Optional private overrides remain at `~/.gitconfig.user`, outside version control.
- The old global ignore file was not present in the repository. Created
  `~/.config/git/ignore` with `.DS_Store`, Vim swap files and editor backup files.
- Retained non-conflicting Omarchy conveniences: branch/tag sorting, verbose commit
  messages, columns, automatic upstream setup and the `br` alias.

Fixes while adapting:

- Corrected quoting in the original custom log aliases so the format is one argument.
- Modernized `snapshot` to use `git stash push`, restoring only a newly created
  snapshot. A clean working tree no longer risks applying an older stash.

### Validation

Parsed the effective global configuration and verified identity, pager, editor,
merge/diff tools, pull behavior and credential-helper commands. A disposable Git
repository verified a local commit, the custom log/status aliases, snapshotting
uncommitted changes, and the clean-tree snapshot case. No remote push, pull, merge,
or credential login was performed.

Reference: [Git's Neovim merge-tool support](https://git-scm.com/docs/git-mergetool).

## Install / reapply

On an existing Omarchy installation, with Node/npm available through mise:

```bash
cd ~/dotfiles
./omarchy-mac/configs.py apply --scope editor-git --dry-run
./omarchy-mac/install-editor-git.sh
```

The editor directory is replaced as a unit, with a backup, so old LazyVim plugin
files cannot leak into AstroNvim. The script installs missing system dependencies,
applies the editor/Git profile, and restores plugins. Open Neovim afterward to
allow Mason to install language tools if they are not present on that machine.
This does not change shell, desktop, monitor, or Fcitx settings.

## Previous setup and rollback

The complete previous editor config, plugin data and editor state were moved to:

`~/.local/state/dotfiles/backups/astronvim-git-20260922-224259/`

The previous Git config is `git-config` in that directory. The earlier LazyVim
config snapshot is also retained at `omarchy-mac/reference/lazyvim-before-astronvim`.
Its relative theme symlink is an archival reference; it resolves correctly when
restored to `~/.config/nvim`, not from the archive's different directory depth.

To roll back, close Neovim, preserve the new `~/.config/nvim`, `~/.local/share/nvim`
and `~/.local/state/nvim` directories, then restore those paths from the backup.
Restore `git-config` to `~/.config/git/config` if reverting Git as well. Update the
tracked profile after deciding which version should remain canonical.
