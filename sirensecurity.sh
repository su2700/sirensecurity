#!/bin/bash
# SIREN Security - Linux Reconnaissance & Audit Tool
# Version: 2.0
# Description: Comprehensive Linux enumeration and privilege escalation discovery script.

set -o errexit
trap 'echo "[ERROR] An error occurred at line $LINENO"' ERR

# Configuration
TARGET_USER="${TARGET_USER:-$USER}"
BOB_USER="${BOB_USER:-bob}"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_DIR="${OUTPUT_DIR:-.}"

# Color codes
COLOR_SECTION="\033[1;34m"    # Blue
COLOR_SUBSECTION="\033[1;36m" # Cyan
COLOR_SUCCESS="\033[1;32m"    # Green
COLOR_RESET="\033[0m"

# Utility Functions
print_section() {
    local title="$1"
    echo
    echo "================================================================"
    echo -e "${COLOR_SECTION}>>> ${title}${COLOR_RESET}"
    echo "================================================================"
}

print_subsection() {
    local title="$1"
    echo
    echo -e "${COLOR_SUBSECTION}[*] ${title}${COLOR_RESET}"
    echo "----------------------------------------------------------------"
}

run_cmd() {
    local title="$1"
    shift
    print_subsection "$title"
    bash -c "$*" 2>/dev/null || echo "[!] Command failed or not available"
    echo
}

run_cmd_safe() {
    local title="$1"
    shift
    print_subsection "$title"
    if ! bash -c "$*" 2>/dev/null; then
        echo "[!] $title - Command failed or not available"
    fi
    echo
}

# 1. SYSTEM INFORMATION & FINGERPRINTING
section_system_info() {
    print_section "1. SYSTEM INFORMATION & FINGERPRINTING"
    run_cmd "Distribution Information" "cat /etc/issue"
    run_cmd "OS Release Files" "cat /etc/*-release"
    run_cmd "Debian/Ubuntu LSB Release" "cat /etc/lsb-release"
    run_cmd "RedHat/CentOS Release" "cat /etc/redhat-release"
    run_cmd "Kernel Version (uname -a)" "uname -a"
    run_cmd "Kernel Version (uname -mrs)" "uname -mrs"
    run_cmd "Kernel Version (/proc/version)" "cat /proc/version"
    run_cmd "Kernel Architecture" "uname -m"
    run_cmd "Kernel Binary Check (file /bin/bash)" "file /bin/bash"
    run_cmd "Kernel DEB Architecture" "dpkg --print-architecture"
    run_cmd "Kernel RPM Package" "rpm -q kernel"
    run_cmd "System Boot Messages" "dmesg | grep -i linux | head -20"
    run_cmd "Kernel Boot Images" "ls -lah /boot/ | grep vmlinuz"
}

# 2. CURRENT USER & PRIVILEGES
section_user_privileges() {
    print_section "2. CURRENT USER & PRIVILEGES"
    run_cmd "Current User (id)" "id"
    run_cmd "Current User (whoami)" "whoami"
    run_cmd "Groups for ${TARGET_USER}" "groups ${TARGET_USER}"
    run_cmd "sudo Configuration (sudo -l)" "sudo -l 2>&1"
    run_cmd "/etc/sudoers Permissions" "ls -lah /etc/sudoers"
    run_cmd "sudo Files" "find /etc/sudoers.d -type f"
}

# 3. ENVIRONMENT & CONFIGURATION
section_environment() {
    print_section "3. ENVIRONMENT & CONFIGURATION"
    run_cmd "Environment Variables" "env | sort"
    print_subsection "Bash Profiles (System-wide)"
    for file in /etc/profile /etc/bashrc /etc/bash.bashrc; do
        if [ -f "$file" ]; then
            echo "[+] $file"
            head -20 "$file"
            echo
        fi
    done
    print_subsection "Bash Profiles (User)"
    for file in ~/.bash_profile ~/.bashrc ~/.bash_logout ~/.profile; do
        if [ -f "$file" ]; then
            echo "[+] $file"
            head -20 "$file"
            echo
        fi
    done
}

