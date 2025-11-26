#!/bin/bash
# basic_enum.sh - Linux privilege escalation / system recon helper
# Usage:
#   chmod +x basic_enum.sh
#   ./basic_enum.sh
#
# Optional environment variables:
#   TARGET_USER   - user to check group membership (default: $USER)
#   BOB_USER      - user for "find / -user" (default: bob)

TARGET_USER="${TARGET_USER:-$USER}"
BOB_USER="${BOB_USER:-bob}"

run_cmd() {
    local title="$1"
    shift
    echo
    echo "================================================================"
    echo ">>> $title"
    echo "----------------------------------------------------------------"
    bash -c "$*"
    echo
}

echo "================================================================"
echo "  Basic Linux enum script (S1REN-style)"
echo "  TARGET_USER=${TARGET_USER}, BOB_USER=${BOB_USER}"
echo "================================================================"

############################
# 1. Which binaries exist?
############################
run_cmd "Which common compilers/interpreters & transfer tools exist?" '
which gcc 2>/dev/null || echo "gcc: not found"
which cc 2>/dev/null || echo "cc: not found"
which python 2>/dev/null || echo "python: not found"
which python3 2>/dev/null || echo "python3: not found"
which perl 2>/dev/null || echo "perl: not found"
which wget 2>/dev/null || echo "wget: not found"
which curl 2>/dev/null || echo "curl: not found"
which fetch 2>/dev/null || echo "fetch: not found"
which nc 2>/dev/null || echo "nc: not found"
which ncat 2>/dev/null || echo "ncat: not found"
which nc.traditional 2>/dev/null || echo "nc.traditional: not found"
which socat 2>/dev/null || echo "socat: not found"
'

############################
# 2. Distribution type and version
############################
run_cmd "Distribution type - /etc/issue" 'cat /etc/issue 2>/dev/null || echo "/etc/issue not found"'
run_cmd "Distribution info - /etc/*-release" 'cat /etc/*-release 2>/dev/null || echo "No *-release files found"'
run_cmd "Debian-based distribution (lsb-release)" 'cat /etc/lsb-release 2>/dev/null || echo "/etc/lsb-release not found"'
run_cmd "RedHat-based distribution (/etc/redhat-release)" 'cat /etc/redhat-release 2>/dev/null || echo "/etc/redhat-release not found"'

############################
# 3. Kernel version
############################
run_cmd "Kernel version - /proc/version" 'cat /proc/version 2>/dev/null || echo "/proc/version not accessible"'
run_cmd "uname -a (all system info)" 'uname -a 2>/dev/null'
run_cmd "uname -mrs (machine, release, system)" 'uname -mrs 2>/dev/null'
run_cmd "Is 64-bit? (arch check)" 'file /bin/bash 2>/dev/null'
run_cmd "Is 64-bit? (uname -m)" 'uname -m 2>/dev/null'
run_cmd "Is 64-bit? (dpkg check)" 'dpkg --print-architecture 2>/dev/null || echo "dpkg check not available"'
run_cmd "Kernel RPM package info" 'rpm -q kernel 2>/dev/null || echo "rpm not available or kernel not installed via RPM"'
run_cmd "Kernel boot messages (dmesg | grep Linux)" 'dmesg 2>/dev/null | grep -i linux | head -20 || echo "dmesg not accessible"'
run_cmd "Kernel images in /boot" 'ls -lah /boot/ 2>/dev/null | grep vmlinuz || echo "No vmlinuz files found in /boot"'

############################
# 4. System / kernel / arch
############################
run_cmd "file /bin/bash (arch + type)" 'file /bin/bash 2>/dev/null'

############################
# 5. Is there a printer?
############################
run_cmd "Printer information (lpstat -a)" 'lpstat -a 2>/dev/null || echo "lpstat not available or no printers"'

