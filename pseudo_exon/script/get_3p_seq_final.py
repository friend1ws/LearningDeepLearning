#! /usr/bin/env python

import sys, subprocess

boundary_file = sys.argv[1]
output_file = sys.argv[2]
margin = int(sys.argv[3])

hout = open(output_file + ".tmp.bed", 'w')
with open(boundary_file, 'r') as hin:
    for line in hin:
        F = line.rstrip('\n').split('\t')
        if F[5] == '+':
            print >> hout, F[0] + '\t' + str(int(F[1]) - margin) + '\t' + str(int(F[1]) + margin) + "\t*\t0\t+"
        else:
            print >> hout, F[0] + '\t' + str(int(F[2]) - margin) + '\t' + str(int(F[2]) + margin) + "\t*\t0\t-"

hout.close()

subprocess.call(["bedtools", "getfasta", "-fi", "db/GRCh38.primary_assembly.genome.fa", "-bed", output_file + ".tmp.bed", "-fo", output_file + ".tmp.bed2", "-s", "-tab"])

hout = open(output_file, 'w')
subprocess.call(["cut", "-f", "2", output_file + ".tmp.bed2"], stdout = hout)
hout.close()

subprocess.call(["rm", "-rf", output_file + ".tmp.bed"])
subprocess.call(["rm", "-rf", output_file + ".tmp.bed2"])




