#!/usr/bin/env python
"""Extract sequences from a FASTA file by the given list
of sequence names.
"""
import sys,re

def find_seq_in_list( name, name_list ):
  outlist = []
  for i in name_list.keys():
    if name in name_list[i]:
      outlist.append(i)
      name_list[i].remove(name)
  return outlist

def find_seq_in_pattern_list( name, pattern_list):
  for p in pattern_list:
    if re.search(p, name):
      return True

  return False

def main():
  if len(sys.argv) < 3:
    sys.stdout.write("Usage: %s <input_fa> <name_list1> [<list2> ...]\n"%sys.argv[0])
    sys.exit(0)

  inf_seq = open(sys.argv[1], 'r')
  inf_names = sys.argv[2:]
  infh = dict((i, open(i, 'r')) for i in inf_names)
  outfh = dict((i, open(i+".fa", 'w')) for i in inf_names)

  name_list = {}
  name_list = dict((name, [l.strip() for l in infh[name].readlines()]) \
    for name in inf_names)
  for i in infh.values():
    i.close()

  output_flag = False
  for l in inf_seq:
    if l.startswith(">"):
      output_flag = False
      name = l.strip()[1:]
      file_list = find_seq_in_list(name, name_list)
      if len(file_list) > 0:
        output_flag = True
        outf_list = [outfh[file_name] for file_name in file_list]

    if output_flag:
      for outf in outf_list:
        outf.write(l)

if __name__ == "__main__":
  main()
