# PBA 2. Data Visualization (Fall 2026)
# Run selected lines in order in RStudio. "PDF p." refers to the 55-page slides.
# Packages used today: ggplot2, gapminder, dplyr. Install once: install.packages(c("pacman", "ggplot2", "gapminder", "dplyr"))

# PDF p. 6
# Install once: install.packages(c("pacman", "gapminder"))
# Load with library() or require(), or let pacman do both:
pacman::p_load(ggplot2, gapminder)
gapminder

# PDF p. 7
ggplot(gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point() + geom_smooth(method = "loess")  # loess: local smoothing, a flexible curve that follows the data

# PDF p. 8
ggplot(gapminder, mapping = aes(x = gdpPercap)) +
  geom_histogram()

# PDF p. 11
ggplot2::midwest ## If needed: install.packages("ggplot2")

# PDF p. 12
p <- ggplot(data = midwest)

# PDF p. 12
p <- ggplot(data = midwest,
              mapping = aes(x = popdensity,
                            y = percbelowpoverty))

# PDF p. 13
ggplot(data = midwest,
         mapping = aes(x = popdensity,
                       y = percbelowpoverty)) +
    geom_point()

# PDF p. 15
ggplot(data = midwest,
         mapping = aes(x = popdensity, 
                       y = percbelowpoverty)) +
    geom_smooth()

# PDF p. 17
ggplot(data = midwest,
         mapping = aes(x = popdensity,
                       y = percbelowpoverty)) +
    geom_point() +
    geom_smooth() +
    scale_x_log10() # Log scale for the skewed x variable

# PDF p. 19
ggplot(data = midwest,
         mapping = aes(x = popdensity,
                       y = percbelowpoverty)) +
    geom_point() +
    geom_smooth(method = "lm", se = F) +
    scale_x_log10()

# PDF p. 21
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

# PDF p. 23
ggplot(data = midwest,
         mapping = aes(x = popdensity,
                       y = percbelowpoverty,
                       color = "purple")) +
    geom_point() +
    geom_smooth() +
    scale_x_log10()

# PDF p. 26
ggplot(data = midwest,
         mapping = aes(x = popdensity,
                       y = percbelowpoverty)) +
    geom_point(color = "purple") +
    geom_smooth() +
    scale_x_log10()

# PDF p. 28
ggplot(data = midwest,
         mapping = aes(x = popdensity,
                       y = percbelowpoverty,
                       color = state,
                       fill = state)) +
    geom_point() +
    geom_smooth() +
    scale_x_log10()

# PDF p. 30
ggplot(data = midwest,
         mapping = aes(x = popdensity,
                       y = percbelowpoverty)) +
    geom_point(mapping = aes(color = state)) +
    geom_smooth(color = "black") +
    scale_x_log10()

# PDF p. 34
ggplot2::midwest ## If needed: install.packages("ggplot2")

# PDF p. 35
require(ggplot2)
ggplot(data = midwest,
       mapping = aes(x = percbelowpoverty)) +
  geom_histogram()

# PDF p. 37
ggplot(data = midwest,
       mapping = aes(x = percbelowpoverty)) +
  geom_histogram() +
  facet_wrap(~ state)

# PDF p. 39
ggplot(data = midwest,
       mapping = aes(x = percbelowpoverty,
                     fill = state, color = state)) +
  geom_density(alpha = 0.3)

# PDF p. 41
ggplot(data = midwest,
       mapping = aes(x = state,
                     y = percbelowpoverty)) +
  geom_boxplot()

# PDF p. 45
require(gapminder)
dplyr::glimpse(gapminder)

# PDF p. 46
ggplot(data = gapminder,
       mapping = aes(x = year,
                     y = gdpPercap)) +
  geom_line() # Didn't specify how to group the lines..

# PDF p. 48
ggplot(data = gapminder,
       mapping = aes(x = year,
                     y = gdpPercap)) +
  geom_line(mapping = aes(group = country))

# PDF p. 50
ggplot(data = gapminder,
       mapping = aes(x = year,
                     y = gdpPercap)) +
  geom_line(mapping = aes(group = country), color = "gray") +
  geom_smooth(method = "loess") +
  scale_y_log10(labels = scales::dollar)

# ---------------- Appendix: data types (reference, pp. 80-84) ----------------

# PDF p. 52-51  In-class exercise E1 (Gapminder): write your own code here and upload it to eeclass.
