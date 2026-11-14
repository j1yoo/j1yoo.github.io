# PBA 8. More on Regression (Fall 2026)
# Run selected lines in order in RStudio. "Slide" is the number at the bottom right of each slide; "PDF p." in parentheses is the page in a PDF viewer.
# Packages used today: tidyverse (readr, dplyr, tidyr, ggplot2), broom, modelr, glmnet, ggrepel, and pbadata.
# The UT Austin course evaluations, the Ames house prices, and the minimum wage data are read from the web.
# The ad study data (bli_experiment, bli_ads, bli_survey) are in the course data package pbadata (0.6.0 or later).
# Update pbadata once with the line below (restart R first if pbadata is loaded):
# install.packages("pbadata", type = "source", repos = "https://j1yoo.github.io/assets/courses/pba")
# evals and minwage are also in pbadata: if a download fails, run library(pbadata) instead of the line that reads them.
# If modelr, glmnet, or ggrepel is not installed yet, run this line once: install.packages(c("modelr", "glmnet", "ggrepel"))
#
# The script has four parts and an appendix, like the slides. RStudio lists them in the outline of the script.
# A model fit many times uses the for loop from PBA 6 (Prediction and Iteration): 1. output, 2. sequence, 3. body.
# Four loops take a while. On a Mac Studio (M1 Ultra): slide 18 about 1 minute, the table of slide 22 about 10 seconds,
# appendix slide 1 about 10 seconds, and appendix slide 2 about 20 seconds. Slower computers may take two or three times as long.
# The target picture on appendix slide 1, the ad pictures on slides 26-27, and the diagram on slide 31 are images, not data.

library(tidyverse)


# Part 1. Multiple Regression -------------------------------------------------------------------

# Slide 5 (PDF p. 8): UT Austin Student Eval. Data
# Don't forget to load tidyverse and ggplot2!
evals <- read_csv("https://bit.ly/46rSa7s"); evals

# Slide 7 (PDF p. 10): Multiple Regression in R
eval_cnt <- evals |> # Center the variables for better interpretation of the intercept
    mutate(bty_cnt = bty_avg - mean(bty_avg),
           age_cnt = age - mean(age))
mult.fit.cnt <- lm(score ~ bty_cnt + age_cnt, data = eval_cnt); mult.fit.cnt
mean(evals$bty_avg); mean(evals$age)   # the means on the slide (4.42 and 48.4): the intercept is the score at these values

# Slide 8, second page (PDF p. 12): Least Squares: The Lowest Point of the SSR Curve
# ssr() is our own function: the sum of squared residuals for one pair of slopes. The intercept is mean(score), 4.17 in
# the output of slide 7: with centered predictors it is the best intercept for every pair of slopes.
ssr <- function(b1, b2) {
  sum((eval_cnt$score - mean(eval_cnt$score) - b1 * eval_cnt$bty_cnt - b2 * eval_cnt$age_cnt)^2)
}
b1_hat <- coef(mult.fit.cnt)["bty_cnt"]   # 0.061, the estimate on slide 7
b2_hat <- coef(mult.fit.cnt)["age_cnt"]   # -0.003
ssr(b1_hat, b2_hat)                       # 131.49: the SSR at the estimates

# Left picture: three values of beta1. Each line is the predicted score of an instructor of average age.
# It goes through the point of means (beauty 4.42, score 4.17). geom_abline() draws a line from its intercept and slope (PBA 6).
three <- tibble(beta1 = c(0, b1_hat, 0.18),
                name = c("0", "0.061 (lm estimate)", "0.18")) |>
  mutate(name = factor(name, levels = c("0.061 (lm estimate)", "0", "0.18")),     # the order in the legend
         intercept = mean(evals$score) - beta1 * mean(evals$bty_avg))            # the height of the line where beauty is 0
line_colors <- c("indianred1", "steelblue", "forestgreen")   # the lm estimate, as the fitted lines of earlier weeks; then beta1 = 0 and 0.18
p_lines <- ggplot(evals, aes(x = bty_avg, y = score)) +
  geom_point(color = "#5f2167", alpha = 0.3) +
  geom_abline(data = three, aes(slope = beta1, intercept = intercept, linetype = name, color = name), linewidth = 0.9) +
  scale_color_manual(values = line_colors) +
  labs(x = "Beauty score", y = "Evaluation score", linetype = "beta1", color = "beta1") +
  theme(legend.position = "bottom")
p_lines

# Right picture: SSR for many values of beta1 while beta2 stays at its estimate (the for loop of PBA 6).
ssr_curve <- tibble(beta1 = seq(-0.12, 0.27, by = 0.01), ssr = NA)   # 1. output: one row per value of beta1
for (i in 1:nrow(ssr_curve)) {                                        # 2. sequence
  ssr_curve$ssr[i] <- ssr(ssr_curve$beta1[i], b2_hat)                 # 3. body
}
three <- three |>
  mutate(ssr = c(ssr(0, b2_hat), ssr(b1_hat, b2_hat), ssr(0.18, b2_hat)))   # 135.5, 131.5, 146.8
p_curve <- ggplot(ssr_curve, aes(x = beta1, y = ssr)) +
  geom_line(linewidth = 0.8) +
  geom_point(data = three, aes(color = name), size = 3) +             # each point in the color of its line
  scale_color_manual(values = line_colors) +
  geom_text(data = three, aes(label = round(ssr, 1)),
            hjust = c(1.3, 0.5, -0.3), vjust = c(0.5, -1.2, 0.5)) +   # each number left of, above, or right of its point
  labs(x = "beta1: coefficient of beauty", y = "SSR") +
  theme(legend.position = "none")
p_curve

# Slide 8, third page (PDF p. 13): Intercept at Y bar: SSR Is a Bowl
# SSR for 61 x 61 pairs of slopes around the estimates.
b1_values <- seq(-0.04, 0.16, length.out = 61)
b2_values <- seq(-0.019, 0.013, length.out = 61)
bowl <- tibble(beta1 = rep(b1_values, times = 61),      # 1. output: one row per pair
               beta2 = rep(b2_values, each = 61), ssr = NA)
for (i in 1:nrow(bowl)) {                               # 2. sequence
  bowl$ssr[i] <- ssr(bowl$beta1[i], bowl$beta2[i])      # 3. body
}

# Left picture: persp() (base R) draws the SSRs as a surface. It takes them as a matrix: one row per beta1, one column per beta2.
height <- matrix(bowl$ssr, nrow = 61)
view <- persp(x = b1_values, y = b2_values, z = height,
              theta = 32, phi = 26,                       # the direction we look from
              col = "thistle", border = NA, shade = 0.15, # one color, with a little shadow
              xlab = "beta1 (beauty)", ylab = "beta2 (age)", zlab = "SSR")
# trans3d() returns the place of a point in that picture. Dashed curve: the SSR curve above. Dot: the lm() estimates.
on_bowl <- ssr_curve |> filter(beta1 >= -0.04, beta1 <= 0.16)
lines(trans3d(on_bowl$beta1, b2_hat, on_bowl$ssr, view), lty = "dashed", lwd = 2)
points(trans3d(b1_hat, b2_hat, ssr(b1_hat, b2_hat), view), pch = 21, bg = "indianred1", cex = 1.5)

# Right picture: the same bowl from above. geom_contour() draws lines along which SSR is the same.
p_contour <- ggplot(bowl, aes(x = beta1, y = beta2)) +
  geom_contour(aes(z = ssr), breaks = ssr(b1_hat, b2_hat) + c(0.5, 2, 4.5, 8), color = "grey40") +
  geom_hline(yintercept = b2_hat, linetype = "dashed") +     # the SSR curve above, seen from above
  annotate("point", x = b1_hat, y = b2_hat, shape = 21, fill = "indianred1", size = 3) +
  annotate("text", x = b1_hat, y = b2_hat + 0.002, label = "least squares", hjust = -0.1) +
  labs(x = "beta1: coefficient of beauty", y = "beta2: coefficient of age")
