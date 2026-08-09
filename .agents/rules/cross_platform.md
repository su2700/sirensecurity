# Cross-Platform & Line Ending Rules

1. **Line Endings (CRLF vs LF)**:
   - ALL `.sh`, `.bash`, `.py`, and executable files in this repository MUST use **Unix LF (`\n`)** line endings.
   - Even when developing on Windows, NEVER save shell scripts with Windows CRLF (`\r\n`) line endings.
   - Check and enforce LF line endings whenever creating or editing shell scripts.

2. **Linux & macOS (Darwin) Portability**:
   - Write shell code that is compatible with both Linux distributions (GNU toolchain) and macOS (BSD toolchain / default zsh/bash).
   - Handle differences between BSD and GNU utilities (e.g. `stat -c` vs `stat -f`, `sed -i ''` vs `sed -i`, `grep -P` availability).
   - Use feature detection (e.g. checking command availability or using helper functions) rather than assuming GNU or Linux-only utilities.
