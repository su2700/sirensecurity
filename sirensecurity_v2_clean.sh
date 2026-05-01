#!/bin/bash#!/bin/bash

################################################################################# basic_enum.sh - Linux privilege escalation / system recon helper

# SIREN Security - Linux Privilege Escalation & System Reconnaissance Script# Usage:

# #   chmod +x basic_enum.sh

# A comprehensive enumeration tool for Linux systems audit and privilege #   ./basic_enum.sh

# escalation assessment. Organized by logical security domains.#

## Optional environment variables:

# Usage:#   TARGET_USER   - user to check group membership (default: $USER)

#   chmod +x sirensecurity.sh#   BOB_USER      - user for "find / -user" (default: bob)

#   ./sirensecurity.sh

#   TARGET_USER=admin ./sirensecurity.sh        (custom target user)TARGET_USER="${TARGET_USER:-$USER}"

#   BOB_USER=testuser ./sirensecurity.sh         (custom username for search)BOB_USER="${BOB_USER:-bob}"

#

# Optional Environment Variables:run_cmd() {

#   TARGET_USER   - User to check group membership (default: $USER)    local title="$1"

#   BOB_USER      - Username to search for files (default: bob)    shift

#   VERBOSE       - Increase output detail (not set for normal)    echo

################################################################################



set -o errexit; echo "----------------------------------------------------------------"

trap 'echo "[ERROR] An error occurred at line $LINENO"' ERR; bash -c "$*"

    echo

# Configuration}

TARGET_USER="${TARGET_USER:-$USER}"

BOB_USER="${BOB_USER:-bob}"echo "================================================================"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")echo "  Basic Linux enum script (S1REN-style)"

OUTPUT_DIR="${OUTPUT_DIR:-.}"echo "  TARGET_USER=${TARGET_USER}, BOB_USER=${BOB_USER}"

echo "================================================================"

# Color codes (optional)

COLOR_SECTION="\033[1;34m"

COLOR_SUBSECTION="\033[1;36m"

COLOR_SUCCESS="\033[1;32m"

COLOR_RESET="\033[0m"run_cmd "Which common compilers/interpreters & transfer tools exist?" '

which gcc 2>/dev/null || echo "gcc: not found"

################################################################################which cc 2>/dev/null || echo "cc: not found"

# UTILITY FUNCTIONSwhich python 2>/dev/null || echo "python: not found"

################################################################################which python3 2>/dev/null || echo "python3: not found"

which perl 2>/dev/null || echo "perl: not found"

print_section() {which wget 2>/dev/null || echo "wget: not found"

    local title="$1"which curl 2>/dev/null || echo "curl: not found"

    echowhich fetch 2>/dev/null || echo "fetch: not found"



    echo -e "${COLOR_SECTION}>>> ${title}${COLOR_RESET}"which ncat 2>/dev/null || echo "ncat: not found"



}which socat 2>/dev/null || echo "socat: not found"

'

print_subsection() {

    local title="$1"############################

    echo# 2. Distribution type and version

    echo -e "${COLOR_SUBSECTION}[*] ${title}${COLOR_RESET}"############################



}run_cmd "Distribution info - /etc/*-release" 'cat /etc/*-release 2>/dev/null || echo "No *-release files found"'

run_cmd "Debian-based distribution (lsb-release)" 'cat /etc/lsb-release 2>/dev/null || echo "/etc/lsb-release not found"'

run_cmd() {run_cmd "RedHat-based distribution (/etc/redhat-release)" 'cat /etc/redhat-release 2>/dev/null || echo "/etc/redhat-release not found"'

    local title="$1"

    shift############################



    bash -c "$*" 2>/dev/null || echo "[!] Command failed or not available"############################

    echorun_cmd "Kernel version - /proc/version" 'cat /proc/version 2>/dev/null || echo "/proc/version not accessible"'

}run_cmd "uname -a (all system info)" 'uname -a 2>/dev/null'

run_cmd "uname -mrs (machine, release, system)" 'uname -mrs 2>/dev/null'

