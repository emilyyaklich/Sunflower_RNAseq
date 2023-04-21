#!/bin/bash

set -o pipefail

# load SAMtools
ml SAMtools/1.10-GCC-8.3.0

# arrayID (minimum for slurm is zero)
if [[ "${QUEUE}" == "Slurm" ]]; then
	PBS_ARRAYID=$((SLURM_ARRAY_TASK_ID+1))

        # write Job IDs to a text file that will be used to keep track of exit codes
        echo "${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}" >> ${MB_JOB_LOG}
	echo "Processing array ${SLURM_ARRAY_TASK_ID} corresponding to line/file # ${PBS_ARRAYID}"
else
	echo "Processing array ${PBS_ARRAYID} through PBS queuing system"
fi


ID=$(sed -n ${PBS_ARRAYID}p $ID_NAMES) #finds the IDname

bams=$(find $MB_INPUTDIR -name "$ID[!0-9]*${MB_SUFFIX}") #files with the same ID

echo "Concatenating $(ls -1 $bams | wc -l) bam files for sample $ID"
echo "Bam files being Concatenated are: $(ls -1 $bams)"

#samtools merge -ru $MB_OUTPUTDIR/${ID}.merged.bam $bams
samtools cat -o $MB_OUTPUTDIR/${ID}.merged.bam $bams
