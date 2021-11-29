#!/bin/bash
# download data and unzip
cd $bbwDir
wget --no-check-certificate --content-disposition "https://fz-juelich.sciebo.de/s/pFu9XfNonT65HpS/download"
unzip BigBrainWarp.zip

# run checksum
