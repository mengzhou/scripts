#!/usr/bin/env python
import sys

def main():
  names = []
  seqs = []
  index = 0
  for l in sys.stdin:
    f = l.split()
    if l == "\n":
      index = 0
    if len(f) == 2:
      index += 1
      name = f[0]
      seq = f[1]
      if index > len(names):
        names.append(name)
        seqs.append(seq)
      else:
        seqs[index-1] = seqs[index-1] + seq

  for index in xrange(len(names)):
    sys.stdout.write("%s\t%s\n"%(names[index], seqs[index]))

if __name__ == "__main__":
  main()
