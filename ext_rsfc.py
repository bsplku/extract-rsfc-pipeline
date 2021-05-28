import os
import sys
import time
import numpy as np
import pandas as pd
import nibabel as nib
import seaborn as sns
import scipy.stats as stats
import matplotlib.pyplot as plt

args = sys.argv

bold_path = args[1]
parc_path = args[2]
save_path = args[3]

start_time = time.time()

# Loading parcellaiton and ptseries.nii file 
print("Loading input data ...", end="")

# Loading parcellation map
parc_map = nib.load(parc_path)
parc_arr = np.array(parc_map.dataobj)

# Loading preprocessed BOLD timeseries
bold_img = nib.load(bold_path)
print("Complete !")

# 2D bold dtseries --> 2D numpy array
bold_arr = np.array(bold_img.dataobj)

tot_vols = bold_arr.shape[0]
tot_rois = 352

# Applying GSR or just demeaning each vertex's timeseries
gsr_flag = False

if gsr_flag:
    bold_arr = bold_arr - np.expand_dims(np.mean(bold_arr, 1), 1)
else:
    bold_arr = bold_arr - np.expand_dims(np.mean(bold_arr, 0), 0)
 
# Make empty array to store parcellated BOLD
temp_bold_arr = np.zeros((tot_vols, tot_rois), dtype=np.float32)

print("Assigning each voxels to ROIs...", end=" ")      

for roi in range(tot_rois):
    roi_pos = (parc_arr == (roi + 1)).ravel()
    avg_bold = (np.mean(bold_arr[:, roi_pos], axis=1)).reshape(-1, 1)
    temp_bold_arr[:, [roi]] = avg_bold

print("Complete !")      
print("Parcellated timeseires shape: {}".format(temp_bold_arr.shape))

# Calculate temporal correaltion between ROIs
corr_mat = np.corrcoef(temp_bold_arr, rowvar=False)

# Extract only upper triagle matrix without diagonal components 
upper_corr_mat = corr_mat[np.triu_indices(tot_rois, k=1)]

# Fisher's R to Z transform
r_to_z_corr_mat = np.arctanh(upper_corr_mat)

# z-scoring
print("Running time to extract RSFC: %.2fsec" % (time.time() - start_time))
np.savez("{}/rsfc".format(save_path), X=r_to_z_corr_mat)
