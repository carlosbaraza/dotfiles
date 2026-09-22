# Omarchy on Apple Silicon — Carlos's configuration

This is the reference profile for the M2 Mac running Omarchy / Arch Linux ARM.
The repository lives at **`~/dotfiles`**. The original `osx/`, `debian/`, `aerospace/`,
and AstroNvim `nvim/` profiles remain separate.

## Goals and scope

Preserve the Mac's AeroSpace and tmux muscle memory while using Omarchy's native
Hyprland, Wayland clipboard, package manager, and working application integrations.
Track user configuration rather than modifying `/usr/share/omarchy`.

- Implemented: Option window/desktop shortcuts, personal tmux bindings, occupied-only
  workspace bar, Fn dictation binding.
- Shell: Zsh / Oh My Zsh / Atuin installed and active for new login shells; see installation status below.
- Configured: AstroNvim from the original dotfiles, personal Git aliases/identity, Delta.
- Preserved baseline: Ghostty clipboard integration, Voxtype,
  mise and the user Hyprland files.
- Not migrated: Mac monitor assignments,
  cloud history credentials, private environment files, or application credentials.

## Terminal installation list

Package availability was checked against this machine's configured ARM repositories
on 2026-09-22. `packages.txt` is the core set; `packages-optional.txt` is a review list.

| Component | Package / source | Status before this migration | Purpose |
| --- | --- | --- | --- |
| Zsh | `zsh` | Missing | Familiar interactive shell |
| Oh My Zsh | `ohmyzsh/ohmyzsh` | Missing | `robbyrussell` theme and Git shell plugin |
| Autosuggestions | `zsh-autosuggestions` | Missing | History suggestions |
| Syntax highlighting | `zsh-syntax-highlighting` | Missing | Highlight command input |
| Atuin | `atuin` | Missing | Ctrl+R history; Up searches this session |
| fzf | `fzf` | Installed | Fuzzy selection and shell widgets |
| zoxide | `zoxide` | Installed | Directory jumping |
| ripgrep / fd | `ripgrep`, `fd` | Installed | Content and filename search |
| bat / eza | `bat`, `eza` | Installed | File previews and listings |
| tmux / Neovim | `tmux`, `neovim` | Installed | Terminal sessions and editor |
| Wayland clipboard | `wl-clipboard` | Installed | `pbcopy` / `pbpaste` equivalents |
| dust / sd | `dust`, `sd` | Optional, missing | Disk usage and substitutions |
| ripgrep-all | `ripgrep-all` | Optional, missing | `rga-fzf`, including document search |
| Delta | `git-delta` | Installed during editor/Git migration | Git diff viewer |
| fnm | `fnm` | Optional, missing | Mac's Node manager; do not combine with active mise Node management |
| pyenv / Go / Rust | `pyenv`, `go`, `rustup` | Optional, missing | Project language tools |
| Bun / Deno | `bun`, `deno` | Optional, missing | Alternative JavaScript runtimes |

Node and Codex are already managed by **mise**. The new Zsh configuration activates
mise rather than adding a second Node manager. Optional runtime package availability
should be checked before installation. No Homebrew, macOS paths, or x86 Neovim
binaries are used here.

```bash
cd ~/dotfiles
./omarchy-mac/install-terminal.sh
chsh -s /usr/bin/zsh
# Start using it immediately in an existing terminal:
exec zsh -l
```

The installer installs only the core list, clones Oh My Zsh if absent, and applies
only the `.zshrc` symlink and Atuin configuration. Run it as your normal user from a terminal;
Omarchy requests privilege for system packages. Optional tools can be installed
individually, for example `omarchy pkg add dust sd ripgrep-all`.

### Keyboard layout

English (UK, Macintosh), XKB layout `gb`, variant `mac`. This replaces the
initial generic UK layout, which did not match the MacBook keycaps. Both Hyprland's `input.lua` and
Fcitx's `~/.config/fcitx5/profile` use `gb-mac` / `keyboard-gb-mac`. Existing Compose
and Caps Lock options are retained. Fcitx is managed by `omarchy-fcitx5.service`. Stop that service before restoring
its profile, then start it afterward: it otherwise writes cached settings on exit
and may race a manually launched instance. Run `hyprctl reload` for Hyprland.

