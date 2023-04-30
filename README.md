# Accounting-and-Monitoring-Bash-Scripts
🧾This repository contains two Bash scripts that can be used to monitor and account for system resources.

## 📈Test Stress Script

The `test_estres.sh` script is used to monitor the memory, CPU, and disk usage during a stress test.

### Usage

To use the script, execute it as root with the following command:

`sudo ./test_estres.sh` 

The script will open a new terminal window and run a stress test to simulate high usage of system resources. It will monitor the CPU, memory, and disk usage and output the results to a text file called `test.txt`.

### Requirements

The script requires the `sysstat` package to be installed. If the package is not installed, the script will install it automatically.

### Options

The script has no options.

## 💾Disk Space Script

The `espai_disc.sh` script is used to check how much disk space is used by users who have logged in during the last three days.

### Usage

To use the script, execute it as root with the following command:

`sudo ./espai_disc.sh` 

The script will output the disk usage for each user's home directory who has logged in during the last three days.

### Options

The script has no options.

### Requirements

The script has no special requirements beyond running as root.