############################
# 6. Services and privileges
############################
run_cmd "Running services (ps aux)" 'ps aux 2>/dev/null || echo "ps aux not accessible"'
run_cmd "Running services (ps -ef)" 'ps -ef 2>/dev/null || echo "ps -ef not accessible"'
run_cmd "Running services (top -b -n 1)" 'top -b -n 1 2>/dev/null | head -30 || echo "top not available"'
run_cmd "Service list (/etc/services)" 'cat /etc/services 2>/dev/null | head -50 || echo "/etc/services not found"'

############################
# 7. Services running as root
############################
run_cmd "Services running as root (ps aux | grep root)" 'ps aux 2>/dev/null | grep root --color=auto || echo "No root processes found"'
run_cmd "Services running as root (ps -ef | grep root)" 'ps -ef 2>/dev/null | grep root --color=auto || echo "No root processes found"'

############################
# 8. Applications and versions
############################
run_cmd "Installed applications in /usr/bin/" 'ls -alh /usr/bin/ 2>/dev/null | head -50'
run_cmd "Installed applications in /sbin/" 'ls -alh /sbin/ 2>/dev/null | head -50'
run_cmd "Debian/Ubuntu packages (dpkg -l)" 'dpkg -l 2>/dev/null | head -50 || echo "dpkg not available"'
run_cmd "RedHat/CentOS packages (rpm -qa)" 'rpm -qa 2>/dev/null | head -50 || echo "rpm not available"'
run_cmd "APT cache archives" 'ls -alh /var/cache/apt/archives/ 2>/dev/null || echo "/var/cache/apt/archives not accessible"'
run_cmd "YUM cache" 'ls -alh /var/cache/yum/ 2>/dev/null || echo "/var/cache/yum not accessible"'

############################
# 9. Service configuration files
############################
run_cmd "syslog configuration" 'cat /etc/syslog.conf 2>/dev/null || echo "/etc/syslog.conf not found"'
run_cmd "HTTP (chttp) configuration" 'cat /etc/chttp.conf 2>/dev/null || echo "/etc/chttp.conf not found"'
run_cmd "Lighttpd configuration" 'cat /etc/lighttpd.conf 2>/dev/null || echo "/etc/lighttpd.conf not found"'
run_cmd "CUPS configuration" 'cat /etc/cups/cupsd.conf 2>/dev/null || echo "/etc/cups/cupsd.conf not found"'
run_cmd "Inetd configuration" 'cat /etc/inetd.conf 2>/dev/null || echo "/etc/inetd.conf not found"'
run_cmd "Apache2 configuration" 'cat /etc/apache2/apache2.conf 2>/dev/null || echo "/etc/apache2/apache2.conf not found"'
run_cmd "MySQL configuration" 'cat /etc/my.cnf 2>/dev/null || cat /etc/my.conf 2>/dev/null || echo "MySQL config not found"'
run_cmd "Apache HTTPd configuration" 'cat /etc/httpd/conf/httpd.conf 2>/dev/null || echo "/etc/httpd/conf/httpd.conf not found"'
run_cmd "LAMPP Apache configuration" 'cat /opt/lampp/etc/httpd.conf 2>/dev/null || echo "/opt/lampp/etc/httpd.conf not found"'
run_cmd "World-readable config files in /etc/" 'find /etc/ -readable -type f 2>/dev/null | head -30'

