#!/bin/bash
# download data and unzip
cd $bbwDir
curl https://fz-juelich.sciebo.de/s/pFu9XfNonT65HpS/download --output BBW_BigData.zip
unzip BBW_BigData.zip
mv BigBrainWarp/spaces spaces
cd BigBrainWarp
unzip xfms.zip
mv xfms ../xfms
cd ..
rm -rf BigBrainWarp
rm BBW_BigData.zip
