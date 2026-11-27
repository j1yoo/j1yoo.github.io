# PBA 10. The Bootstrap and Confidence Intervals (Fall 2026)
# Run selected lines in order in RStudio. "Slide" is the number at the bottom right of each slide; "PDF p." in parentheses is the page in a PDF viewer.
# Packages used today: tidyverse (readr, dplyr, tidyr, ggplot2) and infer.
# If infer is not installed yet, run this line once: install.packages("infer")
# The data (anes, trains) are read from the web. midwest comes with ggplot2.
#
# With set.seed(1) before a random draw, the draw is the same every time, so your output is the same as on the slides.
# Run the lines in order. If you run a random draw again without its set.seed(1) line, you get a different sample.
#
# The script has five parts, like the slides. RStudio lists them in the outline of the script.
# The check on slide 18 and the loops on slides 50, 51, and 52 take a few seconds each.
# Slides 9, 15, 21, 22, 27, 34, 35, 38, 40, 49, and 53 are text. Slides 5, 10, 19, 36, and 37 show pictures, not data.

library(tidyverse)


# Part 1. Resampling from Our Sample ------------------------------------------------------------

# Slide 6 (PDF p. 9): ANES Data
# don't forget to load tidyverse as usual!
anes <- read_csv("https://bit.ly/3TbUZXo"); anes

# Slide 7 (PDF p. 10): How Did 5,162 People Answer?
anes |>
    ggplot(aes(x = sci_therm)) +
    geom_histogram(binwidth = 5, color = "white")

# Slide 8 (PDF p. 11): Sample Statistic
anes |>
    summarize(mean(sci_therm))

# Slide 11 (PDF p. 14): One Bootstrap Resample
set.seed(1)   # the same random draws every time, as on the slides
boot_1 <- anes |>
    slice_sample(prop = 1, replace = TRUE); boot_1

# Slide 12 (PDF p. 15): Sample Mean in the Bootstrap Sample
boot_1 |>
    summarize(mean(sci_therm))

# Slide 13 (PDF p. 16): Many Bootstrap Samples
library(infer) # install the package if you haven't done so yet.
set.seed(1)
bootstrap_dist <- anes |>
    rep_slice_sample(prop = 1, reps = 1000, replace = TRUE) |>
    group_by(replicate) |>
    summarize(sci_therm_mean = mean(sci_therm)); bootstrap_dist

# Slide 14 (PDF p. 17): Visualizing the Bootstrap Distribution
bootstrap_plot <- bootstrap_dist |>
    ggplot(aes(x = sci_therm_mean)) +
    geom_histogram(aes(y = after_stat(density)), 
                   binwidth = 0.1, color = "white"); bootstrap_plot

# Slide 16 (PDF p. 19): Comparing to the Point Estimate
bootstrap_dist |>
    summarize(mean(sci_therm_mean))
anes |>
    summarize(mean(sci_therm))

# Slide 17 (PDF p. 20): Bootstrap Distribution: the Standard Error
bootstrap_dist |>
    summarize(se = sd(sci_therm_mean))   # spread of the 1,000 bootstrap means

# Slide 18 (PDF p. 21): Checking the Bootstrap Standard Error
set.seed(1)
means <- midwest |>                              # 10,000 samples of 50 counties
    rep_slice_sample(n = 50, reps = 10000) |>
    group_by(replicate) |> summarize(xbar = mean(percollege))
means |> summarize(true_se = sd(xbar))           # needs all 437 counties
one_sample <- midwest |> slice_sample(n = 50)    # in practice: one sample
boots <- one_sample |>
    rep_slice_sample(prop = 1, replace = TRUE, reps = 1000) |>
    group_by(replicate) |> summarize(xbar = mean(percollege))
boots |> summarize(boot_se = sd(xbar))           # needs only the one sample


# Part 2. Confidence Intervals ------------------------------------------------------------------

# Slide 20 (PDF p. 24): Q: Where is Most of the Bootstrap Distribution?
bootstrap_plot # ggplot obj. from earlier

# Slide 23 (PDF p. 27): Percentile Method
perc_ci95 <- quantile(bootstrap_dist$sci_therm_mean,
                        probs = c(0.025, 0.975))
perc_ci95

# Slide 24 (PDF p. 28): Visualizing the CI
bootstrap_plot_1 <- bootstrap_plot + geom_vline(xintercept = perc_ci95[1]) +
    geom_vline(xintercept = perc_ci95[2]); bootstrap_plot_1

# Slide 25 (PDF p. 29): 99% Confidence Interval
perc_ci99 <- quantile(bootstrap_dist$sci_therm_mean,
                        probs = c(0.005, 0.995))
perc_ci99

# Slide 26 (PDF p. 30): Visualizing the CIs
bootstrap_plot_2 <- bootstrap_plot_1 +
    geom_vline(xintercept = perc_ci99[1], color = "red") +
    geom_vline(xintercept = perc_ci99[2], color = "red"); bootstrap_plot_2


