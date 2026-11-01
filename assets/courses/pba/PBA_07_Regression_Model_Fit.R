# PBA 7. Regression and Model Fit (Fall 2026)
# Run selected lines in order in RStudio. "PDF p." refers to the 66-page slides.
# Packages used today: tidyverse (readr, dplyr, tidyr, ggplot2) and broom.
# Today's two data sets (health, and UT Austin course evaluations) are read from the web.
# If broom is not installed yet, run this line once: install.packages("broom")
library(tidyverse)

# PDF p. 10
# Don't forget to load tidyverse and ggplot2!
health <- as_tibble(read.csv(url("https://bit.ly/47uyilg"))); health
health <- drop_na(health)

# PDF p. 11
Tsinghua_Purple <- "#5f2167"  # Hex code for Tsinghua Purple
ggplot(health, aes(x = steps_lag, y = weight)) +
    geom_point(color = Tsinghua_Purple, size = 2) +
    labs(
      x = "Steps on day prior (in 1000s)",
      y = "Weight (in kg)"
    )

# PDF p. 13
health |>
    filter(round(steps_lag) == 5)

# PDF p. 14
mean_wt_5k_steps <- health |>
    filter(round(steps_lag) == 5) |>
    summarize(mean(weight)) |>
    pull() # indexing operator tailored to dplyr pipelines
mean_wt_5k_steps
ggplot(health, aes(x = steps_lag, y = weight)) +
    geom_point(color = Tsinghua_Purple, alpha = 0.5) +
    labs(
      x = "Steps on day prior (in 1000s)",
      y = "Weight (in kg)",
      title = "Weight and Steps"
    ) +
    geom_vline(xintercept = c(4.5, 5.5), linetype = "dashed") +
    geom_point(aes(x = 5, y = mean_wt_5k_steps), color = "indianred1", size = 3)

# PDF p. 16
ggplot(health, aes(x = steps_lag, y = weight)) +
    geom_point(color = Tsinghua_Purple, alpha = 0.25) +
    labs(
      x = "Steps on day prior (in 1000s)",
      y = "Weight (in kg)",
      title = "Weight and Steps"
    ) +
    stat_summary_bin(fun = "mean", color = "indianred1", size = 3,
                     geom = "point", binwidth = 1)

# PDF p. 19
ggplot(health, aes(x = steps_lag, y = weight)) +
    geom_point(color = Tsinghua_Purple, alpha = 0.25) +
    labs(x = "Steps on day prior (in 1000s)", y = "Weight (in kg)") +
    stat_summary_bin(fun = "mean", color = "indianred1", size = 2,
                     geom = "point", binwidth = 0.5) +
    geom_vline(xintercept = c(2.5, 3, 23, 23.5), linetype = "dashed")

# PDF p. 26
ggplot(health, aes(x = steps_lag, y = weight)) +
    geom_point(color = Tsinghua_Purple) +
    labs(
      x = "Steps on day prior (in 1000s)", y = "Weight",
      title = "Weight and Steps"
    ) +
    geom_smooth(method = "lm", se = FALSE, color = "indianred1", size = 1.5)

# PDF p. 32
fit <- lm(weight ~ steps_lag, data = health); fit

# PDF p. 33
coef(fit)

# PDF p. 34
# Don't forget to install and load the package!
require(broom)
augment(fit) |> head()

# PDF p. 35
ggplot(health, aes(x = steps_lag, y = weight)) +
    geom_point(color = Tsinghua_Purple) +
    labs(x = "Steps on day prior (in 1000s)", y = "Weight (in kg)") +
    geom_hline(yintercept = mean(health$weight), linetype = "dashed") +
    geom_vline(xintercept = mean(health$steps_lag), linetype = "dashed") +
    geom_smooth(method = "lm", se = FALSE, color = "indianred1", size = 1.5)

# PDF p. 36
augment(fit) |>
    summarize(mean(.resid))

# PDF p. 37
augment(fit) |>
    ggplot(aes(x = steps_lag, y = .resid)) +
    geom_point(color = Tsinghua_Purple, alpha = 0.75) +
    labs(
      x = "Steps on day prior (in 1000s)", y = "Residuals",
      title = "Residual plot"
    ) +
    geom_smooth(method = "lm", se = FALSE, color = "indianred1", size = 1.5)

# PDF p. 38
ggplot(health, aes(x = steps_lag, y = weight)) +
    geom_point(color = Tsinghua_Purple, alpha = 0.25) +
    labs(x = "Steps on day prior (in 1000s)", y = "Weight (in kg)") +
    stat_summary_bin(fun = "mean", color = "indianred1", size = 3,
                     geom = "point", binwidth = 1) +
    geom_smooth(method = "lm", se = FALSE, color = "indianred1", size = 1.5)

# PDF p. 41
# Don't forget to load tidyverse and ggplot2!
evals <- read_csv("https://bit.ly/46rSa7s"); evals

# PDF p. 42
fit.bty <- lm(score ~ bty_avg, data = evals)
fit.bty

# PDF p. 43
fit.age <- lm(score ~ age, data = evals)
fit.age

# PDF p. 50
fit.bty.sum <- summary(fit.bty)
fit.bty.sum$r.squared
fit.age.sum <- summary(fit.age)
fit.age.sum$r.squared

# PDF p. 51
library(broom)
glance(fit.bty)

# PDF p. 52
# fit.x <- lm(y ~ x)  # x and y are simulated for the slide figures and are not created in this script