p_contour

# Slide 10 (PDF p. 15): Comparing Model Fits
# Four models, one more predictor each time. glance() returns one row for a model, and bind_rows() stacks the rows.
# df in glance() is the model degrees of freedom: the number of coefficients of the predictors (the intercept is not counted).
# Here each predictor has one coefficient, so df is 1, 2, 3, 4. A predictor with categories has one coefficient for each
# category but the first. The other degrees of freedom, n - k - 1 in the formula of slide 9, is the column df.residual.
library(broom)
fit.bty <- lm(score ~ bty_avg, data = evals)   # the beauty score model from Week 9
fit.size <- lm(score ~ bty_avg + age + cls_students, data = evals)   # add class size
# set.seed() makes the random draw the same every time. sample(age) returns the same ages in a random order,
# so this last predictor cannot be related to the score.
set.seed(1)   # sample(age): the same ages in a random order, unrelated to the score
fit.rand <- lm(score ~ bty_avg + age + cls_students + sample(age), data = evals)
bind_rows(glance(fit.bty), glance(mult.fit.cnt), glance(fit.size), glance(fit.rand)) |>
    select(df, r.squared, adj.r.squared)   # model df: the number of predictor coefficients

# Slide 11 (PDF p. 16): Predicted Values from R
mult.fit <- lm(score ~ bty_avg + age, data = evals)  # same model, not centered
evals_26 <- evals |>   ## Suppose we have course 464 being taught in 2026
    select(ID, score, age, bty_avg) |>   # keep the four columns we use
    bind_rows(
      data.frame(ID = 464, score = NA, age = 36, bty_avg = 4.7)
    )

library(modelr)
evals_26 |>
    filter(ID == 464) |>
    add_predictions(mult.fit)

# Slide 12 (PDF p. 17): Predictions from Several Models
evals_26 |>
    filter(ID == 464) |>
    gather_predictions(fit.bty, mult.fit)

# Slide 13 (PDF p. 18): Predictions from New Data
tibble(bty_avg = c(2.5, 4.5), age = 36) |>
    gather_predictions(fit.bty, mult.fit)

# The last line of the slide: the coefficient that the random ages got on slide 10.
coef(fit.rand) |> round(4)   # the last one, for sample(age), is 0.0017: not 0


# Part 2. Many Predictors: Ridge, Lasso, and Elastic Net ----------------------------------------

# Slide 15 (PDF p. 21): Ames Data in R: 40 Training Houses
# predictors: the 27 numeric features of the Ames data (size, quality, year built, rooms, garage, and more)
predictors <- c("Lot Area", "Overall Qual", "Overall Cond", "Year Built",
    "Year Remod/Add", "Mas Vnr Area", "Total Bsmt SF", "Gr Liv Area", "Bsmt Full Bath",
    "Bsmt Half Bath", "Full Bath", "Half Bath", "Bedroom AbvGr", "Kitchen AbvGr",
    "TotRms AbvGrd", "Fireplaces", "Garage Cars", "Garage Area", "Wood Deck SF",
    "Open Porch SF", "Enclosed Porch", "3Ssn Porch", "Screen Porch", "Pool Area",
    "Misc Val", "Mo Sold", "Yr Sold")   # the 27 numeric features

# read_tsv() reads a tab-separated file, as read_csv() reads a comma-separated one.
# all_of(predictors) selects the columns whose names are in predictors.
ames <- read_tsv("https://jse.amstat.org/v19n3/decock/AmesHousing.txt") |>
    select(SalePrice, all_of(predictors)) |>    # all_of(): the columns named in predictors
    drop_na() |>                                # 2,904 sales with complete records
    mutate(price = SalePrice / 1000)            # sale price in $1,000s
ames |> select(price, `Gr Liv Area`, `Overall Qual`, `Year Built`, `Garage Cars`) |>
    head(3)
nrow(ames)          # sales with all 27 features (2,930 sales in the file)
median(ames$price)  # the median sale price in the table on slide 14

# set.seed() makes the random draws the same every time; sample(n, 40) draws 40 of the row numbers 1 to n.
set.seed(87746)
train <- sample(nrow(ames), 40)                          # 40 training houses
# data[rows, columns], as in Week 1 (R basics); -train means all rows but train
ames_train <- ames[train, ]; ames_test <- ames[-train, ]  # test: the other 2,864 houses
rmse <- function(y, yhat) sqrt(mean((y - yhat)^2))   # root mean squared error (Week 9)
nrow(ames_test)   # 2,864 test houses

# Slide 16 (PDF p. 22): Polynomial Regression Can Overfit
# I(): inhibit interpretation. Inside I(), R reads ^ as arithmetic ("as is") and computes the square.
lm(price ~ `Gr Liv Area` + I(`Gr Liv Area`^2), data = ames_train)   # degree 2
# poly(x, 10): the polynomial of degree 10 in x, without typing ten I() terms. We use only its predictions.
lm(price ~ poly(`Gr Liv Area`, 10), data = ames_train)              # degree 10

# The figure: fits of degree 1, 2, and 10 to the same 40 training houses (purple); grey: the test houses.
# Test RMSE uses the 2,794 test houses inside the living-area range of the training houses.
Tsinghua_Purple <- "#5f2167"  # Hex code for Tsinghua Purple

set.seed(87746); i <- sample(nrow(ames), 40)   # the same 40 training houses as on slide 15
area <- ames$`Gr Liv Area`; y <- ames$price
tr <- tibble(area = area[i], price = y[i])     # training houses
te <- tibble(area = area[-i], price = y[-i])   # test houses
inside <- te$area >= min(tr$area) & te$area <= max(tr$area)   # TRUE: inside the living-area range of the training houses
sum(inside)                                                    # 2,794 test houses
grid <- tibble(area = seq(min(tr$area), max(tr$area), length.out = 400))   # 400 living areas to draw each curve

degrees <- c(1, 2, 10)
fits <- tibble(degree = degrees, train = NA, test = NA)   # 1. output: one row per degree
curves <- tibble()                                        #    and the curves, added one degree at a time
for (j in 1:3) {                                          # 2. sequence
  f <- lm(price ~ poly(area, degrees[j]), data = tr)      # 3. body
  fits$train[j] <- rmse(tr$price, predict(f))             # predict() without new data: the training houses
  fits$test[j] <- rmse(te$price[inside], predict(f, te[inside, ]))
  curves <- bind_rows(curves, grid |> mutate(degree = degrees[j], pred = predict(f, grid)))
}
fits   # training and test RMSE of the three fits (the panel titles)

# Panel titles, such as "Degree 1 (a line)", with the two RMSEs rounded to whole numbers
lab <- fits |>
  mutate(panel = paste0("Degree ", degree, c(" (a line)", "", ""),
                        "\ntraining RMSE ", round(train), ", test RMSE ", round(test)))
lab$panel <- factor(lab$panel, levels = lab$panel)   # keep the order 1, 2, 10
curves <- curves |> left_join(lab |> select(degree, panel), by = "degree")

p <- ggplot() +
  geom_point(data = te, aes(area, price), color = "grey80", size = 0.4) +          # no panel column: drawn in every panel
  geom_point(data = tr, aes(area, price), color = Tsinghua_Purple, size = 1.4) +
  geom_line(data = curves, aes(area, pred), color = "darkorange", linewidth = 0.9) +
  facet_wrap(~ panel, nrow = 1) +
  coord_cartesian(xlim = c(min(tr$area), max(tr$area)), ylim = c(-30, 790)) +   # zoom in: points outside are hidden, not dropped
  labs(x = "Living area (square feet)", y = "Sale price ($1,000s)")
p  # the slide figure is 8 x 2.9 inches: widen the Plots pane (wide and short) to see the same shape
# ggsave("B08_poly_degrees.pdf", p, width = 8, height = 2.9)  # saves it at the slide's size

