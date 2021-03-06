#!/bin/bash
#PBS -l walltime=2:00:00
#PBS -l select=1:ncpus=1:mem=5gb
# NOTE: FSL can experience parallelization issues when run like this. If submitting this job as a batch job has issues, run RUN WITH QSUB -I <script>

module load fsl
source ${FSLDIR}/etc/fslconf/fsl.sh

# Use a space-separated list of your participants, in the format as follows
participant_list=("P1" "P2");

# This directory containing the nifti files from which you will compute the motion outliers. 
datadir=("/rds/general/user/ExperimentData/done");

# This directory is where you will put the computed motion outlier values. In this case, we will use DVARS. 
DVARSdir=("/rds/general/user/MotionOutliers/DVARS")

for p in ${participant_list[@]}

do

cd ${datadir}/${p}.feat

fsl_motion_outliers -i filtered_func_data.nii.gz -o ConfMatrix_DVARS.mat --dvars --thresh=50 -s DVARS_${p}.txt -p DVARS_img ;

DVARS=DVARS_${p}.txt

cp ${DVARS} -t ${DVARSdir}

done