############################
# 10. Scheduled jobs
############################
run_cmd "User crontab - root" 'crontab -l 2>/dev/null || echo "Cannot read crontab (not running as root)"'
run_cmd "User crontab - root (via sudo)" 'sudo crontab -l 2>/dev/null || echo "Cannot read root crontab via sudo"'
run_cmd "Cron spool directory" 'ls -alh /var/spool/cron/ 2>/dev/null || echo "/var/spool/cron not accessible"'
run_cmd "/etc cron files overview" 'ls -al /etc/ 2>/dev/null | grep cron || echo "No cron files in /etc"'
run_cmd "/etc/cron.d" 'ls -al /etc/cron.d 2>/dev/null || echo "/etc/cron.d not found"'
run_cmd "/etc/cron.daily" 'ls -al /etc/cron.daily 2>/dev/null || echo "/etc/cron.daily not found"'
run_cmd "/etc/cron.weekly" 'ls -al /etc/cron.weekly 2>/dev/null || echo "/etc/cron.weekly not found"'
run_cmd "/etc/cron.monthly" 'ls -al /etc/cron.monthly 2>/dev/null || echo "/etc/cron.monthly not found"'
run_cmd "/etc/cron.hourly" 'ls -al /etc/cron.hourly 2>/dev/null || echo "/etc/cron.hourly not found"'
run_cmd "/etc/crontab" 'cat /etc/crontab 2>/dev/null || echo "/etc/crontab not found"'
run_cmd "/etc/anacrontab" 'cat /etc/anacrontab 2>/dev/null || echo "/etc/anacrontab not found"'
run_cmd "at.allow" 'cat /etc/at.allow 2>/dev/null || echo "/etc/at.allow not found"'
run_cmd "at.deny" 'cat /etc/at.deny 2>/dev/null || echo "/etc/at.deny not found"'
run_cmd "cron.allow" 'cat /etc/cron.allow 2>/dev/null || echo "/etc/cron.allow not found"'
run_cmd "cron.deny" 'cat /etc/cron.deny 2>/dev/null || echo "/etc/cron.deny not found"'

############################
# 11. Plain text credentials search
############################
run_cmd "Search for password/user patterns in common locations" '
for dir in /home /root /var/www /opt; do
    if [ -d "$dir" ]; then
        echo "[*] Searching in $dir..."
        find "$dir" -type f 2>/dev/null | head -20 | while read file; do
            if grep -i "password\|passwd\|pwd" "$file" 2>/dev/null | head -1; then
                echo "  Found in: $file"
            fi
        done
    fi
done
'
run_cmd "Search for credentials in PHP files" 'find / -name "*.php" -type f 2>/dev/null | xargs grep -l "password\|passwd\|user" 2>/dev/null | head -20'
run_cmd "Search for credentials in config files" 'grep -r "password\|passwd" /etc/ 2>/dev/null | head -20'

############################
# 12. Are we a real user? sudo?
############################
run_cmd "sudo -l (may prompt for password)" 'sudo -l 2>/dev/null || echo "sudo -l failed or needs password"'
run_cmd "Permissions on /etc/sudoers" 'ls -lsaht /etc/sudoers 2>/dev/null'

############################
# 13. Exotic groups for TARGET_USER
############################
run_cmd "Groups for ${TARGET_USER}" "groups ${TARGET_USER} 2>/dev/null || echo 'Cannot get groups for ${TARGET_USER}'"

############################
# 14. Environment variables
############################
run_cmd "Environment (env)" 'env 2>/dev/null'
run_cmd "Bash profile (/etc/profile)" 'cat /etc/profile 2>/dev/null || echo "/etc/profile not found"'
run_cmd "Bash rc (/etc/bashrc)" 'cat /etc/bashrc 2>/dev/null || echo "/etc/bashrc not found"'
run_cmd "User bash profile (~/.bash_profile)" 'cat ~/.bash_profile 2>/dev/null || echo "~/.bash_profile not found"'
run_cmd "User bashrc (~/.bashrc)" 'cat ~/.bashrc 2>/dev/null || echo "~/.bashrc not found"'
run_cmd "User bash_logout (~/.bash_logout)" 'cat ~/.bash_logout 2>/dev/null || echo "~/.bash_logout not found"'
run_cmd "Set variables (set)" 'set 2>/dev/null | head -50'

############################
# 15. NICs and network connectivity
############################
run_cmd "Network interfaces - ifconfig" 'ifconfig -a 2>/dev/null || echo "ifconfig not available"'
run_cmd "Network interfaces - ip addr" 'ip addr 2>/dev/null || echo "ip command not available"'
run_cmd "Network interfaces configuration" 'cat /etc/network/interfaces 2>/dev/null || echo "/etc/network/interfaces not found"'
run_cmd "Network configuration - sysconfig/network" 'cat /etc/sysconfig/network 2>/dev/null || echo "/etc/sysconfig/network not found"'

