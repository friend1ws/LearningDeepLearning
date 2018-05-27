#! /usr/bin/env python

import sys, re

region_re = re.compile('([^ \t\n\r\f\v,]+):(\d+)\-(\d+)\(([+-])\)')

input_file = sys.argv[1]
donor_or_acceptor = sys.argv[2]

if donor_or_acceptor == "donor":
    SS_motif, prev_size, after_size = "GT", 3, 4
elif donor_or_acceptor == "acceptor":
    SS_motif, prev_size, after_size = "AG", 18, 3
else:
    priyt >> sys.stderr, "Second input should be donor or acceptor"


with open(input_file, 'r') as hin:
    for line in hin:
        F = line.rstrip('\n').split('\t')
        match = region_re.match(F[0])
        if match is None:
            print >> sys.stderr, "Wroooong!"
            sys.exit(1)

        tchr, tstart, tend, tstrand = match.group(1), int(match.group(2)), int(match.group(3)), match.group(4)

        tseq = F[1]
        sind = tseq.find(SS_motif, 0)
        while sind != -1:
            # length check
            if sind >= 100 and len(tseq) - sind -1 >= 100:

                if tstrand == "+":
                    ttstart = tstart + sind - prev_size
                    ttend = tstart + sind + after_size + 2
                    ttkey = tchr + ':' + str(ttstart) + '-' + str(ttend) + "(+)"
                else:
                    ttstart = tend - sind - (after_size + 2)
                    ttend = tend - sind + prev_size
                    ttkey = tchr + ':' + str(ttstart) + '-' + str(ttend) + "(-)"
                ttseq = tseq[(sind - prev_size):(sind + after_size + 2)]

                if not "N" in ttseq:
                    print '\t'.join([tchr, str(ttstart), str(ttend), ttkey, '0', tstrand, F[0], ttseq])

            sind = tseq.find(SS_motif, sind + 1)


