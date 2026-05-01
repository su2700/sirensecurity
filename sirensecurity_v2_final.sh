#!/bin/bash#!/bin/bash

################################################################################# basic_enum.sh - Linux privilege escalation / system recon helper

# SIREN Security - Linux Privilege Escalation & System Reconnaissance Script# Usage:

# #   chmod +x basic_enum.sh

# A comprehensive enumeration tool for Linux systems audit and privilege #   ./basic_enum.sh

# escalation assessment. Organized by logical security domains.#

## Optional environment variables:

# Usage:#   TARGET_USER   - user to check group membership (default: $USER)

#   chmod +x sirensecurity.sh#   BOB_USER      - user for "

#   ./sirensecurity.sh

#   TARGET_USER=admin ./sirensecurity.sh        (custom target user)TARGET_USER="${TARGET_USER:-$USER}"

#   BOB_USER=testuser ./sirensecurity.sh         (custom username for search)BOB_USER="${BOB_USER:-bob}"

#

# Optional Environment Variables:run_cmd() {

#   TARGET_USER   - User to check group membership (default: $USER)    local title="$1"

#   BOB_USER      - Username to search for files (default: bob)    shift

#   VERBOSE       - Increase output detail (not set for normal)

################################################################################    echo "================================================================"

    echo ">>> $title"

set -o errexit; echo "----------------------------------------------------------------"

trap 'echo "[ERROR] An error occurred at line $LINENO"' ERR; bash -c "$*"

    echo

# Configuration}

TARGET_USER="${TARGET_USER:-$USER}"

BOB_USER="${BOB_USER:-bob}"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

OUTPUT_DIR="${OUTPUT_DIR:-.}"

echo "================================================================"

# Color codes (optional)

COLOR_SECTION="\033[1;34m"

COLOR_SUBSECTION="\033[1;36m"

COLOR_SUCCESS="\033[1;32m"

COLOR_RESET="\033[0m"

which gcc 2>/dev/null || echo "gcc: not found"

################################################################################which cc 2>/dev/null || echo "cc: not found"

# UTILITY FUNCTIONSwhich python 2>/dev/null || echo "python: not found"

################################################################################which python3 2>/dev/null || echo "python3: not found"

which perl 2>/dev/null || echo "perl: not found"

print_section() {

    local title="$1"

    echo

    echo "================================================================"

    echo -e "${COLOR_SECTION}>>> ${title}${COLOR_RESET}"

    echo "================================================================"

}

'

print_subsection() {

    local title="$1"

    echo

    echo -e "${COLOR_SUBSECTION}[*] ${title}${COLOR_RESET}"

    echo "----------------------------------------------------------------"

}

run_cmd "Debian-based distribution (lsb-release)" 'cat /etc/lsb-release 2>/dev/null || echo "/etc/lsb-release not found"'

run_cmd() {

    local title="$1"

    shift############################

    print_subsection "$title"

    bash -c "$*" 2>/dev/null || echo "[!] Command failed or not available"

    echo

}

run_cmd "uname -mrs (machine, release, system)" 'uname -mrs 2>/dev/null'

run_cmd_safe() {

    local title="$1"

    shiftrun_cmd "Is 64-bit? (dpkg check)" 'dpkg --print-architecture 2>/dev/null || echo "dpkg check not available"'

    print_subsection "$title"

    if ! bash -c "$*" 2>/dev/null; thenrun_cmd "Kernel boot messages (dmesg | grep Linux)" 'dmesg 2>/dev/null | grep -i linux | head -20 || echo "dmesg not accessible"'

        echo "[!] $title - Command failed or not available"

    fi

    echo

}

############################

################################################################################run_cmd "file /bin/bash (arch + type)" 'file /bin/bash 2>/dev/null'

# SECTION 1: SYSTEM INFORMATION & FINGERPRINTING

############################################################################################################

# 5. Is there a printer?

