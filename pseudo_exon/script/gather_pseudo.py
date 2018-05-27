#! /usr/bin/env python

import sys, re

key_re = re.compile('([^ \t\n\r\f\v,]+):(\d+)\-(\d+)\(([\+\-])\)')


GT_file = sys.argv[1]
AG_file = sys.argv[2]
thres = float(sys.argv[3])

key2GT_info = {}
with open(GT_file, 'r') as hin:
    for line in hin:
        F = line.rstrip('\n').split('\t')
        key = F[6]
        if key not in key2GT_info: key2GT_info[key] = []
        key2GT_info[F[6]].append('\t'.join(F))


key2AG_info = {}
with open(AG_file, 'r') as hin:
    for line in hin:
        F = line.rstrip('\n').split('\t')
        key = F[6]
        if key not in key2AG_info: key2AG_info[key] = []
        key2AG_info[F[6]].append('\t'.join(F))


for key in sorted(key2GT_info):
    if key in key2AG_info:
        GT_info = key2GT_info[key]
        AG_info = key2AG_info[key]
        temp_match = key_re.search(key)
        tstrand = temp_match.group(4)

        for GT_elm, AG_elm in zip(GT_info, AG_info):
            F_GT = GT_elm.split('\t')
            F_AG = AG_elm.split('\t')
            
            if float(F_GT[8]) + float(F_AG[8]) < thres: continue

            if tstrand == '+':
                exon_start, exon_end = int(F_AG[2]) - 3, int(F_GT[2]) - 6
            else:
                exon_start, exon_end = int(F_GT[1]) + 6, int(F_AG[1]) + 3

            pseudo_exon_key = F_GT[0] + ':' + str(exon_start) + '-' + str(exon_end) + '(' + tstrand + ')'

            if 50 <= int(exon_end) - int(exon_start) <= 250:
                print F_GT[0] + '\t' + str(exon_start) + '\t' + str(exon_end) + '\t' + pseudo_exon_key + '\t' + '0' + '\t' + tstrand + '\t' + \
                        F_GT[3] + '\t' + F_GT[7] + '\t' + F_GT[8] + '\t' + F_AG[3] + '\t' + F_AG[7] + '\t' + F_AG[8]


