#! /usr/bin/env python

import sys

input_file = sys.argv[1]
nucleosomal_sequence_file = sys.argv[2]
linker_sequence_file = sys.argv[3]

hout1 = open(nucleosomal_sequence_file, 'w')
hout2 = open(linker_sequence_file, 'w') 
with open(input_file, 'r') as hin:
    lines = hin.readlines()
    for i in range(len(lines)):
        line = lines[i].rstrip('\n')
        if line.startswith(">nucleosomal_sequence"):
            print >> hout1, lines[i + 1].rstrip('\n')

        if line.startswith(">linker_sequence"):
            print >> hout2, lines[i + 1].rstrip('\n')

hout1.close()
hout2.close()


        

