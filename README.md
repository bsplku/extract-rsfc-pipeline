# extract-rsfc-pipeline
A surface-based rs-fMRI preprocessing script for extracting resting-state functional connectivity (RSFC) matrix from raw bold timeseries and T1w image.

## Requirements
+ **FreeSurfer**
+ **Connectome Workbench**
+ **AFNI**
+ **FSL with MSM (Multimodal Surface Matching)**
+ **Ciftify**
+ In python 3 environment with several libraries
  + Will be installed via script automatically with several packages (pip install ciftify)
    + NumPy, Pandas, SciPy, Nibabel, Matplotlib, Seaborn
+ **Provided files**
 + run_proc.sh
 + ext_rsfc.py
 + Gordon_352_parc.dlabel.nii
