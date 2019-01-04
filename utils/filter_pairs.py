#!/usr/bin/env python
import sys

def read_fq(infh):
  buff = [infh.readline() for i in range(4)]
  if all(buff):
    name = buff[0].strip().split()[0]
    seq = buff[2].strip()
    qual = buff[3].strip()

    return (name, seq, qual)
  else:
    return None

class FASTQ:
  def __init__(self, infh):
    self.infh = infh
    self.name = ""
    self.seq = ""
    self.qual = ""
    self.eof = False

  def load(self):
    buff = [self.infh.readline() for i in range(4)]
    if all(buff):
      self.name = buff[0].strip().split()[0]
      self.seq = buff[1].strip()
      self.qual = buff[3].strip()
    else:
      self.name = None
      self.seq = None
      self.qual = None
      self.eof = True

  def __gt__(self, other):
    return self.name > other.name

  def __lt__(self, other):
    return self.name < other.name

  def __eq__(self, other):
    return self.name == other.name

  def __str__(self):
    return "\n".join((self.name, self.seq, "+", self.qual))+"\n"

def main():
  if len(sys.argv) < 5:
    sys.stdout.write("Usage: %s <in1> <in2> <out1> <out2>\n"%sys.argv[0])
    sys.exit(1)

  inf1 = open(sys.argv[1], 'r')
  inf2 = open(sys.argv[2], 'r')
  out1 = open(sys.argv[3], 'w')
  out2 = open(sys.argv[4], 'w')

  in1 = FASTQ(inf1)
  in2 = FASTQ(inf2)
  in1.load()
  in2.load()

  while not in1.eof and not in2.eof:
    if in1 == in2:
      out1.write(str(in1))
      out2.write(str(in2))
      in1.load()
      in2.load()
    elif in1 < in2:
      in1.load()
    elif in1 > in2:
      in2.load()

  inf1.close()
  inf2.close()
  out1.close()
  out2.close()

if __name__ == "__main__":
  main()
