#!/usr/bin/env python3
"""
SIREN Security - Linux Reconnaissance & Audit Tool (Python Version)
Version: 2.0
"""

import os
import sys
import subprocess
import argparse
from datetime import datetime

COLOR_SECTION = "\033[1;34m"
COLOR_SUBSECTION = "\033[1;36m"
COLOR_SUCCESS = "\033[1;32m"
COLOR_FAILURE = "\033[1;31m"
COLOR_INFO = "\033[1;33m"
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
        print(f"\n{COLOR_SECTION}================================================================{COLOR_RESET}")
        print(f"{COLOR_SECTION}>>> ({self.section_count}/{self.total_sections}) {title}{COLOR_RESET}")
        print(f"{COLOR_SECTION}================================================================{COLOR_RESET}")

    def print_subsection(self, title):
        print(f"\n{COLOR_SUBSECTION}🔍 [*] {title}{COLOR_RESET}")
        print("----------------------------------------------------------------")

    def add_highlight(self, msg):
        self.highlights.append(f"{COLOR_SUCCESS}  [!] {msg}{COLOR_RESET}")

    def run_cmd(self, title, cmd, silent=True):
        self.print_subsection(title)
        full_cmd = cmd
        if self.user_password and "sudo" in cmd:
            full_cmd = cmd.replace("sudo", f"echo '{self.user_password}' | sudo -S -p ''")
        try:
            result = subprocess.run(full_cmd, shell=True, capture_output=True, text=True, executable='/bin/bash')
            if result.stdout: print(result.stdout.strip())
            if result.returncode != 0 and not silent:
                print(f"{COLOR_FAILURE}❌ [!] Command failed with code {result.returncode}{COLOR_RESET}")
        except Exception as e:
            print(f"{COLOR_FAILURE}❌ [!] Error: {e}{COLOR_RESET}")

    def pause_for_focus(self):
        if self.interactive_mode:
            input(f"{COLOR_INFO}☕ Press [ENTER] to continue...{COLOR_RESET}")

    def section_system_info(self):
        self.print_section("1. SYSTEM INFORMATION")
        cmds = [("Distribution", "cat /etc/issue"), ("OS Release", "cat /etc/*-release"), ("Kernel", "uname -a"), ("Arch", "uname -m")]
        for t, c in cmds: self.run_cmd(t, c)

    def section_user_privileges(self):
        self.print_section("2. USER & PRIVILEGES")
        self.run_cmd("Current User", "id")
        self.run_cmd("Groups", f"groups {self.target_user}")
        self.print_subsection("sudo -l")
        cmd = f"echo '{self.user_password}' | sudo -S -p '' -l" if self.user_password else "sudo -l"
        res = subprocess.run(cmd, shell=True, capture_output=True, text=True, executable='/bin/bash')
        output = res.stdout + res.stderr
        print(output.strip())
        if any(x in output for x in ["(ALL : ALL) ALL", "NOPASSWD"]): self.add_highlight("High-privilege sudo found!")

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
        res = subprocess.run("find / -perm -4000 -type f 2>/dev/null | head -20", shell=True, capture_output=True, text=True)
        if res.stdout:
            print(res.stdout.strip())
            self.add_highlight("SUID files found")

    def section_filesystems(self):
        self.print_section("9. FILESYSTEMS")
        self.run_cmd("mount", "mount")

    def section_users(self):
        self.print_section("10. USERS")
        self.run_cmd("passwd", "cat /etc/passwd")

    def section_sensitive_files(self):
        self.print_section("11. SENSITIVE FILES")
        self.run_cmd("SSH Keys", "ls -lah ~/.ssh/ 2>/dev/null")

    def section_configs(self):
        self.print_section("12. CONFIGS")
        self.run_cmd("Apache", "ls -lah /etc/apache2/ 2>/dev/null")

    def section_logs(self):
        self.print_section("13. LOGS")
        self.run_cmd("syslog", "ls -lah /var/log/syslog 2>/dev/null")

    def section_credentials(self):
        self.print_section("14. CREDENTIALS")
        self.run_cmd("PHP config", "find /var/www -name \"*.php\" 2>/dev/null | xargs grep -i \"password\" | head -10")

    def section_transfer_tools(self):
        self.print_section("15. TOOLS")
        for tool in ["wget", "curl", "nc"]:
            if subprocess.run(f"command -v {tool}", shell=True).returncode == 0: print(f"{COLOR_SUCCESS}[+] {tool} found{COLOR_RESET}")

    def section_misc(self):
        self.print_section("16. MISC")
        self.run_cmd("Printers", "lpstat -a 2>/dev/null")

    def run(self):
        print(f"{COLOR_INFO}⏰ Start Time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}{COLOR_RESET}")
        methods = [self.section_system_info, self.section_user_privileges, self.section_environment, self.section_processes, self.section_packages, self.section_network, self.section_cron, self.section_file_permissions, self.section_filesystems, self.section_users, self.section_sensitive_files, self.section_configs, self.section_logs, self.section_credentials, self.section_transfer_tools, self.section_misc]
        for m in methods:
            m()
            self.pause_for_focus()
        if self.highlights:
            print(f"\n{COLOR_INFO}🚩 HIGHLIGHTS:{COLOR_RESET}")
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
