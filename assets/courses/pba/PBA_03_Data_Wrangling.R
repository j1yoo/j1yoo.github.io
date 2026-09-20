# PBA 3. Data Wrangling with dplyr (Fall 2026)
# Run selected lines in order in RStudio. "PDF p." refers to the 65-page slides.
# Packages used today: tidyverse (dplyr, ggplot2, forcats), knitr, wesanderson.
# Install once: install.packages(c("tidyverse", "knitr", "wesanderson"))

# PDF p. 8
mtcars$mpg

# PDF p. 8
mtcars

# PDF p. 13
# Illustration only: f, g, h, and r are placeholder functions, so this does not run.
# f(g(h(r(x))))

# PDF p. 13
# Illustration only: f, g, h, and r are placeholder functions, so this does not run.
# x |>
#   r() |>
#   h() |>
#   g() |>
#   f()

# PDF p. 15
library(tidyverse)
news <- as_tibble(read.csv(url("https://bit.ly/3Qst0Ry")))
news <- news |>
    mutate(date = as.Date(date),
           weekday = factor(weekday, levels = c("Mon", "Tue", "Wed", "Thu", "Fri"),
                            ordered = TRUE),
           month = factor(month, levels = month.abb, ordered = TRUE)); news

# PDF p. 18
news |>
    filter(weekday == "Tue")

# PDF p. 19
news |>
    filter(weekday == "Tue",
           affiliation == "FOX")

# PDF p. 20
# Common mistake, shown on purpose: "=" instead of "==" makes filter() stop with an error.
# news |>
#     filter(weekday = "Tue")

# PDF p. 22
news |>
    filter(weekday == "Tue" & ideology < 0)

# PDF p. 23
news |>
    filter(affiliation == "FOX" | affiliation == "ABC")

# PDF p. 24
news |>
    filter(weekday %in% c("Mon", "Fri"))

# PDF p. 27
news |>
    arrange(callsign, date)

# PDF p. 28
news |>
    arrange(ideology)

# PDF p. 30
news |>
    arrange(desc(ideology))

# PDF p. 32
news |>
    slice(1,3)

# PDF p. 32
news |>
    slice(1:3)

# PDF p. 33
news |>
    slice_min(ideology, n = 5)

# PDF p. 35
news |>
    select(callsign, date, ideology)

# PDF p. 35
news |>
    select(callsign:date)

# PDF p. 36
news |>
    select(!callsign:date)

# PDF p. 37
news |>
    select(where(is.numeric))

# PDF p. 38
news |>
    select(callsign:weekday, ends_with("politics"))

# PDF p. 39
news |>
    rename(call_sign = callsign)

# PDF p. 40
news |>
    mutate(
      national_local_diff = national_politics - local_politics,
      national_politics_perc = national_politics * 100
    ) |>
    select(callsign, date, national_politics, local_politics,
           national_local_diff, national_politics_perc)

# PDF p. 41
news |>
    mutate(Ownership = if_else(sinclair2017 == 1,
                               "Acquired by Sinclair",
                               "Not Acquired")) |>
    select(callsign, affiliation, date, Ownership)

# PDF p. 43
news |>
    group_by(month)

# PDF p. 44
news |>
    group_by(month) |>
    summarize(
      political_leaning_mean = mean(ideology, na.rm = TRUE)
    )

# PDF p. 45
news |>
    group_by(sinclair2017, post) |>
    summarize(
      slant_mean = mean(ideology, na.rm = TRUE),
      national_mean = mean(national_politics, na.rm = TRUE)
    )

# PDF p. 46
news |>
    group_by(sinclair2017, post) |>
    summarize(
      across(where(is.numeric), ~ mean(.x, na.rm = TRUE))
    )

# PDF p. 47
news |>
    group_by(month) |>
    summarize(
      political_leaning_mean = mean(ideology, na.rm = TRUE) ) |>
    knitr::kable(col.names = c("Month", "Avg. Ideology"))   # we can also specify column names

# PDF p. 48
news |>
    group_by(affiliation) |>
    summarize(n = n())

# PDF p. 48
news |>
    count(affiliation)

# PDF p. 50
ggplot(news, aes(x = affiliation)) +
    geom_bar()

# PDF p. 51
aff_ideology_means <- news |>
    group_by(affiliation) |>
    summarize(avg_ideology = mean(ideology, na.rm = TRUE))
aff_ideology_means
ggplot(aff_ideology_means, aes(x = affiliation, y = avg_ideology)) +
    geom_col()

# PDF p. 53
station_ideology <- news |>
    group_by(callsign, affiliation) |>
    summarize(avg_ideology = mean(ideology, na.rm = TRUE), .groups = "drop") |>
    slice_max(avg_ideology, n = 20)
ggplot(station_ideology, aes(x = avg_ideology, y = callsign)) +
    geom_col()

# PDF p. 55
ggplot(data = station_ideology,
         mapping = aes(x = avg_ideology,
                       y = fct_reorder(callsign, avg_ideology))) +
    geom_col(aes(fill = affiliation))

# PDF p. 63
ggplot(station_ideology,
         mapping = aes(x = avg_ideology,
                       y = fct_reorder(callsign, avg_ideology))) +
    geom_col(mapping = aes(fill = affiliation)) +
    scale_fill_brewer(palette = "Dark2")

# PDF p. 64
ggplot(station_ideology,
         mapping = aes(x = avg_ideology,
                       y = fct_reorder(callsign, avg_ideology))) +
    geom_col(mapping = aes(fill = affiliation)) +
    scale_fill_manual(values = c(ABC = "lightblue",
                                 CBS = "salmon",
                                 FOX = "plum",
                                 NBC = "palegreen"))

# PDF p. 65
library(wesanderson)   # install the package first!
ggplot(station_ideology,
         mapping = aes(x = avg_ideology,
                       y = fct_reorder(callsign, avg_ideology))) +
    geom_col(mapping = aes(fill = affiliation)) +
    scale_fill_manual(values = wes_palette("Moonrise3"))
