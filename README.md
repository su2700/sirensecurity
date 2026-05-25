# SIREN Security - Linux Reconnaissance & Audit Tool

A comprehensive, well-structured Linux privilege escalation and system reconnaissance toolset designed for security professionals and penetration testers.

## 🚀 Version 2.0 (Stable)
The project has been expanded to support multiple environments and legacy systems.

### 📦 Available Versions
1.  **`sirensecurity.sh`**: The primary Bash (4.0+) version. Modular, clean, and highly portable.
2.  **`sirensecurity.py`**: Modern Python 3 version. Offers robust error handling and is easier to extend for automated reporting (JSON/CSV).
3.  **`sirensecurity-py2.py`**: Legacy Python 2 version. Designed for older Linux environments (RHEL 6/7, legacy Debian) where Python 3 is unavailable.

### Key Improvements in v2.0
- **Multi-Platform Support:** Choice of Bash, Python 3, or Python 2 depending on the target environment.
- **Modular Architecture:** 16 separate security domains encapsulated in functions/methods.
- **Enhanced Reliability:** Improved error trapping and graceful command fallbacks.
- **Visual Clarity:** Full color-coded output and emoji-based visual anchoring.
- **ADHD-Friendly Design:** Progress tracking (e.g., "1 of 16") and a final "High-Interest Findings" summary.
- **Interactive Mode:** `--interactive` flag to pause between sections, preventing information overload.

## 🎯 16 Major Assessment Categories

1.  **System Information & Fingerprinting**: OS, Kernel, Architecture.
2.  **Current User & Privileges**: `id`, `whoami`, `groups`, `sudo -l`.
3.  **Environment & Configuration**: Env vars, Bash profiles, initialization files.
4.  **Running Processes & Services**: `ps`, `top`, root processes, capabilities.
5.  **Installed Software & Packages**: Compilers, package managers (`dpkg`/`rpm`), binary paths.
6.  **Network & Communications**: Interfaces, listening ports, connections, DNS, routing.
7.  **Scheduled Jobs & Cron**: User/System crontabs, cron directories, `at` jobs.
8.  **File Permissions & Security**: SUID/SGID, sticky bits, world-writable files.
9.  **File Systems & Mounts**: `mount`, `df`, `/etc/fstab`, NFS exports.
10. **Users & Accounts**: `/etc/passwd`, `/etc/shadow` (if readable), UID 0 check.
11. **Sensitive Files & Data**: SSH keys, command history (`.bash_history`), config files.
12. **Service Configuration Files**: Web servers (Apache/Nginx), Databases (MySQL/Postgres).
13. **Log Files & Directories**: `/var/log`, web logs, application directories.
14. **Credential Search**: PHP database configs, grep-based password hunting in `/etc`.
15. **File Transfer & Communication Tools**: `wget`, `curl`, `nc`, `socat`, `tcpdump`.
16. **Miscellaneous Checks**: Printers, user-owned files, orphaned files.

## 🧠 ADHD-Friendly Features
Designed to improve focus and manage information density:
- **Interactive Mode (`-i`)**: Pauses execution between sections.
- **Progress Tracking**: Real-time counters (e.g., `(1/16)`) on every header.
- **Visual Anchoring**: High-contrast emojis (🛡️, 🔍, 🔑, 🔓, 📜) act as landmarks.
- **Summary of Interest**: A dedicated findings summary at the end.

## 🛠️ Usage

### Bash Version (Primary)
```bash
chmod +x sirensecurity.sh
./sirensecurity.sh [options]
```

### Python 3 Version (Modern)
```bash
python3 sirensecurity.py [options]
```

### Python 2 Version (Legacy)
```bash
python2 sirensecurity-py2.py [options]
```

### Options (Supported by all versions)
- `-i`, `--interactive`: Enable pauses between sections.
- `-p <password>`, `--password <password>`: Provide a sudo password for checks.
- `-t <user>`, `--target <user>`: Specify target user for group checks.
- `-b <user>`, `--bob <user>`: Specify user for file ownership searches.

## 📋 Requirements
- **Bash**: 4.0+
- **Python 3**: Standard library (no external dependencies).
- **Python 2**: 2.7+
- **Privileges**: Running as `root` or with `sudo` provides the most comprehensive results.

## 🧪 Compatibility
Tested on:
- Ubuntu 18.04 - 24.04
- Debian 10/11/12
- CentOS/RHEL 6, 7, 8, 9
- Alpine Linux
- Arch Linux

## ⚖️ License
This tool is provided for authorized security testing and educational purposes only.

---
**Version**: 2.0  
**Last Updated**: May 2026  
**Maintainer**: SIREN Security
