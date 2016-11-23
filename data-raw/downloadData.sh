#!/bin/sh
# download data based on manifest

cd ~/Documents/data/btexon/

~/Documents/bin/gdc-client download -m ${1}

