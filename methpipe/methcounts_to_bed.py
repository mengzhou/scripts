#!/usr/bin/env python
"""Convert between the methcounts format and the BED format.
methcounts:
chr position strand context meth coverage
BED:
chr start end context:coverage meth strand
"""
import sys,re

def decide_format(line):
  p_meth = "^\w+\t\d+\t[+-]\t\w+\t[0-9\.]+\t\d+$"
  p_bed = "^\w+\t\d+\t\d+\t\w+:\d+\t[0-9\.]+\t[+-]"
  if re.match(p_meth, line):
    return 0
  elif re.match(p_bed, line):
    return 1
  else:
    return -1

def meth_to_bed(line):
  f = line.split()
  start = int(f[1])
  end = start+1
  return "\t".join((f[0], str(start), str(end), f[3]+":"+f[5], f[4], f[2]))+"\n"

def bed_to_meth(line):
  f = line.split()
  context, coverage = f[3].split(":")
  return "\t".join((f[0], f[1], f[5], context, f[4], coverage))+"\n"

def main():
  if len(sys.argv) < 2:
    sys.stdout.write("Usage: %s <Input methcounts/BED> "%sys.argv[0]+\
        "[stdout|output BED/methcounts]\n")
    sys.exit(0)

  infh = open(sys.argv[1], 'r')
  if len(sys.argv) > 2:
    outfh = open(sys.argv[2], 'w')
  else:
    outfh = sys.stdout

  l = infh.readline()
  format = decide_format(l)
  if format < 0:
    sys.stderr.write("The input file has an unrecognized format.\n")
    sys.exit(1)
  elif format == 0:
    convert = meth_to_bed
  else:
    convert = bed_to_meth

  while l:
    outfh.write(convert(l))
    l = infh.readline()

  infh.close()
  if len(sys.argv) > 1:
    outfh.close()

if __name__ == "__main__":
  main()
