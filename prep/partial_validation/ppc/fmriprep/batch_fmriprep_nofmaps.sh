#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list.txt). And 
# runs the job_fmriprep.sh file for 
# each subject. It saves the ouput
# and error files in their specified
# directories.
#

# Set your directories
group_dir=/projects/sanlab/shared
container=containers/fmriprep-latest-2018-09-05.simg #poldracklab_fmriprep_latest-2017-12-07-ba92e815fc4e.img
freesurferlicense=/projects/sanlab/shared/containers/license.txt
study=CHIVES

# Set subject list
sublist=`cat subject_list_test.txt`

# Source task list
tasks=`cat tasks.txt`

# Submit fmriprep jobs for each subject
for sub in ${sublist}; do

SUBID=`echo $sub|awk '{print $1}' FS=,`
SESSID=`echo $sub|awk '{print $2}' FS=,`

sbatch --export ALL,subid=${sub},group_dir=${group_dir},study=${study},container=${container},freesurferlicense=${freesurferlicense} \
        --job-name fmriprep \
        --partition=long \
	--mem=100G \
	-o ${group_dir}/${study}/${study}_scripts/fMRI/ppc/output/${SUBID}_${SESSID}_fmriprep_output.txt \
	-e ${group_dir}/${study}/${study}_scripts/fMRI/ppc/output/${SUBID}_${SESSID}_fmriprep_error.txt \
	job_fmriprep_nofmaps.sh
done