run_cmd_safe() {run_cmd "Is 64-bit? (arch check)" 'file /bin/bash 2>/dev/null'

    local title="$1"run_cmd "Is 64-bit? (uname -m)" 'uname -m 2>/dev/null'

    shiftrun_cmd "Is 64-bit? (dpkg check)" 'dpkg --print-architecture 2>/dev/null || echo "dpkg check not available"'









    echo############################

}# 4. System / kernel / arch

############################

################################################################################run_cmd "file /bin/bash (arch + type)" 'file /bin/bash 2>/dev/null'

# SECTION 1: SYSTEM INFORMATION & FINGERPRINTING

############################################################################################################

# 5. Is there a printer?

section_system_info() {############################









    echo############################







    echorun_cmd "Service list (/etc/services)" 'cat /etc/services 2>/dev/null | head -50 || echo "/etc/services not found"'

























}run_cmd "Debian/Ubuntu packages (dpkg -l)" 'dpkg -l 2>/dev/null | head -50 || echo "dpkg not available"'

run_cmd "RedHat/CentOS packages (rpm -qa)" 'rpm -qa 2>/dev/null | head -50 || echo "rpm not available"'

################################################################################run_cmd "APT cache archives" 'ls -alh /var/cache/apt/archives/ 2>/dev/null || echo "/var/cache/apt/archives not accessible"'

# SECTION 2: CURRENT USER & PRIVILEGESrun_cmd "YUM cache" 'ls -alh /var/cache/yum/ 2>/dev/null || echo "/var/cache/yum not accessible"'

################################################################################

############################

section_user_privileges() {# 9. Service configuration files

















}run_cmd "Apache HTTPd configuration" 'cat /etc/httpd/conf/httpd.conf 2>/dev/null || echo "/etc/httpd/conf/httpd.conf not found"'

run_cmd "LAMPP Apache configuration" 'cat /opt/lampp/etc/httpd.conf 2>/dev/null || echo "/opt/lampp/etc/httpd.conf not found"'

################################################################################run_cmd "World-readable config files in /etc/" 'find /etc/ -readable -type f 2>/dev/null | head -30'

# SECTION 3: ENVIRONMENT & CONFIGURATION

############################################################################################################

# 10. Scheduled jobs

section_environment() {############################















            head -20 "$file"run_cmd "/etc/cron.monthly" 'ls -al /etc/cron.monthly 2>/dev/null || echo "/etc/cron.monthly not found"'

            echorun_cmd "/etc/cron.hourly" 'ls -al /etc/cron.hourly 2>/dev/null || echo "/etc/cron.hourly not found"'















            head -20 "$file"############################

            echo# 11. Plain text credentials search





}for dir in /home /root /var/www /opt; do



################################################################################

# SECTION 4: RUNNING PROCESSES & SERVICES

################################################################################



section_processes() {



















}############################

run_cmd "sudo -l (may prompt for password)" 'sudo -l 2>/dev/null || echo "sudo -l failed or needs password"'

################################################################################run_cmd "Permissions on /etc/sudoers" 'ls -lsaht /etc/sudoers 2>/dev/null'

# SECTION 5: INSTALLED SOFTWARE & PACKAGES

############################################################################################################

# 13. Exotic groups for TARGET_USER

section_packages() {############################

















    echorun_cmd "User bash profile (~/.bash_profile)" 'cat ~/.bash_profile 2>/dev/null || echo "~/.bash_profile not found"'









    ############################

















}# 16. Network configuration details

############################

################################################################################run_cmd "DNS configuration (/etc/resolv.conf)" 'cat /etc/resolv.conf 2>/dev/null || echo "/etc/resolv.conf not found"'

# SECTION 6: NETWORK & COMMUNICATIONSrun_cmd "Network details (/etc/networks)" 'cat /etc/networks 2>/dev/null || echo "/etc/networks not found"'

################################################################################run_cmd "IPTables rules" 'iptables -L 2>/dev/null || echo "iptables not available or not accessible"'

run_cmd "Hostname" 'hostname 2>/dev/null || echo "hostname command failed"'

section_network() {run_cmd "DNS domain name" 'dnsdomainname 2>/dev/null || echo "dnsdomainname not available"'









































}run_cmd "Routing table (route)" 'route 2>/dev/null || echo "route not available"'

