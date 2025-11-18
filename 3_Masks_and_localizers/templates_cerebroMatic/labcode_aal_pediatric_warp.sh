
## warp atlas T1 image to template
auto_warp.py -base mw_com_T1_Age_0072.nii -input MNI_T1.nii -skull_strip_input yes

## apply the nonlinear transformation to Atlas file
# 3dNwarpApply -master MNI_T1.aw.nii -dxyz 2 -source aal_MNI_V4.nii -nwarp "anat.un.aff.qw_WARP.nii anat.un.aff.nii.Xaff12.1D" -ainterp NN -prefix aal_MNI_V4_NL.nii