### Shell behavior

- Keeps inherited PATH and mise-managed tools; editor aliases `v`, `vi`, `vim` use Neovim.
- Oh My Zsh uses `robbyrussell`, the Git plugin, and disabled automatic updates.
- Autosuggestions and syntax highlighting are supplied by Arch packages.
- Atuin loads after fzf to own Ctrl+R and Up. Search is global; Up is session-scoped.
- Atuin Enter executes the selection, matching the original config. Ctrl+numbers
  choose results because Option+numbers are desktop shortcuts.
- `pbcopy` uses Wayland locally, OSC 52 remotely; `pbpaste` reads Wayland.
- `open` uses `xdg-open`; `chrome` opens a new Chromium window.
- `claude-tmux` and an adapted `rga-fzf` are available.
- `cx` and `c` launch Codex and Claude with their normal permission settings. Old
  bypass flags, provider-specific model aliases, and hardcoded Mac paths were not ported.
- `.env`, project shell utilities, and `.zshrc.local` are sourced only if present.
- Atuin account login/sync credentials and history databases are not in this repository.

## Desktop and window shortcuts

On this keyboard, **Option = Alt** and **Command = Super**.

| Shortcut | Action |
| --- | --- |
| Option+H/J/K/L | Focus left/down/up/right |
| Option+Shift+H/J/K/L | Move window left/down/up/right |
| Option+1–9 | Switch to numbered desktop |
| Option+A–Z, except H/J/K/L | Switch to corresponding letter desktop |
| Option+Shift+number/letter | Move window there without following it |
| Option+Tab | Return to previous desktop |
| Option+Shift+Tab | Move desktop to next monitor |
| Option+Shift+Space | Toggle fullscreen |
| Option+− / Option+= | Shrink/grow window horizontally by 50 |
| Option+0 | Equalize the active Dwindle split |
| Command+C / Command+V | Copy / paste (terminal-aware) |
| Hold Fn / release Fn | Start dictation / stop and transcribe |

There are 31 configured persistent desktops (9 numbers, 22 letters). Empty desktops
remain reachable by shortcut but are hidden in the top bar. Numbers precede letters
in the bar. Special/scratchpad workspaces are excluded.

Important adaptations:

- Option+0 affects the active split, **not** AeroSpace's entire workspace tree.
- Resize is horizontal, not AeroSpace's layout-dependent `smart` resize.
- Hyprland Dwindle movement/layout differs from AeroSpace's tiling tree.
- AeroSpace's accordion, service/passthrough modes, and zen-gap shortcuts have not
  been ported.
- Option+Tab / Shift+Tab replace window cycling. Option+Shift+D and L replace
  Omarchy's web-app video download and URL-copy shortcuts.
- Monitor-to-desktop assignments and monitor geometry were not changed.

The Fn binding uses Linux KEY_FN 464 + the XKB offset 8 (`code:472`). The keyboard
advertises this key. The bindings loaded without configuration errors; physical
Fn recording was not independently verified by the agent.

## Tmux

| Shortcut | Action |
| --- | --- |
| Ctrl+A | Prefix (Ctrl+B remains a secondary prefix) |
| Prefix, h/j/k/l | Focus pane left/down/up/right |
| Ctrl+1–9 | Select window without prefix |
| Prefix, pipe / minus | Split horizontally / vertically, preserving directory |
| Prefix, c | New window in current directory |
| Prefix, Ctrl+P / Ctrl+N | Previous / next window |
| Ctrl+Shift+Left/Right | Previous / next window |
| Ctrl+Shift+Option+Left/Right | Swap window left/right |
| Option+Shift+arrows | Focus pane |
| Prefix, r | Reload config |
| Prefix, Shift+D | Detach current window into its own session and Ghostty window |
| Copy mode: v / y | Begin selection / copy |

