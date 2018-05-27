#! /usr/bin/env python

import sys, subprocess

subprocess.call(["annot_utils", "exon", "--genome_id", "hg38", "--add_ref_id", "exon.bed.gz"])

hout = open("exon.bed", 'w')
subprocess.call(["zcat", "exon.bed.gz"], stdout = hout)
hout.close()

hout = open("exon.sorted.bed", 'w')
subprocess.call(["sort", "-k4", "-k2", "exon.bed"], stdout = hout)
hout.close()


temp_gene = ""
temp_info = []
hout = open("exon.sorted.filt.bed", 'w')
with open("exon.sorted.bed", 'r') as hin:
    for line in hin:
        F = line.rstrip('\n').split('\t')
        if F[3] != temp_gene:
            if temp_gene != "" and len(temp_info) >= 3: 
                temp_info.pop(0)
                temp_info.pop(-1)
                print >> hout, '\n'.join(temp_info)
            temp_gene = F[3]
            temp_info = []
        temp_info.append('\t'.join(F))

if temp_gene != "" and len(temp_info) >= 3: 
    temp_info.pop(0)
    temp_info.pop(-1)
    print >> hout, '\n'.join(temp_info)
hout.close()

subprocess.call(["rm", "-rf", "exon.bed.gz"])
subprocess.call(["rm", "-rf", "exon.bed.gz.tbi"])
subprocess.call(["rm", "-rf", "exon.bed"])
subprocess.call(["rm", "-rf", "exon.sorted.bed"])
