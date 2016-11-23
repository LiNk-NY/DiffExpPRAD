#!/bin/sh
# download data based on manifest

cd ~/Documents/data/exon/

~/Documents/bin/gdc-client download -m ${1}

