# neural-signatures-health-neuro
This repository contains code for the manuscript [Multivariate neural signatures for health neuroscience: Assessing spontaneous regulation during food choice](https://psyarxiv.com/sjg64). The OSF project for this manuscript can be found [here](https://osf.io/7jf82/).

## directory structure
* `CR_analyses` = data and scripts related to the Craving Regulation task analyses  
* `FV_analyses` = data and scripts related to the Food Valuation task analyses  
* `demographics` = data and scripts related to demographic information within samples  
* `neural_signatures` = data and scripts related to the development of the neural signatures and craving regulation neural signature nifti files  
    * `empirical_null` = data and scripts related to the simulated neural signatures used to create an empirical null distribution of accuracy  
* `prep` = data and scripts related to dicom conversion, preprocessing, and first-level modeling  
* `dcm2bids` = scripts for converting dicoms to nifti files in BIDS format  
* `fx` = data and scripts for running first-level models  
    * `models` = scripts for running first-level models in [SPM12](https://www.fil.ion.ucl.ac.uk/spm/software/spm12/)  
    * `motion` = scripts for automated motion assessment to identify visual motion artifacts using [auto-motion-fmriprep](https://github.com/dcosme/auto-motion-fmriprep)  
    * `multiconds` = scripts for creating event multicondition files for first-level modeling  
* `ppc` = data and scripts for preprocessing using [fMRIPrep](https://fmriprep.readthedocs.io/en/stable/) and smoothing in SPM12  

Please note that the Craving Regulation (CR) task is also called the picture task in the partial validation sample and the ROC task in the complete validation sample in the prep directories; the Food Valuation (FV) task is also called the money task in the partial validation sample and the WTP task in the complete validation sample.

```
├── CR_analyses
│   ├── dotProducts_complete_validation
│   └── dotProducts_partial_validation
├── FV_analyses
│   ├── dotProducts_complete_validation
│   └── dotProducts_partial_validation
├── demographics
├── neural_signatures
│   └── empirical_null
│       ├── dotProducts_complete_validation
│       └── dotProducts_partial_validation
└── prep
    ├── complete_validation
    │   ├── dcm2bids
    │   │   ├── bidsQC
    │   │   │   └── images
    │   │   └── conversion
    │   ├── fx
    │   │   ├── models
    │   │   │   ├── ROC
    │   │   │   └── WTP
    │   │   ├── motion
    │   │   │   └── auto-motion-fmriprep
    │   │   │       ├── rp_txt
    │   │   │       └── summary
    │   │   └── multiconds
    │   │       ├── ROC
    │   │       │   └── betaseries
    │   │       └── WTP
    │   │           └── betaseries
    │   └── ppc
    │       └── smooth
    └── partial_validation
        ├── dcm2bids
        │   └── bidsQC
        │       └── images
        ├── fx
        │   ├── models
        │   │   ├── money
        │   │   └── picture
        │   ├── motion
        │   │   └── auto-motion-fmriprep
        │   │       ├── rp_txt
        │   │       └── summary
        │   └── multiconds
        │       ├── money
        │       └── picture
        └── ppc
            ├── fmriprep
            └── smooth
```
