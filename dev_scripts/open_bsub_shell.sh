#!/bin/bash


# https://www.ibm.com/support/knowledgecenter/SSWRJV_10.1.0/lsf_command_ref/bsub.man_top.1.html


# settings used to install torch
#MEM_LIMIT=8192
#MIN_TASKS=8
#SCRATCH_SIZE=4096
#bsub -M $MEM_LIMIT -Is -n $MIN_TASKS -R"rusage[mem=$MEM_LIMIT, scratch=$SCRATCH_SIZE] select[model=XeonE52650, mem>$MEM_LIMIT] span[hosts=1]" $SHELL


# -Is [-tty]
# Submits an interactive job and creates a pseudo-terminal with shell mode when the job starts.
# -n min_tasks[,max_tasks]
# Submits a parallel job and specifies the number of tasks in the job.
# -M mem_limit [!]
# Sets a memory limit for all the processes that belong to the job.
# -q "queue_name ..."
# Submits the job to one of the specified queues.
# -R "res_req" [-R "res_req" ...]
# Runs the job on a host that meets the specified resource requirements.

#JOB_TYPE=standard
JOB_TYPE=gpu
#JOB_TYPE=parallel

#QUEUE=research-rh74
QUEUE=production-rh74

#MEM_LIMIT=16384
#MEM_LIMIT=20000
MEM_LIMIT=32768
#MEM_LIMIT=65536

#MIN_TASKS=8
MIN_TASKS=16


# open a shell on a stardard compute node
if [[ "$JOB_TYPE" = "standard" ]]; then
    bsub -Is -tty -M $MEM_LIMIT -R"select[mem>$MEM_LIMIT] rusage[mem=$MEM_LIMIT] span[hosts=1]" $SHELL
fi

# open a shell on a GPU node
# https://sysinf.ebi.ac.uk/doku.php?id=ebi_cluster_good_computing_guide#gpu_hosts
if [[ "$JOB_TYPE" = "gpu" ]]; then
    bsub -q $QUEUE -P gpu -gpu - -Is -tty -M $MEM_LIMIT -R"select[mem>$MEM_LIMIT] rusage[mem=$MEM_LIMIT] span[hosts=1]" $SHELL
fi

# open a parallel jobs shell
if [[ "$JOB_TYPE" = "parallel" ]]; then
    bsub -Is -tty -n $MIN_TASKS -M $MEM_LIMIT -R"select[mem>$MEM_LIMIT] rusage[mem=$MEM_LIMIT] span[hosts=1]" $SHELL
fi