############################
# 16. Network configuration details
############################
run_cmd "DNS configuration (/etc/resolv.conf)" 'cat /etc/resolv.conf 2>/dev/null || echo "/etc/resolv.conf not found"'
run_cmd "Network details (/etc/networks)" 'cat /etc/networks 2>/dev/null || echo "/etc/networks not found"'
run_cmd "IPTables rules" 'iptables -L 2>/dev/null || echo "iptables not available or not accessible"'
run_cmd "Hostname" 'hostname 2>/dev/null || echo "hostname command failed"'
run_cmd "DNS domain name" 'dnsdomainname 2>/dev/null || echo "dnsdomainname not available"'
run_cmd "Listening ports (netstat -tulpn)" 'netstat -tulpn 2>/dev/null || ss -tulpn 2>/dev/null || echo "netstat/ss not available"'

############################
# 17. Other users and hosts communicating
############################
run_cmd "Open files and network connections (lsof -i)" 'lsof -i 2>/dev/null || echo "lsof not available"'
run_cmd "Connections on port 80 (lsof -i :80)" 'lsof -i :80 2>/dev/null || echo "lsof not available"'
run_cmd "Network services (/etc/services port 80)" 'grep 80 /etc/services 2>/dev/null || echo "Port 80 not found in /etc/services"'
run_cmd "Active TCP/UDP connections (netstat -antup)" 'netstat -antup 2>/dev/null || ss -antup 2>/dev/null || echo "netstat/ss not available"'
run_cmd "Active connections extended (netstat -antpx)" 'netstat -antpx 2>/dev/null || echo "netstat not available"'
run_cmd "Listening ports and processes (netstat -tunlp)" 'netstat -tunlp 2>/dev/null || ss -tunlp 2>/dev/null || echo "netstat/ss not available"'
run_cmd "Service startup status (chkconfig --list)" 'chkconfig --list 2>/dev/null || echo "chkconfig not available"'
run_cmd "Services enabled on runlevel 3 (chkconfig --list | grep 3:on)" 'chkconfig --list 2>/dev/null | grep "3:on" || echo "chkconfig not available"'
run_cmd "Last logins (last)" 'last 2>/dev/null | head -20 || echo "last command not available"'
run_cmd "Currently logged in users (w)" 'w 2>/dev/null || echo "w command not available"'

############################
# 18. IP and MAC address cache
############################
run_cmd "ARP cache (arp -e)" 'arp -e 2>/dev/null || arp -a 2>/dev/null || echo "arp not available"'
run_cmd "Routing table (route)" 'route 2>/dev/null || echo "route not available"'
run_cmd "Routing table extended (route -nee)" '/sbin/route -nee 2>/dev/null || route -n 2>/dev/null || echo "route not available"'

############################
# 19. Packet sniffing capability
############################
run_cmd "Packet sniffing - tcpdump available?" 'which tcpdump 2>/dev/null || echo "tcpdump not found"'
run_cmd "Packet sniffing example (tcpdump -n -c 5)" 'tcpdump -n -c 5 2>/dev/null || echo "tcpdump not available or insufficient permissions"'

############################
# 20. Shell interaction and port forwarding
############################
run_cmd "Netcat tools availability" '
which nc 2>/dev/null || echo "nc: not found"
which ncat 2>/dev/null || echo "ncat: not found"
which nc.traditional 2>/dev/null || echo "nc.traditional: not found"
which socat 2>/dev/null || echo "socat: not found"
'
run_cmd "SSH tunneling capability (ssh available?)" 'which ssh 2>/dev/null && echo "SSH available for tunneling" || echo "SSH not available"'
run_cmd "Rinetd availability" 'which rinetd 2>/dev/null || echo "rinetd not found"'

