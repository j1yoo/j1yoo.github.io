# PBA 8. Regression and Model Fit (Fall 2026)
# Run selected lines in order in RStudio. "PDF p." refers to the 66-page slides.
# Packages used today: tidyverse (readr, dplyr, tidyr, ggplot2, purrr), broom, and gridExtra.
# Today's two data sets (health, and UT Austin course evaluations) are read from the web.
# The same two data sets are also in the course data package pbadata (0.5.0 or later) as health and evals.
# If a download fails: update pbadata once with the line below (restart R first if pbadata is loaded),
# then run library(pbadata) instead of the line that reads the data.
# install.packages("pbadata", type = "source", repos = "https://j1yoo.github.io/assets/courses/pba")
# The simulated points on PDF p. 45 and pp. 51-54 are typed into this script. anscombe (PDF p. 55) comes with R.
# If broom or gridExtra is not installed yet, run this line once: install.packages(c("broom", "gridExtra"))

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

# PDF p. 12
health |>
    filter(round(steps_lag) == 5)

# PDF p. 13
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

# PDF p. 15
ggplot(health, aes(x = steps_lag, y = weight)) +
    geom_point(color = Tsinghua_Purple, alpha = 0.25) +
    labs(
      x = "Steps on day prior (in 1000s)",
      y = "Weight (in kg)",
      title = "Weight and Steps"
    ) +
    stat_summary_bin(fun = "mean", color = "indianred1", size = 3,
                     geom = "point", binwidth = 1)

# PDF p. 18
ggplot(health, aes(x = steps_lag, y = weight)) +
    geom_point(color = Tsinghua_Purple, alpha = 0.25) +
    labs(x = "Steps on day prior (in 1000s)", y = "Weight (in kg)") +
    stat_summary_bin(fun = "mean", color = "indianred1", size = 2,
                     geom = "point", binwidth = 0.5) +
    geom_vline(xintercept = c(23.25, 23.75), linetype = "dashed")

# PDF p. 25
ggplot(health, aes(x = steps_lag, y = weight)) +
    geom_point(color = Tsinghua_Purple) +
    labs(
      x = "Steps on day prior (in 1000s)", y = "Weight",
      title = "Weight and Steps"
    ) +
    geom_smooth(method = "lm", se = FALSE, color = "indianred1", size = 1.5)

# PDF p. 26
# Any other line: intercept 150 * 0.453592 + 10 (about 78.04) and slope 0.5
ggplot(health, aes(x = steps_lag, y = weight)) +
    geom_point(color = Tsinghua_Purple) +
    labs(
      x = "Steps on day prior (in 1000s)", y = "Weight",
      title = "Weight and Steps"
    ) +
    geom_abline(intercept = 150 * 0.453592 + 10, slope = .5, color = "green3", size = 1.5)

# PDF p. 31
fit <- lm(weight ~ steps_lag, data = health); fit

# PDF p. 32
coef(fit)

# PDF p. 33
# Don't forget to install and load the package!
require(broom)
augment(fit) |> head()

# PDF p. 34
ggplot(health, aes(x = steps_lag, y = weight)) +
    geom_point(color = Tsinghua_Purple) +
    labs(x = "Steps on day prior (in 1000s)", y = "Weight (in kg)") +
    geom_hline(yintercept = mean(health$weight), linetype = "dashed") +
    geom_vline(xintercept = mean(health$steps_lag), linetype = "dashed") +
    geom_smooth(method = "lm", se = FALSE, color = "indianred1", size = 1.5)

# PDF p. 35
augment(fit) |>
    summarize(mean(.resid))

# PDF p. 36
augment(fit) |>
    ggplot(aes(x = steps_lag, y = .resid)) +
    geom_point(color = Tsinghua_Purple, alpha = 0.75) +
    labs(
      x = "Steps on day prior (in 1000s)", y = "Residuals",
      title = "Residual plot"
    ) +
    geom_smooth(method = "lm", se = FALSE, color = "indianred1", size = 1.5)

# PDF p. 37
ggplot(health, aes(x = steps_lag, y = weight)) +
    geom_point(color = Tsinghua_Purple, alpha = 0.25) +
    labs(x = "Steps on day prior (in 1000s)", y = "Weight (in kg)") +
    stat_summary_bin(fun = "mean", color = "indianred1", size = 3,
                     geom = "point", binwidth = 1) +
    geom_smooth(method = "lm", se = FALSE, color = "indianred1", size = 1.5)