run_cmd "Routing table extended (route -nee)" '/sbin/route -nee 2>/dev/null || route -n 2>/dev/null || echo "route not available"'

################################################################################

# SECTION 7: SCHEDULED JOBS & CRON############################

################################################################################# 19. Packet sniffing capability

############################

section_cron() {run_cmd "Packet sniffing - tcpdump available?" 'which tcpdump 2>/dev/null || echo "tcpdump not found"'

























            echorun_cmd "Rinetd availability" 'which rinetd 2>/dev/null || echo "rinetd not found"'





















}run_cmd "All users with UID 0" 'awk -F: "(\$3 == 0) {print}" /etc/passwd 2>/dev/null || echo "/etc/passwd not accessible"'

run_cmd "sudo configuration (sudoers)" 'cat /etc/sudoers 2>/dev/null || echo "/etc/sudoers not readable (normal without sudo)"'

################################################################################

# SECTION 8: FILE PERMISSIONS & SECURITY############################

################################################################################# 22. Sensitive files

############################

section_file_permissions() {run_cmd "/etc/passwd" 'cat /etc/passwd 2>/dev/null || echo "/etc/passwd not accessible"'









    ############################























            echorun_cmd "SSH authorized_keys (~/.ssh/authorized_keys)" 'cat ~/.ssh/authorized_keys 2>/dev/null || echo "~/.ssh/authorized_keys not found"'











}run_cmd "SSH id_dsa (~/.ssh/id_dsa)" 'cat ~/.ssh/id_dsa 2>/dev/null || echo "~/.ssh/id_dsa not found"'

run_cmd "SSH system config (/etc/ssh/ssh_config)" 'cat /etc/ssh/ssh_config 2>/dev/null || echo "/etc/ssh/ssh_config not found"'

################################################################################run_cmd "SSH daemon config (/etc/ssh/sshd_config)" 'cat /etc/ssh/sshd_config 2>/dev/null || echo "/etc/ssh/sshd_config not found"'

# SECTION 9: FILE SYSTEMS & MOUNTSrun_cmd "SSH host DSA public key" 'cat /etc/ssh/ssh_host_dsa_key.pub 2>/dev/null || echo "Host DSA key not found"'

################################################################################run_cmd "SSH host DSA private key" 'cat /etc/ssh/ssh_host_dsa_key 2>/dev/null || echo "Host DSA key not readable"'

run_cmd "SSH host RSA public key" 'cat /etc/ssh/ssh_host_rsa_key.pub 2>/dev/null || echo "Host RSA key not found"'

section_filesystems() {run_cmd "SSH host RSA private key" 'cat /etc/ssh/ssh_host_rsa_key 2>/dev/null || echo "Host RSA key not readable"'













}run_cmd "World-writable files in /etc/ (anyone)" 'find /etc/ -readable -type f 2>/dev/null | head -30'

run_cmd "Owner-writable config files in /etc/" 'ls -aRl /etc/ 2>/dev/null | awk "$1 ~ /^..w/" | head -30'

################################################################################run_cmd "Group-writable config files in /etc/" 'ls -aRl /etc/ 2>/dev/null | awk "$1 ~ /^.....w/" | head -30'

# SECTION 10: USERS & ACCOUNTSrun_cmd "Other-writable config files in /etc/" 'find /etc/ -writable -type f 2>/dev/null | head -20'

################################################################################

############################

section_users() {# 26. Advanced Linux file permissions (Sticky bits, SUID, GUID)















    grep -v -E '^#' /etc/passwd 2>/dev/null | awk -F: '$3 == 0 { print $0 }' || echo "[!] Cannot read /etc/passwd"

    echo









}############################

# 27. World-writable and executable folders

############################################################################################################

# SECTION 11: SENSITIVE FILES & DATArun_cmd "World-writable directories (find / -writable -type d)" 'find / -writable -type d 2>/dev/null | head -20'

################################################################################run_cmd "World-writable and executable (find / -perm -o w -perm -o x -type d)" 'find / \( -perm -o w -perm -o x \) -type d 2>/dev/null | head -20'

