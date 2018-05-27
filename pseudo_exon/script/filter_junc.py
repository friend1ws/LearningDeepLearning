#! /usr/bin/env python

import sys

input_file = sys.argv[1]
seq2score_file = sys.argv[2]
thres = float(sys.argv[3])

seq2score = {}
with open(seq2score_file, 'r') as hin:
    for line in hin:
        F = line.rstrip('\n').split('\t')
        if float(F[1]) > thres:
            seq2score[F[0]] = float(F[1])


with open(input_file, 'r') as hin:
    for line in hin:
        F = line.rstrip('\n').split('\t')
        if F[7] in seq2score:
            score = str(seq2score[F[7]])
            print '\t'.join(F) + '\t' + score