# PDF p. 40
# Don't forget to load tidyverse and ggplot2!
evals <- read_csv("https://bit.ly/46rSa7s"); evals

# PDF p. 41
fit.bty <- lm(score ~ bty_avg, data = evals)
fit.bty

# PDF p. 42
fit.age <- lm(score ~ age, data = evals)
fit.age

# PDF p. 43
library(gridExtra)  # grid.arrange() puts plots side by side

p1 <- ggplot(data = evals, aes(x = bty_avg, y = score)) +
    geom_point(alpha = .5) +
    geom_smooth(method = "lm", se = F, color = "red") +
    labs(title = "Aesthetic", x = "Average Beauty Score", y = "Teaching Evaluation Score")

p2 <- ggplot(data = evals, aes(x = age, y = score)) +
    geom_point(alpha = .5) +
    geom_smooth(method = "lm", se = F, color = "red") +
    labs(title = "Age", x = "Instructor's Age", y = "Teaching Evaluation Score")

grid.arrange(p1, p2, nrow = 1)

# PDF p. 45
# The simulated points on the slide: x from 0 to 1; y1 does not change with x, and y2 rises with x
simdat <- tibble(
    x = seq(0, 1, length.out = 100),
    y1 = c(
      0.0261, -0.0788, 0.0092, -0.0506, 0.0149, 0.0869, 0.2082, -0.1625, 0.2800, -0.2563, -0.0199, 0.0772, 0.0369,
      -0.0817, -0.0273, -0.0647, -0.0774, 0.1115, 0.0469, -0.0910, 0.1181, 0.0404, 0.1067, 0.0827, -0.1088,
      -0.0735, 0.0981, 0.0801, -0.0027, 0.0154, 0.1677, -0.0777, 0.0718, -0.0265, -0.0286, 0.1442, 0.1084, 0.1068,
      0.1714, 0.0028, 0.0895, -0.0407, 0.0425, -0.0171, 0.0127, 0.0781, -0.1074, 0.2747, -0.1321, -0.1594, 0.1520,
      0.1039, 0.0819, 0.0825, -0.0016, -0.1178, 0.0100, -0.0889, 0.1280, -0.0193, -0.1084, -0.0422, 0.0542,
      -0.0740, -0.1079, 0.0320, 0.0322, -0.0665, -0.0618, 0.0305, -0.1901, -0.1848, -0.0943, -0.0280, 0.0408,
      0.1937, 0.1126, -0.0210, -0.0025, -0.1316, -0.0024, -0.0379, 0.0423, -0.1086, 0.0682, 0.2012, -0.0143,
      0.0527, 0.0906, -0.0527, 0.0294, 0.0017, 0.0128, -0.1015, 0.0032, 0.0654, 0.1905, 0.1259, 0.2826, -0.1007
    ),
    y2 = c(
      -0.9128, -0.9615, -0.7406, -1.0202, -1.0032, -0.9589, -1.0912, -0.9112, -0.9143, -0.8031, -0.7638, -0.5902,
      -0.6625, -0.7951, -0.8070, -0.6478, -0.8088, -0.4734, -0.5184, -0.6631, -0.7673, -0.4404, -0.5670, -0.4116,
      -0.6746, -0.5549, -0.4742, -0.4499, -0.4793, -0.3519, -0.5007, -0.3880, -0.3415, -0.2819, -0.2420, -0.4054,
      -0.4262, -0.1248, -0.1991, -0.2870, -0.0368, -0.1602, -0.0336, -0.1246, 0.0950, 0.0846, -0.0956, 0.0466,
      0.0342, 0.1268, -0.0864, 0.0989, 0.1564, -0.1052, -0.0274, -0.0928, 0.1044, 0.2233, 0.3219, 0.1993, 0.3750,
      0.0943, 0.0822, 0.2672, 0.3313, 0.3099, 0.1266, 0.3446, 0.2433, 0.4609, 0.4508, 0.3404, 0.4032, 0.3688,
      0.4887, 0.6107, 0.4368, 0.6060, 0.5227, 0.5167, 0.6055, 0.5328, 0.6012, 0.5570, 0.8934, 0.7207, 0.6674,
      0.7790, 0.7666, 0.7759, 0.8796, 0.9141, 0.8055, 0.8212, 0.8715, 0.6890, 0.7879, 1.0963, 1.1443, 0.9751
    )
)

