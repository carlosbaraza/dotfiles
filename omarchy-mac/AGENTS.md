# Maintaining this profile

- Keep README.md up to date with every configuration change, its purpose, shortcuts,
  validation performed, known differences from macOS, and installation status.
- The live checkout is ~/dotfiles. Use the Omarchy skill for live desktop/terminal edits.
- Edit user configuration, never /usr/share/omarchy.
- After an authorized live change, run configs.py capture --dry-run, review the scope,
  then capture the allowlisted configuration. Review git diff before committing.
- Preserve Omarchy theme symlinks. Exclude credentials, private environment files,
  shell history databases, and backup files from the repository.
- Keep the original macOS, Debian, AeroSpace and AstroNvim profiles separate.
- Optional runtime packages and monitor assignments remain separate choices.
  AstroNvim and the personal Git profile are now explicitly authorized and active.
- Record physical keypress tests separately from configuration/dispatcher tests.
