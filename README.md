# extract-rsfc-pipeline
A surface-based rs-fMRI preprocessing script for extracting resting-state functional connectivity (RSFC) matrix from raw BOLD timeseries and T1w image.

## Requirements
+ Python 3.6+
+ FreeSurfer
+ Connectome Workbench
+ AFNI
+ FSL with MSM (Multimodal Surface Matching)**
+ Ciftify
  + In python 3 environment with several libraries
    + Will be installed via script automatically with several packages
    + ```sh
      pip install ciftify
      ```
## Provided files
 + run_proc.sh
   + Shell-based main script
 + ext_rsfc.py
   + Python-based code for extracting RSFC matrix from dtseries.nii (BOLD timeseries)
 + Gordon_352_parc.dlabel.nii
   + Parcellation atlas from **Gordon et al., 2016**
 
 ## Detailed Description
[Link](./extract_rsfc_pipeline.pdf)
 ## Sample data
[Link](https://drive.google.com/file/d/1kjHRdeLG5D9WlM_46NqJNw_Fo-v17kz7/view)
 
## Reference
[1] [Dickie, E. W., Anticevic, A., Smith, D. E., Coalson, T. S., Manogaran, M., Calarco, N., ... & Voineskos,
A. N. (2019). Ciftify: A framework for surface-based analysis of legacy MR acquisitions. Neuroimage, 197,
818-826](https://pubmed.ncbi.nlm.nih.gov/31091476/)

## Author
Jinwoo Hong / jw_hong@korea.ac.kr
