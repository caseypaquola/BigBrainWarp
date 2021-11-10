# Use Ubuntu 16.04 LTS
FROM ubuntu:xenial-20200114

# Provides MINC 2.3.0
FROM simexp/minc-toolkit

# Prepare environment
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
                    curl \
                    bzip2 \
                    ca-certificates \
                    xvfb \
                    build-essential \
                    autoconf \
                    libtool \
                    pkg-config \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# installing workbench
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
                        connectome-workbench
                   
# Install Python 3.8
RUN add-apt-repository -y ppa:deadsnakes/ppa && apt-get update && apt-get install -y --no-install-recommends python3.8 python3.8-dev python3.8-distutils wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://bootstrap.pypa.io/get-pip.py -O get-pip.py && python3.8 get-pip.py

# Python dependencies
RUN pip3.8 install numpy nibabel scipy

COPY . /BigBrainWarp

# BigBrainWarp config: fix paths, run init script, set default python to 3.8 (scripts call "python")
RUN sed -i s,bbwDir=.*,bbwDir=/BigBrainWarp,g /BigBrainWarp/scripts/init.sh &&\
    sed -i s,mnc2Path=.*,mnc2Path=/opt/minc-itk4/bin,g /BigBrainWarp/scripts/init.sh &&\
    bash /BigBrainWarp/scripts/downloads.sh && update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1

# Source the fsl and BigBrainWarp init scripts before running the command
ENTRYPOINT ["bash", "-c", "source /BigBrainWarp/scripts/init.sh && \"$@\"", "-s"]

# BigBrainWarp scripts must be run from this directory
WORKDIR /BigBrainWarp/scripts
