# Changelog

## 2025-11-05 - Fish Shell Configuration Fixes

### Fixed
- **Fixed fish shell startup errors** caused by incorrect PATH configuration
  - Removed `/usr/bin/python3` from PATH (was adding a file instead of directory)
  - Commented out pyenv initialization (not installed)
  - Commented out rbenv paths and initialization (not installed)
  - Made `.private-env-vars-gitignored.fish` source conditional to prevent errors when file doesn't exist

### Added
- **Restored missing fish abbreviations** by adding them directly to `config.fish`
  - Git abbreviations: `gs`, `gb`, `gc`, `gch`, `gd`, `gdc`, `gca`, `gpu`, `grb`, `gsp`, `gst`, and more
  - Development abbreviations: `ef`, `nv`, `ns`, `rgf`, `rgs`, `rga`, `fbat`, `rbat`, `cr`
  - System abbreviations: `kp`, `pk`, `rmf`, `dp`

### Changed
- Removed duplicate `gs` abbreviation in `config.setup.fish` (was mapped to both nvim config and git status)
- Fish shell now starts cleanly without errors
- System Python 3.9.6 remains available via default PATH

### Technical Details
- Lines modified in `config.fish`: 103-107, 116-119, 131-133, 174-212, 374, 401-402
- Lines modified in `config.setup.fish`: 35-36
- All changes maintain backward compatibility while removing dependencies on uninstalled tools
