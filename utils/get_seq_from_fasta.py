#!/usr/bin/python
import sys

def get_length(inf):
  pool = []
  headline = 0
  for i in range(2):
    line = inf.readline()
    if line.startswith(">"):
      headline = len(line)
      continue
    pool.append(line)
    
  l = [len(i) for i in pool]
  return (sum(l)/len(l),headline)

def process_len( start, len_par ):
  if len_par.startswith("+"):
    return int(len_par[1:])
  else:
    return int(len_par) - int(start)

def seeker(inf, start, length):
  (l,hl) = get_length(inf)
  block_size_start = start/(l-1)*l + start % (l-1)
  inf.seek(hl+block_size_start)
  length_tail = length - (l - start%(l-1))
  block_size_length = length_tail/(l-1)*l + length_tail % (l-1) + (l - start%(l-1)) + 1
  return inf.read(block_size_length).replace("\n",'')

def fold(string):
  width = 500000
  return [string[i:i+width]+"\n" for i in range(0,len(string),width)]
  
  
def main():
  if len(sys.argv) < 4:
    sys.stderr.write("Usage: %s <input fasta> <start coordinate> "%sys.argv[0] + \
      "<end coordinate | +length>\n")
    sys.stderr.write("Example 1: %s chr1.fa 100050 +50\n"%sys.argv[0])
    sys.stderr.write("Example 2: %s chr1.fa 100050 100150\n"%sys.argv[0])
    sys.exit(1)
  
  if sys.argv[1] == "stdin":
    inf = sys.stdin
  else:
    inf = open(sys.argv[1],'r')
    
  length = process_len(sys.argv[2], sys.argv[3])
  sys.stdout.write("".join(fold(seeker(inf,int(sys.argv[2]),length))))
                   
if __name__ == '__main__':
  main()
