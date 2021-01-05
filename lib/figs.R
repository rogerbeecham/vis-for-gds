site_colours <- list(
  primary = "#003c8f",
  primary_selected = "#1565c0",
  secondary = "#8e0000",
  secondary_selected = "#c62828"
)

update_geom_defaults("label", list(family = "Roboto Condensed", face = "plain"))
update_geom_defaults("text", list(family = "Roboto Condensed", face = "plain"))

theme_v_gds <- function(base_size = 11, base_family = "Roboto Condensed") {
  return <- theme_minimal(base_size, base_family) +
    theme(plot.title = element_text(size = rel(1.4), face = "plain",
                                    family = "Roboto Condensed Regular"),
          plot.subtitle = element_text(size = rel(1), face = "plain",
                                       family = "Roboto Condensed Light"),
          plot.caption = element_text(size = rel(0.8), color = "grey50", face = "plain",
                                      family = "Roboto Condensed Light",
                                      margin = margin(t = 10)),
          plot.tag = element_text(size = rel(1), face = "plain", color = "grey50",
                                  family = "Roboto Condensed Regular"),
          strip.text = element_text(size = rel(0.8), face = "plain",
                                    family = "Roboto Condensed Regular"),
          strip.text.x = element_text(margin = margin(t = 1, b = 1)),
          panel.border = element_blank(),
          strip.background = element_rect(fill = "#ffffff", colour = NA),
          axis.ticks = element_blank(),
          axis.title.x = element_text(margin = margin(t = 10)),
          axis.title.y = element_text(margin = margin(r = 10)),
          legend.margin = margin(t = 0),
          legend.title = element_text(size = rel(0.8)),
          legend.position = "bottom")

  return
}


# library(datasauRus)

datasaurus_dozen %>% View()
anscombe %>% View()

plot <- anscombe %>%
  gather(var, value) %>%
  add_column(var_type=c(rep("x",44),rep("y",44)), row_index=rep(1:44,2)) %>%
  mutate(dataset=paste("dataset",str_sub(var,2,2))) %>%
  select(-var) %>%
  spread(key=var_type, value=value) %>%
  ggplot(aes(x, y))+
  geom_point(colour=site_colours$primary, fill=site_colours$primary, pch=21) +
  stat_smooth(method=lm, se=FALSE, size=0.6, colour="#636363")+
  annotate("segment", x=9, xend=9, y=2.5, yend=7.5, colour=site_colours$secondary, alpha=.5, size=.5)+
  annotate("segment", x=5, xend=9, y=7.5, yend=7.5, colour=site_colours$secondary, alpha=.5, size=.5)+
  annotate("text", label="mean - 9.00 ",
           vjust="centre", hjust="centre", family="Roboto Condensed Light",size=2,
           x=9, y=2, colour=site_colours$secondary)+
  annotate("text", label="variance  - 11.00 ",
           vjust="centre", hjust="centre", family="Roboto Condensed Light",size=2,
           x=9, y=1)+
  annotate("text", label="correlation r.0.82",
           vjust="top", hjust="right", family="Roboto Condensed Light",size=2.5,
           x=20, y=3)+
  annotate("text", label="mean - 7.50 ",
           vjust="centre", hjust="right", family="Roboto Condensed Light",size=2,
           x=5, y=8, colour=site_colours$secondary)+
  annotate("text", label="variance  - 4.12 ",
           vjust="centre", hjust="right", family="Roboto Condensed Light",size=2,
           x=5, y=7)+
  facet_wrap(~dataset, nrow=2)+
  coord_equal(xlim = c(5, 20), ylim=c(3,13), # This focuses the x-axis on the range of interest
                  clip = 'off')+
  theme_v_gds()+
  theme(plot.margin = unit(c(1,1,1.5,2), "lines"),
        axis.text = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        panel.spacing = unit(3, "lines"))

ggsave(filename="./static/class/01-class_files/anscombe.png", plot=plot,width=7, height=4, dpi=300)


  theme(
    #text=element_text(family="Avenir LT 45 Book"),
    #axis.title = element_blank(),
    #axis.ticks = element_blank(),
    axis.text = element_blank(),
    # axis.line = element_blank(),
    #strip.text=element_blank()
  )
