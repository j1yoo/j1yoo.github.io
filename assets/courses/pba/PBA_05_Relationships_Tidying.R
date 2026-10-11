# PBA 5. Summarizing Bivariate Relationships & Tidying Data (Fall 2026)
# Run selected lines in order in RStudio. "PDF p." refers to the 71-page slides.
# Packages used today: tidyverse (dplyr, tidyr, readr, ggplot2), gapminder (Week 2), and nycflights13.
# Today's vaccination, mortality, and Spotify data are read from the web; gapminder and nycflights13 come with their packages.
# The same three data sets are also in the course data package pbadata (0.3.0 or later) under the same names.
# If a download fails: update pbadata once with the line below (restart R first if pbadata is loaded),
# then run library(pbadata) instead of the line that reads the data.
# install.packages("pbadata", type = "source", repos = "https://j1yoo.github.io/assets/courses/pba")
# If you have not installed nycflights13 yet: remove the "# " in front of the next line, run it once, then put the "# " back.
# install.packages("nycflights13")
library(tidyverse)

# PDF p. 11
covid_data <- read_csv(url("https://bit.ly/3FOLohq")); covid_data

# PDF p. 18
covid_data |>
  mutate(one_dose_centered = one_dose_5plus_pct -
           mean(one_dose_5plus_pct, na.rm = T)) |>
  select(fips:state, one_dose_5plus_pct, one_dose_centered)

# PDF p. 19
covid_data |>
  mutate(one_dose_z = (one_dose_5plus_pct - mean(one_dose_5plus_pct, na.rm = T)) /
           sd(one_dose_5plus_pct, na.rm = T)) |>
  select(fips:state, one_dose_5plus_pct, one_dose_z)

# PDF p. 28
covid_data |>
  summarize(cor(one_dose_5plus_pct, dem_pct_2020))

covid_data |>
  summarize(cor(one_dose_5plus_pct, dem_pct_2020, use = "pairwise"))

# PDF p. 29
covid_data |>
  ggplot(aes(x = dem_pct_2020, y = one_dose_5plus_pct)) + geom_point(alpha = .5) +
  labs(x = "Percent of votes for Joe Biden (Democrat; vs. D. Trump), 2020",
       y = "Percent with at least one dose (ages 5+)")

cor(covid_data$one_dose_5plus_pct, covid_data$dem_pct_2020, use = "pairwise")

# PDF p. 30
covid_data |>
  ggplot(aes(x = dem_pct_2000, y = one_dose_5plus_pct)) + geom_point(alpha = .5) +
  labs(x = "Percent of votes for Al Gore (Democrat; vs. G. W. Bush), 2000",
       y = "Percent with at least one dose (ages 5+)")

cor(covid_data$one_dose_5plus_pct, covid_data$dem_pct_2000, use = "pairwise")

# PDF p. 31
covid_data |>
  ggplot(aes(x = dem_pct_2000, y = one_dose_65plus_pct)) + geom_point(alpha = .5) +
  labs(x = "Percent of votes for Al Gore (Democrat; vs. G. W. Bush), 2000",
       y = "Percent with at least one dose (ages 65+)")

cor(covid_data$one_dose_65plus_pct, covid_data$dem_pct_2000, use = "pairwise")

# PDF p. 33
covid_data |>
  mutate(
    one_dose_5p_z =
      (one_dose_5plus_pct - mean(one_dose_5plus_pct, na.rm = TRUE)) /
      sd(one_dose_5plus_pct, na.rm = TRUE),
    one_dose_65p_z =
      (one_dose_65plus_pct - mean(one_dose_65plus_pct, na.rm = TRUE)) /
      sd(one_dose_65plus_pct, na.rm = TRUE),
    booster_z =
      (booster_5plus_pct - mean(booster_5plus_pct, na.rm = TRUE)) /
      sd(booster_5plus_pct, na.rm = TRUE),
    dem_pct_2000_z =
      (dem_pct_2000 - mean(dem_pct_2000, na.rm = TRUE)) /
      sd(dem_pct_2000, na.rm = TRUE),
    dem_pct_2020_z =
      (dem_pct_2020 - mean(dem_pct_2020, na.rm = TRUE)) /
      sd(dem_pct_2020, na.rm = TRUE)
  )

# PDF p. 36
z_score <- function(x) {
  (x - mean(x, na.rm = TRUE)) / sd(x, na.rm = TRUE)
}

z_score(c(1,2,3,4,5))

# PDF p. 37
covid_data |>
  mutate(
    one_dose_5p_z = z_score(one_dose_5plus_pct),
    one_dose_65p_z = z_score(one_dose_65plus_pct),
    booster_z = z_score(booster_5plus_pct),
    dem_pct_2000_z = z_score(dem_pct_2000),
    dem_pct_2020_z = z_score(dem_pct_2020)
  )

# PDF p. 38
covid_data |>
  mutate(across(one_dose_5plus_pct:dem_pct_2020, z_score))

# PDF p. 39
covid_data |>
  mutate(across(where(is.numeric), z_score))

# PDF p. 40
covid_data |>
  mutate(across(starts_with("one_dose"), z_score))

# PDF p. 41
z_score2 <- function(x, na.rm = FALSE) {
  (x - mean(x, na.rm = na.rm)) / sd(x, na.rm = na.rm)
}

head(z_score2(covid_data$one_dose_5plus_pct))