Clipboard copying uses tmux's OSC 52 integration instead of macOS `pbcopy`.
Ctrl+number bindings use extended keys, enabled for Ghostty's xterm terminfo.
Omarchy's theme, 50,000-line history, and existing terminal integrations remain.
The helper lives at `~/.local/bin/tmux-detach-window` and does not depend on the
repository checkout path.

## Top bar

The built-in workspace widget was cloned to
`~/.config/omarchy/plugins/carlosbaraza.workspaces/`, then selected in `shell.json`.
It lists only workspaces with at least one toplevel window, including named letter
workspaces. Empty active workspaces are also hidden.

A plugin rescan initially left the old widget displayed. `omarchy restart shell`
loaded the new widget; a fresh screenshot confirmed only occupied desktops 1 and 2.
After restoring this profile, restart the shell to avoid that stale-widget behavior.

## Neovim and Git

The active editor is now **AstroNvim v6.1**, installed from the original `nvim/`
dotfiles. Its adapted configuration is recorded in `files/.config/nvim/`.
The previous LazyVim profile is preserved in `reference/lazyvim-before-astronvim/`.
See [EDITOR-GIT.md](EDITOR-GIT.md) for the migration, configuration, validation and
rollback details. The original root `nvim/` and `git/gitconfig` were not modified.

## Window appearance

Compact spacing uses `general.gaps_in = 2` (per inner edge) and
`general.gaps_out = 4`, reduced from Omarchy's 5 and 10 logical pixels.

`files/.config/hypr/looknfeel.lua` sets `decoration.rounding = 20` and
`rounding_power = 4.0`: a soft macOS-style corner shape, using logical pixels.
This is an approximation rather than an exact macOS geometry match.
Omarchy menus, notifications and panels share the radius, but the installed shell
does not watch `looknfeel.lua` for changes. Run `omarchy restart shell` after changing
the radius; reloading Hyprland alone can leave shell surfaces square. Fullscreen
windows and any explicit per-window rules may override global decorations.

## Terminal, dictation and shell defaults

Ghostty explicitly starts `/usr/bin/zsh -l`. The account login shell is also Zsh;
the live systemd user-manager and compositor environments were updated after the
old desktop retained `SHELL=/bin/bash`. `.zshrc` exports the matching `SHELL` value.
A newly opened Ghostty window was inspected and confirmed to launch Zsh.
Already-running Bash sessions can switch with `exec zsh -l`.

Ghostty's current font, theme integration, CSI-u Shift+Enter encodings and SSH
terminfo integration are recorded. Voxtype's current `base.en` model configuration
and user service are recorded; downloaded models are not included. System files,
including the existing `hid_apple fnmode=1` setting, are not deployed by these scripts.

## File layout and ongoing maintenance

- `files/`: user configuration, stored relative to the home directory.
- `configs.py`: explicit allowlist for capture/apply; excludes Git metadata and backups.
- `packages.txt`: core terminal packages.
- `packages-optional.txt`: optional tools requiring individual review.
- `install-terminal.sh`: core package install, Oh My Zsh checkout, terminal-only apply.
- `install-editor-git.sh`: AstroNvim and Git installation with editor-directory backup.
- `README.md`: this configuration record and change log.

After making a local change, update this document and capture it:

```bash
cd ~/dotfiles
./omarchy-mac/configs.py capture --dry-run
./omarchy-mac/configs.py capture
git diff -- omarchy-mac
```

Capture does not remove obsolete files from the profile; remove them deliberately
when retiring a configuration. Review captures before committing, especially if
adding credentials to an allowlisted file. Private `.env`, `.zshrc.local`, Atuin
history/login data, and the optional private `~/.gitconfig.user` are not captured.
The portable Git configuration itself is now included.

To restore this profile on an already-installed compatible Omarchy system:

```bash
cd ~/dotfiles
./omarchy-mac/configs.py apply --dry-run
systemctl --user stop omarchy-fcitx5.service
./omarchy-mac/configs.py apply
systemctl --user start omarchy-fcitx5.service
hyprctl reload
hyprctl configerrors
omarchy restart shell
# If tmux is running, reload its configuration there:
tmux source-file ~/.config/tmux/tmux.conf
systemctl --user daemon-reload
systemctl --user restart voxtype
```