# Part 3. Calculating Confidence Intervals ------------------------------------------------------

# Slide 28 (PDF p. 33): Step 1: Define an Outcome of Interest
anes |>
    specify(response = sci_therm)

# Slide 29 (PDF p. 34): Step 2: Generate Bootstraps
set.seed(1)
anes |>
    specify(response = sci_therm) |>
    generate(reps = 1000, type = "bootstrap")

# Slide 30 (PDF p. 35): Step 3(a): Calculate Sample Statistics
set.seed(1)
boot_dist_infer <- anes |>
    specify(response = sci_therm) |>
    generate(reps = 1000, type = "bootstrap") |>
    calculate(stat = "mean"); boot_dist_infer

# Slide 31 (PDF p. 36): Step 3(b): Visualize the Bootstrap Distribution
visualize(boot_dist_infer)

# Slide 32 (PDF p. 37): Step 4(a): Calculate the CI
perc_ci_95 <- boot_dist_infer |>
    get_confidence_interval(level = 0.95, type = "percentile"); perc_ci_95

# Slide 33 (PDF p. 38): Step 4(b): Visualize the CI
visualize(boot_dist_infer) +
    shade_confidence_interval(endpoints = perc_ci_95)


# Part 4. Bootstrap CIs for a Difference in Means -----------------------------------------------

# Slide 39 (PDF p. 45): Trains Data
trains <- read_csv("https://bit.ly/3sUrtec"); trains

# Slide 41 (PDF p. 47): Estimating the Difference in Means
diff_in_means <- trains |>
    group_by(treatment) |>
    summarize(post_mean = mean(numberim.post)) |>
    pivot_wider(
      names_from = treatment,
      values_from = post_mean
    ) |> mutate(ATE = `1` - `0`); diff_in_means

# Slide 42 (PDF p. 48): Bootstrap for the Difference in Means
set.seed(1)
dim_boots <- trains |>
    rep_slice_sample(prop = 1, replace = TRUE, reps = 1000) |>
    group_by(replicate, treatment) |>
    summarize(post_mean = mean(numberim.post)) |>
    pivot_wider(names_from = treatment, values_from = post_mean) |>
    mutate(ATE = `1` - `0`); dim_boots
# R prints a note that the output is grouped by replicate. It is a message, not an error.

# Slide 43 (PDF p. 49): Visualizing the Bootstraps
dim_boots |>
    ggplot(aes(x = ATE)) +
    geom_histogram(aes(y = after_stat(density)), binwidth = 0.05, color = "white")

# Slide 44 (PDF p. 50): Calculating the Percentile CI
dim_ci_95 <- dim_boots |>
    select(replicate, ATE) |>
    get_confidence_interval(level  = 0.95, type = "percentile"); dim_ci_95

# Slide 45 (PDF p. 51): Change in Views/Opinions as the Outcome?
set.seed(1)
change_ci_95 <- trains |>
    rep_slice_sample(prop = 1, replace = TRUE, reps = 1000) |>
    group_by(replicate, treatment) |>
    summarize(change_mean = mean(numberim.post - numberim.pre)) |>
    pivot_wider(names_from = treatment, values_from = change_mean) |>
    mutate(ATE = `1`- `0`) |>
    select(replicate, ATE) |>
    get_confidence_interval(level = 0.95, type = "percentile"); change_ci_95

# Slide 46 (PDF p. 52): What is Different?
dim_ci_95[2] - dim_ci_95[1]
change_ci_95[2] - change_ci_95[1]

# Slide 47 (PDF p. 53): Width of CI Depends on Outcome Variability!
trains |> summarize(sd_post = sd(numberim.post),
                      sd_change = sd(numberim.post - numberim.pre))

# Slide 48 (PDF p. 54): The infer Workflow
set.seed(1)
dim_boots_infer <- trains |>
    mutate(treatment = if_else(treatment == 1, "Treated", "Control")) |>
    specify(numberim.post ~ treatment) |>
    generate(reps = 1000, type = "bootstrap") |>
    calculate(stat = "diff in means", order = c("Treated", "Control"))
dim_boots_infer |>
    get_confidence_interval(level = 0.95, type = "percentile")


# Part 5. Interpreting Confidence Intervals -----------------------------------------------------

