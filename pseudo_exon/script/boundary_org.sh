#! /usr/bin/env bash

if [ ! -d data/boundary_org ]
then
    mkdir -p data/boundary_org
fi

annot_utils exon --genome_id hg38 --add_ref_id data/boundary_org/exon.bed.gz
    
annot_utils boundary --donor_size 3,6 --acceptor_size 20,3 --genome_id hg38 data/boundary_org/boundary_raw.bed.gz

bedtools getfasta -fi db/GRCh38.primary_assembly.genome.fa -bed data/boundary_org/boundary_raw.bed.gz -fo data/boundary_org/boundary_fasta.tsv -tab -s 2>/dev/null

awk 'length($2) == 9' data/boundary_org/boundary_fasta.tsv | cut -f 2 > data/boundary_org/boundary_fasta_5.tsv
awk 'length($2) == 23' data/boundary_org/boundary_fasta.tsv | cut -f 2 > data/boundary_org/boundary_fasta_3.tsv

WORKDIR=`pwd`

cd ${WORKDIR}/bin/maxent
perl score5.pl ${WORKDIR}/data/boundary_org/boundary_fasta_5.tsv > ${WORKDIR}/data/boundary_org/boundary_fasta_5_score.tsv
perl score3.pl ${WORKDIR}/data/boundary_org/boundary_fasta_3.tsv > ${WORKDIR}/data/boundary_org/boundary_fasta_3_score.tsv

cd ${WORKDIR}

python script/boundary_org_proc2.py data/boundary_org/exon.bed.gz data/boundary_org/boundary_fasta.tsv data/boundary_org/boundary_fasta_5_score.tsv data/boundary_org/boundary_fasta_3_score.tsv | sort -k1,1 -k2,2n -k3,3n | uniq > data/boundary_org/boundary_proc.tsv

awk '$9 >= 5.28 && $12 >= 4.83 && $9 + $12 >= 11.87' data/boundary_org/boundary_proc.tsv > data/boundary_org/boundary_proc_filt.tsv

python script/get_3p_seq_final.py data/boundary_org/boundary_proc_filt.tsv data/boundary_org/boundary_org.fa 150

# python script/boundary_org_proc.py data/boundary_org/boundary_raw.bed.gz data/boundary_org/boundary_fasta.tsv data/boundary_org/boundary_fasta_5_score.tsv data/boundary_org/boundary_fasta_3_score.tsv > data/boundary_org/boundary_proc.tsv

