#!/usr/bin/env python
import sys

def main():
  d = {}
  for l in sys.stdin:
    f = l.split()
    if len(f) == 2:
      name = f[0]
      seq = f[1]
      if d.has_key(name):
        d[name].append(seq)
      else:
        d[name] = [seq]

  for name in d.keys():
    sys.stdout.write("%s\t%s\n"%(name, "".join(d[name])))

if __name__ == "__main__":
  main()
