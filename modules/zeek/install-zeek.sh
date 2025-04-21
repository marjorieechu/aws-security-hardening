#!/bin/bash

# Update system
apt-get update -y
apt-get upgrade -y

# Install dependencies
apt-get install -y wget build-essential cmake libssl-dev

# Install Zeek
wget https://download.zeek.org/zeek-4.0.0.tar.gz
tar -xzvf zeek-4.0.0.tar.gz
cd zeek-4.0.0
./configure
make
make install

# Setup Zeek to monitor network interfaces
zeekctl deploy

# Start Zeek
zeekctl start
