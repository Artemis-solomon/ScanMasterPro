#!/bin/bash
# ScanMasterPro - Automated Vulnerability Scanning Script
# Author: Artemis O. Solomon
# Description: This script automates vulnerability scanning using OpenVAS.
# Version: 1.0

# Banner

echo "_______________________               _____        ";
echo "___    |__  __ \__  __/___________ ______(_)_______";
echo "__  /| |_  /_/ /_  /  _  _ \_  __ \`__ \_  /__  ___/";
echo "_  ___ |  _, _/_  /   /  __/  / / / / /  / _(__  ) ";
echo "/_/  |_/_/ |_| /_/    \___//_/ /_/ /_//_/  /____/  ";
echo "                                                   ";


function prompt_user {
    read -p "$1" response
    echo "$response"
}

OMP_CMD=$(prompt_user "Enter the OpenVAS command (omp): ")
SCAN_CONFIG=$(prompt_user "Enter the scan configuration (Full and Fast): ")
IP_SOURCE=$(prompt_user "Do you want to enter target IPs manually (M) or from a .txt file (F)? ")
TARGET=""
if [ "$IP_SOURCE" == "M" ]; then
    TARGET=$(prompt_user "Enter the target IP or range (e.g., 192.168.0.0/24): ")
elif [ "$IP_SOURCE" == "F" ]; then
    IP_FILE=$(prompt_user "Enter the path to the .txt file containing target IPs: ")
    if [ ! -f "$IP_FILE" ]; then
        echo "File not found: $IP_FILE"
        exit 1
    fi
fi
REPORT_FORMAT=$(prompt_user "Enter the report format (HTML): ")
OUTPUT_DIR=$(prompt_user "Enter the output directory path: ")

# Banner

echo "_______________________               _____        ";
echo "___    |__  __ \__  __/___________ ______(_)_______";
echo "__  /| |_  /_/ /_  /  _  _ \_  __ \`__ \_  /__  ___/";
echo "_  ___ |  _, _/_  /   /  __/  / / / / /  / _(__  ) ";
echo "/_/  |_/_/ |_| /_/    \___//_/ /_/ /_//_/  /____/  ";
echo "                                                   ";


while true; do
    # Prompt user for input
    read -p "Enter the OpenVAS command (omp): " OMP_CMD
    read -p "Enter the scan configuration (Full and Fast): " SCAN_CONFIG
    read -p "Do you want to enter target IPs manually (M) or from a .txt file (F)? " IP_SOURCE

    if [ "$IP_SOURCE" == "M" ]; then
        read -p "Enter the target IP or range (e.g., 192.168.0.0/24): " TARGET
    elif [ "$IP_SOURCE" == "F" ]; then
        read -p "Enter the path to the .txt file containing target IPs: " IP_FILE
        if [ ! -f "$IP_FILE" ]; then
            echo "File not found: $IP_FILE"
            exit 1
        fi
    else
        echo "Invalid input. Please enter 'M' for manual entry or 'F' for file."
        continue
    fi

    read -p "Enter the report format (HTML): " REPORT_FORMAT
    read -p "Enter the output directory path: " OUTPUT_DIR

    # Check if omp command is installed
    if ! command -v $OMP_CMD &> /dev/null; then
        echo "$OMP_CMD command not found. Please install OpenVAS and set the correct path."
        exit 1
    fi

    # Create output directory if it doesn't exist
    mkdir -p $OUTPUT_DIR

    # Authenticate with OpenVAS
    read -p "Enter OpenVAS username: " OPENVAS_USER
    read -sp "Enter OpenVAS password: " OPENVAS_PASS
    AUTH_XML="<authenticate><credentials><username>$OPENVAS_USER</username><password>$OPENVAS_PASS</password></credentials></authenticate>"
    $OMP_CMD -u $OPENVAS_USER -w $OPENVAS_PASS --xml="$AUTH_XML"

    # Start a new task (vulnerability scan)
    if [ "$IP_SOURCE" == "M" ]; then
        TASK_XML="<create_task><name>My Vulnerability Scan</name><target>$TARGET</target><config id=\"$SCAN_CONFIG\"/></create_task>"
    else
        TASK_XML="<create_task><name>My Vulnerability Scan</name><target>$IP_FILE</target><config id=\"$SCAN_CONFIG\"/></create_task>"
    fi

    TASK_ID=$($OMP_CMD -u $OPENVAS_USER -w $OPENVAS_PASS --xml="$TASK_XML" | grep -oP '(?<=id=")[^"]+')

    echo "Scan task started. Task ID: $TASK_ID"

 while true; do
        STATUS=$($OMP_CMD -u $OPENVAS_USER -w $OPENVAS_PASS --xml="<get_tasks task_id=\"$TASK_ID\" details=\"1\"/>" | grep -oP '(?<=status=")[^"]+')
        if [ "$STATUS" == "Done" ]; then
            break
        fi
        sleep 10
    done

    REPORT_ID=$($OMP_CMD -u $OPENVAS_USER -w $OPENVAS_PASS --xml="<get_reports report_id=\"last\"/>" | grep -oP '(?<=report id=")[^"]+')
    $OMP_CMD -u $OPENVAS_USER -w $OPENVAS_PASS --xml="<get_report report_id=\"$REPORT_ID\" format=\"$REPORT_FORMAT\"/>" > "$OUTPUT_DIR/scan_report.$REPORT_FORMAT"

    echo "Scan complete. Report exported to $OUTPUT_DIR/scan_report.$REPORT_FORMAT"

    $OMP_CMD -u $OPENVAS_USER -w $OPENVAS_PASS --xml="<logout/>"

    # Prompt user to run another scan
    read -p "Do you want to run another scan (Y/N)? " ANOTHER_SCAN
    if [ "$ANOTHER_SCAN" != "Y" ]; then
        break
    fi
done
