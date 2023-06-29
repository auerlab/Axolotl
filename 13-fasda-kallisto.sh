#!/bin/sh -e

##########################################################################
#   Script description:
#
#   Dependencies:
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
    sbatch SLURM/13-fasda-kallisto.sbatch
else
    # Debug
    # rm -f Results/13-fasda-kallisto/*
    
    hw_threads=$(./get_hw_threads.sh)
    jobs=$(($hw_threads / 2))
    # Tried GNU parallel and ran into bugs.  Xargs just works.
    ls Results/04-kallisto-quant/*/abundance.tsv \
	| xargs -n 1 -P $jobs Xargs/13-fasda-kallisto.sh
fi
