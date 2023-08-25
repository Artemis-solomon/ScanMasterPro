# ScanMasterPro - Automated Vulnerability Scanning Script

ScanMasterPro is a bash script that automates vulnerability scanning using OpenVAS. It provides an interactive and user-friendly way to perform vulnerability scans, configure scan parameters, and generate reports.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Configuration](#configuration)
- [Contributions](#contributions)
- [License](#license)

## Features

- Interactive wizard-like interface for easy configuration.
- Choose between manual entry or reading target IPs from a .txt file.
- Configure scan settings like scan configuration and report format.
- Automated OpenVAS authentication and task creation.
- Report generation and export to a specified output directory.
- Looping functionality to run multiple scans consecutively.

## Prerequisites

- OpenVAS installed and configured.
  - Visit the [OpenVAS website](https://www.openvas.org/) for installation instructions.
- Bash shell (compatible with Linux and macOS).

## Usage

1. Clone this repository:

   ```bash
   git clone https://github.com/your-username/ScanMasterPro.git
   ```

2. Navigate to the script directory:

   ```bash
   cd ScanMasterPro
   ```

3. Run the script:

   ```bash
   bash scan_master_pro.sh
   ```

4. Follow the prompts to configure the scan settings. Choose your OpenVAS command, scan configuration, IP source, target IPs, report format, and output directory.

5. The script will initiate the vulnerability scan, monitor its progress, and generate a report.

6. Review the generated report in the specified output directory.

## Configuration

- Open the script in a text editor and adjust variables as needed.
- Set your OpenVAS credentials in the script for authentication.
- Modify the script to match your specific environment and requirements.

## Contributions

Contributions are welcome! If you find a bug or want to enhance the script, feel free to create an issue or a pull request. Your contributions can help improve this tool for everyone.

## License

This project is licensed under the [MIT License](LICENSE), which means you are free to use, modify, and distribute the code.

---

**Disclaimer**: This script is intended for educational and testing purposes only. Always ensure that you have proper authorization before scanning any network or system. The script author takes no responsibility for the misuse of this tool.

For questions or support, contact [artemis@dnmx.org](mailto:artemis@dnmx.org).
