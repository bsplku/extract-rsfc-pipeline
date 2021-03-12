#!/bin/bash

args=("$@")

# Set root working path
work_dir=${args[0]}

# Set subject's id
sub=${args[1]}

# Set task
tsk=${args[2]}

# Set n_cpus
n_cpus=${args[3]}

# Install ciftify package
pip install ciftify

# Make FreeSurfer output folder
mkdir -p ${work_dir}/data/${sub}/freesurfer/outputs

# Set environment variables
export SUBJECTS_DIR=${work_dir}/data/${sub}/freesurfer/outputs
export CIFTIFY_WORKDIR=${work_dir}/output
export FREESURFER_HOME=/usr/local/freesurfer
export FS_LICENSE=$FREESURFER_HOME/license.txt
source $FREESURFER_HOME/SetUpFreeSurfer.sh

# Set data directories 
top_dir=${work_dir}/data/${sub}
ant_dir=${top_dir}/anat
epi_dir=${top_dir}/func

gunzip -d ${ant_dir}/${sub}_T1w.nii.gz

# 1. Run FreeSurfer's recon-all for surface-based analysis
echo "-------------------------------------------------------------"
echo "1. Freesurfer recon-all"
echo "-------------------------------------------------------------"
recon-all -s ${sub} -i ${ant_dir}/${sub}_T1w.nii -all -qcache

# 2. Run ciftify-recon-all to make CIFTI format suface-based T1w
echo "-------------------------------------------------------------"
echo "2. ciftify recon-all"
echo "-------------------------------------------------------------"
ciftify_recon_all --ciftify-work-dir ${work_dir}/output            \
    --fs-subjects-dir $SUBJECTS_DIR                                \
    -v --n_cpus ${n_cpus} ${sub}

# 2-2. Generate QC (Quality Control) page of ciftify-recon-all
echo "-------------------------------------------------------------"
echo "2-2. ciftify vis-recon-all"
echo "-------------------------------------------------------------"
cifti_vis_recon_all snaps ${sub}  

# 3. Run AFNI's afni_proc.py to preprocess 4D rs-fMRI volume
echo "-------------------------------------------------------------"
echo "3. afni_proc.py"
echo "-------------------------------------------------------------"

afni_proc.py -subj_id ${sub}                                       \
    -script ${top_dir}/proc.${sub} -scr_overwrite                  \
    -blocks despike tshift align volreg mask scale regress         \
    -copy_anat ${ant_dir}/${sub}_T1w.nii                           \
    -dsets ${epi_dir}/${sub}_${tsk}_bold.nii                       \
    -align_opts_aea -cost lpc+ZZ -giant_move -check_flip           \
    -volreg_align_to MIN_OUTLIER                                   \
    -volreg_align_e2a                                              \
    -mask_epi_anat yes                                             \
    -mask_segment_anat yes                                         \
    -mask_apply anat                                               \
    -regress_censor_motion 0.3                                     \
    -regress_censor_outliers 0.1                                   \
    -regress_bandpass 0.008 0.09                                   \
    -regress_apply_mot_types demean deriv                          \
    -html_review_style pythonic

cd ${top_dir}

# Execute afni_proc.py
tcsh -xef ${top_dir}/proc.${sub} 2>&1 | tee ${top_dir}/output.proc.${sub}

mni_dir=${work_dir}/output/${sub}/MNINonLinear

# Convert output of afni_proc.py to NIFTI format
3dresample -input ${top_dir}/${sub}.results/all_runs.${sub}+orig   \
       -master ${mni_dir}/ROIs/Atlas_ROIs.2.nii.gz                 \
       -prefix ${epi_dir}/proc_bold.nii.gz                         \
       -overwrite -debug 1


# Using subcotical label in standard MNI space
yes | cp -rf ${mni_dir}/ROIs/Atlas_ROIs.2.nii.gz                   \
    ${mni_dir}/ROIs/ROIs.2.nii.gz

# 4. Run cifti-subject-fmri to register preprocessed fMRI to surface
echo "-------------------------------------------------------------"
echo "4. cifti-subject-fmri.py"
echo "-------------------------------------------------------------"
ciftify_subject_fmri ${epi_dir}/proc_bold.nii.gz                   \
    ${sub} ${tsk} --SmoothingFWHM 8 --n_cpus ${n_cpus}             \
    -v --debug

# 5. Run extract_rsfc.py to extract RSFC
echo "-------------------------------------------------------------"
echo "5. Running extract_rsfc.py"
echo "-------------------------------------------------------------"
bold_path=${mni_dir}/Results/${tsk}/${tsk}_Atlas_s8.dtseries.nii
parc_path=${work_dir}/Gordon_352_parc.dlabel.nii
save_path=${work_dir}/output/${sub}

python3 ${work_dir}/ext_rsfc.py ${bold_path} ${parc_path} ${save_path}


