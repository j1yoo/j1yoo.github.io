# PBA 4. Causality (Fall 2026)
# Run selected lines in order in RStudio. "Slide" is the number at the bottom right of each slide; "PDF p." in parentheses is the page in a PDF viewer.
# Packages used today: tidyverse (dplyr, tidyr) and the course data package pbadata (0.2.0 or later).
# Today's data (ai_tutoring, linepay; both simulated) are in pbadata 0.2.0. If you installed pbadata before today,
# update it once: remove the "# " in front of the next line, run it, then put the "# " back.
# (If pbadata is already loaded in this R session, restart R first: Session > Restart R.)
# install.packages("pbadata", type = "source", repos = "https://j1yoo.github.io/assets/courses/pba")
library(tidyverse)

# Slide 25 (PDF p. 31)
library(pbadata)
AI_data <- ai_tutoring

# Slide 26 (PDF p. 32)
AI_data # Take a peek at the data!

# Slide 27 (PDF p. 33)
treat_mean <- AI_data |>
    filter(treat_ind == 1) |>
    summarize(test_outcome_mean = mean(test_outcome_post))
treat_mean

# Slide 27 (PDF p. 33)
control_mean <- AI_data |>
    filter(treat_ind == 0) |>
    summarize(test_outcome_mean = mean(test_outcome_post))
control_mean

# Slide 28 (PDF p. 34)
treat_mean - control_mean

# Slide 29 (PDF p. 35)
AI_data |>
    group_by(treat_ind) |>
    summarize(age_mean = mean(student_age))

# Slide 30 (PDF p. 36)
AI_data |>
    group_by(treat_ind, education_level) |>
    summarize(n = n())

# Slide 30 (PDF p. 36)
AI_data |>
    group_by(treat_ind, education_level) |>
    summarize(n = n()) |>
    pivot_wider(
      names_from = treat_ind,
      values_from = n
    )

# Slide 32 (PDF p. 38)
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

# Slide 35 (PDF p. 42)
LinePay_data <- linepay   # also in the course data package, pbadata

# Slide 35 (PDF p. 42)
LinePay_data

# Slide 40 (PDF p. 47)
adopted <- LinePay_data |>
    filter(line_pay_adopt == 1) |>
    summarize(mean(spending_post)); adopted
no_change <- LinePay_data |>
    filter(line_pay_adopt == 0) |>
    summarize(mean(spending_post)); no_change

# Slide 40 (PDF p. 47)
adopted - no_change

# Slide 42 (PDF p. 49)
LinePay_data |>
    group_by(tech_savviness, line_pay_adopt) |>
    summarize(avg_spending = mean(spending_post)) |>
    mutate(line_pay_adopt = if_else(line_pay_adopt == 1, "adopted", "unadopted")) |>
    pivot_wider(
      names_from = line_pay_adopt,
      values_from = avg_spending
    ) |>
    mutate(diff_by_tech_savviness = `adopted` - `unadopted`)

# Slide 44 (PDF p. 51)
LinePay_data |>
    filter(line_pay_adopt == 1) |>
    mutate(
      spending_change = spending_post - spending_pre
    ) |>
    summarize(avg_change = mean(spending_change))

# Slide 46 (PDF p. 53)
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
