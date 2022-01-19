#!/bin/bash
# download data and unzip
cd $bbwDir
curl https://fz-juelich.sciebo.de/s/pFu9XfNonT65HpS/download --output BBW_BigData.zip
unzip BBW_BigData.zip
mv BBW_BigData/spaces spaces
cd BBW_BigData
unzip xfms.zip
mv xfms ../xfms
cd ..
rm -rf BBW_BigData
rm BBW_BigData.zip
rm -rf xfms/xfms
rm -rf spaces/spaces