############################
# 21. User information
############################
run_cmd "Current user (id)" 'id 2>/dev/null || echo "id command failed"'
run_cmd "Current user (whoami)" 'whoami 2>/dev/null || echo "whoami command failed"'
run_cmd "Logged in users (who)" 'who 2>/dev/null || echo "who command failed"'
run_cmd "Last logged in users (last)" 'last 2>/dev/null | head -10 || echo "last command failed"'
run_cmd "Users list from /etc/passwd" 'cat /etc/passwd 2>/dev/null | cut -d: -f1 || echo "/etc/passwd not accessible"'
run_cmd "Super users (UID 0)" 'grep -v -E "^#" /etc/passwd 2>/dev/null | awk -F: "$3 == 0 { print \$1}" || echo "/etc/passwd not accessible"'
run_cmd "All users with UID 0" 'awk -F: "(\$3 == 0) {print}" /etc/passwd 2>/dev/null || echo "/etc/passwd not accessible"'
run_cmd "sudo configuration (sudoers)" 'cat /etc/sudoers 2>/dev/null || echo "/etc/sudoers not readable (normal without sudo)"'

############################
# 22. Sensitive files
############################
run_cmd "/etc/passwd" 'cat /etc/passwd 2>/dev/null || echo "/etc/passwd not accessible"'
run_cmd "/etc/group" 'cat /etc/group 2>/dev/null || echo "/etc/group not accessible"'
run_cmd "/etc/shadow (if readable)" 'cat /etc/shadow 2>/dev/null || echo "/etc/shadow not readable (normal)"'
run_cmd "Mail directory (/var/mail)" 'ls -alh /var/mail/ 2>/dev/null || echo "/var/mail not accessible"'

############################
# 23. User histories and sensitive data
############################
run_cmd "Bash history (~/.bash_history)" 'cat ~/.bash_history 2>/dev/null || echo "~/.bash_history not found or not readable"'
run_cmd "Nano history (~/.nano_history)" 'cat ~/.nano_history 2>/dev/null || echo "~/.nano_history not found"'
run_cmd "ATFTP history (~/.atftp_history)" 'cat ~/.atftp_history 2>/dev/null || echo "~/.atftp_history not found"'
run_cmd "MySQL history (~/.mysql_history)" 'cat ~/.mysql_history 2>/dev/null || echo "~/.mysql_history not found"'
run_cmd "PHP history (~/.php_history)" 'cat ~/.php_history 2>/dev/null || echo "~/.php_history not found"'

############################
# 24. SSH keys and authentication
############################
run_cmd "SSH authorized_keys (~/.ssh/authorized_keys)" 'cat ~/.ssh/authorized_keys 2>/dev/null || echo "~/.ssh/authorized_keys not found"'
run_cmd "SSH identity.pub (~/.ssh/identity.pub)" 'cat ~/.ssh/identity.pub 2>/dev/null || echo "~/.ssh/identity.pub not found"'
run_cmd "SSH identity (~/.ssh/identity)" 'cat ~/.ssh/identity 2>/dev/null || echo "~/.ssh/identity not found"'
run_cmd "SSH id_rsa.pub (~/.ssh/id_rsa.pub)" 'cat ~/.ssh/id_rsa.pub 2>/dev/null || echo "~/.ssh/id_rsa.pub not found"'
run_cmd "SSH id_rsa (~/.ssh/id_rsa)" 'cat ~/.ssh/id_rsa 2>/dev/null || echo "~/.ssh/id_rsa not found or not readable"'
run_cmd "SSH id_dsa.pub (~/.ssh/id_dsa.pub)" 'cat ~/.ssh/id_dsa.pub 2>/dev/null || echo "~/.ssh/id_dsa.pub not found"'
run_cmd "SSH id_dsa (~/.ssh/id_dsa)" 'cat ~/.ssh/id_dsa 2>/dev/null || echo "~/.ssh/id_dsa not found"'
run_cmd "SSH system config (/etc/ssh/ssh_config)" 'cat /etc/ssh/ssh_config 2>/dev/null || echo "/etc/ssh/ssh_config not found"'
run_cmd "SSH daemon config (/etc/ssh/sshd_config)" 'cat /etc/ssh/sshd_config 2>/dev/null || echo "/etc/ssh/sshd_config not found"'
run_cmd "SSH host DSA public key" 'cat /etc/ssh/ssh_host_dsa_key.pub 2>/dev/null || echo "Host DSA key not found"'
run_cmd "SSH host DSA private key" 'cat /etc/ssh/ssh_host_dsa_key 2>/dev/null || echo "Host DSA key not readable"'
run_cmd "SSH host RSA public key" 'cat /etc/ssh/ssh_host_rsa_key.pub 2>/dev/null || echo "Host RSA key not found"'
run_cmd "SSH host RSA private key" 'cat /etc/ssh/ssh_host_rsa_key 2>/dev/null || echo "Host RSA key not readable"'
run_cmd "SSH host key.pub" 'cat /etc/ssh/ssh_host_key.pub 2>/dev/null || echo "Host key not found"'
run_cmd "SSH host key" 'cat /etc/ssh/ssh_host_key 2>/dev/null || echo "Host key not readable"'

