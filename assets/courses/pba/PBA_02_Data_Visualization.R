# PBA 2. Data Visualization (Fall 2026)
# Run selected lines in order in RStudio. "PDF p." refers to the 56-page slides.
# Packages used today: ggplot2, gapminder, dplyr (install once if needed):
# install.packages(c("ggplot2", "gapminder", "dplyr"))

# PDF p. 7
library(ggplot2)
gapminder <- gapminder::gapminder
gapminder

# PDF p. 8
ggplot(gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point() + geom_smooth(method = "loess")

# PDF p. 9
ggplot(gapminder, mapping = aes(x = gdpPercap)) +
  geom_histogram()

# PDF p. 12
ggplot2::midwest ## If needed: install.packages("ggplot2")

# PDF p. 13
p <- ggplot(data = midwest)

# PDF p. 13
p <- ggplot(data = midwest,
              mapping = aes(x = popdensity,
                            y = percbelowpoverty))

# PDF p. 14
ggplot(data = midwest,
         mapping = aes(x = popdensity,
                       y = percbelowpoverty)) +
    geom_point()

# PDF p. 16
ggplot(data = midwest,
         mapping = aes(x = popdensity, 
                       y = percbelowpoverty)) +
    geom_smooth()

# PDF p. 18
ggplot(data = midwest,
         mapping = aes(x = popdensity,
                       y = percbelowpoverty)) +
    geom_point() +
    geom_smooth() +
    scale_x_log10() # Log scale for the skewed x variable

# PDF p. 20
ggplot(data = midwest,
         mapping = aes(x = popdensity,
                       y = percbelowpoverty)) +
    geom_point() +
    geom_smooth(method = "lm", se = F) +
    scale_x_log10()

# PDF p. 22
ggplot(data = midwest,
         mapping = aes(x = popdensity,
                       y = percbelowpoverty)) +
    geom_point() +
    geom_smooth(method = "loess", se = F) +
    scale_x_log10() +
    labs(x = "Population Density",
         y = "Percent of County Below Poverty Line",
         title = "Poverty and Population Density",
         subtitle = "Among Counties in the Midwest",
         caption = "Source: US Census, 2000")

# PDF p. 24
ggplot(data = midwest,
         mapping = aes(x = popdensity,
                       y = percbelowpoverty,
                       color = "purple")) +
    geom_point() +
    geom_smooth() +
    scale_x_log10()

# PDF p. 27
ggplot(data = midwest,
         mapping = aes(x = popdensity,
                       y = percbelowpoverty)) +
    geom_point(color = "purple") +
    geom_smooth() +
    scale_x_log10()

# PDF p. 29
ggplot(data = midwest,
         mapping = aes(x = popdensity,
                       y = percbelowpoverty,
                       color = state,
                       fill = state)) +
    geom_point() +
    geom_smooth() +
    scale_x_log10()

# PDF p. 31
ggplot(data = midwest,
         mapping = aes(x = popdensity,
                       y = percbelowpoverty)) +
    geom_point(mapping = aes(color = state)) +
    geom_smooth(color = "black") +
    scale_x_log10()

# PDF p. 35
ggplot2::midwest ## If needed: install.packages("ggplot2")

# PDF p. 36
require(ggplot2)
ggplot(data = midwest,
       mapping = aes(x = percbelowpoverty)) +
  geom_histogram()

# PDF p. 38
ggplot(data = midwest,
       mapping = aes(x = percbelowpoverty)) +
  geom_histogram() +
  facet_wrap(~ state)

# PDF p. 40
ggplot(data = midwest,
       mapping = aes(x = percbelowpoverty,
                     fill = state, color = state)) +
  geom_density(alpha = 0.3)

# PDF p. 42
ggplot(data = midwest,
       mapping = aes(x = state,
                     y = percbelowpoverty)) +
  geom_boxplot()

# PDF p. 46
require(gapminder)
dplyr::glimpse(gapminder)

# PDF p. 47
ggplot(data = gapminder,
       mapping = aes(x = year,
                     y = gdpPercap)) +
  geom_line() # Didn't specify how to group the lines..

# PDF p. 49
ggplot(data = gapminder,
       mapping = aes(x = year,
                     y = gdpPercap)) +
  geom_line(mapping = aes(group = country))

# PDF p. 51
ggplot(data = gapminder,
       mapping = aes(x = year,
                     y = gdpPercap)) +
  geom_line(mapping = aes(group = country), color = "gray") +
  geom_smooth(method = "loess") +
  scale_y_log10(labels = scales::dollar)

# ---------------- Appendix: data types (reference, pp. 80-84) ----------------

# PDF p. 53-51  In-class exercise E1 (Gapminder): write your own code here and upload it to eeclass.
