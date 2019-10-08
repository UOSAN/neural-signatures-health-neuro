#!/bin/bash
#--------------------------------------------------------------
# This script executes $SHELL_SCRIPT for $SUB and matlab $SCRIPT
#	
# D.Cos 2018.11.06
#--------------------------------------------------------------

# Set your study scripts folder
STUDY=/projects/sanlab/shared/CHIVES/CHIVES_scripts

# Set subject list
SUBJLIST=`cat test_subject_list.txt`

# Which SID should be replaced?
REPLACESID=CHIVES1001

# SPM Path
SPM_PATH=/projects/sanlab/shared/spm12

# Set MATLAB script path
SCRIPT=${STUDY}/fMRI/ppc/smooth/smooth_money.m

# Set shell script to execute
SHELL_SCRIPT=spm_job.sh

# Tag the results files
RESULTS_INFIX=smooth_money

# Set output dir and make it if it doesn't exist
OUTPUTDIR=${STUDY}/fMRI/ppc/smooth/output

if [ ! -d ${OUTPUTDIR} ]; then
	mkdir -p ${OUTPUTDIR}
fi

# Set job parameters
cpuspertask=1
mempercpu=8G

# Create and execute batch job
for SUB in $SUBJLIST; do
	 	sbatch --export ALL,REPLACESID=$REPLACESID,SCRIPT=$SCRIPT,SUB=$SUB,SPM_PATH=$SPM_PATH,  \
		 	--job-name=${RESULTS_INFIX} \
		 	-o ${OUTPUTDIR}/${SUB}_${RESULTS_INFIX}.log \
		 	--cpus-per-task=${cpuspertask} \
		 	--mem-per-cpu=${mempercpu} \
		 	--account=sanlab \
		 	${SHELL_SCRIPT}
	 	sleep .25
done
