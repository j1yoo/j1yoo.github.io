# PBA 4. Causality (Fall 2026)
# Run selected lines in order in RStudio. "PDF p." refers to the 62-page slides.
# Packages used today: tidyverse (dplyr, tidyr) and the course data package pbadata (0.2.0 or later).
# Today's data (ai_tutoring, linepay; both simulated) are in pbadata 0.2.0. If you installed pbadata before today,
# update it once: remove the "# " in front of the next line, run it, then put the "# " back.
# (If pbadata is already loaded in this R session, restart R first: Session > Restart R.)
# install.packages("pbadata", type = "source", repos = "https://j1yoo.github.io/assets/courses/pba")
library(tidyverse)

# PDF p. 32
library(pbadata)
AI_data <- ai_tutoring

# PDF p. 33
AI_data # Take a peek at the data!

# PDF p. 34
treat_mean <- AI_data |>
    filter(treat_ind == 1) |>
    summarize(test_outcome_mean = mean(test_outcome_post))
treat_mean

# PDF p. 34
control_mean <- AI_data |>
    filter(treat_ind == 0) |>
    summarize(test_outcome_mean = mean(test_outcome_post))
control_mean

# PDF p. 35
treat_mean - control_mean

# PDF p. 36
AI_data |>
    group_by(treat_ind) |>
    summarize(age_mean = mean(student_age))

# PDF p. 37
AI_data |>
    group_by(treat_ind, education_level) |>
    summarize(n = n())

# PDF p. 37
AI_data |>
    group_by(treat_ind, education_level) |>
    summarize(n = n()) |>
    pivot_wider(
      names_from = treat_ind,
      values_from = n
    )

# PDF p. 39
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

# PDF p. 43
LinePay_data <- linepay   # also in the course data package, pbadata

# PDF p. 43
LinePay_data

# PDF p. 48
adopted <- LinePay_data |>
    filter(line_pay_adopt == 1) |>
    summarize(mean(spending_post)); adopted
no_change <- LinePay_data |>
    filter(line_pay_adopt == 0) |>
    summarize(mean(spending_post)); no_change

# PDF p. 48
adopted - no_change

# PDF p. 50
LinePay_data |>
    group_by(tech_savviness, line_pay_adopt) |>
    summarize(avg_spending = mean(spending_post)) |>
    mutate(line_pay_adopt = if_else(line_pay_adopt == 1, "adopted", "unadopted")) |>
    pivot_wider(
      names_from = line_pay_adopt,
      values_from = avg_spending
    ) |>
    mutate(diff_by_tech_savviness = `adopted` - `unadopted`)

# PDF p. 52
LinePay_data |>
    filter(line_pay_adopt == 1) |>
    mutate(
      spending_change = spending_post - spending_pre
    ) |>
    summarize(avg_change = mean(spending_change))

# PDF p. 54
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