# Slide 17 (PDF p. 23): Few Houses: 27 Predictors Overfit
# This loop makes the table: 200 random samples of 40 training houses, and the medians of the 200 training and test RMSEs.
# set.seed(r) gives each round its own seed, so round r draws the same 40 houses every time (also for the table of slide 22).
# R warns "prediction from rank-deficient fit" when the loop ends: in most samples some predictor (Pool Area, for example)
# is 0 for all 40 training houses, so lm() cannot estimate its coefficient (NA in coef(fit_all)) and predicts without it.
few <- c("Gr Liv Area", "Overall Qual", "Year Built")
output <- tibble(few_train = rep(NA, 200), few_test = NA,   # 1. output: 200 rows
                 all_train = NA, all_test = NA)
for (r in 1:200) {                 # 2. sequence
  set.seed(r); i <- sample(nrow(ames), 40)   # 3. body: 40 random houses
  fit_few <- lm(price ~ ., data = ames[i, c("price", few)])         # 3 predictors
  fit_all <- lm(price ~ ., data = ames[i, c("price", predictors)])  # all 27 predictors
  output$few_train[r] <- rmse(ames$price[i], predict(fit_few, ames[i, ]))  # training RMSE
  output$few_test[r] <- rmse(ames$price[-i], predict(fit_few, ames[-i, ])) # test RMSE
  output$all_train[r] <- rmse(ames$price[i], predict(fit_all, ames[i, ]))
  output$all_test[r] <- rmse(ames$price[-i], predict(fit_all, ames[-i, ]))
}
output |> summarize(across(few_train:all_test, median))   # medians over the 200 samples

# Slide 18 (PDF p. 24): Too Many Columns, Even with Many Houses
# 378 columns: the 27 predictors and the product of every pair of them (351 products).
# In a formula, .^2 means every predictor plus every product of two predictors (an interaction, slide 40).
# 200 random splits: 2,323 training houses (80% of 2,904) and 581 test houses.
# It prints its progress every 20 splits. R warns "prediction from rank-deficient fit": some products are 0 for
# every training house, so lm() leaves them out.
ames27 <- ames |> select(price, all_of(predictors))
ncol(model.matrix(price ~ .^2, data = ames27)) - 1   # 378 columns (model.matrix: slide 38), not counting the intercept

output378 <- tibble(ls27_train = rep(NA, 200), ls27_test = NA,   # 1. output: one row per split
                    ls378_train = NA, ls378_test = NA)
set.seed(2026)
for (r in 1:200) {                                            # 2. sequence
  tr <- sample(nrow(ames27), 2323)                            # 3. body: 80% of the houses for training
  fit27 <- lm(price ~ ., data = ames27[tr, ])                 # 27 predictors
  fit378 <- lm(price ~ .^2, data = ames27[tr, ])              # 378 columns

  output378$ls27_train[r] <- rmse(ames27$price[tr], predict(fit27))
  output378$ls27_test[r] <- rmse(ames27$price[-tr], predict(fit27, ames27[-tr, ]))
  output378$ls378_train[r] <- rmse(ames27$price[tr], predict(fit378))
  output378$ls378_test[r] <- rmse(ames27$price[-tr], predict(fit378, ames27[-tr, ]))

  if (r %% 20 == 0) print(paste0("Completed ", r, "th iteration."))  # show progress every 20 splits
}
output378 |> summarize(across(everything(), median))   # the table: medians over the 200 splits

# Slide 19 (PDF p. 25): Penalized Regression: Penalty on Large Coefficients
# The note on the slide: the coefficient of garage cars ($1,000s per car space) with all houses and with 40 houses.
fit_2904 <- lm(price ~ ., data = ames[, c("price", predictors)])   # all 2,904 houses, 27 predictors
coef(fit_2904)["`Garage Cars`"]                                     # 4.0
garage <- rep(NA, 200)                        # 1. output: the coefficient in each sample
for (r in 1:200) {                            # 2. sequence
  set.seed(r); i <- sample(nrow(ames), 40)    # 3. body: the same 40 houses as in round r of slide 17
  fit_40 <- lm(price ~ ., data = ames[i, c("price", predictors)])
  garage[r] <- coef(fit_40)["`Garage Cars`"]
}
# quantile(x, c(0.05, 0.95)): 5% of the values are below the first number, and 5% are above the second.
quantile(garage, c(0.05, 0.95))   # -39 and 41: 9 of 10 samples are in between
sum(garage < 0)                   # 103 of the 200 samples: a negative coefficient

# Slide 20 (PDF p. 26): Ridge Shrinks; Lasso Sets Some to Zero
# The figure: ridge and lasso coefficients for 8 predictors as lambda grows (all 2,904 houses).
# Each predictor becomes a z-score (PBA 5): mean 0 and standard deviation 1, so the 8 are on the same scale.
# glmnet() fits the model for 100 values of lambda at once; alpha = 0 is ridge and alpha = 1 is lasso.
library(glmnet)    # install.packages("glmnet") once
library(ggrepel)   # install.packages("ggrepel") once: labels that do not overlap
X <- as.matrix(ames[, predictors])   # glmnet() takes the predictors as a matrix (slide 22)
y <- ames$price
show <- c("Gr Liv Area", "Overall Qual", "Year Built", "Total Bsmt SF",
          "Garage Cars", "Fireplaces", "Bedroom AbvGr", "Lot Area")
Xs <- ames |>
  select(all_of(show)) |>
  mutate(across(everything(), ~ (.x - mean(.x)) / sd(.x))) |>
  as.matrix()

paths <- tibble()                                     # 1. output: one row per method, predictor, and lambda
for (m in c("lasso", "ridge")) {                      # 2. sequence
  fit <- glmnet(Xs, y, alpha = if_else(m == "lasso", 1, 0), standardize = FALSE)   # 3. body
  b <- as.matrix(fit$beta)                            # coefficients: one row per predictor, one column per lambda
  for (v in show) {
    paths <- bind_rows(paths, tibble(method = m, variable = v, log_lambda = log(fit$lambda), coef = b[v, ]))
  }
}
paths <- paths |>
  mutate(method = factor(method, levels = c("ridge", "lasso"),
                         labels = c("Ridge: shrinks all coefficients", "Lasso: sets some exactly to zero")))
ends <- paths |> group_by(method, variable) |> slice_min(log_lambda, n = 1)   # the left end of each line: its label goes there

p1 <- ggplot(paths, aes(x = log_lambda, y = coef, color = variable)) +
  geom_hline(yintercept = 0, color = "grey60") +
  geom_line(linewidth = 0.8) +
  geom_text_repel(data = ends, aes(label = variable),   # like geom_text(), but the labels do not overlap (ggrepel)
                  direction = "y", hjust = 1, nudge_x = -0.4, size = 2.3,
                  segment.size = 0.2, min.segment.length = 0, show.legend = FALSE) +
  facet_wrap(~ method, nrow = 1, scales = "free_x") +
  scale_x_continuous(expand = expansion(mult = c(0.32, 0.03))) +   # room on the left of each panel for the labels
  labs(x = "log(lambda): a larger penalty to the right", y = "Coefficient (same scale)") +
  theme(legend.position = "none")
p1  # the slide figure is 8 x 3.6 inches: widen the Plots pane (wide and short) to see the same shape
# ggsave("B08_coef_paths.pdf", p1, width = 8, height = 3.6)  # saves it at the slide's size

# Slide 21 (PDF p. 27): Choosing lambda: Cross-Validation
# The figure: 5-fold cross-validation for lasso with the 40 training houses of slide 15.
# The next three lines are the lasso fit of slide 22, so the figure and the code of slide 22 show the same fit.
x <- as.matrix(ames_train[, predictors])
set.seed(87746)   # cv.glmnet() draws the 5 folds at random
cv <- cv.glmnet(x, ames_train$price, alpha = 1, nfolds = 5, keep = TRUE)
cv$lambda.min                              # the lambda with the lowest CV error: 6.9
max(cv$lambda)                             # the largest lambda in cv$lambda: 70

