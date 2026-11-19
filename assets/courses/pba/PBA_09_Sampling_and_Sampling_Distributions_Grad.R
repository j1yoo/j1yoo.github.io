# PBA 10. Sampling and Sampling Distributions (Fall 2026)
# Run selected lines in order in RStudio. "Slide" is the number at the bottom right of each slide; "PDF p." in parentheses is the page in a PDF viewer.
# Packages used today: tidyverse (readr, dplyr, ggplot2) and infer. The picture on slide 20 also uses gridExtra.
# If infer or gridExtra is not installed yet, run this line once: install.packages(c("infer", "gridExtra"))
# The class data (class_years) are read from the web. midwest comes with ggplot2.
#
# With set.seed(1) before a random draw, the draw is the same every time, so your output is the same as on the slides.
# Run the lines in order. If you run a random draw again without its set.seed(1) line, you get a different sample.
#
# The script has five parts and an appendix, like the slides. RStudio lists them in the outline of the script.
# The pictures with 10,000 and 100,000 repetitions (slides 34 and 35), the check on slide 49 and the picture on appendix slide 2 take a few seconds.
# Slides 21, 22, 42 and 43 and appendix slides 1 and 3 are text. The target picture (slide 38) and the normal curves of part 5 (slides 45, 46 and 48) are pictures, not data.

library(tidyverse)


# Part 1. Sampling Exercise ---------------------------------------------------------------------

# Slide 4 (PDF p. 7): Data on Class Years Enrolled in PBA Fall'23
# don't forget to load tidyverse as usual!
class_years <- read_csv("https://bit.ly/47TCVp7"); class_years

# Slide 5 (PDF p. 8): Proportion Table for Class Year
class_years |>
    count(year) |>
    mutate(prop = n / nrow(class_years)) |>
    arrange(desc(prop))

# Slide 6 (PDF p. 9): Let's Take Some Samples!
set.seed(1)   # the same random draws every time, as on the slides

# Our 1st sample
class_years |>
    select(year) |>
    slice_sample(n = 5)

# Another sample
class_years |>
    select(year) |>
    slice_sample(n = 5)

# Sampling proportion of 3rd year undergrads (n=20)
class_years |> slice_sample(n = 20) |>
    summarize(jn_prop = mean(year == "Junior"))

# Slide 7 (PDF p. 10): Repeated Sampling
library(infer) # don't forget to install the package!
set.seed(1)
class_years |>
    rep_slice_sample(n = 5, reps = 2)
# In the textbook (ModernDive 7.2), the same step is rep_sample_n(size = 5, reps = 2), an older infer function.

# Slide 8 (PDF p. 11): Simulate Many Separate `Studies' Being Done
set.seed(1)
samples_n20 <- class_years  |>
    rep_slice_sample(n = 20, reps = 100) |>
    group_by(replicate) |>
    summarize(jn_prop = mean(year == "Junior")); samples_n20

# Slide 9 (PDF p. 12): Distribution of These Proportions
samples_n20 |>
    ggplot(mapping = aes(x = jn_prop)) +
    geom_histogram(binwidth=0.05) +
    coord_cartesian(xlim = c(0, 1)) +
    # red line: the population proportion, 0.324 (slide 5)
    geom_vline(xintercept = 0.324, color = "indianred1", linewidth = 1)

# Slide 10 (PDF p. 13): What If the Sample Sizes are Bigger? (n=40)
set.seed(1)
samples_n40 <- class_years |>
    rep_slice_sample(n = 40, reps = 100) |>
    group_by(replicate) |>
    summarize(jn_prop = mean(year == "Junior"))

samples_n40 |>
    ggplot(mapping = aes(x = jn_prop)) +
    geom_histogram(binwidth=0.05) + coord_cartesian(xlim = c(0, 1)) +
    geom_vline(xintercept = 0.324, color = "indianred1", linewidth = 1)

# Slide 11 (PDF p. 14): What About When n=60?
set.seed(1)
samples_n60 <- class_years |>
    rep_slice_sample(n = 60, reps = 100) |> group_by(replicate) |>
    summarize(jn_prop = mean(year == "Junior"))

samples_n60 |>
    ggplot(mapping = aes(x = jn_prop)) + geom_histogram(binwidth=0.02) +
    coord_cartesian(xlim = c(0, 1)) +
    geom_vline(xintercept = 0.324, color = "indianred1", linewidth = 1)

# Slide 12 (PDF p. 15): Sample Size and Variability Across Samples
samples_n20 |>
    summarize(sd(jn_prop)) |> pull()

samples_n40 |>
    summarize(sd(jn_prop)) |> pull()

samples_n60 |>
    summarize(sd(jn_prop)) |> pull()