fit.y1 <- lm(y1 ~ x, data = simdat)
fit.y2 <- lm(y2 ~ x, data = simdat)
sum(residuals(fit.y1)^2)  # SSR of the first line
sum(residuals(fit.y2)^2)  # SSR of the second line: about the same

p1 <- ggplot(simdat, aes(x = x, y = y1)) +
    geom_point() +
    geom_smooth(method = "lm", se = F) +
    ylim(-1.6, 1.6)

p2 <- ggplot(simdat, aes(x = x, y = y2)) +
    geom_point() +
    geom_smooth(method = "lm", se = F) +
    ylim(-1.6, 1.6)

grid.arrange(p1, p2, nrow = 1)

# PDF p. 47
# 46 randomly chosen courses (10%), so that each vertical line is easy to see.
# The slides use the sample drawn in 2023 with set.seed(123) and sample_frac(evals, .1).
# Today's R draws a different sample from that code, so the 46 row numbers are listed here.
sample <- slice(evals, c(134, 365, 189, 407, 432, 21, 242, 460, 251, 208, 434, 205, 306, 258, 47, 404,
                         111, 19, 146, 424, 395, 307, 283, 438, 288, 311, 238, 260, 126, 64, 417, 390,
                         298, 343, 11, 452, 324, 93, 136, 99, 61, 175, 422, 155, 453, 59))
sample$fitted <- predict(lm(score ~ bty_avg, sample))

ggplot(data = sample, aes(x = bty_avg, y = score)) +
    geom_point(alpha = .5, size = 3) +
    geom_hline(yintercept = mean(sample$score), color = "steelblue1", size = 1.5) +
    geom_segment(aes(xend = bty_avg, yend = mean(sample$score)), color = "steelblue1") +
    labs(x = "Average Beauty Score (Sampled)", y = "Teaching Evaluation Score") +
    theme_classic()

# PDF p. 48
ggplot(data = sample, aes(x = bty_avg, y = score)) +
    geom_point(alpha = .5, size = 3) +
    geom_smooth(method = "lm", se = F, color = Tsinghua_Purple, size = 1.5) +
    geom_segment(aes(xend = bty_avg, yend = fitted), color = Tsinghua_Purple) +
    labs(x = "Average Beauty Score (Sampled)", y = "Teaching Evaluation Score") +
    theme_classic()

# R-squared from the two sums of squares (PDF p. 46), with all 463 courses
tss <- sum((evals$score - mean(evals$score))^2)  # total sum of squares
ssr <- sum(residuals(fit.bty)^2)                 # sum of squared residuals
(tss - ssr) / tss                                # the same R-squared as on PDF p. 49

# PDF p. 49
fit.bty.sum <- summary(fit.bty)
fit.bty.sum$r.squared

fit.age.sum <- summary(fit.age)
fit.age.sum$r.squared

# PDF p. 50
library(broom)
glance(fit.bty)