section_system_info() {

    print_section "1. SYSTEM INFORMATION & FINGERPRINTING"

    

    print_subsection "Distribution Information"

    cat /etc/issue 2>/dev/null || echo "[!] /etc/issue not found"

    echo

    run_cmd "Running services (ps aux)" 'ps aux 2>/dev/null || echo "ps aux not accessible"'

    print_subsection "OS Release Files"

    cat /etc/*-release 2>/dev/null || echo "[!] No *-release files found"

    echo

    

    run_cmd "Debian/Ubuntu LSB Release" "

    run_cmd "RedHat/CentOS Release" "

    run_cmd "Kernel Version (uname -a)" "uname -a"

    run_cmd "Kernel Version (uname -mrs)" "uname -mrs"

    run_cmd "Kernel Version (/proc/version)" "

run_cmd "Kernel Architecture" "uname -m"

    run_cmd "Kernel Binary Check (file /bin/bash)" "file /bin/bash"

    run_cmd "Kernel DEB Architecture" "dpkg --print-architecture"

    run_cmd "Kernel RPM Package" "rpm -q kernel"

    run_cmd "System Boot Messages" "dmesg 2>/dev/null | grep -i linux | head -20"

    run_cmd "Kernel Boot Images" "

}

run_cmd "RedHat/CentOS packages (rpm -qa)" 'rpm -qa 2>/dev/null | head -50 || echo "rpm not available"'

################################################################################run_cmd "APT cache archives" 'ls -alh /var/cache/apt/archives/ 2>/dev/null || echo "/var/cache/apt/archives not accessible"'

# SECTION 2: CURRENT USER & PRIVILEGESrun_cmd "YUM cache" 'ls -alh /var/cache/yum/ 2>/dev/null || echo "/var/cache/yum not accessible"'

################################################################################

############################

section_user_privileges() {

    print_section "2. CURRENT USER & PRIVILEGES"

    run_cmd "syslog configuration" 'cat /etc/syslog.conf 2>/dev/null || echo "/etc/syslog.conf not found"'

    run_cmd "Current User (id)" "id"

    run_cmd "Current User (whoami)" "whoami"

    run_cmd "Groups for ${TARGET_USER}" "groups ${TARGET_USER}"

    run_cmd "sudo Configuration (sudo -l)" "sudo -l 2>&1"

    run_cmd "/etc/sudoers Permissions" "

    run_cmd "sudo Files" "

}

run_cmd "LAMPP Apache configuration" 'cat /opt/lampp/etc/httpd.conf 2>/dev/null || echo "/opt/lampp/etc/httpd.conf not found"'

################################################################################run_cmd "World-readable config files in /etc/" 'find /etc/ -readable -type f 2>/dev/null | head -30'

# SECTION 3: ENVIRONMENT & CONFIGURATION

############################################################################################################

# 10. Scheduled jobs

section_environment() {

    print_section "3. ENVIRONMENT & CONFIGURATION"

    run_cmd "User crontab - root (via sudo)" 'sudo crontab -l 2>/dev/null || echo "Cannot read root crontab via sudo"'

    run_cmd "Environment Variables" "env | sort"

    print_subsection "Bash Profiles (System-wide)"

    for file in /etc/profile /etc/bashrc /etc/bash.bashrc; dorun_cmd "/etc/cron.d" 'ls -al /etc/cron.d 2>/dev/null || echo "/etc/cron.d not found"'

        if [ -f "$file" ]; thenrun_cmd "/etc/cron.daily" 'ls -al /etc/cron.daily 2>/dev/null || echo "/etc/cron.daily not found"'

            echo "[+] $file"

            head -20 "$file"

            echo

        firun_cmd "/etc/crontab" 'cat /etc/crontab 2>/dev/null || echo "/etc/crontab not found"'

    donerun_cmd "/etc/anacrontab" 'cat /etc/anacrontab 2>/dev/null || echo "/etc/anacrontab not found"'

    run_cmd "at.allow" 'cat /etc/at.allow 2>/dev/null || echo "/etc/at.allow not found"'

    print_subsection "Bash Profiles (User)"

    for file in ~/.bash_profile ~/.bashrc ~/.bash_logout ~/.profile; dorun_cmd "cron.allow" 'cat /etc/cron.allow 2>/dev/null || echo "/etc/cron.allow not found"'

        if [ -f "$file" ]; thenrun_cmd "cron.deny" 'cat /etc/cron.deny 2>/dev/null || echo "/etc/cron.deny not found"'

            echo "[+] $file"

            head -20 "$file"

            echo

        fi############################

    donerun_cmd "Search for password/user patterns in common locations" '

}

    if [ -d "$dir" ]; then

################################################################################        echo "[*] Searching in $dir..."

# SECTION 4: RUNNING PROCESSES & SERVICES        find "$dir" -type f 2>/dev/null | head -20 | while read file; do

################################################################################            if grep -i "password\|passwd\|pwd" "$file" 2>/dev/null | head -1; then

                echo "  Found in: $file"

section_processes() {

    print_section "4. RUNNING PROCESSES & SERVICES"        done

        fi

run_cmd "All Running Processes (ps aux)" "ps aux"

run_cmd "All Running Processes (ps -ef)" "ps -ef"

    run_cmd "Running Services (top snapshot)" "top -b -n 1 | head -50"

    run_cmd "Services Running as root (ps aux)" "ps aux 2>/dev/null | grep -i 'root' | head -20"

run_cmd "Services Running as root (ps -ef)" "ps -ef 2>/dev/null | grep -i 'root' | head -20"

    run_cmd "Network Services List" "

    run_cmd "File Capabilities" "getcap -r / 2>/dev/null | head -30"

}

run_cmd "sudo -l (may prompt for password)" 'sudo -l 2>/dev/null || echo "sudo -l failed or needs password"'

################################################################################run_cmd "Permissions on /etc/sudoers" 'ls -lsaht /etc/sudoers 2>/dev/null'

# SECTION 5: INSTALLED SOFTWARE & PACKAGES

############################################################################################################

# 13. Exotic groups for TARGET_USER

section_packages() {

    print_section "5. INSTALLED SOFTWARE & PACKAGES"

    

    print_subsection "Development Tools"

    for tool in gcc cc python python3 perl perl5 ruby java javac; do# 14. Environment variables

        if which "$tool" 2>/dev/null; then############################

            echo "[+] $tool found: $(which $tool)"

        firun_cmd "Bash profile (/etc/profile)" 'cat /etc/profile 2>/dev/null || echo "/etc/profile not found"'

    donerun_cmd "Bash rc (/etc/bashrc)" 'cat /etc/bashrc 2>/dev/null || echo "/etc/bashrc not found"'

    echo

    run_cmd "User bashrc (~/.bashrc)" 'cat ~/.bashrc 2>/dev/null || echo "~/.bashrc not found"'

    print_subsection "Package Managers"

    run_cmd "Debian Packages (dpkg -l)" "dpkg -l 2>/dev/null | head -100"

run_cmd "RedHat Packages (rpm -qa)" "rpm -qa 2>/dev/null | head -100"

    ############################

    print_subsection "Package Caches"

    run_cmd "APT Cache" "

    run_cmd "YUM Cache" "

    run_cmd "Network interfaces - ip addr" 'ip addr 2>/dev/null || echo "ip command not available"'

    print_subsection "Important Binaries"

    run_cmd "Binaries in /usr/bin" "

    run_cmd "Binaries in /sbin" "

    run_cmd "Local Binaries" "

}

############################

################################################################################run_cmd "DNS configuration (/etc/resolv.conf)" 'cat /etc/resolv.conf 2>/dev/null || echo "/etc/resolv.conf not found"'

# SECTION 6: NETWORK & COMMUNICATIONSrun_cmd "Network details (/etc/networks)" 'cat /etc/networks 2>/dev/null || echo "/etc/networks not found"'

################################################################################run_cmd "IPTables rules" 'iptables -L 2>/dev/null || echo "iptables not available or not accessible"'

run_cmd "Hostname" 'hostname 2>/dev/null || echo "hostname command failed"'

section_network() {

    print_section "6. NETWORK & COMMUNICATIONS"

    

    print_subsection "Network Interfaces"

    run_cmd "Network Config (ifconfig)" "

    run_cmd "Network Config (ip addr)" "ip addr show"

    run_cmd "Network Interfaces File" "

    run_cmd "Sysconfig Network" "

    run_cmd "Network services (/etc/services port 80)" 'grep 80 /etc/services 2>/dev/null || echo "Port 80 not found in /etc/services"'

    print_subsection "Network Services"

    run_cmd "Listening Ports (netstat)" "netstat -tulpn 2>/dev/null || ss -tulpn 2>/dev/null"

    run_cmd "All Connections (netstat)" "netstat -antup 2>/dev/null || ss -antup 2>/dev/null"

    run_cmd "DNS Configuration" "

    run_cmd "Hostname" "hostname && echo && dnsdomainname"

    run_cmd "Routing Table" "route -n 2>/dev/null || ip route show"

    run_cmd "ARP Cache" "arp -e 2>/dev/null || arp -a 2>/dev/null"

    

    print_subsection "Service Management"

    run_cmd "Runlevel Services (chkconfig)" "chkconfig --list 2>/dev/null | head -50"

    run_cmd "Systemd Services" "systemctl list-unit-files --type=service 2>/dev/null | head -50"

    run_cmd "Open Network Connections (lsof)" "

}

run_cmd "Routing table extended (route -nee)" '/sbin/route -nee 2>/dev/null || route -n 2>/dev/null || echo "route not available"'

################################################################################

# SECTION 7: SCHEDULED JOBS & CRON############################

################################################################################# 19. Packet sniffing capability

############################

section_cron() {

    print_section "7. SCHEDULED JOBS & CRON"

    

    run_cmd "User Crontab" "crontab -l 2>/dev/null"

    run_cmd "Root Crontab (sudo)" "sudo crontab -l 2>/dev/null"

    run_cmd "System Crontab" "

    run_cmd "Anacrontab" "

    which nc 2>/dev/null || echo "nc: not found"

    print_subsection "Cron Directories"

    for dir in /etc/cron.d /etc/cron.daily /etc/cron.weekly /etc/cron.monthly /etc/cron.hourly; dowhich nc.traditional 2>/dev/null || echo "nc.traditional: not found"

        if [ -d "$dir" ]; thenwhich socat 2>/dev/null || echo "socat: not found"

            echo "[+] $dir"'

            ls -lah "$dir" 2>/dev/null | head -20run_cmd "SSH tunneling capability (ssh available?)" 'which ssh 2>/dev/null && echo "SSH available for tunneling" || echo "SSH not available"'

            echo

        fi

    done############################

    # 21. User information

    print_subsection "Cron Access Controls"

    run_cmd "at.allow" "

    run_cmd "at.deny" "

    run_cmd "cron.allow" "

    run_cmd "cron.deny" "

    run_cmd "Users list from /etc/passwd" 'cat /etc/passwd 2>/dev/null | cut -d: -f1 || echo "/etc/passwd not accessible"'

    run_cmd "Cron Spool Directory" "

}

run_cmd "sudo configuration (sudoers)" 'cat /etc/sudoers 2>/dev/null || echo "/etc/sudoers not readable (normal without sudo)"'

################################################################################

# SECTION 8: FILE PERMISSIONS & SECURITY############################

################################################################################# 22. Sensitive files

############################

section_file_permissions() {

    print_section "8. FILE PERMISSIONS & SECURITY"

    run_cmd "/etc/shadow (if readable)" 'cat /etc/shadow 2>/dev/null || echo "/etc/shadow not readable (normal)"'

    print_subsection "SUID Binaries"

    run_cmd "SUID Files" "

    ############################

    print_subsection "SGID Binaries"

    run_cmd "SGID Files" "

    run_cmd "Bash history (~/.bash_history)" 'cat ~/.bash_history 2>/dev/null || echo "~/.bash_history not found or not readable"'

    print_subsection "Sticky Bit Directories"

    run_cmd "Sticky Bit" "

    run_cmd "MySQL history (~/.mysql_history)" 'cat ~/.mysql_history 2>/dev/null || echo "~/.mysql_history not found"'

    print_subsection "World-Writable Locations"

    for dir in /tmp /var/tmp /dev/shm; do

        if [ -d "$dir" ]; then############################

            echo "[+] $dir Permissions:"

            ls -ld "$dir"

            echo

        firun_cmd "SSH identity.pub (~/.ssh/identity.pub)" 'cat ~/.ssh/identity.pub 2>/dev/null || echo "~/.ssh/identity.pub not found"'

    donerun_cmd "SSH identity (~/.ssh/identity)" 'cat ~/.ssh/identity 2>/dev/null || echo "~/.ssh/identity not found"'

    run_cmd "SSH id_rsa.pub (~/.ssh/id_rsa.pub)" 'cat ~/.ssh/id_rsa.pub 2>/dev/null || echo "~/.ssh/id_rsa.pub not found"'

    run_cmd "World-Writable Directories" "

    run_cmd "World-Writable Files (no sticky)" "

}

run_cmd "SSH system config (/etc/ssh/ssh_config)" 'cat /etc/ssh/ssh_config 2>/dev/null || echo "/etc/ssh/ssh_config not found"'

################################################################################run_cmd "SSH daemon config (/etc/ssh/sshd_config)" 'cat /etc/ssh/sshd_config 2>/dev/null || echo "/etc/ssh/sshd_config not found"'

# SECTION 9: FILE SYSTEMS & MOUNTSrun_cmd "SSH host DSA public key" 'cat /etc/ssh/ssh_host_dsa_key.pub 2>/dev/null || echo "Host DSA key not found"'

################################################################################run_cmd "SSH host DSA private key" 'cat /etc/ssh/ssh_host_dsa_key 2>/dev/null || echo "Host DSA key not readable"'

run_cmd "SSH host RSA public key" 'cat /etc/ssh/ssh_host_rsa_key.pub 2>/dev/null || echo "Host RSA key not found"'

section_filesystems() {

    print_section "9. FILE SYSTEMS & MOUNTS"

    run_cmd "SSH host key" 'cat /etc/ssh/ssh_host_key 2>/dev/null || echo "Host key not readable"'

run_cmd "Currently Mounted Filesystems" "mount"

    run_cmd "Disk Usage" "df -h"

    run_cmd "/etc/fstab" "

    run_cmd "NFS Exports" "

}

run_cmd "Owner-writable config files in /etc/" 'ls -aRl /etc/ 2>/dev/null | awk "$1 ~ /^..w/" | head -30'

################################################################################run_cmd "Group-writable config files in /etc/" 'ls -aRl /etc/ 2>/dev/null | awk "$1 ~ /^.....w/" | head -30'

# SECTION 10: USERS & ACCOUNTSrun_cmd "Other-writable config files in /etc/" 'find /etc/ -writable -type f 2>/dev/null | head -20'

################################################################################

############################

section_users() {

    print_section "10. USERS & ACCOUNTS"

    run_cmd "Sticky bit files (find / -perm -1000 -type d)" 'find / -perm -1000 -type d 2>/dev/null | head -20'

    run_cmd "User List (/etc/passwd)" "

    run_cmd "Group List (/etc/group)" "

    run_cmd "Shadow File (/etc/shadow)" "

    run_cmd "SGID or SUID in common bin directories" '

    print_subsection "User Accounts with UID 0"

    grep -v -E '^#' /etc/passwd 2>/dev/null | awk -F: '$3 == 0 { print $0 }' || echo "[!] Cannot read /etc/passwd"

    echo

        fi

run_cmd "Currently Logged In Users" "who"

run_cmd "Login History" "last 2>/dev/null | head -30"

run_cmd "User Sessions" "w"

}

# 27. World-writable and executable folders

############################################################################################################

# SECTION 11: SENSITIVE FILES & DATArun_cmd "World-writable directories (find / -writable -type d)" 'find / -writable -type d 2>/dev/null | head -20'

################################################################################run_cmd "World-writable and executable (find / -perm -o w -perm -o x -type d)" 'find / \( -perm -o w -perm -o x \) -type d 2>/dev/null | head -20'

run_cmd "World-executable directories (find / -perm -o x -type d)" 'find / -perm -o x -type d 2>/dev/null | head -20'

section_sensitive_files() {

    print_section "11. SENSITIVE FILES & DATA"

    # 28. Problem files

    print_subsection "SSH Keys & Configuration"

    for file in ~/.ssh/id_rsa ~/.ssh/id_dsa ~/.ssh/id_rsa.pub ~/.ssh/id_dsa.pub ~/.ssh/authorized_keys; dorun_cmd "World-writable files without sticky bit" 'find / -xdev -type d \( -perm -0002 -a ! -perm -1000 \) -print 2>/dev/null | head -20'

        if [ -f "$file" ]; thenrun_cmd "Files with no owner (find / -nouser)" 'find /dir -xdev \( -nouser -o -nogroup \) -print 2>/dev/null | head -20'

            echo "[+] Found: $file"

            ls -lah "$file"

            echo

        fi############################

    donerun_cmd "List /home/" 'ls -lsaht /home 2>/dev/null || echo "/home not accessible"'

    run_cmd "Recursive listing of /home (look for .ssh, config, etc.)" 'ls -lsaR /home 2>/dev/null | head -100'

    run_cmd "SSH Client Config" "

    run_cmd "SSH System Config" "

    run_cmd "SSH Daemon Config" "

    # 30. File capabilities (getcap)

    print_subsection "System SSH Keys"

    for file in /etc/ssh/ssh_host_*_key*; dorun_cmd "File capabilities (getcap -r /)" '

        if [ -f "$file" ]; thenif command -v getcap >/dev/null 2>&1; then

            echo "[+] $file"    getcap -r / 2>/dev/null

            ls -lah "$file"else

            echo

        fifi

    done'

    

    print_subsection "Command Histories"

    for file in ~/.bash_history ~/.mysql_history ~/.php_history ~/.nano_history; do# 31. Quick look in important dirs

        if [ -f "$file" ]; then############################

            echo "[+] Found: $file"

            ls -lah "$file"

            wc -l "$file"

            echo "--- First 10 lines ---"

            head -10 "$file"

            echo

        fi

    done############################

}

############################

################################################################################run_cmd "/etc/exports (NFS shares)" 'cat /etc/exports 2>/dev/null || echo "/etc/exports not present or not readable"'

# SECTION 12: CONFIGURATION FILES

############################################################################################################

# 33. File systems and mounts

section_configs() {

    print_section "12. SERVICE CONFIGURATION FILES"

    run_cmd "Disk usage (df -h)" 'df -h 2>/dev/null || echo "df command failed"'

    print_subsection "Web Server Configurations"

    for file in /etc/apache2/apache2.conf /etc/httpd/conf/httpd.conf /etc/nginx/nginx.conf /etc/lighttpd/lighttpd.conf; do

        if [ -f "$file" ]; then############################

            echo "[+] $file"

            head -30 "$file"

            echo

        firun_cmd "Config files in /etc (*.conf)" 'find /etc -name "*.conf" 2>/dev/null | head -30'

    donerun_cmd ".secret-looking files in /etc" 'find /etc -name "*secret*" 2>/dev/null'

    

    print_subsection "Database Configurations"

    for file in /etc/mysql/my.cnf /etc/my.cnf /etc/postgresql/postgresql.conf; do# 35. Files owned by BOB_USER

        if [ -f "$file" ]; then############################

            echo "[+] $file"

            head -30 "$file"

            echo

        fi# 36. File transfer capability recap

    done############################

    run_cmd "Transfer tools recap + FTP-like binaries" '

    print_subsection "Other Service Configs"

    run_cmd "Syslog Configuration" "

    run_cmd "Cups Configuration" "

    run_cmd "Inetd Configuration" "

    run_cmd "SAMBA Configuration" "

}

which ftp 2>/dev/null || echo "ftp: not found"

################################################################################find /bin /sbin /usr/bin /usr/sbin -name "*ftp*" 2>/dev/null || echo "no ftp-related binaries found"

# SECTION 13: LOG FILES & DIRECTORIES'

################################################################################

############################

section_logs() {

    print_section "13. LOG FILES & IMPORTANT DIRECTORIES"

    run_cmd "Extra interesting config/log/cred files (existence + first lines)" '

    print_subsection "System Logs"FILES="

    for dir in /var/log /var/adm/log; do/etc/passwd

        if [ -d "$dir" ]; then/etc/shadow

            echo "[+] $dir"/etc/aliases

            ls -lah "$dir" 2>/dev/null | head -30/etc/anacrontab

            echo/etc/apache2/apache2.conf

        fi/etc/apache2/httpd.conf

    done/etc/apache2/sites-enabled/000-default.conf

    /etc/at.allow

    print_subsection "Web Server Logs"/etc/at.deny

    for dir in /var/log/apache2 /var/log/httpd /var/log/nginx; do/etc/bashrc

        if [ -d "$dir" ]; then/etc/bootptab

            echo "[+] $dir"/etc/chrootUsers

            ls -lah "$dir" 2>/dev/null/etc/chttp.conf

            echo/etc/cron.allow

        fi/etc/cron.deny

    done/etc/crontab

    /etc/cups/cupsd.conf

    print_subsection "Important Directories"/etc/exports

    for dir in /opt /var/www /var/www/html /srv/www; do/etc/fstab

        if [ -d "$dir" ]; then/etc/ftpaccess

            echo "[+] $dir (first 20 items)"/etc/ftpchroot

            ls -lah "$dir" 2>/dev/null | head -20/etc/ftphosts

            echo/etc/groups

        fi/etc/grub.conf

    done/etc/hosts

}/etc/hosts.allow

/etc/hosts.deny

################################################################################/etc/httpd/access.conf

# SECTION 14: CREDENTIAL SEARCH/etc/httpd/conf/httpd.conf

################################################################################/etc/httpd/httpd.conf

/etc/httpd/logs/access_log

section_credentials() {

    print_section "14. CREDENTIAL SEARCH"/etc/httpd/logs/error_log

    /etc/httpd/logs/error.log

    print_subsection "Searching for common credential patterns..."/etc/httpd/php.ini

    /etc/httpd/srm.conf

    print_subsection "PHP Database Credentials"/etc/inetd.conf

    find /var/www /opt /srv -name "*.php" -type f 2>/dev/null | while read file; do/etc/inittab

        if grep -l "password\|passwd\|user\|db_" "$file" 2>/dev/null; then/etc/issue

            echo "[+] Potential credentials in: $file"/etc/knockd.conf

            grep -i "password\|passwd\|user\|db_" "$file" | head -5/etc/lighttpd.conf

            echo/etc/lilo.conf

        fi/etc/logrotate.d/ftp

    done/etc/logrotate.d/proftpd

    /etc/logrotate.d/vsftpd.log

    print_subsection "Config Files with Credentials"/etc/lsb-release

    grep -r "password\|passwd\|api_key\|secret" /etc 2>/dev/null | grep -v "^Binary" | head -30/etc/motd

    echo/etc/modules.conf

}/etc/mtab

/etc/my.cnf

################################################################################/etc/my.conf

# SECTION 15: TRANSFER TOOLS AVAILABILITY/etc/mysql/my.cnf

################################################################################/etc/network/interfaces

/etc/networks

section_transfer_tools() {

    print_section "15. FILE TRANSFER & COMMUNICATION TOOLS"/etc/php.ini

    /etc/proftp.conf

    print_subsection "File Transfer Tools"/etc/proftpd/proftpd.conf

    for tool in wget curl fetch ftp scp sftp rsync; do/etc/pure-ftpd.conf

        if command -v "$tool" >/dev/null 2>&1; then/etc/pureftpd.passwd

            echo "[+] $tool: $(which $tool)"/etc/pureftpd.pdb

        else/etc/pure-ftpd/pure-ftpd.conf

            echo "[-] $tool: not found"/etc/pure-ftpd/pure-ftpd.pdb

        fi/etc/pure-ftpd/putreftpd.pdb

    done/etc/redhat-release

    echo/etc/resolv.conf

    /etc/samba/smb.conf

    print_subsection "Network Tools"/etc/snmpd.conf

    for tool in nc ncat netcat socat telnet ssh; do/etc/ssh/ssh_config

        if command -v "$tool" >/dev/null 2>&1; then/etc/ssh/sshd_config

            echo "[+] $tool: $(which $tool)"/etc/ssh/ssh_host_dsa_key

        else/etc/ssh/ssh_host_dsa_key.pub

            echo "[-] $tool: not found"/etc/ssh/ssh_host_key

        fi/etc/ssh/ssh_host_key.pub

    done/etc/sysconfig/network

    echo/etc/syslog.conf

    /etc/termcap

    print_subsection "Packet Capture"/etc/vhcs2/proftpd/proftpd.conf

    for tool in tcpdump wireshark tshark; do/etc/vsftpd.chroot_list

        if command -v "$tool" >/dev/null 2>&1; then/etc/vsftpd.conf

            echo "[+] $tool: $(which $tool)"/etc/vsftpd/vsftpd.conf

        else/etc/wu-ftpd/ftpaccess

            echo "[-] $tool: not found"/etc/wu-ftpd/ftphosts

        fi/etc/wu-ftpd/ftpusers

    done/logs/pure-ftpd.log

    echo/logs/security_debug_log

}/logs/security_log

/opt/lampp/etc/httpd.conf

################################################################################/opt/xampp/etc/php.ini

# SECTION 16: PRINTER & SERVICES CHECK/proc/cmdline

################################################################################/proc/cpuinfo

/proc/filesystems

section_misc() {

    print_section "16. MISCELLANEOUS CHECKS"/proc/ioports

    /proc/meminfo

run_cmd "Printers (lpstat -a)" "lpstat -a 2>/dev/null"

    run_cmd "Files owned by ${BOB_USER}" "

    run_cmd "Files with no owner" "

}/proc/net/tcp

/proc/net/udp

################################################################################/proc/sched_debug

# MAIN EXECUTION/proc/self/cwd/app.py

################################################################################/proc/self/environ

/proc/self/net/arp

main() {

    clear/proc/swaps

    echo "================================================================================"/proc/version

    echo "             SIREN Security - Linux Reconnaissance & Audit Tool"/root/anaconda-ks.cfg

    echo "================================================================================"/usr/etc/pure-ftpd.conf

    echo "Target User: ${TARGET_USER}"/usr/lib/php.ini

    echo "Search User: ${BOB_USER}"/usr/lib/php/php.ini

    echo "Start Time: $(date '+%Y-%m-%d %H:%M:%S')"/usr/local/apache/conf/modsec.conf

    echo "================================================================================"/usr/local/apache/conf/php.ini

    /usr/local/apache/log

    # Execute all sections/usr/local/apache/logs

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

    /usr/local/lib/php.ini

    # Final message/usr/local/php4/httpd.conf

    echo/usr/local/php4/httpd.conf.php

    echo "================================================================================"/usr/local/php4/lib/php.ini

    echo "                          Reconnaissance Complete!"/usr/local/php5/httpd.conf

    echo "                          End Time: $(date '+%Y-%m-%d %H:%M:%S')"/usr/local/php5/httpd.conf.php

    echo "================================================================================"/usr/local/php5/lib/php.ini

    echo/usr/local/php/httpd.conf

    echo "NOTES:"/usr/local/php/httpd.conf.ini

    echo "- Run with 'sudo' for more comprehensive results"/usr/local/php/lib/php.ini

    echo "- Some sections may require elevated privileges"/usr/local/pureftpd/etc/pure-ftpd.conf

    echo "- Use pspy64 to monitor process execution:"/usr/local/pureftpd/etc/pureftpd.pdn

    echo "  cd /tmp && chmod +x pspy64 && ./pspy64 -pf -i 1000"/usr/local/pureftpd/sbin/pure-config.pl

    echo/usr/local/www/logs/httpd_log

}/usr/local/Zend/etc/php.ini

/usr/sbin/pure-config.pl

# Run main function/var/adm/log/xferlog

main "$@"/var/apache2/config.inc

/var/apache/logs/access_log
/var/apache/logs/error_log
/var/cpanel/cpanel.config
/var/lib/mysql/my.cnf
/var/lib/mysql/mysql/user.MYD
/var/local/www/conf/php.ini
/var/log/apache2/access_log
/var/log/apache2/access.log
/var/log/apache2/error_log
/var/log/apache2/error.log
/var/log/apache/access_log
/var/log/apache/access.log
/var/log/apache/error_log
/var/log/apache/error.log
/var/log/apache-ssl/access.log
/var/log/apache-ssl/error.log
/var/log/auth.log
/var/log/boot
/var/htmp
/var/log/chttp.log
/var/log/cups/error.log
/var/log/daemon.log
/var/log/debug
/var/log/dmesg
/var/log/dpkg.log
/var/log/exim_mainlog
/var/log/exim/mainlog
/var/log/exim_paniclog
/var/log/exim.paniclog
/var/log/exim_rejectlog
/var/log/exim/rejectlog
/var/log/faillog
/var/log/ftplog
/var/log/ftp-proxy
/var/log/ftp-proxy/ftp-proxy.log
/var/log/httpd-access.log
/var/log/httpd/access_log
/var/log/httpd/access.log
/var/log/httpd/error_log
/var/log/httpd/error.log
/var/log/httpsd/ssl.access_log
/var/log/httpsd/ssl_log
/var/log/kern.log
/var/log/lastlog
/var/log/lighttpd/access.log
/var/log/lighttpd/error.log
/var/log/lighttpd/lighttpd.access.log
/var/log/lighttpd/lighttpd.error.log
/var/log/mail.info
/var/log/mail.log
/var/log/maillog
/var/log/mail.warn
/var/log/message
/var/log/messages
/var/log/mysqlderror.log
/var/log/mysql.log
/var/log/mysql/mysql-bin.log
/var/log/mysql/mysql.log
/var/log/mysql/mysql-slow.log
/var/log/proftpd
/var/log/pureftpd.log
/var/log/pure-ftpd/pure-ftpd.log
/var/log/secure
/var/log/vsftpd.log
/var/log/wtmp
/var/log/xferlog
/var/log/yum.log
/var/mysql.log
/var/run/utmp
/var/spool/cron/crontabs/root
/var/webmin/miniserv.log
/var/www/html/db_connect.php
/var/www/html/utils.php
/var/www/log/access_log
/var/www/log/error_log
/var/www/logs/access_log
/var/www/logs/error_log
/var/www/logs/access.log
/var/www/logs/error.log
~/.atfp_history
~/.bash_history
~/.bash_logout
~/.bash_profile
~/.bashrc
~/.gtkrc
~/.login
~/.logout
~/.mysql_history
~/.nano_history
~/.php_history
~/.profile
~/.ssh/authorized_keys
~/.ssh/id_dsa
~/.ssh/id_dsa.pub
~/.ssh/id_rsa
~/.ssh/id_rsa.pub
~/.ssh/identity
~/.ssh/identity.pub
~/.viminfo
~/.wm_style
~/.Xdefaults
~/.xinitrc
~/.Xresources
~/.xsession
"

for f in $FILES; do
    # expand ~ manually
    case "$f" in
        ~/*) path="$HOME${f#~}" ;;
        *)   path="$f" ;;
    esac

    if [ -f "$path" ]; then
        echo "[+] $path"
        ls -lsaht "$path" 2>/dev/null
        head -n 10 "$path" 2>/dev/null
        echo
    fi
done
'

############################
# 38. Reminder about pspy
############################
echo
echo "================================================================"
echo "pspy REMINDER (not run automatically):"
echo "
echo "  cd /var/tmp/"
echo "  chmod 755 pspy32 pspy64"
echo "  ./pspy64 -r /bin,/etc,/home,/opt,/var,/usr,/tmp -pf -i 1000"
echo "================================================================"
echo
