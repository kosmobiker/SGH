#biblioteka gganimate używa się do tworzenia GIFów za pomocą ggplot
#instalacja
# devtools::install_github('thomasp85/gganimate')

library(ggplot2)
library(gganimate)
library(tidyr)
library(dplyr)
library(gapminder)

#Używano gganimate żeby stworzyć GIF, który ilustruje zmianę GDP w czasie dla wybranych krajów

df <- gapminder
df <- gapminder %>% filter(country %in% c("Austria", "Bulgaria", "Czech Republic","Hungary", 
                                          "Poland", "Romania", "Slovak Republic", "Slovenia"))
df <- df %>% select(country, year, gdpPercap)


p <- ggplot(
  df,
  aes(year, gdpPercap, color = country),
) +
  geom_line(size=1.25) +
  scale_color_viridis_d() +
  scale_x_continuous(name = "Years", labels=df$year, breaks = df$year) +
  labs(x = "Year", y = "GDP per capita") +
  theme(legend.position = "top")

x11();print(p)

#GIF pojawi się w oknie "Viewer"
anim <- p + geom_point() +
  transition_reveal(year)
anim
