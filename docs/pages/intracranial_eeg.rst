Mapping an atlas of intracranial EEG to BigBrain space
======================================================

Normal physiological activity of neuronal populations have been recorded with stereo-EEG electrodes and cortical grids/strips, and collated across 106 subjects to construct a atlaas of intracranial EEG with 1785 channels (Frauscher et al., 2018). The electrode traces and their positions (co-registered to MNI152) are provided as an open web resource (https://mni-open-ieegatlas.research.mcgill.ca). Here, we aim to adjust the coordinates of the electrodes to BigBrain space to facilitate complementary histological analyses.

.. image:: BigBrainWarp/images/frauscher.2018.PNG

Step 1: Coordinates -> Volume
*******************************
Electrode channels locations are provided as a list of coordinates in MNI152 (specifcally, ICBM2009 nonlinear symmetric space). First, we project the channel locations into a MNI152 mask.

.. code-block:: matlab

    % create empty volume using the icbm mask
    hdr = niftiinfo([bbwDir '/maps/mni152_space/mni_icbm152_t1_tal_nlin_sym_09c_mask.nii']);
    vol = zeros(hdr.ImageSize);

    % load channel coordinates
    tbl = readtable([homeDir '/data/ChannelInformation.csv']);  % downloaded from https://mni-open-ieegatlas.research.mcgill.ca 
    
    % place channels in the volume
    subs = round(table2array(tbl(:,6:8)) - hdr.Transform.T(4,1:3)); % get 3D subscript of each channel
    ind = sub2ind(hdr.ImageSize, subs(:,1), subs(:,2), subs(:,3));
    vol(ind) = 1:length(ind);
    
    % save out volume
    hdr2 = hdr;
    hdr2.Filename = [bbwDir '/maps/mni152_space/iEEG_channels_icbm.nii'];
    hdr2.Description = 'ChannelInformation.csv on mni_icbm152_t1_tal_nlin_sym_09c_mas';
    niftiwrite(single(vol), [bbwDir '/maps/mni152_space/iEEG_channels_icbm.nii'], hdr2)


Step 2: MNI152 -> BigBrain 
*******************************

Next, we use a three-step transformation procedure (2 nonlinear, 1 linear) to realign the MNI152 volume to BigBrain space. The three-step procedure is contained in icbm_to_bigbrain.sh, which requires two arguments: the file name to be transformed and the path to the BigBrainWarp directory.

.. code-block:: bash

    bbwDir=/path/to/BigBrainWarp
    nii2mnc ${bbwDir}/maps/mni152_space/iEEG_channels_icbm.nii ${bbwDir}/maps/mni152_space/iEEG_channels_icbm.mnc
    sh icbm_to_bigbrain.sh ${bbwDir}/maps/mni152_space/iEEG_channels_icbm $bbwWarp
    
 