############################
# 25. Writable configuration files in /etc/
############################
run_cmd "World-writable files in /etc/ (anyone)" 'find /etc/ -readable -type f 2>/dev/null | head -30'
run_cmd "Owner-writable config files in /etc/" 'ls -aRl /etc/ 2>/dev/null | awk "$1 ~ /^..w/" | head -30'
run_cmd "Group-writable config files in /etc/" 'ls -aRl /etc/ 2>/dev/null | awk "$1 ~ /^.....w/" | head -30'
run_cmd "Other-writable config files in /etc/" 'find /etc/ -writable -type f 2>/dev/null | head -20'

############################
# 26. Advanced Linux file permissions (Sticky bits, SUID, GUID)
############################
run_cmd "Sticky bit files (find / -perm -1000 -type d)" 'find / -perm -1000 -type d 2>/dev/null | head -20'
run_cmd "SGID files (find / -perm -g=s -type f)" 'find / -perm -g=s -type f 2>/dev/null | head -30'
run_cmd "SUID files (find / -perm -u=s -type f)" 'find / -perm -u=s -type f 2>/dev/null | head -30'
run_cmd "SGID or SUID (find / -perm -g=s -o -perm -u=s -type f)" 'find / -perm -g=s -o -perm -u=s -type f 2>/dev/null | head -30'
run_cmd "SGID or SUID in common bin directories" '
for i in /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin; do
    if [ -d "$i" ]; then
        find "$i" \( -perm -4000 -o -perm -2000 \) -type f 2>/dev/null
    fi
done | head -30
'

############################
# 27. World-writable and executable folders
############################
run_cmd "World-writable directories (find / -writable -type d)" 'find / -writable -type d 2>/dev/null | head -20'
run_cmd "World-writable and executable (find / -perm -o w -perm -o x -type d)" 'find / \( -perm -o w -perm -o x \) -type d 2>/dev/null | head -20'
run_cmd "World-executable directories (find / -perm -o x -type d)" 'find / -perm -o x -type d 2>/dev/null | head -20'

############################
# 28. Problem files
############################
run_cmd "World-writable files without sticky bit" 'find / -xdev -type d \( -perm -0002 -a ! -perm -1000 \) -print 2>/dev/null | head -20'
run_cmd "Files with no owner (find / -nouser)" 'find /dir -xdev \( -nouser -o -nogroup \) -print 2>/dev/null | head -20'

############################
# 29. Home directories overview
############################
run_cmd "List /home/" 'ls -lsaht /home 2>/dev/null || echo "/home not accessible"'
run_cmd "Recursive listing of /home (look for .ssh, config, etc.)" 'ls -lsaR /home 2>/dev/null | head -100'
run_cmd "Recursive listing of /root" 'ls -lsaR /root 2>/dev/null | head -100'

############################
# 30. File capabilities (getcap)
############################
run_cmd "File capabilities (getcap -r /)" '
if command -v getcap >/dev/null 2>&1; then
    getcap -r / 2>/dev/null
else
    echo "getcap not installed"
fi
'

