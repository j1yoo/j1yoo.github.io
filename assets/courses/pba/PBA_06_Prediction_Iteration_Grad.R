# PBA 7. Prediction and Iteration (Fall 2026)
# Run selected lines in order in RStudio. "Slide" is the number at the bottom right of each slide; "PDF p." in parentheses is the page in a PDF viewer.
# Packages used today: tidyverse (dplyr, tidyr, readr, ggplot2, lubridate).
# Today's five data sets (CES 2020, 2020 state and national polls, 2020 state results, minimum wage study) are read from the web.
# The same five data sets are also in the course data package pbadata (0.4.0 or later) under the same names.
# If a download fails: update pbadata once with the line below (restart R first if pbadata is loaded),
# then run library(pbadata) instead of the line that reads the data.
# install.packages("pbadata", type = "source", repos = "https://j1yoo.github.io/assets/courses/pba")
library(tidyverse)

# Slide 8 (PDF p. 12)
# today's five data sets are also in the course package pbadata (see the top of the R script)
# f=factor; d=double/numeric
cces_2020 <- read_csv("https://bit.ly/49AZaAM", col_types = "ffffdf"); cces_2020

# Slide 9 (PDF p. 13)
length(unique(cces_2020$gender))
length(unique(cces_2020$race))
length(unique(cces_2020$educ))
# Repeat for the rest of the columns, i.e., pid3, turnout_self, pres_vote.
unique(cces_2020$gender) # Point to the first column, gender
unique(cces_2020[[1]])
unique(cces_2020$pid3) # Point to the 4th column, pid3
unique(cces_2020[[4]])

# Slide 10 (PDF p. 14)
length(unique(cces_2020[[1]])) # No. unique values for 1st col.
length(unique(cces_2020[[2]])) # No. unique values for 2nd col.
length(unique(cces_2020[[5]])) # No. unique values for (k-1)th col.
length(unique(cces_2020[[6]])) # No. unique values for kth col.

# Slide 12 (PDF p. 16)
output <- rep(NA, times = ncol(cces_2020))     # 1. output 
for (i in seq_along(cces_2020)) {              # 2. sequence
  output[i] <- length(unique(cces_2020[[i]]))  # 3. body
}
output

# Slide 13 (PDF p. 17)
output <- rep(NA, times = ncol(cces_2020))
for (i in seq_along(cces_2020)) {
  output[i] <- length(unique(cces_2020[[i]]))
  print(output)
}

# Slide 14 (PDF p. 18)
cces_2020 |>
  summarize(across(everything(), n_distinct))

# Slide 18 (PDF p. 22)
polls20 <- as_tibble(read.csv(url("https://bit.ly/3R1qKB8")))
polls20 <- polls20 |>
  mutate(margin = biden - trump)
glimpse(polls20)

# Slide 19 (PDF p. 23)
pres20 <- as_tibble(read.csv(url("https://bit.ly/47b10aU")))
pres20 <- pres20 |>
  mutate(margin = biden - trump)
glimpse(pres20)

# Slide 21 (PDF p. 25)
poll_pred <- rep(NA, 51) # generate vector to hold the output
state_names <- sort(unique(polls20$state))
# add labels to holder
names(poll_pred) <- state_names
for (i in 1:51) {
    state_data <- polls20 |> filter(state == state_names[i])
    latest <- state_data |> filter(days_left == min(days_left))
    poll_pred[i] <- mean(latest$margin)
}
head(poll_pred) # Margin of victory for Biden in Alaska, Alabama, Arkansas...

# Slide 22 (PDF p. 26)
poll_pred <- polls20 |>
  group_by(state) |>
  filter(days_left == min(days_left)) |>
  summarize(margin_pred = mean(biden - trump)); poll_pred

# Slide 23 (PDF p. 27)
poll_pred |>
  mutate(winner_pred = if_else(margin_pred > 0, "Biden", "Trump")) |>
  select(state, margin_pred, winner_pred)

# Slide 24 (PDF p. 29)
poll_pred <- poll_pred |>
  left_join(pres20, by = "state") |>
  mutate(errors = margin - margin_pred); poll_pred

# Slide 25 (PDF p. 30)
mean(poll_pred$errors)
sqrt(mean(poll_pred$errors^2))

# Slide 26 (PDF p. 31)
ggplot(poll_pred, aes(x = errors)) +
  geom_histogram() +
  labs(x = "Prediction error for Biden's margin of victory") +
  geom_vline(xintercept = 0, color = "red") +
  geom_vline(xintercept = mean(poll_pred$errors),
             color = "darkorange", linetype = "dashed", linewidth = 1)