cvd <- tibble(lambda = cv$lambda, rmse = sqrt(cv$cvm))   # cvm: the average test MSE over the 5 folds
p2 <- ggplot(cvd, aes(x = lambda, y = rmse)) +
  geom_line(color = "darkorange", linewidth = 1) +
  geom_point(color = "darkorange", size = 1) +
  geom_vline(xintercept = cv$lambda.min, linetype = "dashed", color = Tsinghua_Purple) +
  annotate("text", x = cv$lambda.min, y = 80, label = paste0("lowest average test error\n(lambda = ", round(cv$lambda.min, 1), ")"),
           hjust = -0.05, vjust = 1, size = 3, color = Tsinghua_Purple) +
  annotate("text", x = 1.6, y = 70, label = "high\nvariance", hjust = 0, size = 3, color = "grey30") +
  annotate("text", x = 25, y = 59.5, label = "high bias", hjust = 1, size = 3, color = "grey30") +
  coord_cartesian(xlim = c(0, 25), ylim = c(53, 80)) +   # zoom in: lambda goes on to 70, outside the picture
  labs(x = "lambda (shown up to 25 of 70)", y = "Test RMSE from 5-fold CV ($1,000s)")
p2  # the slide figure is 6 x 3.8 inches
# ggsave("B08_cv_lasso.pdf", p2, width = 6, height = 3.8)  # saves it at the slide's size

# Slide 22 (PDF p. 28): In R: Penalized Models Predict Better
library(glmnet)   # install.packages("glmnet") once
x <- as.matrix(ames_train[, predictors])   # ames_train, ames_test, predictors: slide 15
set.seed(87746)   # cv.glmnet() draws the 5 folds at random (as on slide 21)
# keep = TRUE saves the fold of each house in cv$foldid, so that ridge and elastic net use the same folds.
cv <- cv.glmnet(x, ames_train$price, alpha = 1, nfolds = 5, keep = TRUE)   # lasso
cv_r <- cv.glmnet(x, ames_train$price, alpha = 0, foldid = cv$foldid)      # ridge
cv_e <- cv.glmnet(x, ames_train$price, alpha = 0.5, foldid = cv$foldid)    # elastic net
x_test <- as.matrix(ames_test[, predictors])
# s = "lambda.min": predict with the lambda that had the lowest cross-validation error. pred: predicted test-house prices.
pred <- predict(cv, newx = x_test, s = "lambda.min")   # s: lambda with lowest CV error
rmse(ames_test$price, pred)   # test RMSE; rmse(): slide 15

# The table: the same three fits for the 200 samples of slide 17 (set.seed(r) draws the same 40 houses as round r there).
# In this loop each model draws its own 5 folds. It takes about 10 seconds and prints its progress every 20 samples.
X <- as.matrix(ames[, predictors]); y <- ames$price
output23 <- tibble(lasso_test = rep(NA, 200), ridge_test = NA, enet_test = NA)   # 1. output: 200 rows
for (r in 1:200) {                                            # 2. sequence
  set.seed(r); i <- sample(nrow(ames), 40)                    # 3. body: 40 random houses
  fit_l <- cv.glmnet(X[i, ], y[i], alpha = 1, nfolds = 5)     # lasso
  fit_r <- cv.glmnet(X[i, ], y[i], alpha = 0, nfolds = 5)     # ridge
  fit_e <- cv.glmnet(X[i, ], y[i], alpha = 0.5, nfolds = 5)   # elastic net
  output23$lasso_test[r] <- rmse(y[-i], predict(fit_l, X[-i, ], s = "lambda.min"))
  output23$ridge_test[r] <- rmse(y[-i], predict(fit_r, X[-i, ], s = "lambda.min"))
  output23$enet_test[r] <- rmse(y[-i], predict(fit_e, X[-i, ], s = "lambda.min"))
  if (r %% 20 == 0) print(paste0("Completed ", r, "th iteration."))  # show progress every 20 samples
}
median(output$all_test)                               # least squares with all 27 predictors (slide 17): 58.2
output23 |> summarize(across(everything(), median))   # lasso, ridge, elastic net: 41.6, 41.8, 40.9

# Slide 23 (PDF p. 29): Three Test Houses: Which Model Predicts Closer?
# The trained models predict the prices of the test houses. All five models were fit to the same 40 training houses.
# Least squares, without a penalty, for comparison (the same 40 training houses)
ls3 <- lm(price ~ ., data = ames_train[, c("price", few)])   # 3 predictors (slide 17)
ls27 <- lm(price ~ ., data = ames_train[, c("price", predictors)])   # all 27 predictors

# cv, cv_r, cv_e: the lasso, ridge, and elastic net fits of slide 22. Here we only predict.
# predict() returns the predicted prices in a one-column matrix; [, 1] takes that column
# (pred_net is our own function: it does this for one fit).
pred_net <- function(fit) predict(fit, newx = x_test, s = "lambda.min")[, 1]

# add_predictions(model, var = "name") puts the predictions of the model into a new column with that name
# (without var the column is called pred, as on slide 11). slice() keeps the rows with these numbers.
ames_test |>   # all 2,864 test houses; var: the name of the new column
    add_predictions(ls3, var = "least_sq3") |> add_predictions(ls27, var = "least_sq27") |>
    mutate(lasso = pred_net(cv), ridge = pred_net(cv_r), elastic_net = pred_net(cv_e)) |>
    select(actual_price = price, least_sq3:elastic_net) |>
    slice(2, 52, 439)   # a cheap, a mid-priced, and an expensive house

# Slide 24 (PDF p. 30): Careful: Lasso Picks Predictors, Not Causes
# Garage cars and garage area carry almost the same information:
cor(ames$`Garage Cars`, ames$`Garage Area`)   # correlation 0.89
# The 60% on the slide comes from the loop of appendix slide 1 at the end of this script.


# Part 3. Categorical Predictors and an Experiment ----------------------------------------------

# Slide 28 (PDF p. 35): Ad Experiment Data (Synthetic)
# today's data are in the course data package pbadata (update it once: see the top of the R script)
library(pbadata)
bli <- bli_experiment   # one row per customer visit: 4,000 synthetic customers, 76 days
bli |> head()

# Slide 29 (PDF p. 36): Linear Regression for Experimental Data
bli |>
    group_by(treat_ind) |>
    summarize(purchase = mean(purchase)) |>
    pivot_wider(names_from = treat_ind, values_from = purchase) |>
    mutate(ITT = `1` - `0`)

lm(purchase ~ treat_ind, data = bli) |> coef() |> round(5)

# Slide 30 (PDF p. 37): Who Finishes the Ad?
bli |>
    filter(treat_ind == 1) |>
    group_by(finished) |>
    summarize(n = n(), purchase = mean(purchase))

# Slide 32 (PDF p. 39): Ad Data: 74 Slider Ads
bli_ads <- bli_ads |>   # add any_face: 1 if a human face appears on any panel, 0 if on none
    mutate(any_face = if_else(first_face + middle_face + late_face > 0, 1, 0))
bli_ads |> select(ad, completion, first_chars, late_chars, late_color, any_face) |> head()
c(min(bli_ads$completion), max(bli_ads$completion))       # completion across the 74 ads (slide 31)
c(min(bli_ads$total_slides), max(bli_ads$total_slides))   # number of panels (slide 26)
median(bli_ads$total_slides)                              # the median number of panels

# Slide 33 (PDF p. 40): Regression on 74 Ads: Do the Signs Match?
ads <- bli_ads |>  # completion: % of views that reached the last panel
    # z-scores of the 13 continuous features (1 = one standard deviation); any_face stays 1 or 0
    mutate(across(total_slides:late_story, ~ (.x - mean(.x)) / sd(.x)))
