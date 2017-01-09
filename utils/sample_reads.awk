#!/bin/awk
# awk script to sample reads from .mr file.
BEGIN{
  srand();
  #P=0.5; # the probability of one read to be sampled. Now used as -v P=???
}

{
  if(rand()>=1-P){
    print $0;
  }
}
