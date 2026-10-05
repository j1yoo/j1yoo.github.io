# PBA 5. Causality II: DAGs and Covariate Selection (Fall 2026)
# Run selected lines in order in RStudio. "PDF p." refers to the 57-page slides.
# Packages used today: tidyverse (dplyr, tidyr), the course data package pbadata (0.2.0 or later), and dagitty.
# dagitty is new today. Install it once: remove the "# " in front of the next line, run it, then put the "# " back.
# install.packages("dagitty")
library(tidyverse)

# PDF p. 7: last week's Line Pay comparisons, overall and within tech-savviness groups
library(pbadata)
LinePay_data <- linepay

LinePay_data |>
    group_by(line_pay_adopt) |>
    summarize(avg_spending = mean(spending_post)) |>
    mutate(line_pay_adopt = if_else(line_pay_adopt == 1, "adopted", "unadopted")) |>
    pivot_wider(names_from = line_pay_adopt, values_from = avg_spending) |>
    mutate(diff = adopted - unadopted)

LinePay_data |>
    group_by(tech_savviness, line_pay_adopt) |>
    summarize(avg_spending = mean(spending_post)) |>
    mutate(line_pay_adopt = if_else(line_pay_adopt == 1, "adopted", "unadopted")) |>
    pivot_wider(names_from = line_pay_adopt, values_from = avg_spending) |>
    mutate(diff = adopted - unadopted)

# PDF p. 14: a DAG is a recipe for data (fork: X -> T, X -> Y, no arrow T -> Y)
set.seed(1008)
n <- 2000
tech  <- rbinom(n, 1, 0.5)                 # X: no parents
adopt <- rbinom(n, 1, 0.3 + 0.4 * tech)    # T: parent X
spend <- 50 + 20 * tech + rnorm(n, 0, 10)  # Y: parent X only
fork  <- tibble(tech, adopt, spend)

# PDF p. 20
fork |>
    group_by(adopt) |>
    summarize(avg_spend = mean(spend))

# PDF p. 21
fork |>
    group_by(tech, adopt) |>
    summarize(avg_spend = mean(spend)) |>
    pivot_wider(names_from = adopt, values_from = avg_spend,
                names_prefix = "adopt_") |>
    mutate(diff = adopt_1 - adopt_0)

# PDF p. 22: chain (T -> M -> Y)
set.seed(1008)
adopt  <- rbinom(n, 1, 0.5)                    # T: no parents
coupon <- rbinom(n, 1, 0.2 + 0.5 * adopt)      # M: parent T
spend  <- 50 + 15 * coupon + rnorm(n, 0, 10)   # Y: parent M only
chain  <- tibble(adopt, coupon, spend)

chain |>
    group_by(adopt) |>
    summarize(avg_spend = mean(spend))

# PDF p. 23
chain |>
    group_by(coupon, adopt) |>
    summarize(avg_spend = mean(spend)) |>
    pivot_wider(names_from = adopt, values_from = avg_spend,
                names_prefix = "adopt_") |>
    mutate(diff = adopt_1 - adopt_0)

# PDF p. 24: collider (T -> C <- Y)
set.seed(1008)
adopt  <- rbinom(n, 1, 0.5)                        # T: no parents
spend  <- 50 + rnorm(n, 0, 10)                     # Y: no parents
member <- if_else(adopt == 1 | spend > 60, 1, 0)   # C: parents T and Y
collider <- tibble(adopt, spend, member)

collider |>
    group_by(adopt) |>
    summarize(avg_spend = mean(spend))

# PDF p. 25
collider |>
    filter(member == 1) |>
    group_by(adopt) |>
    summarize(avg_spend = mean(spend), n = n())

# PDF p. 39
LinePay_data |>
    group_by(gender, line_pay_adopt) |>
    summarize(avg_spending = mean(spending_post)) |>
    mutate(line_pay_adopt = if_else(line_pay_adopt == 1, "adopted", "unadopted")) |>
    pivot_wider(names_from = line_pay_adopt, values_from = avg_spending) |>
    mutate(diff = adopted - unadopted)

# PDF p. 49
library(dagitty)
g <- dagitty('dag {
      X -> Z -> T -> Y
      X -> T -> M
      M <- U2 -> Y
      X <- U1 -> Y
  }')
latents(g) <- c("U1", "U2")   # unobserved
plot(g)

# PDF p. 50
parents(g, "T")
descendants(g, "T")
paths(g, "T", "Y")$paths
paths(g, "T", "Y", directed = TRUE)$paths
dseparated(g, "Z", "M", c("T"))

# PDF p. 51
adjustmentSets(g, "T", "Y")
adjustmentSets(g, "T", "Y", type = "all")
# The list also shows sets with U1 or U2, which we cannot use because they are unobserved.
# dagitty's rule is a little more general than the backdoor criterion, so sets with M appear too, but each needs U2.
# The sets we can actually use: { X } and { X, Z }.