lm(completion ~ first_chars + late_chars + late_color + any_face, data = ads) |>
    coef() |> round(3)

# Slide 34 (PDF p. 41): The Survey Data
survey <- bli_survey   # one row per participant and ad
survey |> head()
n_distinct(survey$person)   # number of participants

# Slide 37 (PDF p. 44): Regression with Categorical Variables
survey <- survey |>   # levels 1 to 5; level 1 (strongly negative) is the baseline
    mutate(experience = factor(experience))

fit.exp <- lm(purchase_intent ~ experience, data = survey); fit.exp

# Slide 38 (PDF p. 45): What R Does Internally w/ Factors in lm()
survey |> select(experience) |> pull() |> head()

model.matrix(fit.exp) |> head()

# Slide 39 (PDF p. 46): Back to the Experiment: Book Dummies as Controls
lm(purchase ~ treat_ind + factor(book), data = bli) |> coef() |> head(2) |> round(5)
n_distinct(bli$book)   # number of books: factor(book) adds one binary variable for each book but the first


# Part 4. Interactions --------------------------------------------------------------------------

# Slide 41 (PDF p. 49): Finishing x Experience in R
# The model on the slide (Table 8 of the article)
fit.int <- lm(purchase_intent ~ finished + finished:experience + genre_match +
                  factor(person) + factor(book), data = survey)
coef(fit.int)[c("finished", paste0("finished:experience", 2:5))] |> round(3)

# The table: the gap between finished and unfinished ads at experience level k = finished + finished:experience k
b <- coef(fit.int)
round(b[["finished"]] + c(0, b[paste0("finished:experience", 2:5)]), 2)

# Slide 42 (PDF p. 50): Plotting the Interaction
effects <- function(fit) {   # the effect of finishing at each experience level
  b <- coef(fit)
  extra <- b[paste0("finished:experience", 2:5)]   # extra effect at levels 2 to 5
  tibble(experience = 1:5, effect = b[["finished"]] + c(0, extra))
}
ggplot(effects(fit.int), aes(x = experience, y = effect)) + geom_line() + geom_point()

# The figure on the slide, with labels and colors. Larger text (base_size = 14) because the figure is small on
# the slide; theme_set(theme_gray()) after the figure puts the default back.
theme_set(theme_gray(base_size = 14))
base <- ggplot(mapping = aes(x = experience, y = effect)) +
  geom_hline(yintercept = 0, color = "grey50", linetype = "dashed") +
  scale_x_continuous(breaks = 1:5,   # x-axis labels 1 to 5, with words at the two ends
                     labels = c("1\nstrongly\nnegative", "2", "3", "4", "5\nstrongly\npositive")) +
  labs(x = "Experience of viewing the ad", y = "Finished minus unfinished\n(purchase intention, 1-5)")
p_int <- base +
  geom_line(data = effects(fit.int), color = Tsinghua_Purple, linewidth = 1) +
  geom_point(data = effects(fit.int), color = Tsinghua_Purple, size = 2.4)
p_int  # the slide figure is 6 x 3.6 inches
# ggsave("B08_jnm_interaction_gap.pdf", p_int, width = 6, height = 3.6)  # saves it at the slide's size
theme_set(theme_gray())   # back to the default text size


# Appendix --------------------------------------------------------------------------------------

# Appendix slide 1 (PDF p. 57): A Little Bias for Much Less Variance
# The table: 900 fixed test houses; 200 training sets of 40 houses drawn from the other houses.
# Spread = standard deviation of a test house's predicted price over the 200 training sets, averaged over the 900 houses.
# The loop also records whether lasso and elastic net keep garage cars and garage area (slide 24).
# It prints its progress every 20 training sets; the rank-deficient warning appears again at the end.
set.seed(2026)
n <- nrow(ames)
ev <- sample(n, 900)         # the 900 test houses
pool <- setdiff(1:n, ev)     # the other 2,004 houses: each training set comes from these

P_ls3 <- matrix(NA, 200, 900)   # 1. output: predicted prices, one row per training set and one column per test house
P_ls27 <- P_ls3; P_ridge <- P_ls3; P_lasso <- P_ls3; P_enet <- P_ls3
garage_l <- rep(NA, 200)        #    and how many of the two garage predictors lasso keeps
garage_e <- rep(NA, 200)        #    and elastic net keeps
for (r in 1:200) {              # 2. sequence
  i <- sample(pool, 40)         # 3. body: 40 training houses
  P_ls3[r, ] <- predict(lm(price ~ ., data = ames[i, c("price", few)]), ames[ev, ])
  P_ls27[r, ] <- predict(lm(price ~ ., data = ames[i, c("price", predictors)]), ames[ev, ])
  cl <- cv.glmnet(X[i, ], y[i], alpha = 1, nfolds = 5)
  cr <- cv.glmnet(X[i, ], y[i], alpha = 0, nfolds = 5)
  ce <- cv.glmnet(X[i, ], y[i], alpha = 0.5, nfolds = 5)
  P_lasso[r, ] <- predict(cl, X[ev, ], s = "lambda.min")
  P_ridge[r, ] <- predict(cr, X[ev, ], s = "lambda.min")
  P_enet[r, ] <- predict(ce, X[ev, ], s = "lambda.min")
  garage_l[r] <- sum(coef(cl, s = "lambda.min")[c("Garage Cars", "Garage Area"), ] != 0)
  garage_e[r] <- sum(coef(ce, s = "lambda.min")[c("Garage Cars", "Garage Area"), ] != 0)

  if (r %% 20 == 0) print(paste0("Completed ", r, "th iteration."))  # show progress every 20 training sets
}

# Our own function: for each test house, the standard deviation of its 200 predicted prices; then the average
spread_of <- function(P) {
  sds <- rep(NA, ncol(P))
  for (h in 1:ncol(P)) {
    sds[h] <- sqrt(mean((P[, h] - mean(P[, h]))^2))
  }
  mean(sds)
}
tibble(model = c("ls3", "ls27", "ridge", "lasso", "enet"),   # the table on the slide: spread in $1,000s, rounded to whole numbers
       spread = round(c(spread_of(P_ls3), spread_of(P_ls27), spread_of(P_ridge), spread_of(P_lasso), spread_of(P_enet))))
# The note on slide 24: in these 200 training sets, how often lasso kept only one of the two garage predictors
mean(garage_l == 1)   # share of training sets where lasso kept only one of the two

# Appendix slide 2 (PDF p. 58): Lasso for Controls: Use Double Selection
# Simulated data: 200 people, 50 candidate controls; the first 5 are confounders that drive the treatment T
# strongly and the outcome Y weakly; the true effect of T is 1. 500 simulated samples; lambda by 5-fold CV.
# It prints its progress every 50 samples.
n <- 200; p <- 50; k <- 5; tau <- 1
gamma <- c(rep(0.8, k), rep(0, p - k))   # confounders -> treatment (strong)
beta  <- c(rep(0.3, k), rep(0, p - k))   # confounders -> outcome (weak)

# Our own function: the columns of x that lasso keeps when it predicts y.
# penalty.factor = 0 for a column means that lasso never drops that column.
selected <- function(x, y, pf = rep(1, ncol(x))) {
  cv <- cv.glmnet(x, y, alpha = 1, nfolds = 5, penalty.factor = pf)
  b <- as.matrix(coef(cv, s = "lambda.min"))[-1, 1]   # the coefficients without the intercept
  which(b != 0)
}

res_dsel <- tibble(naive = rep(NA, 500), single = NA, double = NA,   # 1. output: one row per simulated sample
                   single_kept = NA, double_kept = NA)
