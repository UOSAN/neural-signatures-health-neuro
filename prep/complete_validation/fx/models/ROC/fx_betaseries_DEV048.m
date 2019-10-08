%-----------------------------------------------------------------------
% Job saved on 06-May-2019 21:13:12 by cfg_util (rev $Rev: 6942 $)
% spm SPM - SPM12 (7219)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/projects/sanlab/shared/DEV/bids_data/derivatives/fmriprep/sub-DEV048/ses-wave1/func/'};
matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.filter = 's6_sub-DEV048_ses-wave1_task-ROC_acq-1_bold_space-MNI152NLin2009cAsym_preproc.nii';
matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/projects/sanlab/shared/DEV/bids_data/derivatives/fmriprep/sub-DEV048/ses-wave1/func/'};
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.filter = 's6_sub-DEV048_ses-wave1_task-ROC_acq-2_bold_space-MNI152NLin2009cAsym_preproc.nii';
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/projects/sanlab/shared/DEV/bids_data/derivatives/fmriprep/sub-DEV048/ses-wave1/func/'};
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.filter = 's6_sub-DEV048_ses-wave1_task-ROC_acq-3_bold_space-MNI152NLin2009cAsym_preproc.nii';
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{4}.spm.util.exp_frames.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (s6_sub-DEV048_ses-wave1_task-ROC_acq-1_bold_space-MNI152NLin2009cAsym_preproc.nii)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{4}.spm.util.exp_frames.frames = Inf;
matlabbatch{5}.spm.util.exp_frames.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (s6_sub-DEV048_ses-wave1_task-ROC_acq-2_bold_space-MNI152NLin2009cAsym_preproc.nii)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{5}.spm.util.exp_frames.frames = Inf;
matlabbatch{6}.spm.util.exp_frames.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (s6_sub-DEV048_ses-wave1_task-ROC_acq-3_bold_space-MNI152NLin2009cAsym_preproc.nii)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{6}.spm.util.exp_frames.frames = Inf;
matlabbatch{7}.spm.stats.fmri_spec.dir = {'/projects/sanlab/shared/DEV/nonbids_data/fMRI/fx/models/ROC/betaseries/sub-DEV048'};
matlabbatch{7}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{7}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{7}.spm.stats.fmri_spec.timing.fmri_t = 72;
matlabbatch{7}.spm.stats.fmri_spec.timing.fmri_t0 = 36;
matlabbatch{7}.spm.stats.fmri_spec.sess(2).scans(1) = cfg_dep('Expand image frames: Expanded filename list.', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{7}.spm.stats.fmri_spec.sess(2).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{7}.spm.stats.fmri_spec.sess(2).multi = {'/projects/sanlab/shared/DEV/DEV_scripts/fMRI/fx/multiconds/ROC/betaseries/DEV048_1_ROC1.mat'};
matlabbatch{7}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
matlabbatch{7}.spm.stats.fmri_spec.sess(2).multi_reg = {'/projects/sanlab/shared/DEV/DEV_scripts/fMRI/fx/motion/auto-motion-fmriprep/rp_txt/rp_DEV048_1_ROC_1.txt'};
matlabbatch{7}.spm.stats.fmri_spec.sess(2).hpf = 128;
matlabbatch{7}.spm.stats.fmri_spec.sess(3).scans(1) = cfg_dep('Expand image frames: Expanded filename list.', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{7}.spm.stats.fmri_spec.sess(3).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{7}.spm.stats.fmri_spec.sess(3).multi = {'/projects/sanlab/shared/DEV/DEV_scripts/fMRI/fx/multiconds/ROC/betaseries/DEV048_1_ROC2.mat'};
matlabbatch{7}.spm.stats.fmri_spec.sess(3).regress = struct('name', {}, 'val', {});
matlabbatch{7}.spm.stats.fmri_spec.sess(3).multi_reg = {'/projects/sanlab/shared/DEV/DEV_scripts/fMRI/fx/motion/auto-motion-fmriprep/rp_txt/rp_DEV048_1_ROC_2.txt'};
matlabbatch{7}.spm.stats.fmri_spec.sess(3).hpf = 128;
matlabbatch{7}.spm.stats.fmri_spec.sess(4).scans(1) = cfg_dep('Expand image frames: Expanded filename list.', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{7}.spm.stats.fmri_spec.sess(4).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{7}.spm.stats.fmri_spec.sess(4).multi = {'/projects/sanlab/shared/DEV/DEV_scripts/fMRI/fx/multiconds/ROC/betaseries/DEV048_1_ROC3.mat'};
matlabbatch{7}.spm.stats.fmri_spec.sess(4).regress = struct('name', {}, 'val', {});
matlabbatch{7}.spm.stats.fmri_spec.sess(4).multi_reg = {'/projects/sanlab/shared/DEV/DEV_scripts/fMRI/fx/motion/auto-motion-fmriprep/rp_txt/rp_DEV048_1_ROC_3.txt'};
matlabbatch{7}.spm.stats.fmri_spec.sess(4).hpf = 128;
matlabbatch{7}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{7}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{7}.spm.stats.fmri_spec.volt = 1;
matlabbatch{7}.spm.stats.fmri_spec.global = 'None';
matlabbatch{7}.spm.stats.fmri_spec.mthresh = -Inf;
matlabbatch{7}.spm.stats.fmri_spec.mask = {'/projects/sanlab/shared/spm12/canonical/MNI152_T1_1mm_brain_mask.nii,1'};
matlabbatch{7}.spm.stats.fmri_spec.cvi = 'FAST';
matlabbatch{8}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{8}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{8}.spm.stats.fmri_est.method.Classical = 1;