# 4. RUNNING PROCESSES & SERVICES
section_processes() {
    print_section "4. RUNNING PROCESSES & SERVICES"
    run_cmd "All Running Processes (ps aux)" "ps aux"
    run_cmd "All Running Processes (ps -ef)" "ps -ef"
    run_cmd "Running Services (top snapshot)" "top -b -n 1 | head -50"
    run_cmd "Services Running as root (ps aux)" "ps aux | grep -i 'root' | head -20"
    run_cmd "Network Services List" "cat /etc/services | head -50"
    run_cmd "File Capabilities" "getcap -r / | head -30"
}

# 5. INSTALLED SOFTWARE & PACKAGES
section_packages() {
    print_section "5. INSTALLED SOFTWARE & PACKAGES"
    print_subsection "Development Tools"
    for tool in gcc cc python python3 perl perl5 ruby java javac; do
        if which "$tool" >/dev/null 2>&1; then
            echo "[+] $tool found: $(which $tool)"
        fi
    done
    run_cmd "Debian Packages (dpkg -l)" "dpkg -l | head -100"
    run_cmd "RedHat Packages (rpm -qa)" "rpm -qa | head -100"
    run_cmd "APT Cache" "ls -alh /var/cache/apt/archives/ | head -20"
    run_cmd "YUM Cache" "ls -alh /var/cache/yum/ | head -20"
    run_cmd "Binaries in /usr/bin" "ls -alh /usr/bin/ | head -50"
    run_cmd "Binaries in /sbin" "ls -alh /sbin/ | head -50"
    run_cmd "Local Binaries" "ls -alh /usr/local/bin/ | head -30"
}

# 6. NETWORK & COMMUNICATIONS
section_network() {
    print_section "6. NETWORK & COMMUNICATIONS"
    run_cmd "Network Config (ifconfig)" "ifconfig -a"
    run_cmd "Network Config (ip addr)" "ip addr show"
    run_cmd "Network Interfaces File" "cat /etc/network/interfaces"
    run_cmd "Sysconfig Network" "cat /etc/sysconfig/network"
    run_cmd "Listening Ports (netstat)" "netstat -tulpn || ss -tulpn"
    run_cmd "All Connections (netstat)" "netstat -antup || ss -antup"
    run_cmd "DNS Configuration" "cat /etc/resolv.conf"
    run_cmd "Hostname" "hostname && echo && dnsdomainname"
    run_cmd "Routing Table" "route -n || ip route show"
    run_cmd "ARP Cache" "arp -e || arp -a"
    run_cmd "Runlevel Services (chkconfig)" "chkconfig --list | head -50"
    run_cmd "Systemd Services" "systemctl list-unit-files --type=service | head -50"
    run_cmd "Open Network Connections (lsof)" "lsof -i | head -30"
}

# 7. SCHEDULED JOBS & CRON
section_cron() {
    print_section "7. SCHEDULED JOBS & CRON"
    run_cmd "User Crontab" "crontab -l"
    run_cmd "Root Crontab (sudo)" "sudo crontab -l"
    run_cmd "System Crontab" "cat /etc/crontab"
    run_cmd "Anacrontab" "cat /etc/anacrontab"
    print_subsection "Cron Directories"
    for dir in /etc/cron.d /etc/cron.daily /etc/cron.weekly /etc/cron.monthly /etc/cron.hourly; do
        if [ -d "$dir" ]; then
            echo "[+] $dir"
            ls -lah "$dir" | head -20
            echo
        fi
    done
    run_cmd "at.allow" "cat /etc/at.allow"
    run_cmd "at.deny" "cat /etc/at.deny"
    run_cmd "cron.allow" "cat /etc/cron.allow"
    run_cmd "cron.deny" "cat /etc/cron.deny"
    run_cmd "Cron Spool Directory" "ls -alh /var/spool/cron/"
}

