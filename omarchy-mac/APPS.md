# Mac application inventory and Omarchy comparison

Audited 2026-09-22 using `../osx/setup.sh`, `../aerospace/startup.sh`, the
installed pacman package list, application desktop entries, `/opt`, and commands
visible in a Zsh login shell. A script listing an app is evidence of intended
setup, not proof of current use on the Mac. Installed does not mean signed in,
configured, or functionally tested. Missing means not found in these locations;
browser bookmarks and remote services were not audited.

## Apps explicitly opened at Mac login

| App | Mac workspace | This machine |
| --- | --- | --- |
| Google Chrome | D | Chromium installed; Mac-style shortcuts configured |
| Home Assistant | G | Browser available; no dedicated launcher/workspace automation found |
| Claude Desktop | R | Desktop app missing; Claude Code CLI installed |
| Linear | F | Missing dedicated app/launcher |
| Telegram | A | Missing |
| WhatsApp | W | Chromium web-app launcher installed |
| Signal | W | Missing |
| Apple Calendar | C | GNOME Calendar installed; two Google account sign-ins pending |
| Obsidian | V | Installed AppImage |
| 1Password | P | Installed executable under /opt/1Password, plus launcher |
| Slack | S | Installed as a Chromium web app; signed in and direct channel launch verified |
| Ghostty + tmux | E | Installed and configured |

Letter desktops exist, but this Mac startup app placement sequence has not been
ported. App presence alone does not reproduce the startup workflow.

## Other apps listed in the macOS installer

| App | This machine |
| --- | --- |
| Warp | Missing; Ghostty is available |
| Visual Studio Code | Missing; AstroNvim is configured |
| Firefox | Missing; Chromium is available |
| Spotify | Missing; cliamp is installed, not evidence of Spotify account support |
| VLC | Missing; mpv installed |
| Docker Desktop | Not installed; Docker Engine, Compose, Buildx and lazydocker installed |
| Google Cloud SDK | gcloud not found |
| Google Drive | No dedicated desktop sync client found |
| LM Studio | No desktop app or lms CLI found |
| Wispr Flow | Voxtype installed/configured as dictation replacement |
| CleanShot | Omarchy screenshot/recording tools installed |
| Alfred | Omarchy launcher/menu covers app launching, not all Alfred workflows |
| Rectangle / AeroSpace / Borders | Hyprland provides window management and borders |
| iStat Menus | Omarchy bar and btop cover basic status/monitoring |
| Thaw | No equivalent configured; Omarchy has its own bar |
| The Unarchiver | No same app; archive tools and Nautilus available |

Git config also contains old Sourcetree/Apple opendiff and other Mac diff-tool
paths. These are historical references, not installer/startup evidence of current
use; the Linux Git profile uses Delta and Neovim.

## Terminal tools

Already installed/configured: Zsh, Oh My Zsh, autosuggestions, syntax highlighting,
Atuin, tmux, Neovim/AstroNvim, Git/Delta, fd, eza, ripgrep, bat, fzf, zoxide.
Claude Code and Codex are available. mise currently manages Node.

Not found from the macOS installer: Go, Rust/Cargo, wget, cmake, dust, duf, sd,
pdfgrep, ag (the_silver_searcher), fnm and pyenv. fnm/pyenv are optional alongside
mise; replacing a version manager is not required merely to match package names.
The shell also references optional rga (ripgrep-all), which is missing.

## Follow-up candidates

The startup script suggests prioritizing Slack, Linear, Telegram, Signal, a
calendar workflow and Claude desktop/web access, then their workspace placements.
No applications were installed during this audit.

Linear officially directs Linux users to its [web app](https://linear.app/docs/get-the-app).
Slack's [system requirements](https://slack.com/help/articles/115002037526-System-requirements-for-using-Slack)
cover supported browser and desktop platforms. Verify Linux ARM64 compatibility
for each proposed native package before choosing an installation method on this M2.

## Slack installation (2026-09-22)

Installed with the supported Omarchy web-app mechanism:

```sh
omarchy webapp install Slack https://app.slack.com/client/TE0KN4258/CE0EM6L04 https://a.slack-edge.com/9cc0056/img/icons/favicon-32.png
```

The official Linux download inspected was
`slack-desktop-4.52.155-amd64.deb` (x86-64), and the configured ARM repositories
had no Slack desktop package. This installation is a standalone Chromium window,
not the native Slack desktop client. Find Slack in the app launcher. Uses the
existing browser profile; credentials are not included in dotfiles. Sign in and
allow notifications when prompted. Desktop entry and icon are captured by
`configs.py`; restoring this profile restores the launcher. Desktop entry
validation passed (only a redundant Comment warning); confirmed that a Slack web-app window opened.
Workspace S remains available, but automatic placement was not added.

[Official Linux download](https://slack.com/downloads/linux).

### Direct workspace launch fix

The generic `https://app.slack.com/` landing page prompted native-app redirects
after login. Changed Slack.desktop to open the user-supplied browser client URL
`https://app.slack.com/client/TE0KN4258/CE0EM6L04` directly. Launched via
`gtk-launch Slack` and confirmed a standalone app-class window with the signed-in
general channel title. Desktop entry validation passed. Existing landing-page
windows are not closed automatically. The saved team/channel IDs identify the
launch destination; no authentication tokens or cookies are saved.

### Dark appearance (manual preference)

Desired appearance: dark mode. This was requested and instructions were provided;
the setting has not been applied or visually verified by the agent.

1. Open Slack from the app launcher.
2. Click your profile picture, then **Preferences → Appearance**.
3. Select **Dark**. If syncing with the OS prevents choosing it, disable that sync
   option first.

This is a Slack preference, not a setting in the desktop launcher. Restoring the
tracked launcher does not set Slack's appearance; check it after signing in on a
new installation. Browser cookies, sessions and Slack credentials are not captured.

Reference: [Slack's dark-mode instructions](https://slack.com/help/articles/360019434914-Use-dark-mode-in-Slack).

## GNOME Calendar (2026-09-22)

Installed native ARM64 packages `gnome-calendar` and
`gnome-online-accounts-gtk`. The latter provides standalone account setup on
Hyprland without installing the full GNOME control center/desktop. Dependencies
include GNOME Online Accounts and Evolution Data Server for calendar sync.

Reinstall in a terminal:

```sh
omarchy pkg add gnome-calendar gnome-online-accounts-gtk
```

Open **Online Accounts** (`gnome-online-accounts-gtk`), add **Google**, and sign
in to each of the two accounts separately. Enable Calendars for each account;
other services can be disabled if unwanted. Open **Calendar** (`gnome-calendar`)
and select the calendars to display. When creating events, select the intended
account/calendar. Account sign-in and live Google sync still need user completion.

Accounts, OAuth tokens and calendar data are private runtime state and are not
captured in dotfiles. `packages-calendar.txt` records the repeatable package set.
No automatic workspace placement or login startup was configured.

## Interface size (current)

The desktop now uses 175% scaling. Chromium's separate scaling flag has been
removed so the browser and Slack follow the display. Fully exit Chromium and
its web apps, then reopen to discard an old scaling flag in a running process.
GTK/XWayland apps may also need restarting; compositor scaling now covers legacy
apps, with GDK_SCALE=1 to avoid double scaling. Monitor scale 1.75 and a clean
Hyprland configuration were verified. The earlier Chromium-only 150% setting
is superseded; its history remains in README.md.
