#!/usr/bin/env python
"""Learn the consensus from the output of aln_unwrapper.py
Input format:
  <seq name> <sequence>
  <seq name> <sequence>
  ...

All sequences are assumed to have the same length, with gaps (-).
"""
import sys

def main():
  seqs = []
  consensus = []
  for l in sys.stdin:
    f = l.split()
    seqs.append(f[1])

  for i in xrange(len(seqs[0])):
    col = {}
    for j in xrange(len(seqs)):
      nt = seqs[j][i]
      if col.has_key(nt):
        col[nt] += 1
      else:
        col[nt] = 1

    majority = max(col.values())
    for k in col.keys():
      if col[k] == majority:
        consensus.append(k)
        break

  con_str = [i for i in consensus if i != "-"]
  sys.stdout.write("".join(con_str)+"\n")

if __name__ == "__main__":
  main()