Apply symlinks `~/.zshrc` to `~/dotfiles/omarchy-mac/files/.zshrc`; edit that
repository file for future shell changes. Other configuration is copied. Neovim is restored as a complete directory, with
a backup of the previous directory, to avoid mixing distributions or stale plugins. Existing relative symlinks
inside the profile (notably Neovim's dynamic Omarchy theme) remain symlinks. It backs up existing destinations
under `~/.local/state/dotfiles/backups/<timestamp>/`, retaining relative paths.
Restore desired files from that directory to undo a change; files newly created by
apply have no previous version. No commits or pushes are performed by these scripts.
A full apply is a personal profile restore: inspect its dry run before using it on
another machine, especially the captured monitor and input baseline.

## Change log

### 2026-09-22

1. Added Fn hold-to-talk Voxtype bindings; existing service was already running.
2. Replaced Command-number desktop shortcuts with Option-number shortcuts.
3. Cloned `carlosbaraza/dotfiles`; moved checkout to `~/dotfiles` at the user's request.
4. Added AeroSpace directional navigation, letter desktops, previous-desktop switch,
   fullscreen, horizontal resize, and active-split equalization. Corrected Option+0
   from desktop 10 to split equalization. Moves to desktops no longer follow windows.
5. Adapted personal tmux keybindings, clipboard copying, and detach helper. Corrected
   missing whitespace before separators in the old window-swap bindings.
6. Created occupied-only bar plugin. Restarted shell and visually verified result
   after the first hot reload retained the old widget.
7. Created this profile, config snapshots, package lists, apply/capture tools and
   adapted Zsh/Atuin configuration. Shell installation status is recorded below.

8. Symlinked `~/.zshrc` to `~/dotfiles/omarchy-mac/files/.zshrc`, backing up the
   previous regular file. Updated apply to create the link and capture to avoid
   replacing the repository source with a self-referential symlink.
9. Changed keyboard layout from English (US) to English (UK) in Hyprland and Fcitx;
   verified the physical and virtual keyboards after reload. Added Fcitx profile
   to the tracked allowlist. Fcitx required a stop, profile restore, and restart
   because its cached US profile was rewritten on shutdown.

### Validation record

- Hyprland reloaded with no config errors; 31 desktop-switch and 31 move bindings loaded.
- Temporary terminals verified desktop switching, previous desktop, focus/movement,
  fullscreen, resizing, split equalization, and moving without following.
- Disposable tmux server verified parsing, Ctrl+A, navigation, Ctrl+numbers, clipboard,
  helper binding, reload binding, and actual pane switching.
- Occupied-only bar visually verified after a shell restart.
- Physical keyboard end-to-end tests remain for the user; Fn was not physically tested.
- AstroNvim plugin/tool and TypeScript attachment checks passed (see EDITOR-GIT.md).
- A new Ghostty process launched Zsh by default; UK Macintosh layout was verified
  on the physical keyboard, virtual keyboard and Fcitx input method.

### Shell installation status

Completed on 2026-09-22:

- Installed Zsh 5.9.2, Atuin 18.23.0, zsh-autosuggestions 0.7.1 and
  zsh-syntax-highlighting 0.8.0 from the configured ARM repositories.
- Cloned Oh My Zsh at `40bddc3c1a100feafccb01403f74c1d4e7380380` into `~/.oh-my-zsh`.
- Applied `.zshrc` and `.config/atuin/config.toml` from this profile.
- Changed the account login shell from `/bin/bash` to `/usr/bin/zsh`.
- A PTY-backed Zsh login verified `robbyrussell`, both plugins, Atuin Ctrl+R and Up
  widgets, Node v26.10.0 and Codex 0.155.1 through mise.
- Existing Bash processes continue running Bash. Open a new terminal, or run
  `exec zsh -l` in an existing one.
- Optional shell/runtime packages were not installed. Delta was subsequently installed
  and Git configured in the editor/Git migration below.
- Existing Bash history was not imported. To add it locally, run `atuin import bash`.
  Mac history requires the user's Atuin account or an explicit history export.
- Snapshot checks passed for dry-run, backups, repeated apply, relative symlinks,
  capture, and exclusion of private files. Final capture dry-run reported no drift.
- All repository changes are local; nothing has been committed or pushed.

### Further changes on 2026-09-22

10. Installed AstroNvim from `~/dotfiles/nvim`, adapted clipboard handling and
    installed Lua/TypeScript language tools. Configured personal Git identity,
    aliases, Delta and Neovim merge/diff tools; see EDITOR-GIT.md.
11. Corrected UK layout to **UK Macintosh** (`gb` + `mac`), including Fcitx's
    `keyboard-gb-mac`. Corrected stale session shell environment and explicitly
    configured Ghostty to start Zsh. Confirmed both in the running desktop.
12. Rounded Hyprland windows with 20 logical-pixel corners and rounding power 4.

13. Saved explicit personal Command+C / Command+V shortcuts in `hypr/bindings.lua`.
    These retain Omarchy's existing Universal copy/paste behavior: Ctrl+C/V in
    ordinary apps, Ctrl+Insert / Shift+Insert in terminals. The terminal variants
    trigger Ghostty's clipboard actions and avoid sending Ctrl+C as an interrupt.
    Explicit down/up events avoid leaving synthetic keys held. Select text with
    the mouse for terminal copying; inside Neovim, normal Vim yank operations also
    use the configured system clipboard. Ctrl+C remains available for interrupts.

14. Corrected stale shell rounding after screenshots showed square menu/power
    panels. Restarted the shell, then visually verified the rounded menu,
    battery panel, and a test notification. The installed shared Style component reads rounding at startup
    and on the no-gaps toggle, but does not watch arbitrary looknfeel changes.

15. Reduced inner gaps from 5 to 2 and outer gaps from 10 to 4 logical pixels.
    Reloaded Hyprland, checked for config errors, and refreshed shell spacing.

16. Added browser-aware Mac Command shortcuts in `hypr/bindings.lua` for
    Chromium and Google Chrome (stable/beta/unstable). Command is SUPER;
    Option is ALT. Supported shortcuts:

    | Command shortcut | Browser action |
    | --- | --- |
    | T / Shift+T | New tab / reopen closed tab |
    | W | Close current tab |
    | N / Shift+N | New window / incognito window |
    | L | Address bar |
    | R / Shift+R | Reload / reload without cache |
    | F / G | Find / next match |
    | A / Z / Shift+Z | Select all / undo / redo |
    | D / Shift+B | Bookmark page / toggle bookmarks bar |
    | Y / Shift+J | History / downloads |
    | Option+I / Option+J | Developer tools / JavaScript console |
    | 1–8 / 9 | Select numbered tab / last tab |
    | Option+Left / Option+Right | Previous / next tab |
    | [ or Left / ] or Right | Back / forward |
    | Minus / Equals or Plus / 0 | Zoom out / zoom in / reset zoom |

    Command+C/V retain the universal clipboard handling described above.
    Existing desktop actions on these chords are retained as explicit fallbacks
    outside Chrome: floating, close window, workspace layout, fullscreen,
    grouping, editor/browser launch, directional focus and resizing. Within
    Chrome, Option+H/J/K/L still focus windows and Option+Shift+Space toggles
    fullscreen. Command+Tab now cycles open windows across desktops (see the later update). This is a common browser
    shortcut set, not a complete macOS emulation (no application hide/minimize
    or Command-click remapping). Other browsers and Chrome web-app classes are
    not matched. Fallbacks reflect this machine's current Omarchy defaults and
    should be reviewed if those defaults are changed later.

    Source: [Google's Chrome keyboard shortcuts](https://support.google.com/chrome/answer/157179?hl=en).
    Validation: Hyprland reload returned no config errors. In an isolated temporary
    Chromium profile, invoked the configured callbacks and verified new tab,
    numbered tab selection, next/previous tab, close and reopen closed tab.
    Verified Command+T's nonbrowser floating fallback in a temporary terminal.
    Physical keyboard presses have not been tested. No browser profile changes
    or extensions were needed. Backup: `~/.local/state/dotfiles/backups/chrome-shortcuts-20260922-230454/`.

17. Audited macOS installer and AeroSpace startup apps against the installed
    packages, desktop launchers and terminal commands. See [APPS.md](APPS.md) for
    missing applications, available replacements and original app/workspace mapping.
    Inventory only; no apps installed during this audit.

18. Installed Slack as a standalone Chromium web app using `omarchy webapp install`.
    Saved its desktop launcher and icon in the capture/apply allowlist. Open Slack
    from the app menu and sign in. See [APPS.md](APPS.md) for ARM compatibility
    details and the repeatable installation command. No Slack credentials captured.

19. Fixed Slack's native-app redirect on launch by replacing the generic URL with
    the direct workspace/channel client URL in Slack.desktop. Validated the desktop
    entry and launched it; the signed-in general channel opened in a standalone
    Chromium app window. Captured the corrected launcher in this profile.

20. Documented the requested Slack dark appearance and manual setup steps in
    [APPS.md](APPS.md#dark-appearance-manual-preference). This preference has not
    been applied or verified by the agent. Slack installation, direct workspace
    launcher, icon, and redirect fix remain recorded in the same profile.

19. Installed GNOME Calendar with the standalone GNOME Online Accounts GTK
    frontend for two Google Calendar accounts. Package list:
    `packages-calendar.txt`; setup and restoration: [APPS.md](APPS.md#gnome-calendar-2026-09-22).
    Google sign-in must be completed interactively for each account. Credentials
    and calendar data are excluded from dotfiles.

21. Checked Touch ID support (2026-09-22): Asahi's M2 feature matrix lists TouchID
    as TBA and the Secure Enclave Processor as WIP. Built-in fingerprint login is
    not currently available; installing fprintd alone cannot add the missing
    hardware support. No authentication settings changed. Recheck upstream before
    attempting enrollment: [M2 feature support](https://asahilinux.org/docs/platform/feature-support/m2/).

22. Reduced Chromium interface scaling with
    `--force-device-scale-factor=0.875` in `~/.config/chromium-flags.conf`.
    On this installed Wayland build the flag multiplies the output's 2x scale:
    verified in separate temporary browser profiles that multiplier 1 produces
    devicePixelRatio 2, and 0.875 produces 1.75 (12.5% smaller). This affects
    browser tabs/toolbars/menus and pages, including Chromium web apps such as
    Slack. Monitor scale remains 2; page-specific zoom remains independent.
    Added the flags file to capture/apply for restoration. Backed up the previous
    file under `~/.local/state/dotfiles/backups/chrome-scale-*`.
    The existing browser session has not been restarted: fully exit Chromium
    and its web apps, then reopen to apply. Saving the flag alone does not change
    an already-running browser. Remove this flag and restart to restore default
    sizing. This multiplier also follows the scale of other monitors.

23. Updated Chromium to effective **150%** at the user's request, superseding
    step 22's 175%. Set `--force-device-scale-factor=0.75`; verified effective
    devicePixelRatio 1.5 in a separate temporary Wayland Chromium profile on the
    200% display. Applies to all Chromium windows and its web apps, not individually
    to each window. Full browser/web-app exit and relaunch is required for the
    existing session; no user browser processes were terminated. Backed up the
    previous flag and captured the updated file. Other apps retain their scaling.

24. Resolved the apparent Chromium scaling non-application: Slack's standalone
    window shared the original Chromium process, which had started without the
    scaling flag. Closing browser windows alone did not restart it. Once that
    process exited, reopened Chromium and Slack. Independently verified a fresh
    test profile using only the saved flags file (no command-line scaling override)
    reported devicePixelRatio 1.5. User confirmed the size is now working.

25. Set desktop-wide scaling to **175%**, superseding Chromium-only scaling.
    `hypr/monitors.lua` now sets the catch-all monitor scale to 1.75, with
    `debug.disable_scale_checks=true` because 3456x2234 does not divide into whole
    logical pixels at that scale. Enabled compositor scaling for XWayland
    (`force_zero_scaling=false`) and set GDK_SCALE=1 to avoid double scaling;
    updated the user service environment too. Legacy apps may look softer with
    fractional compositor scaling and must restart to pick up the GTK setting.
    Removed Chromium's device-scale override; all Chromium/Slack processes must
    exit before reopening to discard any old command-line override. Verified
    monitor scale 1.75, Lua syntax, and no Hyprland configuration errors.
    Reverted the attempted image-aware Command+V callback: synchronously querying
    the Wayland clipboard from inside the compositor can block it. Restored the
    previous text-paste binding. Image-paste repair remains pending; no crash
    root-cause/core-dump investigation was performed. Backups are under
    `~/.local/state/dotfiles/backups/desktop-scale-175-20260922-234717/`.

26. Ghostty still appeared at 200% after the desktop scale change. Opened a
    separate Ghostty instance with `env GDK_SCALE=1 ghostty --gtk-single-instance=false`
    to avoid reusing the existing process's old environment. Existing terminals
    were left running. New windows created by the old Ghostty process can retain
    its inherited scaling; fully restarting Ghostty or logging out/in is needed
    to replace that environment. Visual confirmation of the new instance remains
    pending. Ghostty's configured font size remains 9.

27. Increased Ghostty's configured font from 9pt to **11pt** after clarification
    that the desired change was larger terminal text. Desktop scale stays at 175%.
    Backed up the config, passed `ghostty +validate-config`, and reloaded running
    terminals with `omarchy restart terminal` (no terminal sessions closed).

28. Shortened the top bar from 43 to **37 logical pixels** at 175% scale,
    matching the packaged BarModel calibration of 64 physical notch rows for
    the 3456x2234 MacBook Pro panel (ceil(64/1.75)=37). Added machine-level
    `~/.config/omarchy/shell.toml` with `[bar] notch-height=37`,
    `size-horizontal=37`, and `scale-with-font=false`. Hot reload applied it;
    verified the monitor's top reserved area is 37 and scale remains 1.75.
    Added the override to capture/apply. Recalibrate notch-height if display
    scaling changes later. This machine-wide override also affects other bars
    if external monitors are connected.

29. Moved `omarchy.clock` to the final position in the bar's right section and
    changed its primary format to `ddd d HH:mm` (for example `Tue 22 23:55`).
    Preserved alternate date format. Backed up shell.json, validated JSON, and
    confirmed the live clock is the rightmost visible widget with height 37px.

20. Command+Tab / Command+Shift+Tab now cycle forward/backward through mapped,
    focusable windows across all normal desktops, in stable creation order.
    Replaces Omarchy's next/previous desktop bindings, which visited persistent
    empty desktops. Empty desktops and hidden/special-workspace windows are skipped.
    Option+number/letter and Option+Tab retain their desktop navigation behavior.
    This switches individual windows without a visual picker or macOS app grouping.
    Validation: reload/configerrors clean; executed both configured callbacks and
    verified switching from a terminal on desktop 1 to Slack on S and back.
    Physical keypresses remain for user verification. Backup:
    `~/.local/state/dotfiles/backups/cmd-tab-20260923-000351/bindings.lua`.

21. Replaced the basic Command+Tab window cycle with a personal Quickshell
    app switcher in `~/.config/quickshell/mac-switcher/shell.qml`. Hold Command
    and press Tab to show a rounded, centred icon strip. Tab advances, Shift+Tab
    reverses, releasing either Command key commits. Command+Escape or right-click
    cancels; clicking an icon selects it. A quick tap returns to the previously
    used app. Applications are grouped by Hyprland class, using their most recently
    focused window; ordering comes from `focusHistoryID` and is frozen while open.
    Hidden/special-workspace windows are excluded. This is app switching, replacing
    entry 20's creation-order window switching. Class grouping may separate browser
    web apps or apps with unusual window classes. No screenshot previews are taken.
    Uses installed Quickshell; no extra packages. Hyprland autostart starts a separate
    `mac-switcher` instance. Start manually after restoring into an active session:
    `quickshell -c mac-switcher --no-duplicate --daemonize`.
    Captured QML, bindings and autostart in this profile. Styling is currently a
    fixed Catppuccin-style dark palette with 24px rounded corners.
    Validation: visual screenshot verified app icons and selected highlight; IPC
    checks passed for MRU toggle/back, reverse cycling, cancel and quick-release
    commit; Hyprland reload has no errors. Physical key release remains for user
    verification. Backup: `~/.local/state/dotfiles/backups/app-switcher-20260923-000829/`.

22. Fixed Command-release handling for the app switcher: release bindings now
    set `transparent = true` so Hyprland does not shadow them when Tab triggers
    another binding while Command is held. Retained non-consuming and ignore-mods
    flags for both Command keys. Hyprland 0.56.2 KeybindManager::shadowKeybinds
    explicitly exempts transparent bindings. Reload/configerrors clean.
    Attempted wtype input simulation did not trigger the switcher at all in this
    session, so it cannot validate physical release; user keypress verification
    is still required. Earlier IPC tests verified the commit action itself.

23. Switcher now lists every eligible window separately, including multiple
    Ghostty or browser windows, instead of grouping by application class. Each
    card shows the application icon/name, window title and desktop label. Cards
    are 156px wide; the strip scrolls when necessary. Most-recently-used ordering
    and Command-release selection remain; a quick tap returns to the previous
    window (which may belong to the same app). Verified all five current eligible
    windows appear, including both Ghostty windows; Quickshell reload is clean.

24. Redesigned the switcher as a 720px-wide vertical list: 32px app icons on
    the left, bold application names and window titles in the middle, and desktop
    badges on the right. Rows are 68px high; up to eight are visible before the
    list scrolls with selection. Preserved MRU order, individual windows, mouse
    selection and Command-key behavior. Visually verified all five current rows,
    labels, icons and selected highlight; Quickshell reload is clean.

25. Widened the switcher to 1200px (capped to screen width minus 48px).
    Maximum height now fills the screen minus 96px instead of an eight-row cap.
    Reduced outer padding to 8px, row height to 52px and icons to 28px. Window
    titles remain one line with ellipsis on overflow. Panel still shrinks to fit
    short lists. Quickshell reloaded and opened without QML errors.

26. Switcher now enters the dedicated `mac-switcher` Hyprland submap before
    opening. Normal shortcuts are inactive there; a catch-all consumes other keys
    instead of passing them to the underlying app. Hold Command and use Down/J
    for next, Up/K for previous; Tab/Shift+Tab also work. Release Command to select;
    Escape cancels and Enter selects. Command release is universal across submaps
    but its callback only acts in `mac-switcher`, handling the Command press that
    occurred before entering it. Transparent release handling is retained.
    Commit/cancel restore the default submap; mouse selection/cancellation, empty
    results, parse failures and overlay reload also release keyboard mode.
    Verified registered submap/catch-all, executed actual navigation and release
    callbacks, and checked Escape and overlay cancellation restore normal shortcuts.
    Hyprland and Quickshell load without errors; physical keypresses remain for
    user verification. Recovery if the overlay process unexpectedly dies while
    open: Escape still resets the submap. Backup:
    `~/.local/state/dotfiles/backups/switcher-modal-20260923-014235/`.

27. While the switcher is open, Command+W sends a normal window-close request
    to the highlighted window address, without changing focus or exiting the
    switcher. No auto-repeat, forced termination or synthetic browser-tab shortcut.
    The list refreshes every 250ms while open and removes only windows actually
    closed, preserving the selection or selecting the next remaining row.
    Applications can still show save confirmations; release Command to interact
    with one. Closing the final listed window cancels the switcher and resets
    the keyboard mode. Outside the switcher, existing Command+W behavior remains.
    Tested on a disposable foot window: only the highlighted test window closed,
    its row disappeared, other windows remained and the switcher stayed open.
    Hyprland configerrors and Quickshell reload checks passed.
