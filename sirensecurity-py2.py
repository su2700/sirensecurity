#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
SIREN Security - Linux Reconnaissance & Audit Tool (Python 2 Version)
Version: 2.0
Description: Comprehensive Linux enumeration and privilege escalation discovery script for legacy systems.
"""

from __future__ import print_function
import os
import sys
import subprocess
import argparse
from datetime import datetime

# Color codes
COLOR_SECTION = "\033[1;34m"    # Blue
COLOR_SUBSECTION = "\033[1;36m" # Cyan
COLOR_SUCCESS = "\033[1;32m"    # Green
COLOR_FAILURE = "\033[1;31m"    # Red
COLOR_INFO = "\033[1;33m"       # Yellow
COLOR_RESET = "\033[0m"

class SirenSecurity:
    def __init__(self, target_user=None, bob_user="bob", password=None, interactive=False):
        self.target_user = target_user or os.getenv("USER", "root")
        self.bob_user = bob_user
        self.user_password = password
        self.interactive_mode = interactive
        self.section_count = 0
        self.total_sections = 16
        self.highlights = []

    def print_section(self, title):
        self.section_count += 1
        print("\n" + COLOR_SECTION + "================================================================" + COLOR_RESET)
        print(COLOR_SECTION + ">>> (" + str(self.section_count) + "/" + str(self.total_sections) + ") " + title + COLOR_RESET)
        print(COLOR_SECTION + "================================================================" + COLOR_RESET)

    def print_subsection(self, title):
        print("\n" + COLOR_SUBSECTION + "🔍 [*] " + title + COLOR_RESET)
        print("----------------------------------------------------------------")

    def add_highlight(self, msg):
        self.highlights.append(COLOR_SUCCESS + "  [!] " + msg + COLOR_RESET)

    def run_cmd(self, title, cmd, silent=True):
        self.print_subsection(title)
        
        full_cmd = cmd
        if self.user_password and "sudo" in cmd:
            full_cmd = cmd.replace("sudo", "echo '" + self.user_password + "' | sudo -S -p ''")

        try:
            # Python 2 compatible subprocess execution
            process = subprocess.Popen(
                full_cmd, 
                shell=True, 
                stdout=subprocess.PIPE, 
                stderr=subprocess.PIPE,
                executable='/bin/bash'
            )
            stdout, stderr = process.communicate()
            
            if stdout:
                print(stdout.strip())
            
            if process.returncode != 0 and not silent:
                print(COLOR_FAILURE + "❌ [!] Command failed with code " + str(process.returncode) + COLOR_RESET)
                if stderr:
                    print(stderr.strip())
        except Exception as e:
            print(COLOR_FAILURE + "❌ [!] Error: " + str(e) + COLOR_RESET)

    def pause_for_focus(self):
        if self.interactive_mode:
            # Python 2 uses raw_input()
            raw_input(COLOR_INFO + "☕ Press [ENTER] to continue..." + COLOR_RESET)

    def section_system_info(self):
        self.print_section("1. SYSTEM INFORMATION")
        cmds = [
            ("Distribution", "cat /etc/issue"), 
            ("OS Release", "cat /etc/*-release"), 
            ("Kernel", "uname -a"), 
            ("Arch", "uname -m")
        ]
        for t, c in cmds: self.run_cmd(t, c)

    def section_user_privileges(self):
        self.print_section("2. USER & PRIVILEGES")
        self.run_cmd("Current User", "id")
        self.run_cmd("Groups", "groups " + self.target_user)
        self.print_subsection("sudo -l")
        cmd = "echo '" + self.user_password + "' | sudo -S -p '' -l" if self.user_password else "sudo -l"
        try:
            process = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, executable='/bin/bash')
            stdout, stderr = process.communicate()
            output = stdout + stderr
            print(output.strip())
            if any(x in output for x in ["(ALL : ALL) ALL", "NOPASSWD"]): 
                self.add_highlight("High-privilege sudo found!")
        except:
            print("sudo -l check failed")

    def section_environment(self):
        self.print_section("3. ENVIRONMENT")
        self.run_cmd("Env Vars", "env | sort")

    def section_processes(self):
        self.print_section("4. PROCESSES")
        self.run_cmd("ps aux", "ps aux | head -50")

    def section_packages(self):
        self.print_section("5. PACKAGES")
        self.run_cmd("dpkg", "dpkg -l | head -20")
        self.run_cmd("rpm", "rpm -qa | head -20")

    def section_network(self):
        self.print_section("6. NETWORK")
        self.run_cmd("ip addr", "ip addr show")
        self.run_cmd("netstat", "netstat -tulpn 2>/dev/null || ss -tulpn")

    def section_cron(self):
        self.print_section("7. CRON")
        self.run_cmd("crontab", "crontab -l")

    def section_file_permissions(self):
        self.print_section("8. PERMISSIONS")
        try:
            process = subprocess.Popen("find / -perm -4000 -type f 2>/dev/null | head -20", shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            stdout, _ = process.communicate()
            if stdout:
                print(stdout.strip())
                self.add_highlight("SUID files found")
        except:
            pass

    def section_filesystems(self):
        self.print_section("9. FILESYSTEMS")
        self.run_cmd("mount", "mount")

    def section_users(self):
        self.print_section("10. USERS")
        self.run_cmd("passwd", "cat /etc/passwd")

    def audit_ssh_controlmaster(self):
        self.print_subsection("SSH ControlMaster & Session Socket Audit")

        # 1. Check configs for ControlMaster/ControlPath settings
        print(COLOR_INFO + "[*] Auditing SSH configs for ControlMaster / ControlPath settings..." + COLOR_RESET)
        cm_found = False
        cfg_cmd = "grep -iE 'ControlMaster|ControlPath|ControlPersist' ~/.ssh/config /home/*/.ssh/config /root/.ssh/config /etc/ssh/ssh_config /etc/ssh/ssh_config.d/* 2>/dev/null"
        try:
            proc = subprocess.Popen(cfg_cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            stdout, _ = proc.communicate()
            if stdout and stdout.strip():
                cm_found = True
                print(COLOR_SUCCESS + "🔍 [+] ControlMaster settings active:" + COLOR_RESET)
                for line in stdout.strip().splitlines():
                    print("    " + line)
                self.add_highlight("SSH ControlMaster directive configured in SSH configs")
            else:
                print("  [-] No explicit ControlMaster directives found in accessible config files.")
        except Exception:
            pass
        print()

        # 2. Scan .ssh and system locations for Unix domain socket files
        print(COLOR_INFO + "[*] Scanning .ssh and system directories for active SSH sockets..." + COLOR_RESET)
        sock_cmd = "find ~/.ssh /tmp /var/tmp /run/user/$(id -u 2>/dev/null || echo 1000) /home/*/.ssh /root/.ssh -maxdepth 3 -type s 2>/dev/null"
        sockets = []
        try:
            proc = subprocess.Popen(sock_cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            stdout, _ = proc.communicate()
            if stdout:
                sockets = [s for s in stdout.strip().splitlines() if s]
            if sockets:
                for sock in sockets:
                    print(COLOR_SUCCESS + "⚠️ [SECURITY RISK] Active Unix Domain Socket found: " + sock + COLOR_RESET)
                    ls_proc = subprocess.Popen("ls -lah '" + sock + "' 2>/dev/null", shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                    ls_out, _ = ls_proc.communicate()
                    if ls_out and ls_out.strip():
                        print("    " + ls_out.strip())
                    self.add_highlight("Active SSH Unix domain socket file found: " + sock)
            else:
                print("  [-] No active Unix domain sockets found in scanned directories.")
        except Exception:
            pass
        print()

        # 3. Defensive Remediation Guidance
        if cm_found or sockets:
            print(COLOR_INFO + "🛡️ Defensive Remediation:" + COLOR_RESET)
            print("   - Ensure socket directories (e.g. ~/.ssh/controlmaster) have strict 0700 permissions.")
            print("   - Set 'ControlPersist no' or short timeout values if ControlMaster is required.")
            print("   - Remove orphaned socket files when SSH sessions terminate.\n")

    def section_sensitive_files(self):
        self.print_section("11. SENSITIVE FILES")
        home = os.path.expanduser("~")
        self.run_cmd("SSH Keys", "ls -lah " + home + "/.ssh/ 2>/dev/null")
        self.audit_ssh_controlmaster()

    def section_configs(self):
        self.print_section("12. CONFIGS")
        self.run_cmd("Apache/Nginx", "ls -lah /etc/apache2/ /etc/nginx/ 2>/dev/null")

    def section_logs(self):
        self.print_section("13. LOGS")
        self.run_cmd("syslog", "ls -lah /var/log/syslog /var/log/messages 2>/dev/null")

    def section_credentials(self):
        self.print_section("14. CREDENTIALS")
        self.run_cmd("PHP config", "find /var/www -name \"*.php\" 2>/dev/null | xargs grep -i \"password\" | head -10")

    def section_transfer_tools(self):
        self.print_section("15. TOOLS")
        for tool in ["wget", "curl", "nc"]:
            try:
                if subprocess.call(["which", tool], stdout=subprocess.PIPE, stderr=subprocess.PIPE) == 0:
                    print(COLOR_SUCCESS + "[+] " + tool + " found" + COLOR_RESET)
            except:
                pass

    def section_misc(self):
        self.print_section("16. MISC")
        self.run_cmd("Printers", "lpstat -a 2>/dev/null")
        self.run_cmd("Files owned by " + self.bob_user, "find / -user '" + self.bob_user + "' 2>/dev/null | head -30")

    def run(self):
        print(COLOR_INFO + "⏰ Start Time: " + datetime.now().strftime('%Y-%m-%d %H:%M:%S') + COLOR_RESET)
        methods = [
            self.section_system_info, self.section_user_privileges, self.section_environment, 
            self.section_processes, self.section_packages, self.section_network, 
            self.section_cron, self.section_file_permissions, self.section_filesystems, 
            self.section_users, self.section_sensitive_files, self.section_configs, 
            self.section_logs, self.section_credentials, self.section_transfer_tools, 
            self.section_misc
        ]
        for m in methods:
            m()
            self.pause_for_focus()
        if self.highlights:
            print("\n" + COLOR_INFO + "🚩 HIGHLIGHTS:" + COLOR_RESET)
            for h in self.highlights: print(h)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--interactive", action="store_true")
    parser.add_argument("-p", "--password")
    parser.add_argument("-t", "--target")
    parser.add_argument("-b", "--bob", default="bob")
    args = parser.parse_args()
    app = SirenSecurity(args.target, args.bob, args.password, args.interactive)
    app.run()

if __name__ == "__main__": main()