############################
# 31. Quick look in important dirs
############################
run_cmd "ls -lsaht /var/lib" 'ls -lsaht /var/lib 2>/dev/null | head -50'
run_cmd "ls -lsaht /var/db" 'ls -lsaht /var/db 2>/dev/null | head -50'
run_cmd "ls -lsaht /opt" 'ls -lsaht /opt 2>/dev/null | head -50'
run_cmd "ls -lsaht /tmp" 'ls -lsaht /tmp 2>/dev/null | head -50'
run_cmd "ls -lsaht /var/tmp" 'ls -lsaht /var/tmp 2>/dev/null | head -50'
run_cmd "ls -lsaht /dev/shm" 'ls -lsaht /dev/shm 2>/dev/null | head -50'

############################
# 32. NFS exports (potential NFS attacks)
############################
run_cmd "/etc/exports (NFS shares)" 'cat /etc/exports 2>/dev/null || echo "/etc/exports not present or not readable"'

############################
# 33. File systems and mounts
############################
run_cmd "Currently mounted filesystems (mount)" 'mount 2>/dev/null || echo "mount command failed"'
run_cmd "Disk usage (df -h)" 'df -h 2>/dev/null || echo "df command failed"'
run_cmd "fstab - mount options" 'cat /etc/fstab 2>/dev/null || echo "/etc/fstab not accessible"'

############################
# 34. Quick /etc recon
############################
run_cmd "Quick look at /etc" 'ls -lsaht /etc 2>/dev/null | head -50'
run_cmd "Config files in /etc (*.conf)" 'find /etc -name "*.conf" 2>/dev/null | head -30'
run_cmd ".secret-looking files in /etc" 'find /etc -name "*secret*" 2>/dev/null'

############################
# 35. Files owned by BOB_USER
############################
run_cmd "All files owned by user ${BOB_USER}" "find / -user '${BOB_USER}' 2>/dev/null | head -20 || echo 'no files found for ${BOB_USER} or find error'"

############################
# 36. File transfer capability recap
############################
run_cmd "Transfer tools recap + FTP-like binaries" '
which wget 2>/dev/null || echo "wget: not found"
which curl 2>/dev/null || echo "curl: not found"
which nc 2>/dev/null || echo "nc: not found"
which ncat 2>/dev/null || echo "ncat: not found"
which socat 2>/dev/null || echo "socat: not found"
which fetch 2>/dev/null || echo "fetch: not found"
which ftp 2>/dev/null || echo "ftp: not found"
find /bin /sbin /usr/bin /usr/sbin -name "*ftp*" 2>/dev/null || echo "no ftp-related binaries found"
'

