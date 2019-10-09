#!/bin/bash

# Check for root rights
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Make script executable
chmod +x longmethods.sh

# Add to path
sudo mv longmethods.sh /usr/local/bin/longmethods
