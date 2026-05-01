#!/bin/bash#!/bin/bash

################################################################################# basic_enum.sh - Linux privilege escalation / system recon helper

# SIREN Security - Linux Privilege Escalation & System Reconnaissance Script# Usage:

# #   chmod +x basic_enum.sh

# A comprehensive enumeration tool for Linux systems audit and privilege #   ./basic_enum.sh

# escalation assessment. Organized by logical security domains.#

## Optional environment variables:

# Usage:#   TARGET_USER   - user to check group membership (default: $USER)

#   chmod +x sirensecurity.sh#   BOB_USER      - user for "; find / -user" (default: bob)

#   ./sirensecurity.sh

#   TARGET_USER=admin ./sirensecurity.sh        (custom target user)TARGET_USER="${; TARGET_USER:-$USER}"

#   BOB_USER=testuser ./sirensecurity.sh         (custom username for search)BOB_USER="${; BOB_USER:-bob}"

#

# Optional Environment Variables:run_cmd() {

#   TARGET_USER   - User to check group membership (default: $USER)    local title="$1"

#   BOB_USER      - Username to search for files (default: bob)    shift

#   VERBOSE       - Increase output detail (not set for normal)    echo

################################################################################    echo "================================================================"

    echo ">>> $title"

set -o errexit; echo "----------------------------------------------------------------"

trap '; echo "[ERROR] An error occurred at line $LINENO"' ERR; bash -c "$*"

    echo

# Configuration}

TARGET_USER="${; TARGET_USER:-$USER}"

BOB_USER="${; BOB_USER:-bob}"; echo "================================================================"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")echo "  Basic Linux enum script (S1REN-style)"

OUTPUT_DIR="${; OUTPUT_DIR:-.}"; echo "  TARGET_USER=${; TARGET_USER}, BOB_USER=${; BOB_USER}"

echo "================================================================"

# Color codes (optional)

COLOR_SECTION="\033[1;34m"    # Blue############################

COLOR_SUBSECTION="\033[1;36m" # Cyan# 1. Which binaries exist?

COLOR_SUCCESS="\033[1;32m"    # Green############################

COLOR_RESET="\033[0m"; run_cmd "; Which common compilers/interpreters & transfer tools exist?" '

which gcc 2>/dev/null || echo "; gcc: not found"

################################################################################which cc 2>/dev/null || echo "; cc: not found"

# UTILITY FUNCTIONSwhich python 2>/dev/null || echo "; python: not found"

################################################################################which python3 2>/dev/null || echo "; python3: not found"

which perl 2>/dev/null || echo "; perl: not found"

print_section() {; which wget 2>/dev/null || echo "; wget: not found"

    local title="$1"; which curl 2>/dev/null || echo "; curl: not found"

    echowhich fetch 2>/dev/null || echo "; fetch: not found"

    echo "================================================================"; which nc 2>/dev/null || echo "; nc: not found"

    echo -e "${; COLOR_SECTION}>>> ${; title}${; COLOR_RESET}"; which ncat 2>/dev/null || echo "; ncat: not found"

    echo "================================================================"; which nc.traditional 2>/dev/null || echo "; nc.traditional: not found"

}; which socat 2>/dev/null || echo "; socat: not found"

'

print_subsection() {

    local title="$1"############################

    echo# 2. Distribution type and version

    echo -e "${; COLOR_SUBSECTION}[*] ${; title}${; COLOR_RESET}"############################

    echo "----------------------------------------------------------------"; run_cmd "; Distribution type - /etc/issue" '; cat /etc/issue 2>/dev/null || echo "/etc/issue not found"'

}; run_cmd "; Distribution info - /etc/*-release" '; cat /etc/*-release 2>/dev/null || echo "; No *-release files found"'

run_cmd "; Debian-based distribution (lsb-release)" '; cat /etc/lsb-release 2>/dev/null || echo "/etc/lsb-release not found"'

run_cmd() {; run_cmd "; RedHat-based distribution (/etc/redhat-release)" '; cat /etc/redhat-release 2>/dev/null || echo "/etc/redhat-release not found"'

    local title="$1"

    shift############################

    print_subsection "$title"# 3. Kernel version

    bash -c "$*" 2>/dev/null || echo "[!] Command failed or not available"############################

    echorun_cmd "; Kernel version - /proc/version" '; cat /proc/version 2>/dev/null || echo "/proc/version not accessible"'

}; run_cmd "; uname -a (all system info)" '; uname -a 2>/dev/null'

run_cmd "; uname -mrs (machine, release, system)" '; uname -mrs 2>/dev/null'

run_cmd_safe() {; run_cmd "; Is 64-bit? (arch check)" '; file /bin/bash 2>/dev/null'

    local title="$1"; run_cmd "; Is 64-bit? (uname -m)" '; uname -m 2>/dev/null'

    shiftrun_cmd "; Is 64-bit? (dpkg check)" '; dpkg --print-architecture 2>/dev/null || echo "; dpkg check not available"'

    print_subsection "$title"; run_cmd "; Kernel RPM package info" '; rpm -q kernel 2>/dev/null || echo "; rpm not available or kernel not installed via RPM"'

    if ! bash -c "$*" 2>/dev/null; thenrun_cmd "; Kernel boot messages (dmesg | grep Linux)" '; dmesg 2>/dev/null | grep -i linux | head -20 || echo "; dmesg not accessible"'

        echo "[!] $title - Command failed or not available"; run_cmd "; Kernel images in /boot" '; ls -lah /boot/ 2>/dev/null | grep vmlinuz || echo "; No vmlinuz files found in /boot"'

    fi

    echo############################

}# 4. System / kernel / arch

############################

################################################################################run_cmd "; file /bin/bash (arch + type)" '; file /bin/bash 2>/dev/null'

# SECTION 1: SYSTEM INFORMATION & FINGERPRINTING

############################################################################################################

# 5. Is there a printer?