# Slide 50 (PDF p. 57): 100 Samples, 100 Confidence Intervals
# The simulation of slide 49. A population of 1,000,000 people: 40% are interested in buying (demand = 1),
# 60% are not (demand = 0). With rep() and times = c(400000, 600000), the 1 appears 400,000 times and the 0 appears 600,000 times.
cybertruck <- tibble(demand = rep(c(1, 0), times = c(400000, 600000)))
trials <- tibble(trial = 1:100, lower = NA, upper = NA)          # 1. output: 100 rows
for (r in 1:100) {                                               # 2. sequence
    set.seed(r)                                                  # 3. body
    ci <- cybertruck |> slice_sample(n = 1500) |>                # a sample of 1,500 people
      specify(response = demand) |> generate(reps = 1000, type = "bootstrap") |>
      calculate(stat = "mean") |>
      get_confidence_interval(level = 0.95, type = "percentile")
    trials$lower[r] <- ci$lower_ci
    trials$upper[r] <- ci$upper_ci
  }

# The new column result: "Contains 0.4" if the interval contains the true value 0.4, and "Misses" if not.
trials <- trials |>
    mutate(result = if_else(lower < 0.4 & 0.4 < upper, "Contains 0.4", "Misses"))
trials |> count(result)   # the number of misses on the slide

# With geom_segment(), each sample is one vertical line, from the lower end to the upper end of its interval.
ggplot(trials, aes(x = trial, xend = trial, y = lower, yend = upper, color = result)) +
    geom_hline(yintercept = 0.4, color = "gray", linewidth = 1.5) +
    geom_segment(linewidth = 1.5) +
    scale_color_manual(values = c("Contains 0.4" = "steelblue1", "Misses" = "indianred2")) +
    ylim(0.2, 0.6) +
    labs(x = "Trial", y = "Estimate") +
    theme_classic() +
    theme(legend.position = "none")

# Slide 51 (PDF p. 58): Checking the 95% with Repeated Samples
mu <- mean(midwest$percollege); mu             # the population mean
metro <- midwest |> filter(inmetro == 1)       # the list: only the 150 metro counties
output <- tibble(all = rep(NA, 100), metro = NA)   # 1. output: 100 rows
for (r in 1:100) {                             # 2. sequence
    set.seed(r)                                  # 3. body
    ci_all <- midwest |> slice_sample(n = 50) |> # a sample from all 437 counties
      specify(response = percollege) |> generate(reps = 1000, type = "bootstrap") |>
      calculate(stat = "mean") |>
      get_confidence_interval(level = 0.95, type = "percentile")
    ci_metro <- metro |> slice_sample(n = 50) |> # a sample from the metro list
      specify(response = percollege) |> generate(reps = 1000, type = "bootstrap") |>
      calculate(stat = "mean") |>
      get_confidence_interval(level = 0.95, type = "percentile")
    output$all[r] <- ci_all$lower_ci < mu & mu < ci_all$upper_ci   # TRUE: CI contains mu
    output$metro[r] <- ci_metro$lower_ci < mu & mu < ci_metro$upper_ci
  }
output |> summarize(all = mean(all), metro = mean(metro))   # shares that contain mu

# Slide 52 (PDF p. 59): A Biased List: Rings in the Wrong Place
# The same samples as on slide 51 (set.seed(r) in every round). This time, we keep the two ends of every interval.
rings_all <- tibble(sample = 1:100, lower = NA, upper = NA)     # 1. output: 100 rows for each list
rings_metro <- tibble(sample = 1:100, lower = NA, upper = NA)
for (r in 1:100) {                                               # 2. sequence
    set.seed(r)                                                    # 3. body
    ci_all <- midwest |> slice_sample(n = 50) |>
      specify(response = percollege) |> generate(reps = 1000, type = "bootstrap") |>
      calculate(stat = "mean") |>
      get_confidence_interval(level = 0.95, type = "percentile")
    ci_metro <- metro |> slice_sample(n = 50) |>
      specify(response = percollege) |> generate(reps = 1000, type = "bootstrap") |>
      calculate(stat = "mean") |>
      get_confidence_interval(level = 0.95, type = "percentile")
    rings_all$lower[r] <- ci_all$lower_ci
    rings_all$upper[r] <- ci_all$upper_ci
    rings_metro$lower[r] <- ci_metro$lower_ci
    rings_metro$upper[r] <- ci_metro$upper_ci
  }

# With bind_rows(), the two tables become one table. The new column result: "Contains the population mean" if the interval contains mu, and "Misses" if not.
rings <- bind_rows(
    rings_all |> mutate(list = "Samples from all 437 counties"),
    rings_metro |> mutate(list = "Samples from the 150 metro counties")
  ) |>
    mutate(result = if_else(lower < mu & mu < upper, "Contains the population mean", "Misses"))

ggplot(rings, aes(x = sample, xend = sample, y = lower, yend = upper, color = result)) +
    geom_segment() +
    geom_hline(yintercept = mu) +
    facet_wrap(~ list) +
    scale_color_manual(values = c("Contains the population mean" = "#3B8BD9", "Misses" = "#E8505B")) +
    labs(x = "Sample (1 to 100)", y = "95% CI for the mean of percollege", color = NULL) +
    theme(legend.position = "bottom")
