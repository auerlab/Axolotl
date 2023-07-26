#!/bin/sh -e

##########################################################################
#   Script description:
#       Run quality checks on raw and trimmed data for comparison
#       Based on work of Dr. Andrea Rau:
#       https://github.com/andreamrau/OpticRegen_2019
#
#   Dependencies:
#       Requires directory structure.  Run after *-organize.sh.
#
#       All necessary tools are assumed to be in PATH.  If this is not
#       the case, add whatever code is needed here to gain access.
#       (Adding such code to your .bashrc or other startup script is
#       generally a bad idea since it's too complicated to support
#       every program with one environment.)
#
#   History:
#   Date        Name        Modification
#   2023-06     Jason Bacon Begin
##########################################################################

if which sbatch; then
    sbatch SLURM/12-hisat2-align.sbatch
else
    # Debug
    # rm -f Results/12-hisat2-align/*
    
    hw_threads=$(../Common/get-hw-threads.sh)
    hw_mem=$(../Common/get-hw-mem.sh)
    
    # FIXME: Use half of available memory per job?
    jobs=$(($hw_threads / 4))
    
    # Tried GNU parallel and ran into bugs.  Xargs just works.
    ls Results/04-trim/*-R1.fastq.zst | \
	xargs -n 1 -P $jobs Xargs/12-hisat2-align.sh 4
fi