section_system_info() {############################

    print_section "1. SYSTEM INFORMATION & FINGERPRINTING"; run_cmd "; Printer information (lpstat -a)" '; lpstat -a 2>/dev/null || echo "; lpstat not available or no printers"'

    

    print_subsection "; Distribution Information"############################

    cat /etc/issue 2>/dev/null || echo "[!] /etc/issue not found"# 6. Services and privileges

    echo############################

    run_cmd "; Running services (ps aux)" '; ps aux 2>/dev/null || echo "; ps aux not accessible"'

    print_subsection "; OS Release Files"; run_cmd "; Running services (ps -ef)" '; ps -ef 2>/dev/null || echo "; ps -ef not accessible"'

    cat /etc/*-release 2>/dev/null || echo "[!] No *-release files found"; run_cmd "; Running services (top -b -n 1)" '; top -b -n 1 2>/dev/null | head -30 || echo "; top not available"'

    echorun_cmd "; Service list (/etc/services)" '; cat /etc/services 2>/dev/null | head -50 || echo "/etc/services not found"'

    

    run_cmd "; Debian/Ubuntu LSB Release" "; cat /etc/lsb-release"############################

    run_cmd "; RedHat/CentOS Release" "; cat /etc/redhat-release"# 7. Services running as root

    run_cmd "; Kernel Version (uname -a)" "; uname -a"############################

    run_cmd "; Kernel Version (uname -mrs)" "; uname -mrs"; run_cmd "; Services running as root (ps aux | grep root)" '; ps aux 2>/dev/null | grep root --color=auto || echo "; No root processes found"'

    run_cmd "; Kernel Version (/proc/version)" "; cat /proc/version"; run_cmd "; Services running as root (ps -ef | grep root)" '; ps -ef 2>/dev/null | grep root --color=auto || echo "; No root processes found"'

    run_cmd "; Kernel Architecture" "; uname -m"

    run_cmd "; Kernel Binary Check (file /bin/bash)" "; file /bin/bash"############################

    run_cmd "; Kernel DEB Architecture" "; dpkg --print-architecture"# 8. Applications and versions

    run_cmd "; Kernel RPM Package" "; rpm -q kernel"############################

    run_cmd "; System Boot Messages" "; dmesg 2>/dev/null | grep -i linux | head -20"; run_cmd "; Installed applications in /usr/bin/" '; ls -alh /usr/bin/ 2>/dev/null | head -50'

    run_cmd "; Kernel Boot Images" "; ls -lah /boot/ 2>/dev/null | grep vmlinuz"; run_cmd "; Installed applications in /sbin/" '; ls -alh /sbin/ 2>/dev/null | head -50'

}; run_cmd "; Debian/Ubuntu packages (dpkg -l)" '; dpkg -l 2>/dev/null | head -50 || echo "; dpkg not available"'

run_cmd "; RedHat/CentOS packages (rpm -qa)" '; rpm -qa 2>/dev/null | head -50 || echo "; rpm not available"'

################################################################################run_cmd "; APT cache archives" '; ls -alh /var/cache/apt/archives/ 2>/dev/null || echo "/var/cache/apt/archives not accessible"'

# SECTION 2: CURRENT USER & PRIVILEGESrun_cmd "; YUM cache" '; ls -alh /var/cache/yum/ 2>/dev/null || echo "/var/cache/yum not accessible"'

################################################################################

############################

section_user_privileges() {# 9. Service configuration files

    print_section "2. CURRENT USER & PRIVILEGES"############################

    run_cmd "; syslog configuration" '; cat /etc/syslog.conf 2>/dev/null || echo "/etc/syslog.conf not found"'

    run_cmd "; Current User (id)" "; id"; run_cmd "; HTTP (chttp) configuration" '; cat /etc/chttp.conf 2>/dev/null || echo "/etc/chttp.conf not found"'

    run_cmd "; Current User (whoami)" "; whoami"; run_cmd "; Lighttpd configuration" '; cat /etc/lighttpd.conf 2>/dev/null || echo "/etc/lighttpd.conf not found"'

    run_cmd "; Groups for ${; TARGET_USER}" "; groups ${; TARGET_USER}"; run_cmd "; CUPS configuration" '; cat /etc/cups/cupsd.conf 2>/dev/null || echo "/etc/cups/cupsd.conf not found"'

    run_cmd "; sudo Configuration (sudo -l)" "; sudo -l 2>&1"; run_cmd "; Inetd configuration" '; cat /etc/inetd.conf 2>/dev/null || echo "/etc/inetd.conf not found"'

    run_cmd "/etc/sudoers Permissions" "; ls -lah /etc/sudoers 2>/dev/null"; run_cmd "; Apache2 configuration" '; cat /etc/apache2/apache2.conf 2>/dev/null || echo "/etc/apache2/apache2.conf not found"'

    run_cmd "; sudo Files" "; find /etc/sudoers.d -type f 2>/dev/null"; run_cmd "; MySQL configuration" '; cat /etc/my.cnf 2>/dev/null || cat /etc/my.conf 2>/dev/null || echo "; MySQL config not found"'

}; run_cmd "; Apache HTTPd configuration" '; cat /etc/httpd/conf/httpd.conf 2>/dev/null || echo "/etc/httpd/conf/httpd.conf not found"'

run_cmd "; LAMPP Apache configuration" '; cat /opt/lampp/etc/httpd.conf 2>/dev/null || echo "/opt/lampp/etc/httpd.conf not found"'

################################################################################run_cmd "; World-readable config files in /etc/" '; find /etc/ -readable -type f 2>/dev/null | head -30'

# SECTION 3: ENVIRONMENT & CONFIGURATION

############################################################################################################

# 10. Scheduled jobs

section_environment() {############################

    print_section "3. ENVIRONMENT & CONFIGURATION"; run_cmd "; User crontab - root" '; crontab -l 2>/dev/null || echo "; Cannot read crontab (not running as root)"'

    run_cmd "; User crontab - root (via sudo)" '; sudo crontab -l 2>/dev/null || echo "; Cannot read root crontab via sudo"'

    run_cmd "; Environment Variables" "; env | sort"; run_cmd "; Cron spool directory" '; ls -alh /var/spool/cron/ 2>/dev/null || echo "/var/spool/cron not accessible"'

    print_subsection "; Bash Profiles (System-wide)"; run_cmd "/etc cron files overview" '; ls -al /etc/ 2>/dev/null | grep cron || echo "; No cron files in /etc"'

    for file in /etc/profile /etc/bashrc /etc/bash.bashrc; dorun_cmd "/etc/cron.d" '; ls -al /etc/cron.d 2>/dev/null || echo "/etc/cron.d not found"'

        if [ -f "$file" ]; thenrun_cmd "/etc/cron.daily" '; ls -al /etc/cron.daily 2>/dev/null || echo "/etc/cron.daily not found"'

            echo "[+] $file"; run_cmd "/etc/cron.weekly" '; ls -al /etc/cron.weekly 2>/dev/null || echo "/etc/cron.weekly not found"'

            head -20 "$file"; run_cmd "/etc/cron.monthly" '; ls -al /etc/cron.monthly 2>/dev/null || echo "/etc/cron.monthly not found"'

            echorun_cmd "/etc/cron.hourly" '; ls -al /etc/cron.hourly 2>/dev/null || echo "/etc/cron.hourly not found"'

        firun_cmd "/etc/crontab" '; cat /etc/crontab 2>/dev/null || echo "/etc/crontab not found"'

    donerun_cmd "/etc/anacrontab" '; cat /etc/anacrontab 2>/dev/null || echo "/etc/anacrontab not found"'

    run_cmd "; at.allow" '; cat /etc/at.allow 2>/dev/null || echo "/etc/at.allow not found"'

    print_subsection "; Bash Profiles (User)"; run_cmd "; at.deny" '; cat /etc/at.deny 2>/dev/null || echo "/etc/at.deny not found"'

    for file in ~/.bash_profile ~/.bashrc ~/.bash_logout ~/.profile; dorun_cmd "; cron.allow" '; cat /etc/cron.allow 2>/dev/null || echo "/etc/cron.allow not found"'

        if [ -f "$file" ]; thenrun_cmd "; cron.deny" '; cat /etc/cron.deny 2>/dev/null || echo "/etc/cron.deny not found"'

            echo "[+] $file"

            head -20 "$file"############################

            echo# 11. Plain text credentials search

        fi############################

    donerun_cmd "; Search for password/user patterns in common locations" '

}; for dir in /home /root /var/www /opt; do

    if [ -d "$dir" ]; then

################################################################################        echo "[*] Searching in $dir..."

# SECTION 4: RUNNING PROCESSES & SERVICES        find "$dir" -type f 2>/dev/null | head -20 | while read file; do

################################################################################            if grep -i "; password\|passwd\|pwd" "$file" 2>/dev/null | head -1; then

                echo "  Found in: $file"

section_processes() {            fi

    print_section "4. RUNNING PROCESSES & SERVICES"        done

        fi

    run_cmd "; All Running Processes (ps aux)" "; ps aux"; done

    run_cmd "; All Running Processes (ps -ef)" "; ps -ef"'

    run_cmd "; Running Services (top snapshot)" "; top -b -n 1 | head -50"; run_cmd "; Search for credentials in PHP files" '; find / -name "*.php" -type f 2>/dev/null | xargs grep -l "; password\|passwd\|user" 2>/dev/null | head -20'

    run_cmd "; Services Running as root (ps aux)" "; ps aux 2>/dev/null | grep -i '; root' | head -20"; run_cmd "; Search for credentials in config files" '; grep -r "; password\|passwd" /etc/ 2>/dev/null | head -20'

    run_cmd "; Services Running as root (ps -ef)" "; ps -ef 2>/dev/null | grep -i '; root' | head -20"

    run_cmd "; Network Services List" "; cat /etc/services 2>/dev/null | head -50"############################

    run_cmd "; File Capabilities" "; getcap -r / 2>/dev/null | head -30"# 12. Are we a real user? sudo?

}############################

run_cmd "; sudo -l (may prompt for password)" '; sudo -l 2>/dev/null || echo "; sudo -l failed or needs password"'

################################################################################run_cmd "; Permissions on /etc/sudoers" '; ls -lsaht /etc/sudoers 2>/dev/null'

# SECTION 5: INSTALLED SOFTWARE & PACKAGES

############################################################################################################

# 13. Exotic groups for TARGET_USER

section_packages() {############################

    print_section "5. INSTALLED SOFTWARE & PACKAGES"; run_cmd "; Groups for ${; TARGET_USER}" "; groups ${; TARGET_USER} 2>/dev/null || echo '; Cannot get groups for ${; TARGET_USER}'"

    

    print_subsection "; Development Tools"############################

    for tool in gcc cc python python3 perl perl5 ruby java javac; do# 14. Environment variables

        if which "$tool" 2>/dev/null; then############################

            echo "[+] $tool found: $(which $tool)"; run_cmd "; Environment (env)" '; env 2>/dev/null'

        firun_cmd "; Bash profile (/etc/profile)" '; cat /etc/profile 2>/dev/null || echo "/etc/profile not found"'

    donerun_cmd "; Bash rc (/etc/bashrc)" '; cat /etc/bashrc 2>/dev/null || echo "/etc/bashrc not found"'

    echorun_cmd "; User bash profile (~/.bash_profile)" '; cat ~/.bash_profile 2>/dev/null || echo "~/.bash_profile not found"'

    run_cmd "; User bashrc (~/.bashrc)" '; cat ~/.bashrc 2>/dev/null || echo "~/.bashrc not found"'

    print_subsection "; Package Managers"; run_cmd "; User bash_logout (~/.bash_logout)" '; cat ~/.bash_logout 2>/dev/null || echo "~/.bash_logout not found"'

    run_cmd "; Debian Packages (dpkg -l)" "; dpkg -l 2>/dev/null | head -100"; run_cmd "; Set variables (set)" '; set 2>/dev/null | head -50'

    run_cmd "; RedHat Packages (rpm -qa)" "; rpm -qa 2>/dev/null | head -100"

    ############################

    print_subsection "; Package Caches"# 15. NICs and network connectivity

    run_cmd "; APT Cache" "; ls -alh /var/cache/apt/archives/ 2>/dev/null | head -20"############################

    run_cmd "; YUM Cache" "; ls -alh /var/cache/yum/ 2>/dev/null | head -20"; run_cmd "; Network interfaces - ifconfig" '; ifconfig -a 2>/dev/null || echo "; ifconfig not available"'

    run_cmd "; Network interfaces - ip addr" '; ip addr 2>/dev/null || echo "; ip command not available"'

    print_subsection "; Important Binaries"; run_cmd "; Network interfaces configuration" '; cat /etc/network/interfaces 2>/dev/null || echo "/etc/network/interfaces not found"'

    run_cmd "; Binaries in /usr/bin" "; ls -alh /usr/bin/ 2>/dev/null | head -50"; run_cmd "; Network configuration - sysconfig/network" '; cat /etc/sysconfig/network 2>/dev/null || echo "/etc/sysconfig/network not found"'

    run_cmd "; Binaries in /sbin" "; ls -alh /sbin/ 2>/dev/null | head -50"

    run_cmd "; Local Binaries" "; ls -alh /usr/local/bin/ 2>/dev/null | head -30"############################

}# 16. Network configuration details

############################

################################################################################run_cmd "; DNS configuration (/etc/resolv.conf)" '; cat /etc/resolv.conf 2>/dev/null || echo "/etc/resolv.conf not found"'

# SECTION 6: NETWORK & COMMUNICATIONSrun_cmd "; Network details (/etc/networks)" '; cat /etc/networks 2>/dev/null || echo "/etc/networks not found"'

################################################################################run_cmd "; IPTables rules" '; iptables -L 2>/dev/null || echo "; iptables not available or not accessible"'

run_cmd "; Hostname" '; hostname 2>/dev/null || echo "; hostname command failed"'

section_network() {; run_cmd "; DNS domain name" '; dnsdomainname 2>/dev/null || echo "; dnsdomainname not available"'

    print_section "6. NETWORK & COMMUNICATIONS"; run_cmd "; Listening ports (netstat -tulpn)" '; netstat -tulpn 2>/dev/null || ss -tulpn 2>/dev/null || echo "; netstat/ss not available"'

    

    print_subsection "; Network Interfaces"############################

    run_cmd "; Network Config (ifconfig)" "; ifconfig -a"# 17. Other users and hosts communicating

    run_cmd "; Network Config (ip addr)" "; ip addr show"############################

    run_cmd "; Network Interfaces File" "; cat /etc/network/interfaces 2>/dev/null"; run_cmd "; Open files and network connections (lsof -i)" '; lsof -i 2>/dev/null || echo "; lsof not available"'

    run_cmd "; Sysconfig Network" "; cat /etc/sysconfig/network 2>/dev/null"; run_cmd "; Connections on port 80 (lsof -i :80)" '; lsof -i :80 2>/dev/null || echo "; lsof not available"'

    run_cmd "; Network services (/etc/services port 80)" '; grep 80 /etc/services 2>/dev/null || echo "; Port 80 not found in /etc/services"'

    print_subsection "; Network Services"; run_cmd "; Active TCP/UDP connections (netstat -antup)" '; netstat -antup 2>/dev/null || ss -antup 2>/dev/null || echo "; netstat/ss not available"'

    run_cmd "; Listening Ports (netstat)" "; netstat -tulpn 2>/dev/null || ss -tulpn 2>/dev/null"; run_cmd "; Active connections extended (netstat -antpx)" '; netstat -antpx 2>/dev/null || echo "; netstat not available"'

    run_cmd "; All Connections (netstat)" "; netstat -antup 2>/dev/null || ss -antup 2>/dev/null"; run_cmd "; Listening ports and processes (netstat -tunlp)" '; netstat -tunlp 2>/dev/null || ss -tunlp 2>/dev/null || echo "; netstat/ss not available"'

    run_cmd "; DNS Configuration" "; cat /etc/resolv.conf 2>/dev/null"; run_cmd "; Service startup status (chkconfig --list)" '; chkconfig --list 2>/dev/null || echo "; chkconfig not available"'

    run_cmd "; Hostname" "; hostname && echo && dnsdomainname"; run_cmd "; Services enabled on runlevel 3 (chkconfig --list | grep 3:on)" '; chkconfig --list 2>/dev/null | grep "3:on" || echo "; chkconfig not available"'

    run_cmd "; Routing Table" "; route -n 2>/dev/null || ip route show"; run_cmd "; Last logins (last)" '; last 2>/dev/null | head -20 || echo "; last command not available"'

    run_cmd "; ARP Cache" "; arp -e 2>/dev/null || arp -a 2>/dev/null"; run_cmd "; Currently logged in users (w)" '; w 2>/dev/null || echo "; w command not available"'

    

    print_subsection "; Service Management"############################

    run_cmd "; Runlevel Services (chkconfig)" "; chkconfig --list 2>/dev/null | head -50"# 18. IP and MAC address cache

    run_cmd "; Systemd Services" "; systemctl list-unit-files --type=service 2>/dev/null | head -50"############################

    run_cmd "; Open Network Connections (lsof)" "; lsof -i 2>/dev/null | head -30"; run_cmd "; ARP cache (arp -e)" '; arp -e 2>/dev/null || arp -a 2>/dev/null || echo "; arp not available"'

}; run_cmd "; Routing table (route)" '; route 2>/dev/null || echo "; route not available"'

run_cmd "; Routing table extended (route -nee)" '/sbin/route -nee 2>/dev/null || route -n 2>/dev/null || echo "; route not available"'

################################################################################

# SECTION 7: SCHEDULED JOBS & CRON############################

################################################################################# 19. Packet sniffing capability

############################

section_cron() {; run_cmd "; Packet sniffing - tcpdump available?" '; which tcpdump 2>/dev/null || echo "; tcpdump not found"'

    print_section "7. SCHEDULED JOBS & CRON"; run_cmd "; Packet sniffing example (tcpdump -n -c 5)" '; tcpdump -n -c 5 2>/dev/null || echo "; tcpdump not available or insufficient permissions"'

    

    run_cmd "; User Crontab" "; crontab -l 2>/dev/null"############################

    run_cmd "; Root Crontab (sudo)" "; sudo crontab -l 2>/dev/null"# 20. Shell interaction and port forwarding

    run_cmd "; System Crontab" "; cat /etc/crontab 2>/dev/null"############################

    run_cmd "; Anacrontab" "; cat /etc/anacrontab 2>/dev/null"; run_cmd "; Netcat tools availability" '

    which nc 2>/dev/null || echo "; nc: not found"

    print_subsection "; Cron Directories"; which ncat 2>/dev/null || echo "; ncat: not found"

    for dir in /etc/cron.d /etc/cron.daily /etc/cron.weekly /etc/cron.monthly /etc/cron.hourly; dowhich nc.traditional 2>/dev/null || echo "; nc.traditional: not found"

        if [ -d "$dir" ]; thenwhich socat 2>/dev/null || echo "; socat: not found"

            echo "[+] $dir"'

            ls -lah "$dir" 2>/dev/null | head -20run_cmd "; SSH tunneling capability (ssh available?)" '; which ssh 2>/dev/null && echo "; SSH available for tunneling" || echo "; SSH not available"'

            echorun_cmd "; Rinetd availability" '; which rinetd 2>/dev/null || echo "; rinetd not found"'

        fi

    done############################

    # 21. User information

    print_subsection "; Cron Access Controls"############################

    run_cmd "; at.allow" "; cat /etc/at.allow 2>/dev/null"; run_cmd "; Current user (id)" '; id 2>/dev/null || echo "; id command failed"'

    run_cmd "; at.deny" "; cat /etc/at.deny 2>/dev/null"; run_cmd "; Current user (whoami)" '; whoami 2>/dev/null || echo "; whoami command failed"'

    run_cmd "; cron.allow" "; cat /etc/cron.allow 2>/dev/null"; run_cmd "; Logged in users (who)" '; who 2>/dev/null || echo "; who command failed"'

    run_cmd "; cron.deny" "; cat /etc/cron.deny 2>/dev/null"; run_cmd "; Last logged in users (last)" '; last 2>/dev/null | head -10 || echo "; last command failed"'

    run_cmd "; Users list from /etc/passwd" '; cat /etc/passwd 2>/dev/null | cut -d: -f1 || echo "/etc/passwd not accessible"'

    run_cmd "; Cron Spool Directory" "; ls -alh /var/spool/cron/ 2>/dev/null"; run_cmd "; Super users (UID 0)" '; grep -v -E "^#" /etc/passwd 2>/dev/null | awk -F: "$3 == 0 { print \$1}" || echo "/etc/passwd not accessible"'

}; run_cmd "; All users with UID 0" '; awk -F: "(\$3 == 0) {; print}" /etc/passwd 2>/dev/null || echo "/etc/passwd not accessible"'

run_cmd "; sudo configuration (sudoers)" '; cat /etc/sudoers 2>/dev/null || echo "/etc/sudoers not readable (normal without sudo)"'

################################################################################

# SECTION 8: FILE PERMISSIONS & SECURITY############################

################################################################################# 22. Sensitive files

############################

section_file_permissions() {; run_cmd "/etc/passwd" '; cat /etc/passwd 2>/dev/null || echo "/etc/passwd not accessible"'

    print_section "8. FILE PERMISSIONS & SECURITY"; run_cmd "/etc/group" '; cat /etc/group 2>/dev/null || echo "/etc/group not accessible"'

    run_cmd "/etc/shadow (if readable)" '; cat /etc/shadow 2>/dev/null || echo "/etc/shadow not readable (normal)"'

    print_subsection "; SUID Binaries"; run_cmd "; Mail directory (/var/mail)" '; ls -alh /var/mail/ 2>/dev/null || echo "/var/mail not accessible"'

    run_cmd "; SUID Files" "; find / -perm -4000 -type f 2>/dev/null | head -50"

    ############################

    print_subsection "; SGID Binaries"# 23. User histories and sensitive data

    run_cmd "; SGID Files" "; find / -perm -2000 -type f 2>/dev/null | head -50"############################

    run_cmd "; Bash history (~/.bash_history)" '; cat ~/.bash_history 2>/dev/null || echo "~/.bash_history not found or not readable"'

    print_subsection "; Sticky Bit Directories"; run_cmd "; Nano history (~/.nano_history)" '; cat ~/.nano_history 2>/dev/null || echo "~/.nano_history not found"'

    run_cmd "; Sticky Bit" "; find / -perm -1000 -type d 2>/dev/null | head -30"; run_cmd "; ATFTP history (~/.atftp_history)" '; cat ~/.atftp_history 2>/dev/null || echo "~/.atftp_history not found"'

    run_cmd "; MySQL history (~/.mysql_history)" '; cat ~/.mysql_history 2>/dev/null || echo "~/.mysql_history not found"'

    print_subsection "; World-Writable Locations"; run_cmd "; PHP history (~/.php_history)" '; cat ~/.php_history 2>/dev/null || echo "~/.php_history not found"'

    for dir in /tmp /var/tmp /dev/shm; do

        if [ -d "$dir" ]; then############################

            echo "[+] $dir Permissions:"# 24. SSH keys and authentication

            ls -ld "$dir"############################

            echorun_cmd "; SSH authorized_keys (~/.ssh/authorized_keys)" '; cat ~/.ssh/authorized_keys 2>/dev/null || echo "~/.ssh/authorized_keys not found"'

        firun_cmd "; SSH identity.pub (~/.ssh/identity.pub)" '; cat ~/.ssh/identity.pub 2>/dev/null || echo "~/.ssh/identity.pub not found"'

    donerun_cmd "; SSH identity (~/.ssh/identity)" '; cat ~/.ssh/identity 2>/dev/null || echo "~/.ssh/identity not found"'

    run_cmd "; SSH id_rsa.pub (~/.ssh/id_rsa.pub)" '; cat ~/.ssh/id_rsa.pub 2>/dev/null || echo "~/.ssh/id_rsa.pub not found"'

    run_cmd "; World-Writable Directories" "; find / -type d -perm -0002 2>/dev/null | head -30"; run_cmd "; SSH id_rsa (~/.ssh/id_rsa)" '; cat ~/.ssh/id_rsa 2>/dev/null || echo "~/.ssh/id_rsa not found or not readable"'

    run_cmd "; World-Writable Files (no sticky)" "; find / -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null | head -20"; run_cmd "; SSH id_dsa.pub (~/.ssh/id_dsa.pub)" '; cat ~/.ssh/id_dsa.pub 2>/dev/null || echo "~/.ssh/id_dsa.pub not found"'

}; run_cmd "; SSH id_dsa (~/.ssh/id_dsa)" '; cat ~/.ssh/id_dsa 2>/dev/null || echo "~/.ssh/id_dsa not found"'

run_cmd "; SSH system config (/etc/ssh/ssh_config)" '; cat /etc/ssh/ssh_config 2>/dev/null || echo "/etc/ssh/ssh_config not found"'

################################################################################run_cmd "; SSH daemon config (/etc/ssh/sshd_config)" '; cat /etc/ssh/sshd_config 2>/dev/null || echo "/etc/ssh/sshd_config not found"'

# SECTION 9: FILE SYSTEMS & MOUNTSrun_cmd "; SSH host DSA public key" '; cat /etc/ssh/ssh_host_dsa_key.pub 2>/dev/null || echo "; Host DSA key not found"'

################################################################################run_cmd "; SSH host DSA private key" '; cat /etc/ssh/ssh_host_dsa_key 2>/dev/null || echo "; Host DSA key not readable"'

run_cmd "; SSH host RSA public key" '; cat /etc/ssh/ssh_host_rsa_key.pub 2>/dev/null || echo "; Host RSA key not found"'

section_filesystems() {; run_cmd "; SSH host RSA private key" '; cat /etc/ssh/ssh_host_rsa_key 2>/dev/null || echo "; Host RSA key not readable"'

    print_section "9. FILE SYSTEMS & MOUNTS"; run_cmd "; SSH host key.pub" '; cat /etc/ssh/ssh_host_key.pub 2>/dev/null || echo "; Host key not found"'

    run_cmd "; SSH host key" '; cat /etc/ssh/ssh_host_key 2>/dev/null || echo "; Host key not readable"'

    run_cmd "; Currently Mounted Filesystems" "; mount"

    run_cmd "; Disk Usage" "; df -h"############################

    run_cmd "/etc/fstab" "; cat /etc/fstab 2>/dev/null"# 25. Writable configuration files in /etc/

    run_cmd "; NFS Exports" "; cat /etc/exports 2>/dev/null"############################

}; run_cmd "; World-writable files in /etc/ (anyone)" '; find /etc/ -readable -type f 2>/dev/null | head -30'

run_cmd "; Owner-writable config files in /etc/" '; ls -aRl /etc/ 2>/dev/null | awk "$1 ~ /^..w/" | head -30'

################################################################################run_cmd "; Group-writable config files in /etc/" '; ls -aRl /etc/ 2>/dev/null | awk "$1 ~ /^.....w/" | head -30'

# SECTION 10: USERS & ACCOUNTSrun_cmd "; Other-writable config files in /etc/" '; find /etc/ -writable -type f 2>/dev/null | head -20'

################################################################################

############################

section_users() {# 26. Advanced Linux file permissions (Sticky bits, SUID, GUID)

    print_section "10. USERS & ACCOUNTS"############################

    run_cmd "; Sticky bit files (find / -perm -1000 -type d)" '; find / -perm -1000 -type d 2>/dev/null | head -20'

    run_cmd "; User List (/etc/passwd)" "; cat /etc/passwd"; run_cmd "; SGID files (find / -perm -g=s -type f)" '; find / -perm -g=s -type f 2>/dev/null | head -30'

    run_cmd "; Group List (/etc/group)" "; cat /etc/group"; run_cmd "; SUID files (find / -perm -u=s -type f)" '; find / -perm -u=s -type f 2>/dev/null | head -30'

    run_cmd "; Shadow File (/etc/shadow)" "; cat /etc/shadow 2>/dev/null"; run_cmd "; SGID or SUID (find / -perm -g=s -o -perm -u=s -type f)" '; find / -perm -g=s -o -perm -u=s -type f 2>/dev/null | head -30'

    run_cmd "; SGID or SUID in common bin directories" '

    print_subsection "; User Accounts with UID 0"; for i in /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin; do

    grep -v -E '^#' /etc/passwd 2>/dev/null | awk -F: '$3 == 0 { print $0 }' || echo "[!] Cannot read /etc/passwd"    if [ -d "$i" ]; then

    echo        find "$i" \( -perm -4000 -o -perm -2000 \) -type f 2>/dev/null

        fi

    run_cmd "; Currently Logged In Users" "; who"; done | head -30

    run_cmd "; Login History" "; last 2>/dev/null | head -30"'

    run_cmd "; User Sessions" "; w"

}############################

# 27. World-writable and executable folders

############################################################################################################

# SECTION 11: SENSITIVE FILES & DATArun_cmd "; World-writable directories (find / -writable -type d)" '; find / -writable -type d 2>/dev/null | head -20'

################################################################################run_cmd "; World-writable and executable (find / -perm -o w -perm -o x -type d)" '; find / \( -perm -o w -perm -o x \) -type d 2>/dev/null | head -20'

run_cmd "; World-executable directories (find / -perm -o x -type d)" '; find / -perm -o x -type d 2>/dev/null | head -20'

section_sensitive_files() {

    print_section "11. SENSITIVE FILES & DATA"############################

    # 28. Problem files

    print_subsection "; SSH Keys & Configuration"############################

    for file in ~/.ssh/id_rsa ~/.ssh/id_dsa ~/.ssh/id_rsa.pub ~/.ssh/id_dsa.pub ~/.ssh/authorized_keys; dorun_cmd "; World-writable files without sticky bit" '; find / -xdev -type d \( -perm -0002 -a ! -perm -1000 \) -print 2>/dev/null | head -20'

        if [ -f "$file" ]; thenrun_cmd "; Files with no owner (find / -nouser)" '; find /dir -xdev \( -nouser -o -nogroup \) -print 2>/dev/null | head -20'

            echo "[+] Found: $file"

            ls -lah "$file"############################

            echo# 29. Home directories overview

        fi############################

    donerun_cmd "; List /home/" '; ls -lsaht /home 2>/dev/null || echo "/home not accessible"'

    run_cmd "; Recursive listing of /home (look for .ssh, config, etc.)" '; ls -lsaR /home 2>/dev/null | head -100'

    run_cmd "; SSH Client Config" "; cat ~/.ssh/config 2>/dev/null"; run_cmd "; Recursive listing of /root" '; ls -lsaR /root 2>/dev/null | head -100'

    run_cmd "; SSH System Config" "; cat /etc/ssh/ssh_config 2>/dev/null"

    run_cmd "; SSH Daemon Config" "; cat /etc/ssh/sshd_config 2>/dev/null"############################

    # 30. File capabilities (getcap)

    print_subsection "; System SSH Keys"############################

    for file in /etc/ssh/ssh_host_*_key*; dorun_cmd "; File capabilities (getcap -r /)" '

        if [ -f "$file" ]; thenif command -v getcap >/dev/null 2>&1; then

            echo "[+] $file"    getcap -r / 2>/dev/null

            ls -lah "$file"; else

            echo    echo "; getcap not installed"

        fifi

    done'

    

    print_subsection "; Command Histories"############################

    for file in ~/.bash_history ~/.mysql_history ~/.php_history ~/.nano_history; do# 31. Quick look in important dirs

        if [ -f "$file" ]; then############################

            echo "[+] Found: $file"; run_cmd "; ls -lsaht /var/lib" '; ls -lsaht /var/lib 2>/dev/null | head -50'

            ls -lah "$file"; run_cmd "; ls -lsaht /var/db" '; ls -lsaht /var/db 2>/dev/null | head -50'

            wc -l "$file"; run_cmd "; ls -lsaht /opt" '; ls -lsaht /opt 2>/dev/null | head -50'

            echo "--- First 10 lines ---"; run_cmd "; ls -lsaht /tmp" '; ls -lsaht /tmp 2>/dev/null | head -50'

            head -10 "$file"; run_cmd "; ls -lsaht /var/tmp" '; ls -lsaht /var/tmp 2>/dev/null | head -50'

            echorun_cmd "; ls -lsaht /dev/shm" '; ls -lsaht /dev/shm 2>/dev/null | head -50'

        fi

    done############################

}# 32. NFS exports (potential NFS attacks)

############################

################################################################################run_cmd "/etc/exports (NFS shares)" '; cat /etc/exports 2>/dev/null || echo "/etc/exports not present or not readable"'

# SECTION 12: CONFIGURATION FILES

############################################################################################################

# 33. File systems and mounts

section_configs() {############################

    print_section "12. SERVICE CONFIGURATION FILES"; run_cmd "; Currently mounted filesystems (mount)" '; mount 2>/dev/null || echo "; mount command failed"'

    run_cmd "; Disk usage (df -h)" '; df -h 2>/dev/null || echo "; df command failed"'

    print_subsection "; Web Server Configurations"; run_cmd "; fstab - mount options" '; cat /etc/fstab 2>/dev/null || echo "/etc/fstab not accessible"'

    for file in /etc/apache2/apache2.conf /etc/httpd/conf/httpd.conf /etc/nginx/nginx.conf /etc/lighttpd/lighttpd.conf; do

        if [ -f "$file" ]; then############################

            echo "[+] $file"# 34. Quick /etc recon

            head -30 "$file"############################

            echorun_cmd "; Quick look at /etc" '; ls -lsaht /etc 2>/dev/null | head -50'

        firun_cmd "; Config files in /etc (*.conf)" '; find /etc -name "*.conf" 2>/dev/null | head -30'

    donerun_cmd ".secret-looking files in /etc" '; find /etc -name "*secret*" 2>/dev/null'

    

    print_subsection "; Database Configurations"############################

    for file in /etc/mysql/my.cnf /etc/my.cnf /etc/postgresql/postgresql.conf; do# 35. Files owned by BOB_USER

        if [ -f "$file" ]; then############################

            echo "[+] $file"; run_cmd "; All files owned by user ${; BOB_USER}" "; find / -user '${; BOB_USER}' 2>/dev/null | head -20 || echo '; no files found for ${; BOB_USER} or find error'"

            head -30 "$file"

            echo############################

        fi# 36. File transfer capability recap

    done############################

    run_cmd "; Transfer tools recap + FTP-like binaries" '

    print_subsection "; Other Service Configs"; which wget 2>/dev/null || echo "; wget: not found"

    run_cmd "; Syslog Configuration" "; cat /etc/syslog.conf 2>/dev/null"; which curl 2>/dev/null || echo "; curl: not found"

    run_cmd "; Cups Configuration" "; cat /etc/cups/cupsd.conf 2>/dev/null"; which nc 2>/dev/null || echo "; nc: not found"

    run_cmd "; Inetd Configuration" "; cat /etc/inetd.conf 2>/dev/null"; which ncat 2>/dev/null || echo "; ncat: not found"

    run_cmd "; SAMBA Configuration" "; cat /etc/samba/smb.conf 2>/dev/null"; which socat 2>/dev/null || echo "; socat: not found"

}; which fetch 2>/dev/null || echo "; fetch: not found"

which ftp 2>/dev/null || echo "; ftp: not found"

################################################################################find /bin /sbin /usr/bin /usr/sbin -name "*ftp*" 2>/dev/null || echo "; no ftp-related binaries found"

# SECTION 13: LOG FILES & DIRECTORIES'

################################################################################

############################

section_logs() {# 37. EXTRA: check your big list of interesting files

    print_section "13. LOG FILES & IMPORTANT DIRECTORIES"############################

    run_cmd "; Extra interesting config/log/cred files (existence + first lines)" '

    print_subsection "; System Logs"; FILES="

    for dir in /var/log /var/adm/log; do/etc/passwd

        if [ -d "$dir" ]; then/etc/shadow

            echo "[+] $dir"/etc/aliases

            ls -lah "$dir" 2>/dev/null | head -30/etc/anacrontab

            echo/etc/apache2/apache2.conf

        fi/etc/apache2/httpd.conf

    done/etc/apache2/sites-enabled/000-default.conf

    /etc/at.allow

    print_subsection "; Web Server Logs"/etc/at.deny

    for dir in /var/log/apache2 /var/log/httpd /var/log/nginx; do/etc/bashrc

        if [ -d "$dir" ]; then/etc/bootptab

            echo "[+] $dir"/etc/chrootUsers

            ls -lah "$dir" 2>/dev/null/etc/chttp.conf

            echo/etc/cron.allow

        fi/etc/cron.deny

    done/etc/crontab

    /etc/cups/cupsd.conf

    print_subsection "; Important Directories"/etc/exports

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

section_credentials() {/etc/httpd/logs/access.log

    print_section "14. CREDENTIAL SEARCH"/etc/httpd/logs/error_log

    /etc/httpd/logs/error.log

    print_subsection "; Searching for common credential patterns..."/etc/httpd/php.ini

    /etc/httpd/srm.conf

    print_subsection "; PHP Database Credentials"/etc/inetd.conf

    find /var/www /opt /srv -name "*.php" -type f 2>/dev/null | while read file; do/etc/inittab

        if grep -l "; password\|passwd\|user\|db_" "$file" 2>/dev/null; then/etc/issue

            echo "[+] Potential credentials in: $file"/etc/knockd.conf

            grep -i "; password\|passwd\|user\|db_" "$file" | head -5/etc/lighttpd.conf

            echo/etc/lilo.conf

        fi/etc/logrotate.d/ftp

    done/etc/logrotate.d/proftpd

    /etc/logrotate.d/vsftpd.log

    print_subsection "; Config Files with Credentials"/etc/lsb-release

    grep -r "; password\|passwd\|api_key\|secret" /etc 2>/dev/null | grep -v "^Binary" | head -30/etc/motd

    echo/etc/modules.conf

}/etc/mtab

/etc/my.cnf

################################################################################/etc/my.conf

# SECTION 15: TRANSFER TOOLS AVAILABILITY/etc/mysql/my.cnf

################################################################################/etc/network/interfaces

/etc/networks

section_transfer_tools() {/etc/npasswd

    print_section "15. FILE TRANSFER & COMMUNICATION TOOLS"/etc/php.ini

    /etc/proftp.conf

    print_subsection "; File Transfer Tools"/etc/proftpd/proftpd.conf

    for tool in wget curl fetch ftp scp sftp rsync; do/etc/pure-ftpd.conf

        if command -v "$tool" >/dev/null 2>&1; then/etc/pureftpd.passwd

            echo "[+] $tool: $(which $tool)"/etc/pureftpd.pdb

        else/etc/pure-ftpd/pure-ftpd.conf

            echo "[-] $tool: not found"/etc/pure-ftpd/pure-ftpd.pdb

        fi/etc/pure-ftpd/putreftpd.pdb

    done/etc/redhat-release

    echo/etc/resolv.conf

    /etc/samba/smb.conf

    print_subsection "; Network Tools"/etc/snmpd.conf

    for tool in nc ncat netcat socat telnet ssh; do/etc/ssh/ssh_config

        if command -v "$tool" >/dev/null 2>&1; then/etc/ssh/sshd_config

            echo "[+] $tool: $(which $tool)"/etc/ssh/ssh_host_dsa_key

        else/etc/ssh/ssh_host_dsa_key.pub

            echo "[-] $tool: not found"/etc/ssh/ssh_host_key

        fi/etc/ssh/ssh_host_key.pub

    done/etc/sysconfig/network

    echo/etc/syslog.conf

    /etc/termcap

    print_subsection "; Packet Capture"/etc/vhcs2/proftpd/proftpd.conf

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

section_misc() {/proc/interrupts

    print_section "16. MISCELLANEOUS CHECKS"/proc/ioports

    /proc/meminfo

    run_cmd "; Printers (lpstat -a)" "; lpstat -a 2>/dev/null"/proc/modules

    run_cmd "; Files owned by ${; BOB_USER}" "; find / -user '${; BOB_USER}' 2>/dev/null | head -30"/proc/mounts

    run_cmd "; Files with no owner" "; find / -nouser 2>/dev/null | head -30"/proc/net/arp

}/proc/net/tcp

/proc/net/udp

################################################################################/proc/sched_debug

# MAIN EXECUTION/proc/self/cwd/app.py

################################################################################/proc/self/environ

/proc/self/net/arp

main() {/proc/stat

    clear/proc/swaps

    echo "================================================================================"/proc/version

    echo "             SIREN Security - Linux Reconnaissance & Audit Tool"/root/anaconda-ks.cfg

    echo "================================================================================"/usr/etc/pure-ftpd.conf

    echo "; Target User: ${; TARGET_USER}"/usr/lib/php.ini

    echo "; Search User: ${; BOB_USER}"/usr/lib/php/php.ini

    echo "; Start Time: $(date '+%Y-%m-%d %H:%M:%S')"/usr/local/apache/conf/modsec.conf

    echo "================================================================================"/usr/local/apache/conf/php.ini

    /usr/local/apache/log

    # Execute all sections/usr/local/apache/logs

    section_system_info/usr/local/apache/logs/access_log

    section_user_privileges/usr/local/apache/logs/access.log

    section_environment/usr/local/apache/audit_log

    section_processes/usr/local/apache/error_log

    section_packages/usr/local/apache/error.log

    section_network/usr/local/cpanel/logs

    section_cron/usr/local/cpanel/logs/access_log

    section_file_permissions/usr/local/cpanel/logs/error_log

    section_filesystems/usr/local/cpanel/logs/license_log

    section_users/usr/local/cpanel/logs/login_log

    section_sensitive_files/usr/local/cpanel/logs/stats_log

    section_configs/usr/local/etc/httpd/logs/access_log

    section_logs/usr/local/etc/httpd/logs/error_log

    section_credentials/usr/local/etc/php.ini

    section_transfer_tools/usr/local/etc/pure-ftpd.conf

    section_misc/usr/local/etc/pureftpd.pdb

    /usr/local/lib/php.ini

    # Final message/usr/local/php4/httpd.conf

    echo/usr/local/php4/httpd.conf.php

    echo "================================================================================"/usr/local/php4/lib/php.ini

    echo "                          Reconnaissance Complete!"/usr/local/php5/httpd.conf

    echo "                          End Time: $(date '+%Y-%m-%d %H:%M:%S')"/usr/local/php5/httpd.conf.php

    echo "================================================================================"/usr/local/php5/lib/php.ini

    echo/usr/local/php/httpd.conf

    echo "; NOTES:"/usr/local/php/httpd.conf.ini

    echo "- Run with '; sudo' for more comprehensive results"/usr/local/php/lib/php.ini

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
        ~/*) path="$HOME${; f#~}" ;;
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
echo "; pspy REMINDER (not run automatically):"
echo "  # Example:"
echo "  cd /var/tmp/"
echo "  chmod 755 pspy32 pspy64"
echo "  ./pspy64 -r /bin,/etc,/home,/opt,/var,/usr,/tmp -pf -i 1000"
echo "================================================================"
echo
