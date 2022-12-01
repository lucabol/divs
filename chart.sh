<joined.csv fplot 'u "Saf":"Yld" ps 1 pt 1, "" u (column("Saf")+1):(column("Yld")+0.12):(Fmt(stringcolumn("Tik"),stringcolumn("M"))) w labels tc "blue" font ",20"' \
  'set grid y;Fmt(String,moat) = sprintf("{/%s %s}", moat eq "Wide" ? ",30:Bold" : ":Normal", String)'