# PDF p. 51
# The 200 simulated points on the slides (a 10% random sample of a larger simulated data set)
fake_data <- tibble(
    x = c(
      0.2356, -0.4664, 0.0823, -0.0754, 0.5622, 0.0971, -0.2607, 0.4293, -0.9164, 2.1633, -0.3696, 0.0287, 2.5539,
      1.2276, 1.0538, 1.4576, -0.0080, -0.5183, 1.1266, -0.5463, -1.6400, 0.1729, 0.1112, -0.0896, 0.0989,
      -1.2004, -0.9963, -0.1042, 1.6764, -0.4930, 0.2588, 0.6118, 1.4789, -0.8840, 0.3436, -0.5641, 1.5257,
      1.3686, -0.5112, -0.7929, 0.6621, 0.1965, -0.4397, -1.3482, 0.6296, 1.1632, -0.1070, -0.3078, -1.6694,
      0.9224, 0.5133, 1.5475, -0.3674, 0.1864, 0.0372, 0.0052, 1.7655, 0.2090, 1.0678, 0.3476, 2.1529, 0.4825,
      -0.7258, -1.2110, 1.6151, 0.6585, 0.2813, 0.5291, 0.1476, -0.6231, 1.7608, -0.8949, 0.4433, -0.1383, 0.6079,
      0.6454, -0.9784, 0.9886, 1.7523, 0.6514, -0.5305, 0.1525, -0.5161, 1.1417, -0.8839, -0.7678, 0.0264,
      -1.8999, -0.1264, -0.1471, 0.4050, -0.0341, 0.0139, 1.9937, 0.2800, 0.3227, -0.6452, 1.4535, 0.5907, 0.8406,
      -0.7012, -0.4269, 0.3772, -0.8950, -2.0741, 0.4646, 0.3493, 0.6390, -0.2475, -0.3853, 0.1759, 0.0184,
      -0.1923, 0.7522, 0.1513, 0.1307, -1.5740, 0.7520, 2.8963, 0.1220, -0.2790, 0.8696, 1.1438, 1.2777, 0.5931,
      -0.1599, -0.2081, -0.8895, 1.6324, -0.3886, -2.2525, 0.0229, -1.6726, 0.2093, 0.2955, 0.5575, -0.1409,
      0.8505, 0.6500, 0.8819, -0.4153, 2.5601, -1.4123, 0.2450, 2.4243, -1.7588, -1.3045, 1.3071, 0.0549, 0.5765,
      -0.0670, 1.0736, 0.1503, 0.6462, -1.3777, 0.3078, 0.5503, -1.5944, -0.5173, 0.3432, 1.1950, -0.2689, 1.5930,
      0.4443, -1.1065, 0.7604, -0.3918, -1.0676, 0.1848, 1.6871, -0.0064, -0.3214, -1.1648, 0.9731, -2.1452,
      0.7543, 0.7217, -0.6764, -0.4366, 0.3706, -1.5433, -0.3515, -0.5080, 0.2035, -0.8502, -0.0331, -1.6065,
      -2.1423, -0.3385, 0.6435, -0.1903, 0.6328, 0.0831, -1.1055, -0.8713, -1.1227, 1.0291, -0.5501, 0.4621,
      1.6686
    ),
    y = c(
      1.1592, -0.4420, 0.5214, -0.7877, 0.8195, 0.0930, -0.0305, 0.1159, -2.7189, 3.9330, -0.5425, -0.4390,
      5.0427, 2.5477, 0.7415, 3.1819, -0.4114, -1.2379, 2.9455, -0.4623, -3.9189, 0.3814, -0.5341, 0.2187, 0.8390,
      -2.7735, -2.0158, 0.1591, 3.5192, -1.3691, 0.1374, 1.2095, 3.3011, -2.4801, 0.8404, -2.1741, 4.0257, 2.6253,
      -2.3686, -1.3912, 0.4041, -0.3456, -1.2272, -2.7096, 0.5893, 2.6014, 0.4817, -1.1077, -3.6778, 1.6519,
      1.6591, 3.7064, -0.5294, 1.0138, -0.4241, -0.6241, 3.3223, 0.8824, 2.2398, 0.7606, 4.6959, 1.8312, -1.4632,
      -1.9331, 3.4195, 1.1197, 1.0638, 1.0659, 0.0149, -0.9494, 4.4153, -1.4371, 0.8818, -1.2533, 1.3641, 0.4038,
      -2.1360, 2.1597, 3.5879, -0.0072, -0.2165, 0.6375, -0.9282, 2.4042, -1.6781, -1.4520, -0.4044, -3.9212,
      -0.9561, 0.4949, 1.1521, 0.0146, -0.7275, 4.5179, 0.0600, 0.6799, -0.9364, 2.7360, 1.6684, 1.4067, -1.0345,
      -0.2802, 1.3732, -1.6861, -4.6449, 1.5759, 0.3533, 1.7268, -0.1320, -1.4205, 0.1159, -0.3815, -0.2836,
      1.5466, 0.5900, 0.6216, -3.4137, 1.4826, 6.6995, 0.0584, -0.5395, 1.7685, 2.1911, 2.5501, 0.8366, -0.5222,
      0.0308, -1.4417, 2.9118, -0.3118, -4.4384, 0.5189, -3.0257, 0.2847, 0.4957, 1.0310, 0.0651, 2.3878, 0.1861,
      1.8165, -1.1197, 4.9676, -2.9153, 0.1974, 4.9110, -2.9974, -2.7860, 2.6379, 0.1758, 1.0465, -0.1502, 2.5749,
      0.2882, 0.7576, -2.5407, 0.8188, 0.1516, -3.4986, -0.7459, 1.4819, 2.9325, -0.2500, 3.0741, 0.6359, -1.4994,
      1.5119, -0.7826, -1.7350, 0.4225, 2.8800, 0.3013, -0.3364, -2.8406, 2.4016, -4.8762, 1.9192, 1.6954,
      -1.4026, -0.3439, 0.9196, -3.8479, 0.0874, -0.9984, 0.6550, -1.8355, 0.0218, -2.8786, -4.6054, -1.5048,
      1.5345, -0.3873, 0.9393, 0.4955, -2.2718, -1.7534, -3.1819, 2.1959, -1.0188, 0.4176, 2.6529
    )
)

