# extract-rsfc-pipeline
A surface-based rs-fMRI preprocessing script for extracting resting-state functional connectivity (RSFC) matrix from raw bold timeseries and T1w image.

## Requirements
+ **FreeSurfer**
+ **Connectome Workbench**
+ **AFNI**
+ **FSL with MSM (Multimodal Surface Matching)**
+ **Ciftify**
  + In python 3 environment with several libraries
    + Will be installed via script automatically with several packages
    + ```sh
      pip install ciftify
      ```
+ **Provided files**
   + run_proc.sh
     + Main preprocessing script
   + ext_rsfc.py
     + Code for extracting RSFC matrix from dtseries.nii
   + Gordon_352_parc.dlabel.nii
     + Parcellation atlas from **Gordon et al., 2016**
 
 ## Check this pdf file for more details of this script
 [**link for pdf file**](http://bspl.korea.ac.kr/Board/Members_Only/Research_Materials/Code_Tool/rs-fMRI_preprocessing_script.pdf)

 ## Check the sample directory
[**link for sample directory**](https://drive.google.com/file/d/1kjHRdeLG5D9WlM_46NqJNw_Fo-v17kz7/view)
 
