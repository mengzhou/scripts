#!/usr/bin/env python
"""Returns a reverse complement of input DNA sequence.
"""
import sys

def revc( seq ):
  comp = {"A":"T","C":"G","G":"C","T":"A","a":"t","c":"g","g":"c","t":"a",\
      "N":"N","n":"n"}
  rev_seq = [comp[seq[i]] for i in xrange(len(seq)-1,-1,-1)]
  return "".join(rev_seq)

def main():
  for l in sys.stdin:
    sys.stdout.write(revc(l.strip())+"\n")

if __name__ == "__main__":
  main()
