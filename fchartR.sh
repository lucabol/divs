read -r -d '' PLCMD <<- EOM
  ggplot(df,aes(Saf,ifelse(is.na(YldS), Yld,YldS)))
   + geom_point(size = 1, aes(color=M))
   + geom_text_repel(aes(label = ifelse(is.na(Tik),TikS,Tik), color = M), size = 2)
   + theme_tufte()
   + theme(panel.grid.major.y = element_line(colour = "grey", linetype = "dashed"))
   + ylim(3, 9) + guides(color=FALSE)
EOM

CMD=$(echo $PLCMD)

<fulljoined.csv rush run -C -l see,ggplot2,ggthemes,ggrepel "$CMD" - | display

# <fulljoined.csv rush run -C -l see,ggplot2,ggthemes,ggrepel \
#   'ggplot(df,aes(Saf,ifelse(is.na(YldS), Yld,YldS))) + geom_point(size = 1, aes(color=M)) + geom_text_repel(aes(label = ifelse(is.na(Tik),TikS,Tik), color = M), size = 2) + theme_tufte() + theme(panel.grid.major.y = element_line(colour = "grey", linetype = "dashed")) + ylim(3, 8) + guides(color=FALSE)' - |
#   display
