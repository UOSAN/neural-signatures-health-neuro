#!/bin/bash
#
# This script runs fmriprep on subjects located in the 
# BIDS directory and saves ppc-ed output and motion confounds
# in the derivatives folder.

# Set bids directories
bids_dir=${group_dir}/${study}/bids_data
derivatives=${bids_dir}/derivatives
working_dir=${derivatives}/working/
image=${group_dir}/${container}

echo -e \nFmriprep on ${subid}
echo -e \nContainer: ${image}
echo -e \nSubject directory: ${bids_dir}

# Load packages
module load singularity

# Create working directory
if [ ! -d ${working_dir} ]; then
	mkdir -p ${working_dir}
fi

# Run container using singularity
cd ${bids_dir}

# Source task list
tasks=`cat /projects/sanlab/shared/CHIVES/CHIVES_scripts/fMRI/ppc/fmriprep/tasks.txt`

for task in ${tasks}; do
	echo -e \nStarting on: ${task}
	echo -e \n

	singularity run --bind ${group_dir}:${group_dir} ${image} ${bids_dir} ${derivatives} participant \
					--participant_label ${subid} \
					-t ${task} \
					-w ${working_dir} \
					--output-space {T1w,template,fsaverage5,fsnative} \
					--nthreads 1 \
					--mem-mb 100000 \
					--fs-license-file ${freesurferlicense}

	echo -e \n
	echo -e \ndone
	echo -e \n-------------------------------
done

# clean tmp folder
/usr/bin/rm -rvf /tmp/fmriprep*