set.seed(2026)
for (r in 1:500) {                                                   # 2. sequence
  W <- matrix(rnorm(n * p), n, p)                                    # 3. body: 50 candidate controls
  treat <- as.numeric(W %*% gamma) + rnorm(n)                        # T (%*% multiplies a matrix and a vector)
  outcome <- tau * treat + as.numeric(W %*% beta) + rnorm(n)         # Y

  # No controls
  est_naive <- coef(lm(outcome ~ treat))[["treat"]]

  # Single selection: lasso of Y on T and the 50 controls (T always stays), then Y on T and the kept controls
  s1 <- setdiff(selected(cbind(treat, W), outcome, pf = c(0, rep(1, p))), 1) - 1   # kept controls (column 1 was T)
  est_single <- est_naive
  if (length(s1) > 0) est_single <- coef(lm(outcome ~ treat + W[, s1]))[["treat"]]

  # Double selection: keep a control if lasso keeps it for Y or for T
  s_y <- selected(W, outcome)
  s_t <- selected(W, treat)
  s2 <- union(s_y, s_t)
  est_double <- est_naive
  if (length(s2) > 0) est_double <- coef(lm(outcome ~ treat + W[, s2]))[["treat"]]

  res_dsel$naive[r] <- est_naive
  res_dsel$single[r] <- est_single
  res_dsel$double[r] <- est_double
  res_dsel$single_kept[r] <- sum(s1 <= k)   # confounders (columns 1 to 5) kept by single selection
  res_dsel$double_kept[r] <- sum(s2 <= k)   # confounders kept by double selection

  if (r %% 50 == 0) print(paste0("Completed ", r, "th iteration."))  # show progress every 50 samples
}
res_dsel |> summarize(across(everything(), mean))   # averages over the 500 samples (the slide: 1.23, 0.98, about 1 of 5, all 5)

long_dsel <- res_dsel |>
  select(naive, single, double) |>
  pivot_longer(everything(), names_to = "method", values_to = "estimate") |>
  mutate(method = factor(method, levels = c("naive", "single", "double"),
                         labels = c("No controls", "Single selection:\nlasso on Y", "Double selection:\nlasso on Y and on T")))
p3 <- ggplot(long_dsel, aes(x = method, y = estimate, fill = method)) +
  geom_hline(yintercept = tau, linetype = "dashed", color = "grey30") +
  geom_violin(alpha = 0.5, color = NA) +   # violin: the shape of the 500 estimates
  geom_boxplot(width = 0.18, outlier.size = 0.4, fill = "white") +
  annotate("text", x = 0.5, y = tau, label = "true effect = 1", hjust = 0, vjust = -0.5, size = 3) +
  scale_fill_manual(values = c("grey60", "darkorange", "steelblue")) +
  labs(x = NULL, y = "Estimated treatment effect (500 simulated samples)") +
  theme(legend.position = "none")
p3  # the slide figure is 6 x 4 inches
# ggsave("B08_double_selection_sim.pdf", p3, width = 6, height = 4)  # saves it at the slide's size

# Appendix slide 3 (PDF p. 59): Ridge and Lasso: The Lowest SSR Within a Budget
# Two predictors of the 40 training houses (slide 15) as z-scores (PBA 5), as on slide 20. glmnet is loaded on slide 20.
# The price is a difference from its mean, so no intercept is needed.
house <- ames_train |>
  mutate(bath = (`Full Bath` - mean(`Full Bath`)) / sd(`Full Bath`),
         lot = (`Lot Area` - mean(`Lot Area`)) / sd(`Lot Area`),
         y = price - mean(price))
ssr_house <- function(b1, b2) sum((house$y - b1 * house$bath - b2 * house$lot)^2)   # SSR for one pair of coefficients

# Three fits of the same model. The two values of lambda are chosen for the picture.
X2 <- as.matrix(house[, c("bath", "lot")])                                        # glmnet() takes the predictors as a matrix
fit_ls <- lm(y ~ bath + lot, data = house)
fit_ridge <- glmnet(X2, house$y, alpha = 0, lambda = 66.7, standardize = FALSE)   # alpha = 0: ridge (slide 20)
fit_lasso <- glmnet(X2, house$y, alpha = 1, lambda = 27.5, standardize = FALSE)   # alpha = 1: lasso
least <- coef(fit_ls)[c("bath", "lot")]    # least squares: 53.9 and 25.7
ridge <- as.matrix(fit_ridge$beta)[, 1]    # ridge: 30.9 and 15.6 (fit$beta as a matrix: slide 20)
lasso <- as.matrix(fit_lasso$beta)[, 1]    # lasso: 27.8 and 0
budget_ridge <- sqrt(sum(ridge^2))   # 34.7: the size of the ridge coefficients (the root of the sum of their squares)
budget_lasso <- sum(abs(lasso))      # 27.8: the size of the lasso coefficients (the sum of their absolute values)

# SSR for many pairs of coefficients (the for loop of PBA 6)
coef_pairs <- tibble(b1 = rep(seq(-45, 105, by = 1), times = 121),    # 1. output: one row per pair (151 x 121 pairs)
                     b2 = rep(seq(-45, 75, by = 1), each = 151), ssr = NA)
for (i in 1:nrow(coef_pairs)) {                                       # 2. sequence
  coef_pairs$ssr[i] <- ssr_house(coef_pairs$b1[i], coef_pairs$b2[i])  # 3. body
}

# The edge of each budget: a circle for ridge, a diamond (four corners) for lasso.
angle <- seq(0, 2 * pi, length.out = 200)
circle <- tibble(b1 = budget_ridge * cos(angle), b2 = budget_ridge * sin(angle))
diamond <- tibble(b1 = c(budget_lasso, 0, -budget_lasso, 0), b2 = c(0, budget_lasso, 0, -budget_lasso))

# One picture per method: the budget, contours of SSR around least squares, and the contour through the ridge or lasso point.
budget_plot <- function(edge, best, shade, name) {
  ggplot(coef_pairs, aes(x = b1, y = b2)) +
    geom_hline(yintercept = 0, color = "grey60") + geom_vline(xintercept = 0, color = "grey60") +
    geom_polygon(data = edge, fill = shade, alpha = 0.2, color = shade) +     # geom_polygon(): a filled shape (the budget)
    geom_contour(aes(z = ssr), color = "grey60",                              # 7 contours of SSR around least squares
                 breaks = ssr_house(least[1], least[2]) + 1750 * c(1, 4, 9, 16, 25, 36, 49)) +
    geom_contour(aes(z = ssr), breaks = ssr_house(best[1], best[2]), color = "black", linewidth = 1) +   # the contour through the point
    annotate("point", x = least[1], y = least[2], shape = 21, fill = "white", size = 3) +   # white dot: least squares
    annotate("point", x = best[1], y = best[2], color = shade, size = 3) +                  # colored dot: ridge or lasso
    coord_fixed(xlim = c(-45, 105), ylim = c(-45, 75)) +   # coord_fixed(): one unit of b1 as long as one unit of b2 (a round circle)
    labs(x = "beta1: coefficient of full baths", y = "beta2: coefficient of lot area", title = name,
         subtitle = paste0("colored dot: (", round(best[1], 1), ", ", round(best[2], 1), ")"))
}
p_ridge <- budget_plot(circle, ridge, "#5f2167", "Ridge: the budget is a circle")
p_lasso <- budget_plot(diamond, lasso, "darkorange", "Lasso: the budget is a diamond")
p_ridge
p_lasso

# Appendix slide 4 (PDF p. 60): With the Height: A Wall Around the Budget
# For demonstration only (base R).
# The picture of appendix slide 3 with the height drawn: the bowl of SSR, and a wall on the edge of each budget.
# persp() makes an empty 3D view and trans3d() returns the place of a point in it (slide 8). polygon(), segments(), lines(),
# points(), arrows(), rect(), and text() then draw at those places. A later piece covers an earlier one, so the order is:
# floor, the piece of the bowl inside the wall, the wall, the lines of the bowl, the two points, the labels.

