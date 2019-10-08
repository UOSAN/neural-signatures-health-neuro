#!/bin/bash

# This script takes the dot product of template maps and subject beta maps. Output is 
# saved as a text file in the output directory.

# Execute R script to generate random nifti images
#Rscript generate_random_signatures.R 

# Set paths and variables
# ------------------------------------------------------------------------------------------
# variables
maps=$(ls /projects/sanlab/shared/NSC/neural-signatures-health-neuro/neural_signatures/empirical_null/maps/*.nii.gz)
template=/projects/sanlab/shared/NSC/neural-signatures-health-neuro/neural_signatures/empirical_null/maps/multivariate1_map.nii.gz
betasALL=`echo $(printf "beta_%04d.nii\n" {1..20}) $(printf "beta_%04d.nii\n" {28..47}) $(printf "beta_%04d.nii\n" {55..74}) $(printf "beta_%04d.nii\n" {82..101})`
betasDEV022=`echo $(printf "beta_%04d.nii\n" {1..20}) $(printf "beta_%04d.nii\n" {28..47}) $(printf "beta_%04d.nii\n" {55..74}) $(printf "beta_%04d.nii\n" {82..89})`
betasDEV060=`echo $(printf "beta_%04d.nii\n" {1..19}) $(printf "beta_%04d.nii\n" {27..46}) $(printf "beta_%04d.nii\n" {54..73}) $(printf "beta_%04d.nii\n" {81..100})`
betasDEV061=`echo $(printf "beta_%04d.nii\n" {1..20}) $(printf "beta_%04d.nii\n" {28..47}) $(printf "beta_%04d.nii\n" {55..73}) $(printf "beta_%04d.nii\n" {81..100})`
betasDEV063=`echo $(printf "beta_%04d.nii\n" {1..20}) $(printf "beta_%04d.nii\n" {28..38}) $(printf "beta_%04d.nii\n" {46..65}) $(printf "beta_%04d.nii\n" {73..92})`
betasDEV082=`echo $(printf "beta_%04d.nii\n" {1..20}) $(printf "beta_%04d.nii\n" {28..42}) $(printf "beta_%04d.nii\n" {50..69}) $(printf "beta_%04d.nii\n" {77..96})`

# paths
image_dir=/projects/sanlab/shared/DEV/nonbids_data/fMRI/fx/models/ROC/betaseries
output_dir=/projects/sanlab/shared/NSC/neural-signatures-health-neuro/neural_signatures/empirical_null/dotProducts_complete_validation

if [ ! -d ${output_dir} ]; then
	mkdir -p ${output_dir}
fi

# Calculate dot products
# ------------------------------------------------------------------------------------------
cd ${image_dir}

echo ${SUB}
subdir=${image_dir}/sub-${SUB}
if [ $SUB == DEV022 ]; then
	betas=$betasDEV022
elif [ $SUB == DEV060 ]; then
	betas=$betasDEV060
elif [ $SUB == DEV061 ]; then
	betas=$betasDEV061
elif [ $SUB == DEV063 ]; then
	betas=$betasDEV063
elif [ $SUB == DEV082 ]; then
	betas=$betasDEV082
else
	betas=$betasALL
fi
for beta in ${betas[@]}; do
	3dAllineate -source ${subdir}/${beta} -master ${template} -final NN -1Dparam_apply '1D: 12@0'\' -prefix ${subdir}/aligned_${beta}
	for map in ${maps[@]}; do
		map_name=$(echo ${map: 89}) 
		echo ${SUB} ${beta} ${map_name} `3ddot -dodot ${subdir}/aligned_${beta} ${map}` >> "${output_dir}"/"${SUB}"_dotProducts.txt
	done
done
