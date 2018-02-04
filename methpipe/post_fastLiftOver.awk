#!/usr/bin/awk
# assumes the new methcounts format
# works only for fast-liftover with -p
BEGIN {
  OFS = "\t";
  prev_chr = "";
  prev_start = "";
  prev_strand = "";
  prev_context = "";
  prev_meth = 0;
  prev_coverage = 0;
}
{
  if ($1==prev_chr && $2==prev_start && $3==prev_strand) {
    prev_coverage += $6;
    prev_meth += int($5*$6+0.5);
  }
  else {
    if(prev_coverage ==0) meth = 0;
    else meth = prev_meth/prev_coverage;
    if (NR>1)
      print prev_chr, prev_start, prev_strand, prev_context, meth, prev_coverage;
    prev_chr = $1;
    prev_start = $2;
    prev_strand = $3;
    prev_context = $4;
    prev_meth = int($5*$6+0.5);
    prev_coverage = $6;
  }
}
END {
  if(prev_coverage ==0) meth = 0;
  else meth = prev_meth/prev_coverage;
  print prev_chr, prev_start, prev_strand, prev_context, meth, prev_coverage;
}
