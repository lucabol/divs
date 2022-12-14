<joined.csv rush run -C -l see,ggplot2,ggthemes,ggrepel \
  'ggplot(df,aes(Saf,YldS)) + geom_point(size = 1) + geom_text_repel(aes(label = Tik, color = M), size = 2) + theme_tufte() + theme(panel.grid.major.y = element_line(colour = "grey", linetype = "dashed"))' - |
  display