run_cmd "World-executable directories (find / -perm -o x -type d)" 'find / -perm -o x -type d 2>/dev/null | head -20'

section_sensitive_files() {















            echo# 29. Home directories overview

























            echo

















            wc -l "$file"run_cmd "ls -lsaht /opt" 'ls -lsaht /opt 2>/dev/null | head -50'



            head -10 "$file"run_cmd "ls -lsaht /var/tmp" 'ls -lsaht /var/tmp 2>/dev/null | head -50'

            echorun_cmd "ls -lsaht /dev/shm" 'ls -lsaht /dev/shm 2>/dev/null | head -50'





}# 32. NFS exports (potential NFS attacks)

############################

################################################################################run_cmd "/etc/exports (NFS shares)" 'cat /etc/exports 2>/dev/null || echo "/etc/exports not present or not readable"'

# SECTION 12: CONFIGURATION FILES

############################################################################################################

# 33. File systems and mounts

section_configs() {############################













            head -30 "$file"############################

            echorun_cmd "Quick look at /etc" 'ls -lsaht /etc 2>/dev/null | head -50'















            head -30 "$file"

            echo############################

















}which fetch 2>/dev/null || echo "fetch: not found"

which ftp 2>/dev/null || echo "ftp: not found"

################################################################################find /bin /sbin /usr/bin /usr/sbin -name "*ftp*" 2>/dev/null || echo "no ftp-related binaries found"

# SECTION 13: LOG FILES & DIRECTORIES'

################################################################################

############################

section_logs() {# 37. EXTRA: check your big list of interesting files















            echo/etc/apache2/apache2.conf





    /etc/at.allow











            echo/etc/cron.allow





    /etc/cups/cupsd.conf











            echo/etc/groups





}/etc/hosts.allow

/etc/hosts.deny

################################################################################/etc/httpd/access.conf

# SECTION 14: CREDENTIAL SEARCH/etc/httpd/conf/httpd.conf

################################################################################/etc/httpd/httpd.conf

/etc/httpd/logs/access_log

section_credentials() {/etc/httpd/logs/access.log



    /etc/httpd/logs/error.log



    /etc/httpd/srm.conf









            grep -i "password\|passwd\|user\|db_" "$file" | head -5/etc/lighttpd.conf

            echo/etc/lilo.conf





    /etc/logrotate.d/vsftpd.log



    grep -r "password\|passwd\|api_key\|secret" /etc 2>/dev/null | grep -v "^Binary" | head -30/etc/motd

    echo/etc/modules.conf

}/etc/mtab

/etc/my.cnf

################################################################################/etc/my.conf

# SECTION 15: TRANSFER TOOLS AVAILABILITY/etc/mysql/my.cnf

################################################################################/etc/network/interfaces

/etc/networks

section_transfer_tools() {/etc/npasswd



    /etc/proftp.conf









        else/etc/pure-ftpd/pure-ftpd.conf







    echo/etc/resolv.conf

    /etc/samba/smb.conf









        else/etc/ssh/ssh_host_dsa_key.pub







    echo/etc/syslog.conf

    /etc/termcap









        else/etc/wu-ftpd/ftpaccess







    echo/logs/security_debug_log

}/logs/security_log

/opt/lampp/etc/httpd.conf

################################################################################/opt/xampp/etc/php.ini

# SECTION 16: PRINTER & SERVICES CHECK/proc/cmdline

################################################################################/proc/cpuinfo

/proc/filesystems

section_misc() {/proc/interrupts



    /proc/meminfo







}/proc/net/tcp

/proc/net/udp

################################################################################/proc/sched_debug

# MAIN EXECUTION/proc/self/cwd/app.py

################################################################################/proc/self/environ

/proc/self/net/arp

main() {/proc/stat

    clear/proc/swaps















    /usr/local/apache/log



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



    echo/usr/local/php4/httpd.conf.php









    echo/usr/local/php/httpd.conf











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


        ~/*) path="$HOME${f#~}" ;;
        *)   path="$f" ;;





        head -n 10 "$path" 2>/dev/null
        echo

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
