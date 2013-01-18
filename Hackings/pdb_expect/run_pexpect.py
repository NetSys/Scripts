#!/usr/bin/env python

import pexpect

child = pexpect.spawn('./simple.py')

while True:
  try:
    child.expect('\(Pdb\).*')
    print child.before
    child.sendline('s')
  except:
    print str(child)
    raise

