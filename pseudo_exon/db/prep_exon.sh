#! /usr/bin/env bash

set -x

wget http://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/all_est.txt.gz

wget http://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/wgEncodeGencodeBasicV28.txt.gz

python proc_exon.py all_est.txt.gz wgEncodeGencodeBasicV28.txt.gz > exon_raw.bed

sort -k1,1 -k2,2n -k3,3n exon_raw.bed > exon_raw.sorted.bed

bedtools merge -i exon_raw.sorted.bed > exon_raw.proc.bed 

rm -rf exon_raw.bed
rm -rf exon_raw.sorted.bed

