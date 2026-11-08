# PBA 2. Data Visualization (Fall 2026)
# Run selected lines in order in RStudio. "Slide" is the number at the bottom right of each slide; "PDF p." in parentheses is the page in a PDF viewer.
# Packages used today: ggplot2, gapminder, dplyr. Install once: install.packages(c("pacman", "ggplot2", "gapminder", "dplyr"))

# Slide 6 (PDF p. 6)
# Install once: install.packages(c("pacman", "ggplot2"))
# Load with library() or require(), or let pacman do both:
pacman::p_load(ggplot2)
midwest

# Slide 7 (PDF p. 7)
ggplot(midwest, mapping = aes(x = percollege, y = percbelowpoverty)) +
  geom_point() + geom_smooth()   # the curve: loess, local smoothing

# Slide 8 (PDF p. 8)
ggplot(midwest, mapping = aes(x = percollege)) +
  geom_histogram()

# Slide 11 (PDF p. 11)
p <- ggplot(data = midwest)

# Slide 11 (PDF p. 11)
p <- ggplot(data = midwest,
              mapping = aes(x = popdensity,
                            y = percbelowpoverty))

# Slide 12 (PDF p. 12)
ggplot(data = midwest,
         mapping = aes(x = popdensity,
                       y = percbelowpoverty)) +
    geom_point()

# Slide 14 (PDF p. 14)
ggplot(data = midwest,
         mapping = aes(x = popdensity, 
                       y = percbelowpoverty)) +
    geom_smooth()

# Slide 16 (PDF p. 16)
ggplot(data = midwest,
         mapping = aes(x = popdensity,
                       y = percbelowpoverty)) +
    geom_point() +
    geom_smooth() +
    scale_x_log10() # Log scale for the skewed x variable

# Slide 18 (PDF p. 18)
ggplot(data = midwest,
         mapping = aes(x = popdensity,
                       y = percbelowpoverty)) +
    geom_point() +
    geom_smooth(method = "lm", se = F) +
    scale_x_log10()

# Slide 20 (PDF p. 20)
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

# Slide 22 (PDF p. 22)
ggplot(data = midwest,
         mapping = aes(x = popdensity,
                       y = percbelowpoverty,
                       color = "purple")) +
    geom_point() +
    geom_smooth() +
    scale_x_log10()

# Slide 25 (PDF p. 25)
ggplot(data = midwest,
         mapping = aes(x = popdensity,
                       y = percbelowpoverty)) +
    geom_point(color = "purple") +
    geom_smooth() +
    scale_x_log10()

# Slide 27 (PDF p. 27)
ggplot(data = midwest,
         mapping = aes(x = popdensity,
                       y = percbelowpoverty,
                       color = state,
                       fill = state)) +
    geom_point() +
    geom_smooth() +
    scale_x_log10()

# Slide 29 (PDF p. 29)
ggplot(data = midwest,
         mapping = aes(x = popdensity,
                       y = percbelowpoverty)) +
    geom_point(mapping = aes(color = state)) +
    geom_smooth(color = "black") +
    scale_x_log10()

# Slide 33 (PDF p. 33)
ggplot2::midwest ## If needed: install.packages("ggplot2")

# Slide 34 (PDF p. 34)
require(ggplot2)
ggplot(data = midwest,
       mapping = aes(x = percbelowpoverty)) +
  geom_histogram()

# Slide 36 (PDF p. 36)
ggplot(data = midwest,
       mapping = aes(x = percbelowpoverty)) +
  geom_histogram() +
  facet_wrap(~ state)

# Slide 38 (PDF p. 38)
ggplot(data = midwest,
       mapping = aes(x = percbelowpoverty,
                     fill = state, color = state)) +
  geom_density(alpha = 0.3)

# Slide 40 (PDF p. 40)
ggplot(data = midwest,
       mapping = aes(x = state,
                     y = percbelowpoverty)) +
  geom_boxplot()

# Slide 44 (PDF p. 44)
require(gapminder)
dplyr::glimpse(gapminder)

# Slide 45 (PDF p. 45)
ggplot(data = gapminder,
       mapping = aes(x = year,
                     y = gdpPercap)) +
  geom_line() # Didn't specify how to group the lines..

# Slide 47 (PDF p. 47)
ggplot(data = gapminder,
       mapping = aes(x = year,
                     y = gdpPercap)) +
  geom_line(mapping = aes(group = country))

# Slide 49 (PDF p. 49)
ggplot(data = gapminder,
       mapping = aes(x = year,
                     y = gdpPercap)) +
  geom_line(mapping = aes(group = country), color = "gray") +
  geom_smooth(method = "loess") +
  scale_y_log10(labels = scales::dollar)

# ---------------- Appendix: data types (reference, pp. 80-84) ----------------

# Slides 51-51 (PDF pp. 51-51)  In-class exercise E1 (Gapminder): write your own code here and upload it to eeclass.