############################
# 37. EXTRA: check your big list of interesting files
############################
run_cmd "Extra interesting config/log/cred files (existence + first lines)" '
FILES="
/etc/passwd
/etc/shadow
/etc/aliases
/etc/anacrontab
/etc/apache2/apache2.conf
/etc/apache2/httpd.conf
/etc/apache2/sites-enabled/000-default.conf
/etc/at.allow
/etc/at.deny
/etc/bashrc
/etc/bootptab
/etc/chrootUsers
/etc/chttp.conf
/etc/cron.allow
/etc/cron.deny
/etc/crontab
/etc/cups/cupsd.conf
/etc/exports
/etc/fstab
/etc/ftpaccess
/etc/ftpchroot
/etc/ftphosts
/etc/groups
/etc/grub.conf
/etc/hosts
/etc/hosts.allow
/etc/hosts.deny
/etc/httpd/access.conf
/etc/httpd/conf/httpd.conf
/etc/httpd/httpd.conf
/etc/httpd/logs/access_log
/etc/httpd/logs/access.log
/etc/httpd/logs/error_log
/etc/httpd/logs/error.log
/etc/httpd/php.ini
/etc/httpd/srm.conf
/etc/inetd.conf
/etc/inittab
/etc/issue
/etc/knockd.conf
/etc/lighttpd.conf
/etc/lilo.conf
/etc/logrotate.d/ftp
/etc/logrotate.d/proftpd
/etc/logrotate.d/vsftpd.log
/etc/lsb-release
/etc/motd
/etc/modules.conf
/etc/mtab
/etc/my.cnf
/etc/my.conf
/etc/mysql/my.cnf
/etc/network/interfaces
/etc/networks
/etc/npasswd
/etc/php.ini
/etc/proftp.conf
/etc/proftpd/proftpd.conf
/etc/pure-ftpd.conf
/etc/pureftpd.passwd
/etc/pureftpd.pdb
/etc/pure-ftpd/pure-ftpd.conf
/etc/pure-ftpd/pure-ftpd.pdb
/etc/pure-ftpd/putreftpd.pdb
/etc/redhat-release
/etc/resolv.conf
/etc/samba/smb.conf
/etc/snmpd.conf
/etc/ssh/ssh_config
/etc/ssh/sshd_config
/etc/ssh/ssh_host_dsa_key
/etc/ssh/ssh_host_dsa_key.pub
/etc/ssh/ssh_host_key
/etc/ssh/ssh_host_key.pub
/etc/sysconfig/network
/etc/syslog.conf
/etc/termcap
/etc/vhcs2/proftpd/proftpd.conf
/etc/vsftpd.chroot_list
/etc/vsftpd.conf
/etc/vsftpd/vsftpd.conf
/etc/wu-ftpd/ftpaccess
/etc/wu-ftpd/ftphosts
/etc/wu-ftpd/ftpusers
/logs/pure-ftpd.log
/logs/security_debug_log
/logs/security_log
/opt/lampp/etc/httpd.conf
/opt/xampp/etc/php.ini
/proc/cmdline
/proc/cpuinfo
/proc/filesystems
/proc/interrupts
/proc/ioports
/proc/meminfo
/proc/modules
/proc/mounts
/proc/net/arp
/proc/net/tcp
/proc/net/udp
/proc/sched_debug
/proc/self/cwd/app.py
/proc/self/environ
/proc/self/net/arp
/proc/stat
/proc/swaps
/proc/version
/root/anaconda-ks.cfg
/usr/etc/pure-ftpd.conf
/usr/lib/php.ini
/usr/lib/php/php.ini
/usr/local/apache/conf/modsec.conf
/usr/local/apache/conf/php.ini
/usr/local/apache/log
/usr/local/apache/logs
/usr/local/apache/logs/access_log
/usr/local/apache/logs/access.log
/usr/local/apache/audit_log
/usr/local/apache/error_log
/usr/local/apache/error.log
/usr/local/cpanel/logs
/usr/local/cpanel/logs/access_log
/usr/local/cpanel/logs/error_log
/usr/local/cpanel/logs/license_log
/usr/local/cpanel/logs/login_log
/usr/local/cpanel/logs/stats_log
/usr/local/etc/httpd/logs/access_log
/usr/local/etc/httpd/logs/error_log
/usr/local/etc/php.ini
/usr/local/etc/pure-ftpd.conf
/usr/local/etc/pureftpd.pdb
/usr/local/lib/php.ini
/usr/local/php4/httpd.conf
/usr/local/php4/httpd.conf.php
/usr/local/php4/lib/php.ini
/usr/local/php5/httpd.conf
/usr/local/php5/httpd.conf.php
/usr/local/php5/lib/php.ini
/usr/local/php/httpd.conf
/usr/local/php/httpd.conf.ini
/usr/local/php/lib/php.ini
/usr/local/pureftpd/etc/pure-ftpd.conf
/usr/local/pureftpd/etc/pureftpd.pdn
/usr/local/pureftpd/sbin/pure-config.pl
/usr/local/www/logs/httpd_log
/usr/local/Zend/etc/php.ini
/usr/sbin/pure-config.pl
/var/adm/log/xferlog
/var/apache2/config.inc
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
echo "  # Example:"
echo "  cd /var/tmp/"
echo "  chmod 755 pspy32 pspy64"
echo "  ./pspy64 -r /bin,/etc,/home,/opt,/var,/usr,/tmp -pf -i 1000"
echo "================================================================"
echo
