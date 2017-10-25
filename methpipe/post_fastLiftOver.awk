#!/usr/bin/awk
BEGIN {
  OFS="\t";
}
function output(chr, pos, strand, seq, meth, t) {
  if (strand == "-") {
    strand = "+";
    pos--;
  }
  print chr, pos, strand, seq, meth, t;
}
{
  if ($3=="-") {
    $3 = "+";
    $2 = $2-1;
  }
  if (NR == 1) {
    chr = $1;
    pos = $2;
    strand = $3;
    seq = $4;
    t = $6;
    m = $5 * $6;
  }
  else {
    if ($1 == chr && $2 == pos) {
      t += $6;
      m += $5 * $6;
    }
    else {
      if (t == 0) meth = 0.0;
      else meth = m / t;
      output(chr,pos,strand,seq,meth,t);
      chr = $1;
      pos = $2;
      strand = $3;
      seq = $4;
      t = $6;
      m = $5 * $6;
    }
  }
}
END {
  if (t == 0) meth = 0.0;
  else meth = m / t;
  output(chr,pos,strand,seq,meth,t);
}