ssr_many <- function(b1, b2) {            # SSR for many pairs of coefficients: the for loop of PBA 6 inside a function
  out <- rep(NA, length(b1))              # 1. output
  for (i in 1:length(b1)) {               # 2. sequence
    out[i] <- ssr_house(b1[i], b2[i])     # 3. body
  }
  out
}
ssr_min <- ssr_house(least[1], least[2])  # SSR at the bottom of the bowl (least squares)

# The size of a pair of coefficients, as each method counts it. The budget is the largest size allowed.
size_ridge <- function(b1, b2) sqrt(b1^2 + b2^2)
size_lasso <- function(b1, b2) abs(b1) + abs(b2)

# The edge of each budget as 240 steps around (0, 0), with the SSR above each point: the wall is that high there.
turn <- seq(0, 2 * pi, length.out = 241)
edge_ridge <- tibble(b1 = budget_ridge * cos(turn) / size_ridge(cos(turn), sin(turn)),
                     b2 = budget_ridge * sin(turn) / size_ridge(cos(turn), sin(turn))) |>
  mutate(ssr = ssr_many(b1, b2))
edge_lasso <- tibble(b1 = budget_lasso * cos(turn) / size_lasso(cos(turn), sin(turn)),
                     b2 = budget_lasso * sin(turn) / size_lasso(cos(turn), sin(turn))) |>
  mutate(ssr = ssr_many(b1, b2))

# The bowl. SSR rises with the square of the distance from least squares. rise1 is the rise at distance 1 in each of the
# 240 directions, so in that direction SSR is ssr_min + rise at the distance sqrt(rise / rise1).
bowl_dir <- tibble(turn = turn) |>
  mutate(rise1 = ssr_many(least[1] + cos(turn), least[2] + sin(turn)) - ssr_min)
rise_top <- 1.08 * (max(edge_ridge$ssr) - ssr_min)   # the bowl is drawn a little higher than the round wall
ssr_floor <- ssr_min - 0.3 * rise_top                # the floor of the picture is below the bottom of the bowl
contour_at <- function(rise) {                       # the contour of the bowl where SSR is ssr_min + rise
  tibble(b1 = least[1] + sqrt(rise / bowl_dir$rise1) * cos(turn),
         b2 = least[2] + sqrt(rise / bowl_dir$rise1) * sin(turn), ssr = ssr_min + rise)
}
spoke <- function(j) {                               # the bowl from its bottom to its top in direction j
  share <- seq(0, 1, length.out = 61)
  tibble(b1 = least[1] + share * sqrt(rise_top / bowl_dir$rise1[j]) * cos(turn[j]),
         b2 = least[2] + share * sqrt(rise_top / bowl_dir$rise1[j]) * sin(turn[j]), ssr = ssr_min + share^2 * rise_top)
}
place <- function(d, view) trans3d(d$b1, d$b2, d$ssr, view)   # the places on the paper of the points in a table

wall_picture <- function(edge, size, budget, best, shade, mark, name, words) {
  shades <- colorRampPalette(c("white", shade))(100)   # 100 colors from white (1) to the color of this method (100)
  view <- persp(x = c(-38, 146), y = c(-80, 104), z = matrix(ssr_floor, 2, 2), zlim = c(ssr_floor, ssr_min + rise_top),
                theta = 66, phi = 40, expand = 0.64, d = 50, box = FALSE, border = NA, main = name, cex.main = 1)   # an empty view
  on_bowl <- function(d, col_in, col_out, lwd = 0.7) { # a curve on the bowl: one color inside the budget, another outside
    p <- place(d, view); n <- nrow(d)
    segments(p$x[-n], p$y[-n], p$x[-1], p$y[-1], lwd = lwd,
             col = if_else(size(d$b1[-n], d$b2[-n]) <= budget, col_in, col_out))
  }

  # 1. The floor: the window of appendix slide 3, with the lines b1 = 0 and b2 = 0, and an arrow for SSR.
  ground <- tibble(b1 = c(-45, 105, 105, -45), b2 = c(-45, -45, 75, 75), ssr = ssr_floor)
  polygon(place(ground, view), col = "grey97", border = "grey75")
  lines(place(tibble(b1 = c(-45, 105), b2 = 0, ssr = ssr_floor), view), col = "grey55")
  lines(place(tibble(b1 = 0, b2 = c(-45, 75), ssr = ssr_floor), view), col = "grey55")
  text(place(tibble(b1 = c(0, 50, 100), b2 = -54, ssr = ssr_floor), view), labels = c(0, 50, 100), cex = 0.65, col = "grey30")
  text(place(tibble(b1 = 114, b2 = c(0, 50), ssr = ssr_floor), view), labels = c(0, 50), cex = 0.65, col = "grey30")
  text(place(tibble(b1 = 22, b2 = -88, ssr = ssr_floor), view), labels = "beta1:\nfull baths", cex = 0.7)
  text(place(tibble(b1 = 153, b2 = 42, ssr = ssr_floor), view), labels = "beta2: lot area", cex = 0.7)
  up <- trans3d(-45, -45, c(ssr_floor, ssr_min + 1.03 * rise_top), view)
  arrows(up$x[1], up$y[1], up$x[2], up$y[2], length = 0.06, col = "grey35")
  text(up$x[2], up$y[2], "SSR", pos = 3, cex = 0.7)

  # 2. The piece of the bowl inside the wall, as small four-cornered pieces: lighter where SSR is lower.
  for (k in 1:12) {                                    # 12 bands from the middle of the budget to its edge
    inner <- edge |> mutate(b1 = b1 * (k - 1) / 12, b2 = b2 * (k - 1) / 12) |> mutate(ssr = ssr_many(b1, b2))
    outer <- edge |> mutate(b1 = b1 * k / 12, b2 = b2 * k / 12) |> mutate(ssr = ssr_many(b1, b2))
    p_in <- place(inner, view); p_out <- place(outer, view)
    tone <- round(16 + 30 * (outer$ssr - min(edge$ssr)) / (max(edge$ssr) - min(edge$ssr)))
    for (i in 1:240) {
      polygon(c(p_in$x[i], p_in$x[i + 1], p_out$x[i + 1], p_out$x[i]), c(p_in$y[i], p_in$y[i + 1], p_out$y[i + 1], p_out$y[i]),
              col = shades[tone[i]], border = shades[tone[i]])
    }
  }

  # 3. The wall: from the floor up to the bowl, only where it faces us (there its foot runs from left to right on the paper).
  foot <- place(edge |> mutate(ssr = ssr_floor), view); top <- place(edge, view)
  for (i in 1:240) {
    if (foot$x[i + 1] > foot$x[i]) {
      slope <- (foot$y[i + 1] - foot$y[i]) / sqrt((foot$x[i + 1] - foot$x[i])^2 + (foot$y[i + 1] - foot$y[i])^2)
      tone <- round(min(62, max(36, 47 - 17 * slope)))   # lighter where the wall turns to the right
      polygon(c(foot$x[i], foot$x[i + 1], top$x[i + 1], top$x[i]), c(foot$y[i], foot$y[i + 1], top$y[i + 1], top$y[i]),
              col = shades[tone], border = shades[tone])
      segments(foot$x[i], foot$y[i], foot$x[i + 1], foot$y[i + 1], col = shades[80])   # the foot of the wall
    }
  }
  lines(top, col = shades[95], lwd = 2)                  # the top of the wall: where it meets the bowl

  # 4. The lines of the bowl: 9 contours, evenly spaced in distance, and 24 spokes. The dark contour passes through ridge or lasso.
  for (k in 1:9) on_bowl(contour_at(rise_top * (k / 9)^2), shades[62], if_else(k == 9, "grey45", "grey70"))
  for (j in seq(10, 240, by = 10)) on_bowl(spoke(j), shades[62], "grey70")
  on_bowl(contour_at(ssr_house(best[1], best[2]) - ssr_min), "grey20", "grey20", lwd = 2)

  # 5. Least squares (white dot) and ridge or lasso (colored mark), each with a line straight down to the floor.
  p_least <- trans3d(least[1], least[2], c(ssr_floor, ssr_min), view)
  p_best <- trans3d(best[1], best[2], c(ssr_floor, ssr_house(best[1], best[2])), view)
  lines(p_least, lty = "dotted", col = "grey40"); points(p_least$x[1], p_least$y[1], pch = 4, cex = 0.6, col = "grey40")
  lines(p_best, lty = "dashed", col = shades[90])
  points(p_least$x[2], p_least$y[2], pch = 21, bg = "white", cex = 1.3, lwd = 1.6)
  points(p_best$x[2], p_best$y[2], pch = mark, col = "white", cex = 1.8)   # a white edge around the mark
  points(p_best$x[2], p_best$y[2], pch = mark, col = shade, cex = 1.4)

  # 6. The labels: words on a white box, with a thin line to the point.
  label <- function(x, y, to_x, to_y, words) {
    segments(x, y, to_x, to_y, col = "grey45")
    rect(x - 0.56 * strwidth(words, cex = 0.7), y - 0.9 * strheight(words, cex = 0.7),
         x + 0.56 * strwidth(words, cex = 0.7), y + 0.9 * strheight(words, cex = 0.7), col = "white", border = NA)
    text(x, y, words, cex = 0.7)
  }
  label(p_least$x[2] + 0.24, p_least$y[2] - 0.12, p_least$x[2], p_least$y[2], "least squares")
  label(p_best$x[2] + 0.34, p_best$y[2] + 0.27, p_best$x[2], p_best$y[2], words)
  points(p_least$x[2], p_least$y[2], pch = 21, bg = "white", cex = 1.3, lwd = 1.6)   # the two points again, on top of the lines
  points(p_best$x[2], p_best$y[2], pch = mark, col = "white", cex = 1.8)
  points(p_best$x[2], p_best$y[2], pch = mark, col = shade, cex = 1.4)
}
wall_picture(edge_ridge, size_ridge, budget_ridge, ridge, "#5f2167", 15, "Ridge: a round wall",
             paste0("ridge (", round(ridge[1], 1), ", ", round(ridge[2], 1), ")"))
