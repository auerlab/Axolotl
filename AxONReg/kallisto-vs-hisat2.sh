#!/bin/sh -e


##########################################################################
#   Function description:
#       Pause until user presses return
##########################################################################

pause()
{
    local junk
    
    printf "Press return to continue..."
    read junk
}

# Abundances
kallisto=Results/09-kallisto-quant/sample01-time1-rep1/abundance.tsv
hisat2_exact=Results/13-fasda-abundance-hisat2/sample01-time1-rep1-abundance-exact.tsv
hisat2=Results/13-fasda-abundance-hisat2/sample01-time1-rep1-abundance.tsv
# more $hisat2

wc -l $kallisto $hisat2_exact $hisat2
pause

# FIXME: kallisto transcript IDs contain a ';'
for transcript in $(awk '$1 != "target_id" { print $1 }' $hisat2); do
    # printf "transcript = $transcript\n"
    if fgrep -q $transcript $kallisto; then
	printf '===\n'
	printf "          "
	head -1 $hisat2
	printf "Kallisto: "
	fgrep $transcript $kallisto || true
	printf "Hisat2e:  "
	fgrep $transcript $hisat2_exact || true
	printf "Hisat2s:  "
	fgrep $transcript $hisat2 || true
	
	# Based on normalized counts
	#k=$(awk -v t=$transcript '$1 == t { print $2 + $3 + $4 }' $kallisto)
	#h=$(awk -v t=$transcript '$1 == t { print $2 + $3 + $4 }' $hisat2)
	#printf "$h / ($k + .0000001)\n" | bc -l
    fi
done | more
exit

# Normalized
kallisto=Results/10-fasda-kallisto/time1-all-norm.tsv
hisat2=Results/13-fasda-hisat/time1-all-norm.tsv
for transcript in $(awk '$1 != "target_id" { print $1 }' $hisat2); do
    # printf "transcript = $transcript\n"
    if fgrep -q $transcript $kallisto; then
	printf '===\n'
	printf "          "
	head -1 $hisat2
	printf "Kallisto: "
	fgrep $transcript $kallisto || true
	printf "Hisat2e:  "
	fgrep $transcript $hisat2_exact || true
	printf "Hisat2s:  "
	fgrep $transcript $hisat2 || true
	
	# Based on normalized counts
	k=$(awk -v t=$transcript '$1 == t { print $2 + $3 + $4 }' $kallisto)
	h=$(awk -v t=$transcript '$1 == t { print $2 + $3 + $4 }' $hisat2)
	printf "$h / ($k + .0000001)\n" | bc -l
    fi
done | more

# Fold-changes
kallisto=Results/10-fasda-kallisto/time1-time2-FC.txt
hisat2=Results/14-fasda-fc-hisat2/time1-time2-FC.txt
for transcript in $(awk '{ print $1 }' $hisat2 | head -100); do
    if fgrep -q $transcript $kallisto; then
	echo $transcript
	grep $transcript $kallisto
	grep $transcript $hisat2
    fi
done | more
