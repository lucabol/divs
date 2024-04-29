BEGIN {
    print "Yld", "Saf", "Tik", "M"
  }
{
  Yld = sprintf("%.1f", @"Yld")
  Saf = @"Saf"
  Tik = @"Tik"
  M   = @"M"

  # Each couple of offsets (2 -2) must be symmetric for the algo below to work (i.e., using Saf)
  len = split("3 -3 5 -5", offsets, " ")

  for(off in offsets) {
    if(ylds[Yld,Saf] || ylds[Yld,Saf+1] || ylds[Yld,Saf-1]) {
      print Tik,ylds[Yld,Saf],ylds[Yld,Saf+1],ylds[Yld,Saf-1] > "/dev/stderr"
      Saf += offs
    } else {
      break 
    }
  }
  if(off == len)
    print "Cannot find free slot for ", Tik, Yld, Saf > "/dev/stderr"

  ylds[Yld,Saf] = Tik
  print Yld, Saf, Tik, M
}