# Slide 28 (PDF p. 33)
mean(poll_pred$errors)^2                              # bias squared
mean((poll_pred$errors - mean(poll_pred$errors))^2)   # variance (= 4.58 squared)
mean(poll_pred$errors^2)                              # MSE = RMSE squared

# Slide 29 (PDF p. 34)
ggplot(poll_pred, aes(x = margin_pred, y = margin)) +
  geom_text(aes(label = state)) +
  geom_abline(intercept = 0, slope = 1, linetype = 2) +
  geom_hline(yintercept = 0, color = "grey") +
  geom_vline(xintercept = 0, color = "grey")

# Slide 30 (PDF p. 35)
poll_pred |>
  filter(margin > 0) |> ## States in which Biden actually won
  summarize(sum(ev)) |> pull() # pull to extract single column
poll_pred |>
  filter(margin_pred > 0) |> ## States in which Biden predicted to win
  summarize(sum(ev)) |> pull()

# Slide 31 (PDF p. 36)
poll_pred |>
  summarize(prop_correct = mean(sign(margin_pred) == sign(margin)))
poll_pred |>
  filter(sign(margin_pred) != sign(margin))

# Slide 32 (PDF p. 37)
poll_pred |>
  mutate(pred = if_else(margin_pred > 0, "Biden", "Trump"),
         actual = if_else(margin > 0, "Biden", "Trump")) |>
  count(pred, actual)

# Slide 33 (PDF p. 39)
national_polls20 <- read_csv("https://bit.ly/3VOUjsa"); national_polls20

# Slide 34 (PDF p. 40)
national_polls20 |>
  filter(!is.na(trump)) |> # one poll has no number for Trump
  ggplot(aes(x = end_date)) +
  geom_point(aes(y = biden), color = "steelblue") +
  geom_point(aes(y = trump), color = "indianred")

# Slide 36 (PDF p. 42)
head(national_polls20$end_date)
head(national_polls20$end_date + 3)
# Don't forget to install and load the package!
# "2020-11-03" + 3  ## R doesn't know this is a date yet! (remove the first "# " to see the error)
lubridate::ymd("2020-11-03") + 3
lubridate::mdy("11/03/2020") + 3

# Slide 37 (PDF p. 43)
election_day <- lubridate::ymd("2020-11-03")
# + 1: start one day later, so even the first average covers two days of polls
all_dates <- seq(from = min(national_polls20$end_date) + 1, 
                 to = election_day, 
                 by = "days")
head(all_dates)

# Slide 38 (PDF p. 44)
output <- vector("list", length = length(all_dates)) # empty list to assign the output
for (i in seq_along(all_dates)) {
  this_date <- all_dates[[i]]
 
  this_week <- national_polls20 |>
    filter(
      this_date - end_date >= 0, # this_date is on or after end_date
      this_date - end_date < 7   # within a week
    )
  
  output[[i]] <- this_week |>
    summarize(
      date = this_date,
      biden = mean(biden, na.rm = TRUE), 
      trump = mean(trump, na.rm = TRUE)
    )
  }
output <- bind_rows(output)

# Slide 39 (PDF p. 45)
output

# Slide 40 (PDF p. 46)
output |>
  ggplot(aes(x = date)) +
  geom_point(aes(y = biden), color = "steelblue") +
  geom_point(aes(y = trump), color = "indianred") +
  geom_vline(xintercept = election_day) +
  annotate("point", x = election_day, y = 51.3, color = "steelblue", size = 4) +
  annotate("point", x = election_day, y = 46.8, color = "indianred", size = 4) + 
  labs(x = "Date", y = "Predicted Vote Percentage")

# Slide 41 (PDF p. 47)
output |>
  filter(date == election_day) |>
  mutate(margin_pred = biden - trump)

# Slide 45 (PDF p. 52)
minwage <- as_tibble(read.csv(url("https://bit.ly/3QZmodH"))); head(minwage)

# Slide 46 (PDF p. 53)
minwage <- minwage |>
  mutate(
    state = if_else(location == "PA", "PA", "NJ") ## PA is control
  ); head(minwage, 2)
minwage |>
  count(location)

# Slide 47 (PDF p. 54)
minwage |>
  group_by(state) |>
  mutate(fte_after = fullAfter + 0.5 * partAfter,
         fte_before = fullBefore + 0.5 * partBefore) |>
  summarize(trend = mean(fte_after) - mean(fte_before)) |>
  pivot_wider(
    names_from = state,
    values_from = trend
  ) |>
  mutate(DID = NJ - PA)