wall_picture(edge_lasso, size_lasso, budget_lasso, lasso, "darkorange", 17, "Lasso: a wall with corners",
             paste0("lasso (", round(lasso[1], 1), ", ", round(lasso[2], 1), ")"))

# Appendix slide 5 (PDF p. 61): From the Side: The Lowest Point Is at the Wall
# SSR (in thousands) along the straight line from (0, 0) through the ridge point. Position t on that line is the pair
# (t * d[1], t * d[2]).
d <- ridge / budget_ridge                                              # the direction of the line
side <- tibble(t = seq(-41, 97, by = 0.5), ssr = NA)                   # 1. output: one row per position
for (i in 1:nrow(side)) {                                              # 2. sequence
  side$ssr[i] <- ssr_house(side$t[i] * d[1], side$t[i] * d[2]) / 1000  # 3. body
}
rim <- tibble(t = c(-budget_ridge, budget_ridge),                      # the two places where the wall meets the bowl
              ssr = c(ssr_house(-ridge[1], -ridge[2]), ssr_house(ridge[1], ridge[2])) / 1000)
top <- bind_rows(side |> filter(t > -budget_ridge, t < budget_ridge), rim) |>
  arrange(t)                                                           # the bowl between the walls: the top of the piece
piece <- bind_rows(tibble(t = -budget_ridge, ssr = 50), top, tibble(t = budget_ridge, ssr = 50))   # the piece, down to the floor (50)
bottom <- side |> slice_min(ssr)                                       # the bottom of the bowl on this line

# The labels: where the words go (t, ssr) and the point that each label names (to_t, to_ssr).
notes <- tibble(words = c("the top of the piece:\nthe bowl itself", "a flat cut through the rim",
                          "ridge: the lowest point\nof the top", "the bottom of the bowl\nis outside the wall"),
                t = c(58, 62, 76, 80), ssr = c(490, 380, 280, 105),
                to_t = c(-6, 12, budget_ridge, bottom$t),
                to_ssr = c(ssr_house(-6 * d[1], -6 * d[2]) / 1000,                           # on the bowl
                           mean(rim$ssr) + 12 * (rim$ssr[2] - rim$ssr[1]) / (2 * budget_ridge),   # on the flat cut
                           rim$ssr[2], bottom$ssr))
p_side <- ggplot(side, aes(x = t, y = ssr)) +
  geom_polygon(data = piece, fill = "#5f2167", alpha = 0.12) +                    # the piece inside the wall
  geom_line(color = "grey50") +                                                   # the bowl of SSR, cut along that line
  geom_line(data = rim, linetype = "dashed") +                                    # a flat cut through the two rim points
  geom_line(data = top, color = "#5f2167", linewidth = 1.5) +                     # the top of the piece: the bowl itself
  geom_segment(data = rim, aes(xend = t, yend = 50), color = "#5f2167") +         # the wall: straight up from the edge of the budget
  annotate("segment", x = -budget_ridge, xend = budget_ridge, y = 54, yend = 54, color = "#5f2167", linewidth = 2.5) +   # the budget
  annotate("segment", x = -budget_ridge, xend = budget_ridge, y = 150, yend = 150, color = "grey50") +
  annotate("label", x = 0, y = 150, label = "the wall: straight up from\nthe edge of the budget", size = 3, linewidth = 0) +
  annotate("text", x = 0, y = 80, label = "the budget", size = 3, color = "#5f2167") +
  geom_segment(data = notes, aes(xend = to_t, yend = to_ssr), color = "grey50") +   # a thin line from each label to its point
  geom_label(data = notes, aes(label = words), size = 3, linewidth = 0) +           # geom_label(): geom_text() on a white box
  geom_point(data = rim |> filter(t > 0), shape = 15, color = "#5f2167", size = 3) +    # ridge
  geom_point(data = bottom, shape = 21, fill = "white", size = 3) +                     # the bottom of the bowl
  scale_x_continuous(breaks = c(-budget_ridge, 0, budget_ridge), labels = round(c(-budget_ridge, 0, budget_ridge), 1)) +
  coord_cartesian(xlim = c(-60, 104), ylim = c(50, 580), expand = FALSE) +
  labs(x = "Position on the line from (0, 0) through the ridge point", y = "SSR (thousands)")
p_side

# Appendix slide 6 (PDF p. 62): Compare by Assignment, Not by Choice
share <- mean(bli$finished[bli$treat_ind == 1])                  # share of slider visits that finished
itt <- coef(lm(purchase ~ treat_ind, data = bli))[["treat_ind"]]   # effect of assignment (slide 29)
round(c(share = share, itt = itt, finishing = itt / share), 5)     # effect of finishing = itt / share

# Appendix slide 7 (PDF p. 63): Difference-in-Differences as a Regression
minwage <- as_tibble(read.csv(url("https://bit.ly/3QZmodH")))   # same data as before
long <- minwage |>
    mutate(id = 1:n(), nj = if_else(location == "PA", 0, 1),
           fte_before = fullBefore + 0.5 * partBefore,
           fte_after = fullAfter + 0.5 * partAfter) |>
    pivot_longer(c(fte_before, fte_after), names_to = "period", values_to = "fte") |>
    mutate(post = if_else(period == "fte_after", 1, 0))
lm(fte ~ nj * post, data = long) |> coef() |> round(2)   # nj * post: nj + post + nj:post

# Appendix slide 8 (PDF p. 64): Two-Way Fixed Effects
fit.twfe <- lm(fte ~ nj:post + post + factor(id), data = long)
coef(fit.twfe)[c("post", "nj:post")] |> round(2)
n_distinct(long$id)   # number of restaurants: factor(id) adds one binary variable for each restaurant but the first
