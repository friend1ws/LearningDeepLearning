#! /usr/bin/env python

import sys, gzip

ext_file = sys.argv[1]
gencode_file = sys.argv[2]
margin = 50

with gzip.open(ext_file, 'r') as hin:
    for line in hin:
        F = line.rstrip('\n').split('\t')
        tchr = F[14]
        tsizes = F[19].split(',')
        tstarts = F[21].split(',')

        for i in range(len(tsizes) - 1):
            tstart = max(0, int(tstarts[i]) - margin)
            tend = int(tstarts[i]) + int(tsizes[i]) + margin
            print tchr + '\t' + str(tstart) + '\t' + str(tend)

with gzip.open(gencode_file, 'r') as hin:
    for line in hin:
        F = line.rstrip('\n').split('\t')
        tchr = F[2]
        tstarts = F[9].split(',')
        tends = F[10].split(',')

        for i in range(len(tstarts) - 1):
            tstart = max(0, int(tstarts[i]) - margin)
            tend = int(tends[i]) + margin
            print tchr + '\t' + tstarts[i] + '\t' + tends[i]

