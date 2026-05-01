# SIREN Security - Project Instructions

This project is a comprehensive Linux reconnaissance and audit tool designed for security professionals and penetration testers. It focuses on automated enumeration and privilege escalation discovery.

## Project Overview

- **Purpose**: Automated Linux system reconnaissance and privilege escalation assessment.
- **Main Technology**: Bash (4.0+)
- **Architecture**: Modular, function-based shell scripts.
- **Key Components**:
    - `sirensecurity.sh`: The primary assessment script (Version 2.0).
    - `sirensecurity_backup.sh`: An alternative or older version of the assessment script.
    - `CHANGELOG.md`: Detailed history of project evolution.

## 16 Major Assessment Categories

The tool performs deep enumeration across these domains:
1.  System Information & Fingerprinting
2.  Current User & Privileges
3.  Environment & Configuration
4.  Running Processes & Services
5.  Installed Software & Packages
6.  Network & Communications
7.  Scheduled Jobs & Cron
8.  File Permissions & Security
9.  File Systems & Mounts
10. Users & Accounts
11. Sensitive Files & Data
12. Service Configuration Files
13. Log Files & Important Directories
14. Credential Search (PHP, config files)
15. File Transfer & Communication Tools
16. Miscellaneous Checks (Printers, orphaned files)

## Running the Project

The scripts are intended to be run directly on a target Linux system.

```bash
# Basic usage
chmod +x sirensecurity.sh
./sirensecurity.sh

# With custom parameters
TARGET_USER=admin BOB_USER=www-data ./sirensecurity.sh

# With elevated privileges (recommended for full coverage)
sudo ./sirensecurity.sh
```

### Configuration via Environment Variables

- `TARGET_USER`: User to check for group membership (default: current user).
- `BOB_USER`: Username to search for file ownership (default: `bob`).
- `OUTPUT_DIR`: Directory to store output (default: current directory).

## Development Conventions

- **Modularity**: New checks should be added as distinct functions and called within the `main` execution loop.
- **Color Coding**:
    - `Blue`: Section headers
    - `Cyan`: Subsection headers
    - `Green`: Success indicators
- **Safety**:
    - Use `run_cmd` or `run_cmd_safe` wrappers to handle command execution and potential failures gracefully.
    - Avoid destructive commands; the tool is strictly for reconnaissance.
- **Portability**: Ensure commands work across different distributions (Ubuntu/Debian, RedHat/CentOS, Alpine). Use fallbacks (e.g., `netstat` vs `ss`).

## Testing Strategy

- **Verification**: Changes to the script should be tested on multiple Linux distributions to ensure compatibility.
- **Mocking**: For complex checks, ensure they handle missing tools gracefully (e.g., if `dpkg` is missing on a RedHat system).

## Documentation

- Maintain the `CHANGELOG.md` with every version update.
- Ensure `README.md` reflects the current features and usage instructions.
