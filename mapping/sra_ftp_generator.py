#!/usr/bin/env python
"""Converting SRA IDs to their corresponding ftp links for download.
Input: stdin IDs of any type. E.g. SRX, SRR, and SRP.
Output: ftp links (not necessarily to a file).
"""
import sys, re

def parse_exp(name):
  template = "ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByExp/sra/SRX/%s/%s/"
  return template%(name[:6], name)

def parse_study(name):
  template = "ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByStudy/sra/SRP/%s/%s/"
  return template%(name[:6], name)

def parse_run(name):
  template = "ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/SRR/%s/%s/%s.sra"
  return template%(name[:6], name, name)

def main():
  for name in sys.stdin:
    name = name.strip()
    if re.match("SRX", name):
      sys.stdout.write(parse_exp(name)+"\n")
    elif re.match("SRP", name):
      sys.stdout.write(parse_study(name)+"\n")
    elif re.match("SRR", name):
      sys.stdout.write(parse_run(name)+"\n")
    else:
      sys.stderr.write("ID type not recognized: %s!\n"%name)
      sys.exit(1)

if __name__ == "__main__":
  main()