# Slide 13 (PDF p. 16): One Loop for All Sample Sizes
# The code of slides 8, 10 and 11 once, in a for loop (PBA 6): output, sequence, body.
sizes <- c(10, 20, 30, 40, 50, 60, 70)
output <- rep(NA, times = length(sizes))  # 1. output
for (i in seq_along(sizes)) {             # 2. sequence
    set.seed(1)                           # 3. body: same seed as slides 8, 10, 11
    samples <- class_years |>
        rep_slice_sample(n = sizes[i], reps = 100) |>
        group_by(replicate) |>
        summarize(jn_prop = mean(year == "Junior"))
    output[i] <- sd(samples$jn_prop)
  }
tibble(n = sizes, sd = output)


# Part 2. Sampling Framework and Polls ----------------------------------------------------------

# Slide 18 (PDF p. 22): Expected Value
samples_n60 |>
    summarize(mean(jn_prop)) |> pull() # 100 samples only: close to 0.324, not exactly

set.seed(1)
class_years |>
    rep_slice_sample(n = 60, reps = 100000) |>       # 100,000 samples
    group_by(replicate) |>
    summarize(jn_prop = mean(year == "Junior")) |>
    summarize(mean(jn_prop)) |> pull() |> round(3)   # the population proportion is 0.324

# Slide 19 (PDF p. 23): Standard Error Across Repeated Samples
samples_n60 |>
    summarize(sd(jn_prop)) |> pull()

# Slide 20 (PDF p. 24): The Three Distributions Visualized
# Left: all 71 students (1 = junior). Middle: one sample of 20 students. Right: the 100 sample proportions of slide 8.
# With factor(), the 0/1 variable is a category, so the bars are labeled 0 and 1. With ylim(), the y-axis goes from 0 to 70.
p1 <- class_years |>
    mutate(third_year = as.numeric(year == "Junior")) |>
    ggplot(aes(x = factor(third_year))) +
    geom_bar() +
    ylim(c(0, 70)) +
    labs(x = "Third Year (Junior)", title = "Population distribution")

set.seed(1)
p2 <- class_years |>
    slice_sample(n = 20) |>
    mutate(third_year = as.numeric(year == "Junior")) |>
    ggplot(aes(x = factor(third_year))) +
    geom_bar() +
    ylim(c(0, 70)) +
    labs(x = "Third Year (Junior)", title = "Sample distribution")

p3 <- samples_n20 |>
    ggplot(mapping = aes(x = jn_prop)) +
    geom_histogram(binwidth = 0.05, color = "white") +
    labs(title = "Sampling distribution") +
    coord_cartesian(xlim = c(0, 1))

gridExtra::grid.arrange(p1, p2, p3, nrow = 1)   # the three plots side by side


# Part 3. Random Variables and Probability Distributions ----------------------------------------

# Slide 26 (PDF p. 31): Discrete Probability Distribution
class_years |>
    mutate(Third_year = as.numeric(year == "Junior")) |>
    ggplot(aes(x = Third_year)) +
    geom_bar(mapping = aes(y = after_stat(prop)), width = 0.1)

# Slide 27 (PDF p. 32): Midwest Data Redux
library(ggplot2)
midwest

# Slide 28 (PDF p. 33): Continuous Probability Distribution
midwest |>
    ggplot(aes(x = percollege)) +
    geom_histogram(aes(y = after_stat(density)), binwidth = 1)


# Part 4. Sampling Distribution -----------------------------------------------------------------

# Slides 31 and 32 (PDF p. 37-38): Sample Means/Proportions Distribution, 100 repetitions
set.seed(1)
midwest |>
    rep_slice_sample(n = 50, reps = 100) |>
    group_by(replicate) |>
    summarize(`Average Percent College` = mean(percollege)) |>
    ggplot(mapping = aes(x = `Average Percent College`)) +
    geom_histogram(aes(y = after_stat(density)), binwidth = 0.5) +
    coord_cartesian(xlim = c(14, 23), ylim = c(0, 0.7)) +
    labs(title = "100 Repetitions") +
    # red curve: a normal curve with this mean and sd (slides 36 and 47)
    stat_function(fun = dnorm, args = c(mean = mean(midwest$percollege),
                                        sd = sd(midwest$percollege)/sqrt(50)),
                  color = "indianred1", linewidth = 1.5, xlim = c(14,23))

# Slide 33 (PDF p. 39): 1,000 repetitions. Only reps and the title change.
set.seed(1)
midwest |>
    rep_slice_sample(n = 50, reps = 1000) |>
    group_by(replicate) |>
    summarize(`Average Percent College` = mean(percollege)) |>
    ggplot(mapping = aes(x = `Average Percent College`)) +
    geom_histogram(aes(y = after_stat(density)), binwidth = 0.5) +
    coord_cartesian(xlim = c(14, 23), ylim = c(0, 0.7)) +
    labs(title = "1,000 Repetitions") +
    stat_function(fun = dnorm, args = c(mean = mean(midwest$percollege),
                                        sd = sd(midwest$percollege)/sqrt(50)),
                  color = "indianred1", linewidth = 1.5, xlim = c(14,23))

