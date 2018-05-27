#! /usr/bin/env python

import sys, gzip

raw_file = sys.argv[1]
key2seq_file = sys.argv[2]
seq2score5_file = sys.argv[3]
seq2score3_file = sys.argv[4]

seq2score5 = {}
with open(seq2score5_file, 'r') as hin:
    for line in hin:
        F = line.rstrip('\n').split('\t')
        seq2score5[F[0]] = F[1]

seq2score3 = {}
with open(seq2score3_file, 'r') as hin:
    for line in hin:
        F = line.rstrip('\n').split('\t')
        seq2score3[F[0]] = F[1]


key2seq = {}
with open(key2seq_file, 'r') as hin:
    for line in hin:
        F = line.rstrip('\n').split('\t')
        key2seq[F[0]] = F[1]

with gzip.open(raw_file, 'r') as hin:
    for line in hin:
        F = line.rstrip('\n').split('\t')
        key = F[0] + ':' + F[1] + '-' + F[2] + '(' + F[5] + ')'
        if key not in key2seq: continue
        seq = key2seq[key]
        score = seq2score5[seq] if len(seq) == 9 else seq2score3[seq]
        print '\t'.join(F) + '\t' + key2seq[key] + '\t' + score

