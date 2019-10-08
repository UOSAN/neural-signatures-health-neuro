#!/bin/bash
#--------------------------------------------------------------
# This script executes $SHELL_SCRIPT for $SUB 
#	
# D.Cos 2018.11.06
#--------------------------------------------------------------

# Set subject list
SUBJLIST=`cat subject_list_partial.txt`

# Set shell script to execute
SHELL_SCRIPT=dotProducts_random_partial.sh

# RRV the results files
RESULTS_INFIX=dots_random

# Set output dir and make it if it doesn't exist
OUTPUTDIR=/projects/sanlab/shared/NSC/neural-signatures-health-neuro/neural_signatures/empirical_null/output

# Map dir where random maps will be output
MAPDIR=/projects/sanlab/shared/NSC/neural-signatures-health-neuro/neural_signatures/empirical_null/maps

if [ ! -d ${OUTPUTDIR} ]; then
	mkdir -p ${OUTPUTDIR}
fi

# Set job parameters
cpuspertask=1
mempercpu=8G

# Run rscript
if [ ! -d ${MAPDIR} ]; then
    mkdir -p ${MAPDIR}
    module load R
    Rscript generate_random_signatures.R
fi

# Create and execute batch job
for SUB in $SUBJLIST; do
 	sbatch --export ALL,SUB=$SUB,  \
	 	--job-name=${RESULTS_INFIX} \
	 	-o ${OUTPUTDIR}/${SUB}_${RESULTS_INFIX}.log \
	 	--cpus-per-task=${cpuspertask} \
	 	--mem-per-cpu=${mempercpu} \
	 	--account=sanlab \
	 	${SHELL_SCRIPT}
 	sleep .25
done