x <- fake_data$x
y <- fake_data$y
fit.x <- lm(y ~ x)
summary(fit.x)$r.squared  # about 0.95

# PDF p. 52-54 (one figure in three steps)
# Step 1: the points and a horizontal line at 0
ggplot(fake_data, aes(x=x, y=y)) +
    geom_point(alpha = .5, color = Tsinghua_Purple) +
    geom_hline(yintercept = 0, color = Tsinghua_Purple, size = 1.5) +
    theme_classic()

# Step 2: the vertical distance from each point to that line
ggplot(fake_data, aes(x=x, y=y)) +
    geom_point(alpha = .5, color = Tsinghua_Purple) +
    geom_hline(yintercept = 0, color = Tsinghua_Purple, size = 1.5) +
    geom_segment(aes(xend = x, yend = 0), color = Tsinghua_Purple, alpha = .5) +
    theme_classic()

# Step 3: the residuals from the regression line
ggplot(fake_data, aes(x=x, y=y)) +
    geom_point(alpha = .5, color = Tsinghua_Purple) +
    geom_abline(slope = coef(summary(lm(y~x, fake_data)))[2,1], color = Tsinghua_Purple, size = 1.5) +
    geom_segment(aes(xend = x, yend = predict(lm(y~x, fake_data))), color = Tsinghua_Purple, alpha = .5) +
    theme_classic()

# PDF p. 55
data(anscombe)  # comes with R

# Convert the data to a long format for easier plotting with ggplot2
anscombe_long <- reshape(anscombe, varying = list(c("x1", "x2", "x3", "x4"),
                                                  c("y1", "y2", "y3", "y4")),
                         direction = "long", times = 1:4, v.names = c("x", "y"),
                         timevar = "dataset", idvar = "id")
anscombe_long$dataset <- factor(anscombe_long$dataset, labels = c("I", "II", "III", "IV"))

# Calculate the coefficients for the regression lines
coefs <- coef(lm(y1 ~ x1, data = anscombe))

# Plotting the Anscombe's quartet with consistent x and y axis limits
ggplot(anscombe_long, aes(x = x, y = y)) +
    geom_point(alpha = .5, size = 3) +
    facet_wrap(~ dataset, scales = "free") +
    geom_abline(slope = coefs[2], intercept = coefs[1], color = "red") +
    xlim(4, 20) + ylim(2, 14) +
    theme_bw() +
    theme(strip.background = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.border = element_rect(colour = "black", fill=NA, size=1))

# R-squared of each data set: 0.67 in all four when rounded to two decimals
anscombe_long |>
    group_by(dataset) |>
    summarize(r_squared = round(summary(lm(y ~ x))$r.squared, 2))

# PDF p. 58
# KNN as a function, from the code that made the figures on PDF p. 59 and p. 61:
# for each value in xnew, the average of ytr over the k training points whose xtr is nearest.
closest_avg <- function(xtr, ytr, xnew, k) sapply(xnew, function(z) mean(ytr[order(abs(xtr - z))[1:k]]))


# PDF p. 59
# 30 random training days; three prediction rules: a straight line, and KNN with k = 5 and k = 1
rmse <- function(y, yhat) sqrt(mean((y - yhat)^2))

set.seed(2026)
train <- health |> slice_sample(n = 30)
test <- health |> anti_join(train, by = "date")

line <- lm(weight ~ steps_lag, data = train)
rules <- tibble(rule = c("A straight line", "KNN, k = 5", "KNN, k = 1"), k = c(NA, 5, 1))
grid <- tibble(steps_lag = seq(min(health$steps_lag), max(health$steps_lag), length.out = 600))
pred <- function(k, x) if (is.na(k)) predict(line, tibble(steps_lag = x)) else closest_avg(train$steps_lag, train$weight, x, k)

res <- rules |> mutate(train_rmse = map2_dbl(k, rule, ~ rmse(train$weight, pred(.x, train$steps_lag))),
                       test_rmse = map2_dbl(k, rule, ~ rmse(test$weight, pred(.x, test$steps_lag))))
