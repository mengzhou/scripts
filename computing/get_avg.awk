#/usr/bin/env awk
BEGIN{
  t=0;
  c=0;
}
{
  t+=$1;
  c++;
}
END{
  if (c==0){
    print 0;
  }
  else{
    print t/c;
}
print NR, c;
}

