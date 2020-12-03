# Use hex-sticker library
library(hexSticker)
library(tidyverse)

d <- tibble(text=c("vis-for-gds"),
            x=c(0),
            y=c(2))
p <- d %>% ggplot()+
  geom_text(aes(x=x,y=y,label=text), size=6, angle=45, family="Avenir Book", colour="#ffffff")+
  theme_void()
s <- hexSticker::sticker(p, package="vis-for-gds",
             p_size=4, s_x=2.5, s_y=2.5, s_width = 5, s_height = 5,
             h_color="#003b8e",
             h_fill="#1564bf",
             p_family="Avenir Book",
             u_family="Avenir Book")
ggsave(s, filename="./static/images/vis_for_gds.png", width=2, height=2, dpi=300)