print(res)

curves <- map2_dfr(rules$k, rules$rule, ~ grid |> mutate(rule = .y, weight = pred(.x, grid$steps_lag)))
lev <- rules$rule
lab <- res |> mutate(rule = factor(rule, lev), text = sprintf("Training RMSE %.2f\nTest RMSE %.2f", train_rmse, test_rmse))

p1 <- ggplot() +
  geom_point(data = test, aes(x = steps_lag, y = weight), color = "grey75", size = 0.5) +
  geom_step(data = curves |> filter(rule != lev[1]) |> mutate(rule = factor(rule, lev)),
            aes(x = steps_lag, y = weight), color = "darkorange", linewidth = 0.6, direction = "mid") +
  geom_line(data = curves |> filter(rule == lev[1]) |> mutate(rule = factor(rule, lev)),
            aes(x = steps_lag, y = weight), color = "darkorange", linewidth = 0.9) +
  geom_point(data = train, aes(x = steps_lag, y = weight), color = Tsinghua_Purple, size = 1.6) +
  geom_text(data = lab, aes(x = Inf, y = Inf, label = text), hjust = 1.04, vjust = 1.25, size = 2.7) +
  facet_wrap(~ factor(rule, lev), nrow = 1) +
  labs(x = "Yesterday's steps (thousands)", y = "Weight (kg)")
p1  # the slide figure is 8 x 3.4 inches: widen the Plots pane (wide and short) to see the same shape
# ggsave("B07_train_test_weight.pdf", p1, width = 8, height = 3.4)  # saves it at the slide's size

# PDF p. 61
# Simulated data: true curve sin(x), noise SD 0.4, 30 training points, 1,000 training samples;
# KNN with k = 30 down to 1. Takes about 15 seconds (1,000 samples x 9 values of k x 130 predictions).
set.seed(2026)
f <- function(x) sin(x); noise_sd <- 0.4; n <- 30; R <- 1000
x0 <- seq(0, 2 * pi, length.out = 100); ks <- c(30, 20, 15, 10, 7, 5, 3, 2, 1)
P <- array(NA, c(R, length(ks), length(x0))); train_mse <- matrix(NA, R, length(ks))

for (r in 1:R) {
  x <- runif(n, 0, 2 * pi); y <- f(x) + rnorm(n, 0, noise_sd)
  for (j in seq_along(ks)) {
    P[r, j, ] <- closest_avg(x, y, x0, ks[j])
    train_mse[r, j] <- mean((y - closest_avg(x, y, x, ks[j]))^2)
  }
  if (r %% 100 == 0) print(paste0("Completed ", r, "th iteration."))  # show progress every 100 samples
}

sim <- tibble(k = ks,
  bias2 = map_dbl(seq_along(ks), ~ mean((colMeans(P[, .x, ]) - f(x0))^2)),
  variance = map_dbl(seq_along(ks), ~ mean(apply(P[, .x, ], 2, var))),
  test = bias2 + variance + noise_sd^2, train = colMeans(train_mse))
print(sim)

p2 <- sim |> pivot_longer(-k, names_to = "what", values_to = "value") |>
  mutate(what = factor(what, c("test", "train", "bias2", "variance"),
                       c("Test MSE", "Training MSE", "Bias squared", "Variance"))) |>
  ggplot(aes(x = factor(k, levels = ks), y = value, color = what, linetype = what, group = what)) +
  geom_hline(yintercept = noise_sd^2, color = "grey50", linetype = "dotted") +
  geom_line(linewidth = 1) + geom_point(size = 1.8) +
  annotate("text", x = 1, y = noise_sd^2, label = "noise", vjust = -0.5, hjust = 0, size = 3, color = "grey40") +
  scale_color_manual(values = c("darkorange", Tsinghua_Purple, "steelblue", "indianred")) +
  scale_linetype_manual(values = c("solid", "dashed", "solid", "solid")) +
  labs(x = "Number of neighbors, k (more flexible to the right)", y = "Mean squared error",
       color = NULL, linetype = NULL) +
  theme(legend.position = "top")
p2
# ggsave("B07_bias_variance_sim.pdf", p2, width = 6.4, height = 4)  # saves it at the slide's size

# PDF p. 66
health |>
    mutate(distance = abs(steps_lag - 5)) |>
    slice_min(distance, n = 10) |>
    summarize(mean(weight)) |>
    pull()
