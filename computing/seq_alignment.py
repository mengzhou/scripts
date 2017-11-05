#!/usr/bin/env python
"""This program generates global alignment of DNA sequences and report
the Hamming distance(s) between each pair of sequences.

Input mode 1: stdin. In this mode, each line represents a sequence
and the alignment will be performed for each pair.
Input mode 2: an FASTA file. In this mode, all the sequences with
corresponding names will be loaded; then each pair will be aligned.

Output: a symmetric matrix of the Hamming distances. If stdin is used,
then sequence names will be assigned as numbers.
"""
import sys
from itertools import combinations

def encode(seq):
  d = {"A":0, "C":1, "G":2, "T":3, "N":4}
  return [d[seq[i].upper()] for i in xrange(len(seq))]

def decode(seq):
  d = {0:"A", 1:"C", 2:"G", 3:"T", 4:"N"}
  return "".join([d[i] for i in seq])

def load_fasta(infh):
  seqs = {}
  for l in infh:
    if l.startswith(">"):
      name = l[1:].strip()
      seqs[name] = ""
    else:
      seqs[name] += l.strip()

  return seqs

def nt_score(nt1, nt2):
  s_hamming = [ [0, 1, 1, 1, 1],
      [1, 0, 1, 1, 1],
      [1, 1, 0, 1, 1],
      [1, 1, 1, 0, 1],
      [1, 1, 1, 1, 1] ]
  s = s_hamming
  return s[nt1][nt2]

def global_align(seq1, seq2, sc_func, MIN=True):
  """Global alignment based on the given scoring function, will optimize
  for the minimum of score by default.
  """
  if MIN:
    gap = 1
    comp = min
  else:
    gap = -1
    comp = max

  L1 = len(seq1)
  L2 = len(seq2)
  d = [[None for j in xrange(L2+1)] for i in xrange(L1+1)]
  d[0][0] = 0
  for i in xrange(1, L1+1):
    d[i][0] = gap*i
  for j in xrange(1, L2+1):
    d[0][j] = gap*j

  for i in xrange(1, L1+1):
    for j in xrange(1, L2+1):
      d[i][j] = comp(d[i-1][j-1] + sc_func(seq1[i-1], seq2[j-1]),\
        d[i-1][j] + gap, d[i][j-1] + gap)

  return d[-1][-1]

def main():
  if len(sys.argv) < 2:
    sys.stdout.write("Usage: %s <stdin | input.fa> [output]\n"%sys.argv[0])
    sys.exit(0)
  if len(sys.argv) < 3:
    outfh = sys.stdout
    verbose = True
  else:
    verbose = False
    outfh = open(sys.argv[2], 'w')

  # load sequences and encode nucleotides
  seqs = {}
  if sys.argv[1] == "stdin":
    counter = 1
    for l in sys.stdin:
      seqs["SEQ%d"%counter] = l.strip()
      counter += 1
  else:
    infh = open(sys.argv[1], 'r')
    seqs = load_fasta(infh)
    infh.close()
  for i in seqs.keys():
    seqs[i] = encode(seqs[i])

  # pair-wise alignment
  seq_list = sorted(seqs.keys())
  sc_matrix = {}
  for i in combinations(seq_list, 2):
    sc_matrix[i[0]] = {i[1]:None}
  total = len(seq_list)*(len(seq_list)-1)/2
  for num, i in enumerate(combinations(seq_list, 2)):
    if verbose and num%10 == 0:
      sys.stderr.write("\r[%-20s] %.2f%%"%("="*int(num*20.0/total)+">",
        num*100.0/(total)))
      sys.stderr.flush()
    sc_matrix[i[0]][i[1]] = global_align(seqs[i[0]], seqs[i[1]], nt_score)

  outfh.write("\t"+"\t".join(seq_list)+"\n")
  for i in seq_list:
    outfh.write(i)
    for j in seq_list:
      if j==i:
        outfh.write("\tNA")
      else:
        left = min(i, j)
        right = max(i, j)
        outfh.write("\t%d"%sc_matrix[left][right])
    outfh.write("\n")

  if verbose:
    sys.stderr.write("\n")


if __name__ == "__main__":
  main()
