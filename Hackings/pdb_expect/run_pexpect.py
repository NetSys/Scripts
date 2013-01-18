#!/usr/bin/env python

import pexpect
import sys

child = pexpect.spawn(' '.join(sys.argv[1:]))
with open("pdb_output.txt", "w") as output:
  while True:
    try:
      child.expect('\(Pdb\).*')
      output.write(child.before)
      child.sendline('s')
    except:
      print str(child)
      raise