# 8. FILE PERMISSIONS & SECURITY
section_file_permissions() {
    print_section "8. FILE PERMISSIONS & SECURITY"
    run_cmd "SUID Files" "find / -perm -4000 -type f 2>/dev/null | head -50"
    run_cmd "SGID Files" "find / -perm -2000 -type f 2>/dev/null | head -50"
    run_cmd "Sticky Bit" "find / -perm -1000 -type d 2>/dev/null | head -30"
    print_subsection "World-Writable Locations"
    for dir in /tmp /var/tmp /dev/shm; do
        if [ -d "$dir" ]; then
            echo "[+] $dir Permissions:"
            ls -ld "$dir"
            echo
        fi
    done
    run_cmd "World-Writable Directories" "find / -type d -perm -0002 2>/dev/null | head -30"
    run_cmd "World-Writable Files (no sticky)" "find / -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null | head -20"
}

# 9. FILE SYSTEMS & MOUNTS
section_filesystems() {
    print_section "9. FILE SYSTEMS & MOUNTS"
    run_cmd "Currently Mounted Filesystems" "mount"
    run_cmd "Disk Usage" "df -h"
    run_cmd "/etc/fstab" "cat /etc/fstab"
    run_cmd "NFS Exports" "cat /etc/exports"
}

# 10. USERS & ACCOUNTS
section_users() {
    print_section "10. USERS & ACCOUNTS"
    run_cmd "User List (/etc/passwd)" "cat /etc/passwd"
    run_cmd "Group List (/etc/group)" "cat /etc/group"
    run_cmd "Shadow File (/etc/shadow)" "cat /etc/shadow"
    print_subsection "User Accounts with UID 0"
    grep -v -E '^#' /etc/passwd | awk -F: '$3 == 0 { print $0 }' || echo "[!] Cannot read /etc/passwd"
    run_cmd "Currently Logged In Users" "who"
    run_cmd "Login History" "last | head -30"
    run_cmd "User Sessions" "w"
}

# 11. SENSITIVE FILES & DATA
section_sensitive_files() {
    print_section "11. SENSITIVE FILES & DATA"
    print_subsection "SSH Keys & Configuration"
    for file in ~/.ssh/id_rsa ~/.ssh/id_dsa ~/.ssh/id_rsa.pub ~/.ssh/id_dsa.pub ~/.ssh/authorized_keys; do
        if [ -f "$file" ]; then
            echo "[+] Found: $file"
            ls -lah "$file"
            echo
        fi
    done
    run_cmd "SSH Client Config" "cat ~/.ssh/config"
    run_cmd "SSH System Config" "cat /etc/ssh/ssh_config"
    run_cmd "SSH Daemon Config" "cat /etc/ssh/sshd_config"
    print_subsection "System SSH Keys"
    for file in /etc/ssh/ssh_host_*_key*; do
        if [ -f "$file" ]; then
            echo "[+] $file"
            ls -lah "$file"
            echo
        fi
    done
    print_subsection "Command Histories"
    for file in ~/.bash_history ~/.mysql_history ~/.php_history ~/.nano_history; do
        if [ -f "$file" ]; then
            echo "[+] Found: $file"
            ls -lah "$file"
            echo "--- Last 10 lines ---"
            tail -10 "$file"
            echo
        fi
    done
}

# 12. SERVICE CONFIGURATION FILES
section_configs() {
    print_section "12. SERVICE CONFIGURATION FILES"
    print_subsection "Web Server Configurations"
    for file in /etc/apache2/apache2.conf /etc/httpd/conf/httpd.conf /etc/nginx/nginx.conf /etc/lighttpd/lighttpd.conf; do
        if [ -f "$file" ]; then
            echo "[+] $file"
            head -30 "$file"
            echo
        fi
    done
    print_subsection "Database Configurations"
    for file in /etc/mysql/my.cnf /etc/my.cnf /etc/postgresql/postgresql.conf; do
        if [ -f "$file" ]; then
            echo "[+] $file"
            head -30 "$file"
            echo
        fi
    done
    run_cmd "Syslog Configuration" "cat /etc/syslog.conf"
    run_cmd "Cups Configuration" "cat /etc/cups/cupsd.conf"
    run_cmd "Inetd Configuration" "cat /etc/inetd.conf"
    run_cmd "SAMBA Configuration" "cat /etc/samba/smb.conf"
}

