#!/bin/bash
#SBATCH --job-name=grab_exit_codes
#SBATCH --partition=batch
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=1gb
#SBATCH --time=40:00:00
#SBATCH --output=ErrorFiles/grab_exit_codes.%j.out
#SBATCH --error=ErrorFiles/grab_exit_codes.%j.error
#SBATCH --mail-user=ely67071@uga.edu
#SBATCH --mail-type=ALL

# read in the file where all JOBs and task IDs were recorded (output from Adapter Trimming section of pipeline; Trimm.sh)
LOG_FILE="/scratch/ely67071/sunflower_data/RM_job_log_2nd_pass.txt"
# name the output file that will contain the exit codes
EXIT_CODE_FILE="/scratch/ely67071/sunflower_data/RM_exit_codes.txt"
NON_ZERO_EXIT_CODE_FILE="/scratch/ely67071/sunflower_data/RM_non_zero_exit_codes.txt"

lines=$(cat $LOG_FILE)

# loop through each JOB ID and record the exit code 
# additionally, check if 0:0 is not in the sacct output
for line in $lines
do
    exit_code=$(sacct -X -n --jobs $line)
    echo "${exit_code}" >> ${EXIT_CODE_FILE}
    
    # write to the job output file if any jobs have non-zero exit codes
    if [[ ${exit_code} != *"0:0"* ]];then echo "Job ID $line has non-zero Exit code" >>${NON_ZERO_EXIT_CODE_FILE}
fi
 


done

