#!/bin/bash
# download data and unzip
cd $bbwDir
wget --no-check-certificate --content-disposition "https://fz-juelich.sciebo.de/s/pFu9XfNonT65HpS/download"
unzip BigBrainWarp.zip
cd BigBrainWarp
unzip spaces.zip
mv spaces ../spaces
unzip xfms.zip
mv xfms ../xfms
rm BigBrainWarp.zip
rm spaces.zip
rm xfms.zip