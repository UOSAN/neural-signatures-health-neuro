#!/bin/bash
#
# This batch file calls on your subject list (which contains both ID and wave number: SID000,wave1). 
# And runs the job_fmriprep.sh file for each subject. 
# It saves the ouput and error files in specified directories.
#
# Set your directories

container=containers/fmriprep-latest-2018-09-05.simg
freesurferlicense=/projects/sanlab/shared/containers/license.txt
group_dir=/projects/sanlab/shared/ #set path to directory within which study folder lives
study=DEV
study_dir="${group_dir}""${study}"
output_dir="${study_dir}"/"${study}"_scripts/fMRI/ppc/output

if [ ! -d "${output_dir}" ]; then
    mkdir -v "${output_dir}"
fi


# Set subject list
subject_list=`cat subject_list.txt` 

# Loop through subjects and run job_mriqc
for subject in $subject_list; do
	subid=`echo $subject|awk '{print $1}' FS=","`
	sessid=`echo $subject|awk '{print $2}' FS=","` 
	sbatch --export ALL,subid=${subid},sessid=${sessid},group_dir=${group_dir},study_dir=${study_dir},study=${study},container=${container},freesurferlicense=${freesurferlicense} \
		   --job-name fmriprep \
		   --partition=short \
		   --cpus-per-task=28 \
		   --mem=100G \
		   -o "${output_dir}"/"${subid}"_"${sessid}"_fmriprep_output.txt \
		   -e "${output_dir}"/"${subid}"_"${sessid}"_fmriprep_error.txt \
		   job_fmriprep.sh
done