# Slide 34 (PDF p. 40): 10,000 repetitions. With more sample means the bins can be narrower (binwidth = 0.2).
set.seed(1)
midwest |>
    rep_slice_sample(n = 50, reps = 10000) |>
    group_by(replicate) |>
    summarize(`Average Percent College` = mean(percollege)) |>
    ggplot(mapping = aes(x = `Average Percent College`)) +
    geom_histogram(aes(y = after_stat(density)), binwidth = 0.2) +
    coord_cartesian(xlim = c(14, 23), ylim = c(0, 0.7)) +
    labs(title = "10,000 Repetitions") +
    stat_function(fun = dnorm, args = c(mean = mean(midwest$percollege),
                                        sd = sd(midwest$percollege)/sqrt(50)),
                  color = "indianred1", linewidth = 1.5, xlim = c(14,23))

# Slide 35 (PDF p. 41): 100,000 repetitions (binwidth = 0.05)
set.seed(1)
midwest |>
    rep_slice_sample(n = 50, reps = 100000) |>
    group_by(replicate) |>
    summarize(`Average Percent College` = mean(percollege)) |>
    ggplot(mapping = aes(x = `Average Percent College`)) +
    geom_histogram(aes(y = after_stat(density)), binwidth = 0.05) +
    coord_cartesian(xlim = c(14, 23), ylim = c(0, 0.7)) +
    labs(title = "100,000 Repetitions") +
    stat_function(fun = dnorm, args = c(mean = mean(midwest$percollege),
                                        sd = sd(midwest$percollege)/sqrt(50)),
                  color = "indianred1", linewidth = 1.5, xlim = c(14,23))

# Slide 39 (PDF p. 45): What If We Sample Only from Undergraduates?
# undergrads: the 52 undergraduates. The 19 graduate students are not on this list.
undergrads <- class_years |>
    filter(year %in% c("Sophomore", "Junior", "Senior"))
set.seed(1)
ug_n20 <- undergrads |>
    rep_slice_sample(n = 20, reps = 100) |> group_by(replicate) |>
    summarize(jn_prop = mean(year == "Junior"))
ug_n40 <- undergrads |>
    rep_slice_sample(n = 40, reps = 100) |> group_by(replicate) |>
    summarize(jn_prop = mean(year == "Junior"))

ug_n20 |> summarize(mean = mean(jn_prop), sd = sd(jn_prop))

ug_n40 |> summarize(mean = mean(jn_prop), sd = sd(jn_prop))

# Slide 40 (PDF p. 46): A Larger Sample: More Precise, Still Biased
# The four tables of 100 sample proportions in one table. panel is the name of the table a row is from: one histogram for each name,
# with facet_wrap() (PBA 2). The panels are in alphabetical order: "Larger ..." before "Smaller ...".
four <- bind_rows(
    samples_n40 |> mutate(panel = "Larger sample (n = 40): whole class"),
    ug_n40      |> mutate(panel = "Larger sample (n = 40): undergraduates only"),
    samples_n20 |> mutate(panel = "Smaller sample (n = 20): whole class"),
    ug_n20      |> mutate(panel = "Smaller sample (n = 20): undergraduates only"))

four |>
    ggplot(mapping = aes(x = jn_prop)) +
    geom_histogram(binwidth = 0.05) +
    geom_vline(xintercept = mean(class_years$year == "Junior"),    # the population proportion, 0.324
               color = "indianred1", linewidth = 1) +
    facet_wrap(~ panel, ncol = 2) +
    coord_cartesian(xlim = c(0, 1)) +
    labs(x = "Sample proportion of juniors (jn_prop)")

# Slide 41 (PDF p. 47): Bias and Spread Together: The Total Error
# four: the table made for the picture of slide 40, just above.
four |>
    group_by(panel) |>
    summarize(bias = round(mean(jn_prop) - 0.324, 3),            # center minus truth
              sd   = round(sd(jn_prop), 3),                      # the spread
              rmse = round(sqrt(mean((jn_prop - 0.324)^2)), 3))  # the typical error


# Part 5. Normal Variables and the Central Limit Theorem ----------------------------------------

# Slide 49 (PDF p. 59): Checking the Empirical Rule with Our Samples
set.seed(1)
means <- midwest |>
    rep_slice_sample(n = 50, reps = 10000) |>
    group_by(replicate) |>
    summarize(xbar = mean(percollege))
mu <- mean(midwest$percollege)   # the population mean
means |>
    summarize(se = sd(xbar),       # the standard error: sd of the sample means
              within_1 = mean(abs(xbar - mu) < se),      # abs(): the distance from mu
              within_2 = mean(abs(xbar - mu) < 2 * se),
              within_3 = mean(abs(xbar - mu) < 3 * se))


# Appendix --------------------------------------------------------------------------------------

# Appendix slide 2 (PDF p. 64): Not Every Statistic: The Largest Value in a Sample
set.seed(1)
midwest |>
    rep_slice_sample(n = 50, reps = 10000) |>
    group_by(replicate) |>
    summarize(largest = max(percollege)) |>
    ggplot(mapping = aes(x = largest)) +
    geom_histogram(binwidth = 0.5)
