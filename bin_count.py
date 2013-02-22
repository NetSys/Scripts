# Input: a list of items sorted by unix timestamp in first column. Counts number of entries in each bin.
# (NB: This was originally for use with Bro's conn.log output)
# Usage:
# cat conn.log | grep -v "#" | awk '{print $1, $3}' | sort -u -k 2 | sort -n -k 1,1 | python bin_count.py > arrivals.source-ip.500ms.ts


import sys

bin_size = 0.5
last_bin = -1.0
count = 0
for line in sys.stdin:
    time, rest = line.split(None, 1)
    time = float(time)

    if last_bin < 0:
        last_bin = time
    while time - last_bin > bin_size:
        print "%f %d" % (last_bin, count)
        count = 0
        last_bin += bin_size

    count += 1
