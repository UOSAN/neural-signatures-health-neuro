# load neural signatures
multivariate = neurobase::readnii("~/Documents/code/sanlab/neural-signatures-health-neuro/neural_signatures/logistic_map.nii")
univariate = neurobase::readnii("~/Documents/code/sanlab/neural-signatures-health-neuro/neural_signatures/univariate_map.nii.gz")

# generate random patterns for multivariate signature
minVal = min(multivariate)
maxVal = max(multivariate)
meanVal = (minVal + maxVal) / 2
nVoxels = length(multivariate[!multivariate == 0])

for (i in 1:10){
  multi_new = multivariate
  multi_new[!multi_new == 0] = runif(nVoxels, minVal, maxVal) - meanVal
  neurobase::writenii(multi_new, sprintf("~/Documents/code/sanlab/neural-signatures-health-neuro/neural_signatures/random/multivariate%s_map", i))
}

# generate random patterns for univariate signature
minVal = min(univariate)
maxVal = max(univariate)
meanVal = (minVal + maxVal) / 2
nVoxels = length(univariate[!univariate == 0])

for (i in 1:10){
  uni_new = univariate
  uni_new[!uni_new == 0] = runif(nVoxels, minVal, maxVal) - meanVal
  neurobase::writenii(uni_new, sprintf("~/Documents/code/sanlab/neural-signatures-health-neuro/neural_signatures/random/univariate%s_map", i))
}
