#! /usr/bin/env python

import sys, gzip

exon_file = sys.argv[1]
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

with gzip.open(exon_file, 'r') as hin:
    for line in hin:
        F = line.rstrip('\n').split('\t')

        if F[5] == '+':
            key_acceptor = F[0] + ':' + str(int(F[1]) - 20) + '-' + str(int(F[1]) + 3) + '(+)'
            key_donor = F[0] + ':' + str(int(F[2]) - 3) + '-' + str(int(F[2]) + 6) + '(+)'
        else:
            key_donor = F[0] + ':' + str(int(F[1]) - 6) + '-' + str(int(F[1]) + 3) + '(-)'
            key_acceptor = F[0] + ':' + str(int(F[2]) - 3) + '-' + str(int(F[2]) + 20) + '(-)'

        if key_donor not in key2seq: continue
        seq_donor = key2seq[key_donor]
        score_donor = seq2score5[seq_donor]

        if key_acceptor not in key2seq: continue
        seq_acceptor = key2seq[key_acceptor]
        score_acceptor = seq2score3[seq_acceptor] 

        exon_key = F[0] + ':' + F[1] + '-' + F[2] + '(' + F[5] + ')'

        print '\t'.join(F[:3]) + '\t' + exon_key + '\t' + '0' + '\t' + F[5] + '\t' + \
                key_donor + '\t' + seq_donor + '\t' + score_donor + '\t' + key_acceptor + '\t' + seq_acceptor + '\t' + score_acceptor