head(z_score2(covid_data$one_dose_5plus_pct, na.rm = T))

# PDF p. 43
mortality <- read_csv(url("https://bit.ly/3QCCPvc")); mortality

# PDF p. 45
mortality |>
  select(-indicator) |>
  pivot_longer(
    cols = `1972`:`2020`,
    names_to = "year",
    values_to = "child_mortality"
  )

# PDF p. 46
mortality |>
  select(-indicator) |>
  pivot_longer(
    cols = `1972`:`2020`,
    names_to = "year",
    values_to = "child_mortality"
  ) |>
  ggplot(mapping = aes(x = year, y = child_mortality, group = country)) +
  geom_line(alpha = 0.25)

# PDF p. 47
mortality_long <- mortality |>
  select(-indicator) |>
  pivot_longer(
    cols = `1972`:`2020`,
    names_to = "year",
    values_to = "child_mortality"
  ) |>
  mutate(year = as.integer(year)); mortality_long

# PDF p. 48
mortality_long |>
  ggplot(mapping = aes(x = year, y = child_mortality, group = country)) +
  geom_line(alpha = 0.25) +
  labs(x = "Year", y = "Under 5 Child Mortality")

# PDF p. 49
spotify <- read_csv(url("https://bit.ly/49tn2qR")); spotify

# PDF p. 50
spotify |>
  pivot_longer(
    cols = c(-`Track Name`, -Artist),
    names_to = "week_of_year",
    values_to = "rank"
  )

# PDF p. 51
spotify |>
  pivot_longer(
    cols = c(-`Track Name`, -Artist),
    names_to = "week_of_year",
    values_to = "rank",
    names_prefix = "week"
  ) |> mutate(
    week_of_year = as.integer(week_of_year)
  )

# PDF p. 54
require(gapminder)
gapminder

# PDF p. 55
gapminder |>
  select(country, year) |>
  head(10)

mortality_long |>
  select(country, year) |>
  head(10)

# PDF p. 57
gapminder |>
  count(country, year) |>
  filter(n > 1)

mortality_long |>
  count(country, year) |>
  filter(n > 1)

# PDF p. 58
gapminder |>
  left_join(mortality_long) |>
  select(country, year, lifeExp, pop, gdpPercap, child_mortality) |>
  head(n = 6)

# PDF p. 59
gapminder |>
  inner_join(mortality_long) |>
  select(country, year, lifeExp, pop, gdpPercap, child_mortality) |>
  head(n = 6)

# PDF p. 62
library(nycflights13)
flights2 <- flights |>
  select(year, time_hour, origin, dest, tailnum, carrier); flights2

# PDF p. 63
planes2 <- planes |>
  select(tailnum, year, type, engine, seats); planes2

# PDF p. 64
flights2 |>
  left_join(planes2)

# PDF p. 65
flights2 |>
  left_join(planes2, by = "tailnum")

# PDF p. 66
flights2 |>
  left_join(planes2 |>
              rename(manufacture_year = year))

# Appendix, PDF p. 69-70: code for the histograms on PDF p. 12 and 14-16
covid_long <- covid_data |>
  pivot_longer(
    cols = c(one_dose_5plus_pct, one_dose_65plus_pct),
    names_to = "population",
    values_to = "one_dose_pct"
  ) |>
  mutate(Population = if_else(population == "one_dose_5plus_pct", "Ages 5+", "Ages 65+"))

# PDF p. 12
ggplot(data = covid_long, aes(x = one_dose_pct, fill = Population)) +
  geom_histogram(alpha = .5) +
  geom_vline(xintercept = 60) +
  labs(x = "Percent of Population with at least One Dose", y = "Count")

# PDF p. 14
ggplot(data = covid_long, aes(x = one_dose_pct, fill = Population)) +
  geom_histogram(alpha = .5) +
  geom_vline(aes(xintercept = 60, color = Population)) +
  labs(x = "Percent of Population with at least One Dose", y = "Count")

# PDF p. 15
centered_60 <- covid_long |>
  group_by(Population) |>
  summarize(centered_60 = 60 - mean(one_dose_pct, na.rm = T)); centered_60

covid_long |>
  group_by(Population) |>
  mutate(one_dose_centered = one_dose_pct - mean(one_dose_pct, na.rm = T),
         centered_60 = 60 - mean(one_dose_pct, na.rm = T)) |>
  ggplot(aes(x = one_dose_centered, fill = Population)) +
  geom_histogram(alpha = .5) +
  geom_vline(aes(xintercept = centered_60, color = Population)) +
  labs(x = "Distance from the Group Mean (percentage points)", y = "Count")

# PDF p. 16
scaled_60 <- covid_long |>
  group_by(Population) |>
  summarize(scaled_60 = (60 - mean(one_dose_pct, na.rm = T))/
              sd(one_dose_pct, na.rm = T)); scaled_60

covid_long |>
  group_by(Population) |>
  mutate(one_dose_z = (one_dose_pct - mean(one_dose_pct, na.rm = T))/
           sd(one_dose_pct, na.rm = T),
         scaled_60 = (60 - mean(one_dose_pct, na.rm = T))/
           sd(one_dose_pct, na.rm = T)) |>
  ggplot(aes(x = one_dose_z, fill = Population)) +
  geom_histogram(alpha = .5) +
  geom_vline(aes(xintercept = scaled_60, color = Population)) +
  labs(x = "Z-Score (standard deviations from the group mean)", y = "Count")
