# specify paths
input_dir = "/projects/sanlab/shared/NSC/neural-signatures-health-neuro/neural_signatures"
output_dir = "/projects/sanlab/shared/NSC/neural-signatures-health-neuro/neural_signatures/empirical_null/maps"

# load neural signatures
multivariate = neurobase::readnii(file.path(input_dir,"multivariate.nii.gz"))
univariate = neurobase::readnii(file.path(input_dir,"univariate_regulate_look.nii.gz"))

# generate random patterns for multivariate signature
minVal = min(multivariate)
maxVal = max(multivariate)
meanVal = (minVal + maxVal) / 2
nVoxels = length(multivariate[!multivariate == 0])

for (i in 1:100){
  multi_new = multivariate
  multi_new[!multi_new == 0] = runif(nVoxels, minVal, maxVal) - meanVal
  neurobase::writenii(multi_new, sprintf("%s/multivariate%s_map.nii.gz", output_dir, i))
}

# generate random patterns for univariate signature
minVal = min(univariate)
maxVal = max(univariate)
meanVal = (minVal + maxVal) / 2
nVoxels = length(univariate[!univariate == 0])

for (i in 1:100){
  uni_new = univariate
  uni_new[!uni_new == 0] = runif(nVoxels, minVal, maxVal) - meanVal
  neurobase::writenii(uni_new, sprintf("%s/univariate%s_map.nii.gz", output_dir, i))
}
