#/bin/awk
BEGIN {
  sites=0;
  sites_covered=0;
  max_cov=0;
  total_cov=0;
  total_meth=0;
}
{
  ++sites;
  if ($6=="+"||$6=="-") {
    split($4,cov,":");
    if (cov[2] > 0) {
      ++sites_covered;
      total_cov+=cov[2];
      total_meth+=int($5*cov[2]+0.5);
      if(cov[2]>max_cov)
        max_cov=cov[2];
    }
  }
  else {
    if($6>0) {
      ++sites_covered;
      if($6>max_cov)max_cov=$6;
      total_cov+=$6;
      total_meth+=int($6*$5+0.5);
    }
  }
}
END {
  printf "SITES:\t%d\nSITES COVERED:\t%d\nFRACTION:\t%f\nMAX COVERAGE:\t%d\nMEAN COVERAGE:\t%f\nMEAN (WHEN > 0):\t%f\nMEAN METHYLATION:\t%f\n",
         sites, sites_covered, sites_covered/sites, max_cov, total_cov/sites, total_cov/sites_covered, total_meth/total_cov;
}