# 13. LOG FILES & DIRECTORIES
section_logs() {
    print_section "13. LOG FILES & IMPORTANT DIRECTORIES"
    print_subsection "System Logs"
    for dir in /var/log /var/adm/log; do
        if [ -d "$dir" ]; then
            echo "[+] $dir"
            ls -lah "$dir" | head -30
            echo
        fi
    done
    print_subsection "Web Server Logs"
    for dir in /var/log/apache2 /var/log/httpd /var/log/nginx; do
        if [ -d "$dir" ]; then
            echo "[+] $dir"
            ls -lah "$dir"
            echo
        fi
    done
    print_subsection "Important Directories"
    for dir in /opt /var/www /var/www/html /srv/www; do
        if [ -d "$dir" ]; then
            echo "[+] $dir (first 20 items)"
            ls -lah "$dir" | head -20
            echo
        fi
    done
}

# 14. CREDENTIAL SEARCH
section_credentials() {
    print_section "14. CREDENTIAL SEARCH"
    print_subsection "PHP Database Credentials"
    find /var/www /opt /srv -name "*.php" -type f 2>/dev/null | while read file; do
        if grep -qi "password\|passwd\|user\|db_" "$file" 2>/dev/null; then
            echo "[+] Potential credentials in: $file"
            grep -i "password\|passwd\|user\|db_" "$file" | head -5
            echo
        fi
    done
    run_cmd "Config Files with Credentials" "grep -r 'password\|passwd\|api_key\|secret' /etc 2>/dev/null | grep -v '^Binary' | head -30"
}

# 15. FILE TRANSFER & COMMUNICATION TOOLS
section_transfer_tools() {
    print_section "15. FILE TRANSFER & COMMUNICATION TOOLS"
    print_subsection "File Transfer Tools"
    for tool in wget curl fetch ftp scp sftp rsync; do
        if command -v "$tool" >/dev/null 2>&1; then
            echo "[+] $tool: $(which $tool)"
        else
            echo "[-] $tool: not found"
        fi
    done
    print_subsection "Network Tools"
    for tool in nc ncat netcat socat telnet ssh; do
        if command -v "$tool" >/dev/null 2>&1; then
            echo "[+] $tool: $(which $tool)"
        else
            echo "[-] $tool: not found"
        fi
    done
    print_subsection "Packet Capture"
    for tool in tcpdump wireshark tshark; do
        if command -v "$tool" >/dev/null 2>&1; then
            echo "[+] $tool: $(which $tool)"
        else
            echo "[-] $tool: not found"
        fi
    done
}

# 16. MISCELLANEOUS CHECKS
section_misc() {
    print_section "16. MISCELLANEOUS CHECKS"
    run_cmd "Printers (lpstat -a)" "lpstat -a"
    run_cmd "Files owned by ${BOB_USER}" "find / -user '${BOB_USER}' 2>/dev/null | head -30"
    run_cmd "Files with no owner" "find / -nouser 2>/dev/null | head -30"
}

# Main Execution Loop
main() {
    clear
    echo "================================================================================"
    echo "             SIREN Security - Linux Reconnaissance & Audit Tool"
    echo "================================================================================"
    echo "Target User: ${TARGET_USER}"
    echo "Search User: ${BOB_USER}"
    echo "Start Time: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "================================================================================"

    section_system_info
    section_user_privileges
    section_environment
    section_processes
    section_packages
    section_network
    section_cron
    section_file_permissions
    section_filesystems
    section_users
    section_sensitive_files
    section_configs
    section_logs
    section_credentials
    section_transfer_tools
    section_misc

    echo "================================================================================"
    echo "                          Reconnaissance Complete!"
    echo "                          End Time: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "================================================================================"
}

main "$@"
