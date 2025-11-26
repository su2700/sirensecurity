# SIREN Security - Linux Reconnaissance & Audit Tool

A comprehensive, well-structured Linux privilege escalation and system reconnaissance script designed for security professionals and penetration testers.

## Overview

This script provides automated enumeration of Linux systems with a focus on:
- System fingerprinting and OS detection
- Privilege escalation vectors
- Sensitive file discovery
- Network configuration analysis
- Service vulnerability assessment
- Credential harvesting opportunities

## Features

### 🎯 16 Major Assessment Categories

1. **System Information & Fingerprinting**
   - OS detection and version identification
   - Kernel version and architecture
   - System release information

2. **Current User & Privileges**
   - User identification
   - Group membership
   - sudo capabilities
   - sudoers file analysis

3. **Environment & Configuration**
   - Environment variables
   - Shell profiles and initialization files
   - System-wide and user-specific configurations

4. **Running Processes & Services**
   - Active process listing
   - Root-owned processes
   - Service startup status
   - File capabilities analysis

5. **Installed Software & Packages**
   - Development tools (compilers, interpreters)
   - Package manager enumeration
   - Package cache inspection
   - Binary directory analysis

6. **Network & Communications**
   - Network interface configuration
   - Active connections and listeners
   - DNS configuration
   - Routing table and ARP cache
   - Service management tools

7. **Scheduled Jobs & Cron**
   - User and system crontabs
   - Cron job directories (/etc/cron.d, .daily, .weekly, etc.)
   - At daemon configuration
   - Cron access controls

8. **File Permissions & Security**
   - SUID binary detection
   - SGID binary identification
   - Sticky bit analysis
   - World-writable directory discovery
   - Permission vulnerability detection

9. **File Systems & Mounts**
   - Current mount status
   - Filesystem table analysis (/etc/fstab)
   - NFS export configuration
   - Disk usage information

10. **Users & Accounts**
    - User and group enumeration
    - Shadow file analysis
    - UID 0 privilege detection
    - Login history and sessions

11. **Sensitive Files & Data**
    - SSH key discovery and analysis
    - SSH configuration files
    - Command history files
    - Shell profiles and initialization

12. **Service Configuration Files**
    - Web server configurations
    - Database configurations
    - System service configs
    - Samba and other service configs

13. **Log Files & Directories**
    - System log directory analysis
    - Web server log locations
    - Important application directories

14. **Credential Search**
    - PHP credential pattern matching
    - Configuration file credential scanning
    - Database password discovery

15. **File Transfer & Communication Tools**
    - Available transfer utilities (wget, curl, ftp, scp, etc.)
    - Network tools (nc, netcat, socat, ssh, telnet)
    - Packet capture tools (tcpdump, wireshark)

16. **Miscellaneous Checks**
    - Printer detection
    - User-owned file discovery
    - Orphaned file detection

## Usage

### Basic Usage
```bash
chmod +x sirensecurity.sh
./sirensecurity.sh
```

### With Custom Parameters
```bash
# Specify a different target user
TARGET_USER=admin ./sirensecurity.sh

# Search for files owned by a specific user
BOB_USER=www-data ./sirensecurity.sh

# Combine parameters
TARGET_USER=admin BOB_USER=www-data ./sirensecurity.sh
```

### With Elevated Privileges
```bash
# Run with sudo for more comprehensive results
sudo ./sirensecurity.sh

# With custom user
sudo TARGET_USER=admin ./sirensecurity.sh
```

## Environment Variables

- **TARGET_USER**: User to check for group membership (default: current user)
- **BOB_USER**: Username to search for file ownership (default: bob)
- **OUTPUT_DIR**: Directory to store output (default: current directory)

## Output Structure

The script produces organized output divided into 16 clear sections:

```
1. System Information & Fingerprinting
2. Current User & Privileges
3. Environment & Configuration
4. Running Processes & Services
5. Installed Software & Packages
6. Network & Communications
7. Scheduled Jobs & Cron
8. File Permissions & Security
9. File Systems & Mounts
10. Users & Accounts
11. Sensitive Files & Data
12. Service Configuration Files
13. Log Files & Important Directories
14. Credential Search
15. File Transfer & Communication Tools
16. Miscellaneous Checks
```

## Key Improvements Over Previous Versions

### Code Organization
- ✅ Modular function-based structure
- ✅ Clear section headers and subsections
- ✅ Consistent command execution patterns
- ✅ Error handling and fallback options

### User Experience
- ✅ Color-coded output for readability
- ✅ Logical grouping of related checks
- ✅ Clear progress indicators
- ✅ Start and end timestamps
- ✅ Success/failure feedback

### Coverage
- ✅ 16 comprehensive security domains
- ✅ Multiple command alternatives (netstat vs ss)
- ✅ Fallback options for missing tools
- ✅ Both Debian and RedHat package managers
- ✅ Modern systemd and legacy init systems

## Privilege Escalation Focus Areas

The script particularly focuses on discovering:

- **Privilege Escalation Vectors**
  - SUID/SGID binaries
  - Weak file permissions
  - World-writable directories
  - Capabilities and ACLs

- **Persistence Opportunities**
  - Cron job manipulation
  - Authorized_keys modification
  - Service hijacking possibilities

- **Exploitation Paths**
  - Vulnerable service versions
  - Unpatched kernel exploits
  - Misconfigured services
  - Insufficient access controls

## Example Output Sections

Each section follows this pattern:

```
================================================================
>>> Section Title
================================================================

[*] Subsection Title
----------------------------------------------------------------
command output here
```

Color-coded for easy visual scanning:
- **Blue**: Section headers
- **Cyan**: Subsection headers
- **Green**: Success indicators
- **Default**: Command output

## Requirements

- Bash shell (4.0+)
- Standard Linux utilities (cat, ls, grep, find, etc.)
- Optional: sudo access for comprehensive enumeration
- Optional: Additional tools (netstat/ss, iptables, getcap, etc.)

## Compatibility

Tested on:
- Ubuntu/Debian-based systems
- RedHat/CentOS/Fedora systems
- Alpine Linux
- Other UNIX-like systems

## Performance Notes

- First run may take 5-10 minutes depending on system size
- The recursive `/` searches are most time-consuming
- Consider running with appropriate find command limits in production environments
- Some operations require elevated privileges

## Security Considerations

- This script performs extensive system scanning
- Store output securely - it contains sensitive information
- Do not run untrusted versions of this script
- Some commands may impact system performance
- Review output for personally identifiable information before sharing

## Additional Resources

### Process Monitoring
For real-time process monitoring, use pspy:
```bash
cd /tmp
wget https://github.com/DominicBreuker/pspy/releases/download/v1.2.0/pspy64
chmod +x pspy64
./pspy64 -pf -i 1000
```

### Post-Exploitation Tools
- GTFOBins: https://gtfobins.github.io/
- LOLBAS: https://lolbas-project.github.io/ (for Windows)
- ExploitDB: https://www.exploit-db.com/

## License

This tool is provided for authorized security testing and educational purposes only.

## Support

For issues, improvements, or feature requests, please review the script structure and test modifications in a safe environment.

---

**Version**: 2.0  
**Last Updated**: November 2025  
**Maintainer**: SIREN Security
