#!/usr/bin/env python3
"""Capture or deploy this profile's allowlisted user configuration, with backups."""
import argparse
from datetime import datetime
from pathlib import Path
import shutil
import os

PROFILE = Path(__file__).resolve().parent
HOME_DIR = Path.home()
SINGLE_FILES = [
    '.config/omarchy/shell.toml',
    '.config/chromium-flags.conf',
    '.local/share/applications/Slack.desktop',
    '.local/share/icons/hicolor/256x256/apps/slack.png',
    '.zshrc', '.config/atuin/config.toml', '.config/fcitx5/profile',
    '.config/hypr/hyprland.lua', '.config/hypr/bindings.lua',
    '.config/hypr/input.lua', '.config/hypr/monitors.lua',
    '.config/hypr/looknfeel.lua', '.config/hypr/autostart.lua',
    '.config/hypr/hyprsunset.conf', '.config/hypr/xdph.conf',
    '.config/omarchy/shell.json', '.config/ghostty/config',
    '.config/tmux/tmux.conf', '.local/bin/tmux-detach-window',
    '.config/voxtype/config.toml', '.config/systemd/user/voxtype.service',
    '.config/mise/config.toml', '.config/git/config', '.config/git/ignore',
]
DIRECTORIES = ['.config/quickshell/mac-switcher', '.config/omarchy/plugins/carlosbaraza.workspaces', '.config/nvim']
TERMINAL_FILES = {'.zshrc', '.config/atuin/config.toml'}


def excluded(path):
    return '.git' in path.parts or '.bak.' in path.name or path.name.endswith(('~', '.swp'))


def allowed(relative):
    return str(relative) in SINGLE_FILES or any(relative.is_relative_to(d) for d in DIRECTORIES)


def sources(base, scope):
    if scope == 'terminal':
        return [base / p for p in sorted(TERMINAL_FILES) if (base / p).is_file() or (base / p).is_symlink()]
    single_files = ['.config/git/config', '.config/git/ignore'] if scope == 'editor-git' else SINGLE_FILES
    directories = ['.config/nvim'] if scope == 'editor-git' else DIRECTORIES
    found = [base / p for p in single_files if (base / p).is_file() or (base / p).is_symlink()]
    for directory in directories:
        found.extend(p for p in (base / directory).rglob('*') if (p.is_file() or p.is_symlink()) and not excluded(p.relative_to(base)))
    return sorted(found)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=['capture', 'apply'])
    parser.add_argument('--scope', choices=['all', 'terminal', 'editor-git'], default='all')
    parser.add_argument('--dry-run', action='store_true')
    args = parser.parse_args()
    source = HOME_DIR if args.action == 'capture' else PROFILE / 'files'
    dest = PROFILE / 'files' if args.action == 'capture' else HOME_DIR
    backup = HOME_DIR / '.local/state/dotfiles/backups' / datetime.now().strftime('%Y%m%d-%H%M%S-%f')
    count = 0
    # An editor distribution must be replaced as a directory, not merged with
    # stale plugin files from the previous distribution.
    replace_editor = args.action == 'apply' and args.scope != 'terminal'
    if replace_editor:
        incoming = source / '.config/nvim'
        installed = dest / '.config/nvim'
        def tree_signature(directory):
            result = {}
            for item in directory.rglob('*'):
                if item.is_symlink():
                    result[str(item.relative_to(directory))] = ('link', str(item.readlink()))
                elif item.is_file():
                    result[str(item.relative_to(directory))] = ('file', item.read_bytes())
            return result
        if incoming.is_dir() and (installed.is_symlink() or not installed.is_dir() or tree_signature(incoming) != tree_signature(installed)):
            print('apply: .config/nvim (replace editor directory with backup)')
            count += 1
            if not args.dry_run:
                if installed.exists() or installed.is_symlink():
                    saved = backup / '.config/nvim'
                    saved.parent.mkdir(parents=True, exist_ok=True)
                    shutil.move(str(installed), str(saved))
                installed.parent.mkdir(parents=True, exist_ok=True)
                shutil.copytree(incoming, installed, symlinks=True)
    for path in sources(source, args.scope):
        relative = path.relative_to(source)
        assert allowed(relative), relative
        if replace_editor and relative.is_relative_to('.config/nvim'):
            continue
        target = dest / relative
        # ~/.zshrc is managed directly in the checkout, unlike copied snapshots.
        link_zshrc = args.action == 'apply' and str(relative) == '.zshrc'
        if path.resolve() == target.resolve():
            continue
        if not link_zshrc and path.is_symlink() and target.is_symlink() and path.readlink() == target.readlink():
            continue
        if not link_zshrc and not path.is_symlink() and not target.is_symlink() and target.is_file() and path.read_bytes() == target.read_bytes():
            continue
        print(f'{args.action}: {relative}')
        count += 1
        if args.dry_run:
            continue
        if args.action == 'apply' and (target.exists() or target.is_symlink()):
            saved = backup / relative
            saved.parent.mkdir(parents=True, exist_ok=True)
            if target.is_symlink():
                saved.symlink_to(target.readlink())
                target.unlink()
            else:
                shutil.copy2(target, saved)
        target.parent.mkdir(parents=True, exist_ok=True)
        if target.is_symlink() or (path.is_symlink() and target.exists()):
            target.unlink()
        if link_zshrc:
            if target.exists():
                target.unlink()
            target.symlink_to(os.path.relpath(path, target.parent))
        else:
            shutil.copy2(path, target, follow_symlinks=(str(relative) == '.zshrc'))
    print(f'{count} file(s) {"would change" if args.dry_run else "changed"}.')
    if args.action == 'apply' and backup.exists():
        print(f'Previous files: {backup}')


if __name__ == '__main__':
    main()
