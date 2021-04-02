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
                    pkg-config

# Installing freesurfer
RUN curl -sSL https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/6.0.1/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.1.tar.gz | tar zxv --no-same-owner -C /opt \
    --exclude='freesurfer/diffusion' \
    --exclude='freesurfer/docs' \
    --exclude='freesurfer/fsfast' \
    --exclude='freesurfer/lib/cuda' \
    --exclude='freesurfer/lib/qt' \
    --exclude='freesurfer/matlab' \
    --exclude='freesurfer/mni/share/man' \
    --exclude='freesurfer/subjects/fsaverage_sym' \
    --exclude='freesurfer/subjects/fsaverage3' \
    --exclude='freesurfer/subjects/fsaverage4' \
    --exclude='freesurfer/subjects/cvs_avg35' \
    --exclude='freesurfer/subjects/cvs_avg35_inMNI152' \
    --exclude='freesurfer/subjects/bert' \
    --exclude='freesurfer/subjects/lh.EC_average' \
    --exclude='freesurfer/subjects/rh.EC_average' \
    --exclude='freesurfer/subjects/sample-*.mgz' \
    --exclude='freesurfer/subjects/V1_average' \
    --exclude='freesurfer/trctrain'
    
ENV OS="Linux" \
    FS_OVERRIDE=0 \
    FIX_VERTEX_AREA="" \
    FSF_OUTPUT_FORMAT="nii.gz" \
    FREESURFER_HOME="/opt/freesurfer"
ENV SUBJECTS_DIR="$FREESURFER_HOME/subjects" \
    FUNCTIONALS_DIR="$FREESURFER_HOME/sessions" \
    MNI_DIR="$FREESURFER_HOME/mni" \
    LOCAL_DIR="$FREESURFER_HOME/local"
ENV PATH="$FREESURFER_HOME/bin:$FSFAST_HOME/bin:$FREESURFER_HOME/tktools:$PATH"

# installing workbench
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
                        connectome-workbench=1.2.3-1~nd90+1+nd16.10+1
                   
# Install Python 3.8
RUN add-apt-repository -y ppa:deadsnakes/ppa && apt-get update && apt-get install -y  python3.8 python3.8-dev python3.8-distutils wget 

RUN wget https://bootstrap.pypa.io/get-pip.py -O get-pip.py && python3.8 get-pip.py

# Python dependencies
RUN pip3.8 install numpy nibabel scipy

COPY . /BigBrainWarp

# BigBrainWarp config: fix paths, run init script, set default python to 3.8 (scripts call "python")
RUN sed -i s,bbwDir=.*,bbwDir=/BigBrainWarp,g /BigBrainWarp/scripts/init.sh &&\
    sed -i s,mnc2Path=.*,mnc2Path=/opt/minc-itk4/bin,g /BigBrainWarp/scripts/init.sh &&\
    bash /BigBrainWarp/scripts/init.sh && update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1

# Source the fsl and BigBrainWarp init scripts before running the command
ENTRYPOINT ["bash", "-c", "source /BigBrainWarp/scripts/init.sh && \"$@\"", "-s"]

# BigBrainWarp scripts must be run from this directory
WORKDIR /BigBrainWarp/scripts
