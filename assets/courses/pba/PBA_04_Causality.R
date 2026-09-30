# PBA 4. Causality (Fall 2026)
# Run selected lines in order in RStudio. "PDF p." refers to the 60-page slides.
# Packages used today: tidyverse (dplyr, tidyr).
# Install once: install.packages("tidyverse")
# Today's data (AI tutoring study, Line Pay adoption; both simulated) are read from the web with read.csv(url(...)).
library(tidyverse)

# PDF p. 30
AI_data <- as_tibble(read.csv(url("https://bit.ly/3FHsusw")))

# PDF p. 31
AI_data # Take a peek at the data!

# PDF p. 32
treat_mean <- AI_data |>
    filter(treat_ind == 1) |>
    summarize(test_outcome_mean = mean(test_outcome_post))
treat_mean

# PDF p. 32
control_mean <- AI_data |>
    filter(treat_ind == 0) |>
    summarize(test_outcome_mean = mean(test_outcome_post))
control_mean

# PDF p. 33
treat_mean - control_mean

# PDF p. 34
AI_data |>
    group_by(treat_ind) |>
    summarize(age_mean = mean(student_age))

# PDF p. 35
AI_data |>
    group_by(treat_ind, education_level) |>
    summarize(n = n())

# PDF p. 35
AI_data |>
    group_by(treat_ind, education_level) |>
    summarize(n = n()) |>
    pivot_wider(
      names_from = treat_ind,
      values_from = n
    )

# PDF p. 37
AI_data |>
    mutate(
      treat_ind = if_else(treat_ind == 1, "Treated", "Control"),
      male_stu = if_else(student_gender == 1, "Male", "Female")
    ) |>
    group_by(treat_ind, male_stu) |>
    summarize(test_outcome_mean = mean(test_outcome_post)) |>
    pivot_wider(
      names_from = treat_ind,
      values_from = test_outcome_mean
    ) |>
    mutate(
      diff_in_means = Treated - Control
    )

# PDF p. 41
LinePay_data <- as_tibble(read.csv(url("https://bit.ly/3QHEPmM")))

# PDF p. 41
LinePay_data

# PDF p. 46
adopted <- LinePay_data |>
    filter(line_pay_adopt == 1) |>
    summarize(mean(spending_post)); adopted
no_change <- LinePay_data |>
    filter(line_pay_adopt == 0) |>
    summarize(mean(spending_post)); no_change

# PDF p. 46
adopted - no_change

# PDF p. 48
LinePay_data |>
    group_by(tech_savviness, line_pay_adopt) |>
    summarize(avg_spending = mean(spending_post)) |>
    mutate(line_pay_adopt = if_else(line_pay_adopt == 1, "adopted", "unadopted")) |>
    pivot_wider(
      names_from = line_pay_adopt,
      values_from = avg_spending
    ) |>
    mutate(diff_by_tech_savviness = `adopted` - `unadopted`)

# PDF p. 50
LinePay_data |>
    filter(line_pay_adopt == 1) |>
    mutate(
      spending_change = spending_post - spending_pre
    ) |>
    summarize(avg_change = mean(spending_change))

# PDF p. 52
LinePay_data |>
    mutate(
      spending_change = spending_post - spending_pre,
      adopted = if_else(line_pay_adopt == 1, "adopted", "unadopted")
    ) |>
    group_by(adopted) |>
    summarize(avg_change = mean(spending_change)) |>
    pivot_wider(
      names_from = adopted,
      values_from = avg_change
    ) |>
    mutate(DID = adopted - unadopted)
