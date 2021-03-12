# extract-rsfc-pipeline
A surface-based rs-fMRI preprocessing script for extracting resting-state functional connectivity (RSFC) matrix from raw bold timeseries and T1w image.

## Requirements
1. FreeSurfer
2. Connectome Workbench
3. AFNI
4. FSL with MSM (Multimodal Surface Matching)
5. Ciftify 
* In python 3 environment with several libraries
  * Will be installed via script automatically with several packages (pip install ciftify)
    * NumPy, Pandas, SciPy, Nibabel, Matplotlib, Seaborn
Provided files
6. 1) run_proc.sh, 2) ext_rsfc.py, 3) Gordon_352_parc.dlabel.nii
