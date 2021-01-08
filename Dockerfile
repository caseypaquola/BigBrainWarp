# Provides MINC 2.3.0
FROM simexp/minc-toolkit

# Install FSL (5.0) from Neurodebian
RUN wget -O- http://neuro.debian.net/lists/xenial.us-ca.full | tee /etc/apt/sources.list.d/neurodebian.sources.list &&\
    apt-key adv --recv-keys --keyserver hkp://pool.sks-keyservers.net:80 0xA5D32F012649A5A9 && apt-get update &&\
    apt install -y fsl 

# Install Python 3.8
RUN add-apt-repository -y ppa:deadsnakes/ppa && apt-get update && apt-get install -y  python3.8 python3.8-dev python3.8-distutils wget 

RUN  wget https://bootstrap.pypa.io/get-pip.py -O get-pip.py && python3.8 get-pip.py

# Python dependencies
RUN pip3.8 install numpy nibabel scipy

COPY . /BigBrainWarp

# BigBrainWarp config: fix paths, run init script, set default python to 3.8 (scripts call "python")
RUN sed -i s,bbwDir=.*,bbwDir=/BigBrainWarp,g /BigBrainWarp/scripts/init.sh &&\
    sed -i s,mnc2Path=.*,mnc2Path=/opt/minc-itk4/bin,g /BigBrainWarp/scripts/init.sh &&\
    bash /BigBrainWarp/scripts/init.sh && update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1

# Source the fsl and BigBrainWarp init scripts before running the command
ENTRYPOINT ["bash", "-c", "source /etc/fsl/5.0/fsl.sh && source /BigBrainWarp/scripts/init.sh && \"$@\"", "-s"]

# BibBrainWarp scripts must be run from this directory
WORKDIR /BigBrainWarp/scripts
