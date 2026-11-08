# PBA 3. Data Wrangling with dplyr (Fall 2026)
# Run selected lines in order in RStudio. "Slide" is the number at the bottom right of each slide; "PDF p." in parentheses is the page in a PDF viewer.
# Packages used today: tidyverse (dplyr, ggplot2, forcats), knitr, wesanderson.
# Install once: install.packages(c("tidyverse", "knitr", "wesanderson"))
# Today's data (news) comes from the course data package, pbadata. Its install line is under "slide 13" below:
# remove the "# " in front of install.packages(...) and the line after it, run them once, then put the "# " back.

# Slide 6 (PDF p. 8)
mtcars$mpg

# Slide 6 (PDF p. 8)
mtcars

# Slide 11 (PDF p. 13)
# Illustration only: f, g, h, and r are placeholder functions, so this does not run.
# f(g(h(r(x))))

# Slide 11 (PDF p. 13)
# Illustration only: f, g, h, and r are placeholder functions, so this does not run.
# x |>
#   r() |>
#   h() |>
#   g() |>
#   f()

# Slide 13 (PDF p. 15)
# install the course data package (only once):
# install.packages("pbadata", type = "source",
#                  repos = "https://j1yoo.github.io/assets/courses/pba")
library(tidyverse)
library(pbadata)
news
# Alternatively, import the CSV file and set the column types yourself:
# news <- as_tibble(read.csv(url("https://bit.ly/3Qst0Ry")))
# news <- news |>
#   mutate(date = as.Date(date),
#          weekday = factor(weekday, levels = c("Mon", "Tue", "Wed", "Thu", "Fri"),
#                           ordered = TRUE),
#          month = factor(month, levels = month.abb, ordered = TRUE))

# Slide 15 (PDF p. 18)
news |>
    filter(weekday == "Tue")

# Slide 16 (PDF p. 19)
news |>
    filter(weekday == "Tue",
           affiliation == "FOX")

# Slide 17 (PDF p. 20)
# Common mistake, shown on purpose: "=" instead of "==" makes filter() stop with an error.
# news |>
#     filter(weekday = "Tue")

# Slide 19 (PDF p. 22)
news |>
    filter(weekday == "Tue" & ideology < 0)

# Slide 20 (PDF p. 23)
news |>
    filter(affiliation == "FOX" | affiliation == "ABC")

# Slide 21 (PDF p. 24)
news |>
    filter(weekday %in% c("Mon", "Fri"))

# Slide 24 (PDF p. 27)
news |>
    arrange(callsign, date)

# Slide 25 (PDF p. 28)
news |>
    arrange(ideology)

# Slide 26 (PDF p. 30)
news |>
    arrange(desc(ideology))

# Slide 27 (PDF p. 32)
news |>
    slice(1,3)

# Slide 27 (PDF p. 32)
news |>
    slice(1:3)

# Slide 28 (PDF p. 33)
news |>
    slice_min(ideology, n = 5)

# Slide 29 (PDF p. 35)
news |>
    select(callsign, date, ideology)

# Slide 29 (PDF p. 35)
news |>
    select(callsign:date)

# Slide 30 (PDF p. 36)
news |>
    select(!callsign:date)

# Slide 31 (PDF p. 37)
news |>
    select(where(is.numeric))

# Slide 32 (PDF p. 38)
news |>
    select(callsign:weekday, ends_with("politics"))

# Slide 33 (PDF p. 39)
news |>
    rename(call_sign = callsign)

# Slide 34 (PDF p. 40)
news |>
    mutate(
      national_local_diff = national_politics - local_politics,
      national_politics_perc = national_politics * 100
    ) |>
    select(callsign, date, national_politics, local_politics,
           national_local_diff, national_politics_perc)

# Slide 35 (PDF p. 41)
news |>
    mutate(Ownership = if_else(sinclair2017 == 1,
                               "Acquired by Sinclair",
                               "Not Acquired")) |>
    select(callsign, affiliation, date, Ownership)

# Slide 36 (PDF p. 43)
news |>
    group_by(month)

# Slide 37 (PDF p. 44)
news |>
    group_by(month) |>
    summarize(
      political_leaning_mean = mean(ideology, na.rm = TRUE)
    )

# Slide 38 (PDF p. 45)
news |>
    group_by(sinclair2017, post) |>
    summarize(
      slant_mean = mean(ideology, na.rm = TRUE),
      national_mean = mean(national_politics, na.rm = TRUE)
    )

# Slide 39 (PDF p. 46)
news |>
    group_by(sinclair2017, post) |>
    summarize(
      across(where(is.numeric), ~ mean(.x, na.rm = TRUE))
    )

# Slide 40 (PDF p. 47)
news |>
    group_by(month) |>
    summarize(
      political_leaning_mean = mean(ideology, na.rm = TRUE) ) |>
    knitr::kable(col.names = c("Month", "Avg. Ideology"))   # we can also specify column names

# Slide 41 (PDF p. 48)
news |>
    group_by(affiliation) |>
    summarize(n = n())

# Slide 41 (PDF p. 48)
news |>
    count(affiliation)

# Slide 42 (PDF p. 50)
ggplot(news, aes(x = affiliation)) +
    geom_bar()

# Slide 43 (PDF p. 51)
aff_ideology_means <- news |>
    group_by(affiliation) |>
    summarize(avg_ideology = mean(ideology, na.rm = TRUE))
aff_ideology_means
ggplot(aff_ideology_means, aes(x = affiliation, y = avg_ideology)) +
    geom_col()

# Slide 45 (PDF p. 53)
station_ideology <- news |>
    group_by(callsign, affiliation) |>
    summarize(avg_ideology = mean(ideology, na.rm = TRUE), .groups = "drop") |>
    slice_max(avg_ideology, n = 20)
ggplot(station_ideology, aes(x = avg_ideology, y = callsign)) +
    geom_col()

# Slide 47 (PDF p. 55)
ggplot(data = station_ideology,
         mapping = aes(x = avg_ideology,
                       y = fct_reorder(callsign, avg_ideology))) +
    geom_col(aes(fill = affiliation))

# Slide 54 (PDF p. 63)
ggplot(station_ideology,
         mapping = aes(x = avg_ideology,
                       y = fct_reorder(callsign, avg_ideology))) +
    geom_col(mapping = aes(fill = affiliation)) +
    scale_fill_brewer(palette = "Dark2")

# Slide 55 (PDF p. 64)
ggplot(station_ideology,
         mapping = aes(x = avg_ideology,
                       y = fct_reorder(callsign, avg_ideology))) +
    geom_col(mapping = aes(fill = affiliation)) +
    scale_fill_manual(values = c(ABC = "lightblue",
                                 CBS = "salmon",
                                 FOX = "plum",
                                 NBC = "palegreen"))

# Slide 56 (PDF p. 65)
library(wesanderson)   # install the package first!
ggplot(station_ideology,
         mapping = aes(x = avg_ideology,
                       y = fct_reorder(callsign, avg_ideology))) +
    geom_col(mapping = aes(fill = affiliation)) +
    scale_fill_manual(values = wes_palette("Moonrise3"))
