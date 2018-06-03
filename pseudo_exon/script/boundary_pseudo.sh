#! /usr/bin/env bash

set -x

if [ ! -d data/boundary_pseudo ]
then
    mkdir -p data/boundary_pseudo
fi

annot_utils coding --genome_id hg38 data/boundary_pseudo/coding_raw.bed.gz

zcat data/boundary_pseudo/coding_raw.bed.gz | awk '$5 == "intron" {print}' > data/boundary_pseudo/coding_raw.intron.bed

bedtools getfasta \
    -fi  db/GRCh38.primary_assembly.genome.fa \
    -bed data/boundary_pseudo/coding_raw.intron.bed \
    -fo data/boundary_pseudo/coding_raw.intron.fasta.tsv \
    -tab -s \
    2>/dev/null


WORKDIR=`pwd`

python script/SS_scan.py data/boundary_pseudo/coding_raw.intron.fasta.tsv donor > data/boundary_pseudo/intron_GT_seq.tsv

cut -f 8 data/boundary_pseudo/intron_GT_seq.tsv > data/boundary_pseudo/intron_GT_seq.only_seq.tsv

cd ${WORKDIR}/bin/maxent
perl score5.pl ${WORKDIR}/data/boundary_pseudo/intron_GT_seq.only_seq.tsv > ${WORKDIR}/data/boundary_pseudo/intron_GT_seq.seq2score.tsv
cd ${WORKDIR}

python script/filter_junc.py data/boundary_pseudo/intron_GT_seq.tsv data/boundary_pseudo/intron_GT_seq.seq2score.tsv 5.12 > data/boundary_pseudo/intron_GT_seq.filt.tsv



python script/SS_scan.py data/boundary_pseudo/coding_raw.intron.fasta.tsv acceptor > data/boundary_pseudo/intron_AG_seq.tsv

cut -f 8 data/boundary_pseudo/intron_AG_seq.tsv > data/boundary_pseudo/intron_AG_seq.only_seq.tsv

cd ${WORKDIR}/bin/maxent
perl score3.pl ${WORKDIR}/data/boundary_pseudo/intron_AG_seq.only_seq.tsv > ${WORKDIR}/data/boundary_pseudo/intron_AG_seq.seq2score.tsv
cd ${WORKDIR}

python script/filter_junc.py data/boundary_pseudo/intron_AG_seq.tsv data/boundary_pseudo/intron_AG_seq.seq2score.tsv 4.87 > data/boundary_pseudo/intron_AG_seq.filt.tsv


bedtools subtract -a data/boundary_pseudo/intron_GT_seq.filt.tsv -b db/exon_raw.proc.bed | sort -k1,1 -k2,2n -k3,3n | uniq > data/boundary_pseudo/intron_GT_seq.filt2.tsv

bedtools subtract -a data/boundary_pseudo/intron_AG_seq.filt.tsv -b db/exon_raw.proc.bed | sort -k1,1 -k2,2n -k3,3n | uniq > data/boundary_pseudo/intron_AG_seq.filt2.tsv

python script/gather_pseudo.py data/boundary_pseudo/intron_GT_seq.filt2.tsv data/boundary_pseudo/intron_AG_seq.filt2.tsv 11.87 | sort -k1,1 -k2,2n -k3,3n | uniq > data/boundary_pseudo/intron_GT_AG.tsv


<<_
> quantile(D$V9, seq(0, 1, 0.05))
      0%       5%      10%      15%      20%      25%      30%      35% 
-47.0300   3.6215   5.2800   6.1400   6.7700   7.2200   7.6100   7.9300 
     40%      45%      50%      55%      60%      65%      70%      75% 
  8.2400   8.4900   8.6800   8.8800   9.1000   9.2600   9.6000   9.7900 
     80%      85%      90%      95%     100% 
 10.0600  10.2400  10.5100  10.8600  11.8100 
> quantile(D$V12, seq(0, 1, 0.05))
     0%      5%     10%     15%     20%     25%     30%     35%     40%     45% 
-46.920   3.370   4.830   5.670   6.280   6.770   7.200   7.570   7.920   8.250 
    50%     55%     60%     65%     70%     75%     80%     85%     90%     95% 
  8.570   8.880   9.180   9.500   9.820  10.160  10.534  10.950  11.460  12.190 
   100% 
 16.140 
> quantile(D$V9 + D$V12, seq(0, 1, 0.05))
    0%     5%    10%    15%    20%    25%    30%    35%    40%    45%    50% 
-72.17   9.88  11.87  13.00  13.83  14.50  15.08  15.59  16.05  16.47  16.89 
   55%    60%    65%    70%    75%    80%    85%    90%    95%   100% 
 17.29  17.69  18.08  18.48  18.91  19.38  19.91  20.54  21.43  26.40 
_

<<_
> summary(D$V9)
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
-47.030   7.220   8.680   8.121   9.790  11.810 
> summary(D$V12)
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
-46.920   6.770   8.570   8.226  10.160  16.140 
> summary(D$V9 + D$V12)
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
 -72.17   14.50   16.89   16.35   18.91   26.40 
_

