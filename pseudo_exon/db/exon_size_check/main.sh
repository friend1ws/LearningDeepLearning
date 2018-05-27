#! /usr/bin/env bash

python get_exon_length.py

cut -f 1-3 exon.sorted.filt.bed | sort -k1,1 -k2,2n -k3,3n | uniq > exon.sorted.filt.uniq.bed

Rscript hist.R

rm -rf exon.sorted.filt.bed
rm -rf exon.sorted.filt.uniq.bed

