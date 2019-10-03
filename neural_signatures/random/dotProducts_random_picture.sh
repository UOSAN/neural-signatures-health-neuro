#!/bin/bash

# This script extracts mean parameter estimates and SDs within an map or parcel
# from subject images (e.g. FX condition contrasts). Output is 
# saved as a text file in the output directory.

# Execute R script to generate random nifti images
#Rscript generate_random_signatures.R 

# Set paths and variables
# ------------------------------------------------------------------------------------------
# variables
maps=$(ls ~/Documents/code/sanlab/neural-signatures-health-neuro/neural_signatures/random/*.nii.gz)
template=~/Documents/code/sanlab/neural-signatures-health-neuro/neural_signatures/random/multivariate4_map.nii.gz
betasALL=`echo $(printf "beta_%04d.nii\n" {1..40}) $(printf "beta_%04d.nii\n" {48..87})`
betasCHIVES1072=`echo $(printf "beta_%04d.nii\n" {1..40}) $(printf "beta_%04d.nii\n" {48..58})`
betasRUN1=`echo $(printf "beta_%04d.nii\n" {1..40})`

# paths
image_dir=~/Documents/code/sanlab/NSC_scripts/data/picture_betaseries
output_dir=~/Documents/code/sanlab/NSC_scripts/data/dotProducts_picture

if [ ! -d ${output_dir} ]; then
	mkdir -p ${output_dir}
fi

# Calculate dot products
# ------------------------------------------------------------------------------------------
cd ${image_dir}

for subname in $(ls -d sub*); do
	SUB=$(echo ${subname:4:14})
	echo ${SUB}
	subdir=${image_dir}/sub-${SUB}
	if [ $subname == sub-CHIVES1072 ]; then
		betas=$betasCHIVES1072
	elif [ $subname == sub-CHIVES1045 ]; then
		betas=$betasRUN1
	elif [ $subname == sub-CHIVES1074 ]; then
		betas=$betasRUN1
	elif [ $subname == sub-CHIVES1102 ]; then
		betas=$betasRUN1
	else
		betas=$betasALL
	fi
	for beta in ${betas[@]}; do
		3dAllineate -source ${subdir}/${beta} -master ${template} -final NN -1Dparam_apply '1D: 12@0'\' -prefix ${subdir}/aligned_${beta}
		for map in ${maps[@]}; do
			map_name=$(echo ${map: 95}) 
			echo ${SUB} ${beta} ${map_name} `3ddot -dodot ${subdir}/aligned_${beta} ${map}` >> "${output_dir}"/"${SUB}"_dotProducts.txt
		done
	done
done
