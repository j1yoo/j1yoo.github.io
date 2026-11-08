# PBA 8. More on Regression (Fall 2026)
# Run selected lines in order in RStudio. "PDF p." is the page of the 60-page slides; "slide" is the number at the bottom right.
# Packages used today: tidyverse (readr, dplyr, tidyr, ggplot2), broom, modelr, glmnet, ggrepel, and pbadata.
# The UT Austin course evaluations, the Ames house prices, and the minimum wage data are read from the web.
# The ad study data (bli_experiment, bli_ads, bli_survey) are in the course data package pbadata (0.6.0 or later).
# Update pbadata once with the line below (restart R first if pbadata is loaded):
# install.packages("pbadata", type = "source", repos = "https://j1yoo.github.io/assets/courses/pba")
# evals and minwage are also in pbadata: if a download fails, run library(pbadata) instead of the line that reads them.
# If modelr, glmnet, or ggrepel is not installed yet, run this line once: install.packages(c("modelr", "glmnet", "ggrepel"))
#
# The script has four parts, like the slides. RStudio lists them in the outline of the script.
# A model fit many times uses the for loop from PBA 6 (Prediction and Iteration): 1. output, 2. sequence, 3. body.
# Four loops take a while. On a Mac Studio (M1 Ultra): PDF p. 21 about 10 seconds, p. 22 about 1 minute,
# p. 25 about 10 seconds, and p. 30 about 20 seconds. Slower computers may take two or three times as long.
# The target picture on PDF p. 25 and the ad pictures on pp. 33-34 are images, not data.

library(tidyverse)


# Part 1. Multiple Regression -------------------------------------------------------------------

# PDF p. 8 (slide 5): UT Austin Student Eval. Data
# Don't forget to load tidyverse and ggplot2!
evals <- read_csv("https://bit.ly/46rSa7s"); evals

# PDF p. 10 (slide 7): Multiple Regression in R
eval_cnt <- evals |> # Center the variables for better interpretation of the intercept
    mutate(bty_cnt = bty_avg - mean(bty_avg),
           age_cnt = age - mean(age))
mult.fit.cnt <- lm(score ~ bty_cnt + age_cnt, data = eval_cnt); mult.fit.cnt
mean(evals$bty_avg); mean(evals$age)   # the means on the slide (4.42 and 48.4): the intercept is the score at these values

# PDF p. 13 (slide 10): Comparing Model Fits
fit.bty <- lm(score ~ bty_avg, data = evals)   # the beauty score model from Week 9
library(broom)
fit.bty |>
    glance() |>
    select(r.squared, adj.r.squared)

mult.fit.cnt |>
    glance() |>
    select(r.squared, adj.r.squared)

# PDF p. 14 (slide 11): Predicted Values from R
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

# PDF p. 15 (slide 12): Predictions from Several Models
evals_26 |>
    filter(ID == 464) |>
    gather_predictions(fit.bty, mult.fit)

# PDF p. 16 (slide 13): Predictions from New Data
tibble(bty_avg = c(2.5, 4.5), age = 36) |>
    gather_predictions(fit.bty, mult.fit)

new_data <- tibble(bty_avg = c(2.5, 4.5), age = 36)
augment(mult.fit, newdata = new_data)


# Part 2. Many Predictors: Ridge, Lasso, and Elastic Net ----------------------------------------

# PDF p. 19 (slide 15): Ames Housing Data in R
# predictors: the 27 numeric features of the Ames data (size, quality, year built, rooms, garage, and more)
predictors <- c("Lot Area", "Overall Qual", "Overall Cond", "Year Built", "Year Remod/Add", "Mas Vnr Area",
                "Total Bsmt SF", "Gr Liv Area", "Bsmt Full Bath", "Bsmt Half Bath", "Full Bath", "Half Bath",
                "Bedroom AbvGr", "Kitchen AbvGr", "TotRms AbvGrd", "Fireplaces", "Garage Cars", "Garage Area",
                "Wood Deck SF", "Open Porch SF", "Enclosed Porch", "3Ssn Porch", "Screen Porch", "Pool Area",
                "Misc Val", "Mo Sold", "Yr Sold")

# read_tsv() reads a tab-separated file, as read_csv() reads a comma-separated one.
# all_of(predictors) selects the columns whose names are in predictors.
ames <- read_tsv("https://jse.amstat.org/v19n3/decock/AmesHousing.txt") |>
    select(SalePrice, all_of(predictors)) |>   # predictors: 27 numeric features (R script)
    drop_na() |>                                # 2,904 sales with complete records
    mutate(price = SalePrice / 1000)            # sale price in $1,000s
ames |> select(price, `Gr Liv Area`, `Overall Qual`, `Year Built`, `Garage Cars`) |>
    head(3)
nrow(ames)          # sales with all 27 features (2,930 sales in the file)
median(ames$price)  # the median sale price in the table on PDF p. 18

# set.seed() makes the random draws the same every time; sample(n, 40) draws 40 of the row numbers 1 to n.
set.seed(2026)
train <- sample(nrow(ames), 40)                          # 40 training houses
ames_train <- ames[train, ]; ames_test <- ames[-train, ]  # test: the other 2,864 houses
nrow(ames_test)   # 2,864 test houses

# PDF p. 20 (slide 16): More Columns from One Predictor: Powers of x
# poly(x, 10) makes the columns x, x^2, ..., x^10 (rescaled so that R can compute them accurately).
lm(price ~ poly(`Gr Liv Area`, 10), data = ames_train)   # the degree-10 fit on the slide

# The figure: fits of degree 1, 2, and 10 to the same 40 training houses (purple); grey: the test houses.
# Test RMSE uses the 2,748 test houses inside the living-area range of the training houses.
Tsinghua_Purple <- "#5f2167"  # Hex code for Tsinghua Purple
rmse <- function(y, yhat) sqrt(mean((y - yhat)^2))   # root mean squared error (Week 9)

set.seed(2026); i <- sample(nrow(ames), 40)   # the same 40 training houses as on PDF p. 19
area <- ames$`Gr Liv Area`; y <- ames$price
tr <- tibble(area = area[i], price = y[i])     # training houses
te <- tibble(area = area[-i], price = y[-i])   # test houses
inside <- te$area >= min(tr$area) & te$area <= max(tr$area)   # TRUE: inside the living-area range of the training houses
sum(inside)                                                    # 2,748 test houses
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

# Two notes in the degree-10 panel: a shaded band with no training house, and how low the curve falls
gap <- sort(tr$area)[1:2]   # the smallest training house and the next: no training house between them
band <- tibble(panel = lab$panel[3], xmin = gap[1], xmax = gap[2])
lowest <- round(min(curves$pred))   # the lowest predicted price on the curves
notes <- tibble(panel = lab$panel[3],
                area = c(mean(gap), 530), price = c(560, -50),   # second label sits between the curve's exit and return
                label = c("no training\nhouse here",
                          paste0("falls to\n", format(lowest, big.mark = ","))))   # format(): writes 1234 as 1,234

p <- ggplot() +
  geom_rect(data = band, aes(xmin = xmin, xmax = xmax, ymin = -Inf, ymax = Inf),   # the shaded band
            fill = Tsinghua_Purple, alpha = 0.08) +
  geom_point(data = te, aes(area, price), color = "grey80", size = 0.4) +          # no panel column: drawn in every panel
  geom_point(data = tr, aes(area, price), color = Tsinghua_Purple, size = 1.4) +
  geom_line(data = curves, aes(area, pred), color = "darkorange", linewidth = 0.9) +
  geom_text(data = notes, aes(area, price, label = label),
            size = 2.6, color = c(Tsinghua_Purple, "darkorange"), lineheight = 0.9) +
  facet_wrap(~ panel, nrow = 1) +
  coord_cartesian(xlim = c(min(tr$area), max(tr$area)), ylim = c(-100, 650)) +   # zoom in: points outside are hidden, not dropped
  labs(x = "Living area (square feet)", y = "Sale price ($1,000s)")
p  # the slide figure is 8 x 2.9 inches: widen the Plots pane (wide and short) to see the same shape
# ggsave("B08_poly_degrees_gap.pdf", p, width = 8, height = 2.9)  # saves it at the slide's size

# PDF p. 21 (slide 17): Too Many Predictors
rmse <- function(y, yhat) sqrt(mean((y - yhat)^2))   # root mean squared error (Week 9)
few <- c("Gr Liv Area", "Overall Qual", "Year Built")
fit_few <- lm(price ~ ., data = ames_train[, c("price", few)])         # 3 predictors
fit_all <- lm(price ~ ., data = ames_train[, c("price", predictors)])  # all 27 predictors
rmse(ames_test$price, predict(fit_all, ames_test))   # test RMSE (R script: 200 samples)
# R warns "prediction from rank-deficient fit": some predictors (Pool Area, for example) are 0 for all 40
# training houses, so lm() cannot estimate their coefficients (NA in coef(fit_all)) and predicts without them.

# The table: the same two fits for 200 random samples of 40 training houses (medians over the 200 samples).
# The same loop also fits lasso, ridge, and elastic net for the lower table on PDF p. 27.
# It prints its progress every 20 samples; the warning above appears again at the end.
library(glmnet)   # install.packages("glmnet") once
X <- as.matrix(ames[, predictors])   # glmnet() takes the predictors as a matrix (PDF p. 27)
y <- ames$price

res <- tibble(few_train = rep(NA, 200), few_test = NA,       # 1. output: one row per sample
              all_train = NA, all_test = NA,
              lasso_test = NA, ridge_test = NA, enet_test = NA)
set.seed(2026)
for (r in 1:200) {                                            # 2. sequence
  i <- sample(nrow(ames), 40)                                 # 3. body: 40 training houses
  fit_few <- lm(price ~ ., data = ames[i, c("price", few)])
  fit_all <- lm(price ~ ., data = ames[i, c("price", predictors)])
  cv_l <- cv.glmnet(X[i, ], y[i], alpha = 1, nfolds = 5)      # lasso (PDF p. 27)
  cv_r <- cv.glmnet(X[i, ], y[i], alpha = 0, nfolds = 5)      # ridge
  cv_e <- cv.glmnet(X[i, ], y[i], alpha = 0.5, nfolds = 5)    # elastic net

  res$few_train[r] <- rmse(y[i], predict(fit_few))            # predict() without new data: the training houses
  res$few_test[r] <- rmse(y[-i], predict(fit_few, ames[-i, ]))
  res$all_train[r] <- rmse(y[i], predict(fit_all))
  res$all_test[r] <- rmse(y[-i], predict(fit_all, ames[-i, ]))
  res$lasso_test[r] <- rmse(y[-i], predict(cv_l, X[-i, ], s = "lambda.min"))
  res$ridge_test[r] <- rmse(y[-i], predict(cv_r, X[-i, ], s = "lambda.min"))
  res$enet_test[r] <- rmse(y[-i], predict(cv_e, X[-i, ], s = "lambda.min"))

  if (r %% 20 == 0) print(paste0("Completed ", r, "th iteration."))  # show progress every 20 samples
}
res |> summarize(across(few_train:all_test, median))   # the table on the slide: medians over the 200 samples

# PDF p. 22 (slide 18): What If We Add Hundreds of Columns?
# 378 columns: the 27 predictors and the product of every pair of them (351 products).
# In a formula, .^2 means every predictor plus every product of two predictors (an interaction, PDF p. 49).
# 200 random splits: 2,323 training houses (80% of 2,904) and 581 test houses.
# It prints its progress every 20 splits. R warns "prediction from rank-deficient fit": some products are 0 for
# every training house, so lm() leaves them out.
ames27 <- ames |> select(price, all_of(predictors))
ncol(model.matrix(price ~ .^2, data = ames27)) - 1   # 378 columns (model.matrix: PDF p. 46), not counting the intercept

res378 <- tibble(ls27_train = rep(NA, 200), ls27_test = NA,   # 1. output: one row per split
                 ls378_train = NA, ls378_test = NA)
set.seed(2026)
for (r in 1:200) {                                            # 2. sequence
  tr <- sample(nrow(ames27), 2323)                            # 3. body: 80% of the houses for training
  fit27 <- lm(price ~ ., data = ames27[tr, ])                 # 27 predictors
  fit378 <- lm(price ~ .^2, data = ames27[tr, ])              # 378 columns

  res378$ls27_train[r] <- rmse(ames27$price[tr], predict(fit27))
  res378$ls27_test[r] <- rmse(ames27$price[-tr], predict(fit27, ames27[-tr, ]))
  res378$ls378_train[r] <- rmse(ames27$price[tr], predict(fit378))
  res378$ls378_test[r] <- rmse(ames27$price[-tr], predict(fit378, ames27[-tr, ]))

  if (r %% 20 == 0) print(paste0("Completed ", r, "th iteration."))  # show progress every 20 splits
}
res378 |> summarize(across(everything(), median))   # the table: medians over the 200 splits
sum(res378$ls378_test > res378$ls27_test)          # splits where the 378 columns did worse on the test houses
max(res378$ls378_test)                             # test RMSE in the worst split

# PDF p. 24 (slide 20): Ridge vs. Lasso
# The figure: ridge and lasso coefficients for 8 predictors as lambda grows (all 2,904 houses).
# Each predictor becomes a z-score (PBA 5): mean 0 and standard deviation 1, so the 8 are on the same scale.
# glmnet() fits the model for 100 values of lambda at once; alpha = 0 is ridge and alpha = 1 is lasso.
library(ggrepel)   # install.packages("ggrepel") once: labels that do not overlap
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
  labs(x = "log(lambda): a higher price for large coefficients to the right", y = "Coefficient (same scale)") +
  theme(legend.position = "none")
p1  # the slide figure is 8 x 3.6 inches: widen the Plots pane (wide and short) to see the same shape
# ggsave("B08_coef_paths.pdf", p1, width = 8, height = 3.6)  # saves it at the slide's size

# PDF p. 25 (slide 21): Why the Price Helps: Bias and Variance
# The table: 900 fixed test houses; 200 training sets of 40 houses drawn from the other houses.
# Spread = standard deviation of a test house's predicted price over the 200 training sets, averaged over the 900 houses.
# The loop also records whether lasso and elastic net keep garage cars and garage area (PDF p. 27).
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
tibble(method = c("ls3", "ls27", "ridge", "lasso", "enet"),   # the table on the slide: $1,000s, rounded to whole numbers
       mean_sd = round(c(spread_of(P_ls3), spread_of(P_ls27), spread_of(P_ridge), spread_of(P_lasso), spread_of(P_enet))))

# PDF p. 26 (slide 22): Choosing lambda: Cross-Validation
# The figure: 5-fold cross-validation for lasso with the 40 training houses of PDF p. 19
set.seed(2026)
i <- sample(nrow(ames), 40)
cv <- cv.glmnet(X[i, ], y[i], alpha = 1, nfolds = 5)
cv$lambda.min                              # the chosen lambda
sum(coef(cv, s = "lambda.min")[-1] != 0)   # number of predictors the chosen lasso keeps

cvd <- tibble(log_lambda = log(cv$lambda), rmse = sqrt(cv$cvm))   # cvm: the average test MSE over the 5 folds
p2 <- ggplot(cvd, aes(x = log_lambda, y = rmse)) +
  geom_line(color = "darkorange", linewidth = 1) +
  geom_point(color = "darkorange", size = 1) +
  geom_vline(xintercept = log(cv$lambda.min), linetype = "dashed", color = Tsinghua_Purple) +
  annotate("text", x = log(cv$lambda.min), y = max(cvd$rmse), label = "lowest average test error",
           hjust = -0.05, vjust = 1, size = 3, color = Tsinghua_Purple) +
  annotate("text", x = min(cvd$log_lambda), y = min(cvd$rmse), label = "small lambda:\nhigh variance",
           hjust = 0, vjust = 0, size = 3, color = "grey30") +
  annotate("text", x = max(cvd$log_lambda), y = min(cvd$rmse), label = "large lambda:\nhigh bias",
           hjust = 1, vjust = 0, size = 3, color = "grey30") +
  labs(x = "log(lambda)", y = "Test RMSE from 5-fold CV ($1,000s)")
p2  # the slide figure is 6 x 3.8 inches
# ggsave("B08_cv_lasso.pdf", p2, width = 6, height = 3.8)  # saves it at the slide's size

# PDF p. 27 (slide 23): Ridge, Lasso, and Elastic Net in R
set.seed(2026); train <- sample(nrow(ames), 40)   # the seed again, so cv.glmnet() draws the same 5 folds as on PDF p. 26
library(glmnet)   # install.packages("glmnet") once
# ames_train, ames_test, predictors: made in today's R script
x <- as.matrix(ames_train[, predictors])   # the 27 predictors
# alpha = 1: lasso; alpha = 0: ridge; alpha = 0.5: elastic net
cv <- cv.glmnet(x, ames_train$price, alpha = 1, nfolds = 5)   # 5 folds (default: 10)
coef(cv, s = "lambda.min")   # coefficients at the chosen lambda
x_test <- as.matrix(ames_test[, predictors])
predict(cv, newx = x_test, s = "lambda.min")   # 2,864 predicted prices: add |> head() to see only the first six

# The table: medians over the 200 samples of PDF p. 21 (res)
res |> summarize(across(c(all_test, lasso_test, ridge_test, enet_test), median))

# Garage cars and garage area in the 200 training sets of PDF p. 25
mean(garage_l == 1)   # share of training sets where lasso kept only one of the two
mean(garage_e == 2)   # elastic net kept both
mean(garage_l == 2)   # lasso kept both

# PDF p. 28 (slide 24): What Price Does Each Model Predict?
# Five models fit to the same 40 training houses as on PDF p. 19, and their predicted prices for three test houses.
# foldid: the 5 folds that cv.glmnet(..., nfolds = 5) drew on PDF p. 26, written out so that
# all three penalized models use the same folds (the lasso is then the same as on PDF p. 26).
set.seed(2026)
i <- sample(nrow(ames), 40)
foldid <- sample(rep(seq(5), length = 40))
ls3 <- lm(price ~ ., data = ames[i, c("price", few)])
ls27 <- lm(price ~ ., data = ames[i, c("price", predictors)])
cv_l <- cv.glmnet(X[i, ], y[i], alpha = 1, foldid = foldid)
cv_r <- cv.glmnet(X[i, ], y[i], alpha = 0, foldid = foldid)
cv_e <- cv.glmnet(X[i, ], y[i], alpha = 0.5, foldid = foldid)

te <- setdiff(1:nrow(ames), i)   # the 2,864 test houses
pred <- tibble(row = te, actual = y[te],
               ls3 = predict(ls3, ames[te, ]),
               ls27 = predict(ls27, ames[te, ]),
               lasso = as.numeric(predict(cv_l, X[te, ], s = "lambda.min")),
               ridge = as.numeric(predict(cv_r, X[te, ], s = "lambda.min")),
               enet = as.numeric(predict(cv_e, X[te, ], s = "lambda.min")))

# Three test houses: the first house at the 10th, 50th, and 90th percentiles of price.
# quantile(..., type = 1) returns prices that occur in the data.
q <- quantile(pred$actual, c(.1, .5, .9), type = 1)
pick <- rep(NA, 3)
for (j in 1:3) {
  pick[j] <- which(pred$actual == q[j])[1]
}
houses <- pred[pick, ] |>
  mutate(house = c("A", "B", "C"), pct = names(q),
         area = ames$`Gr Liv Area`[row], quality = ames$`Overall Qual`[row], built = ames$`Year Built`[row])
houses |>   # the table on the slide: one column per house; prices in $1,000s, rounded
  select(house, area, quality, built, actual, ls3, ls27, lasso, ridge, enet) |>
  mutate(across(actual:enet, ~ round(.x))) |>
  pivot_longer(area:enet, names_to = "row", values_to = "value") |>
  pivot_wider(names_from = house, values_from = value)

# PDF p. 30 (slide 26): When Lasso Chooses Controls: Double Selection
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


# Part 3. Categorical Predictors and an Experiment ----------------------------------------------

# PDF p. 35 (slide 30): Ad Experiment Data (Synthetic)
# today's data are in the course data package pbadata (update it once: see the top of the R script)
library(pbadata)
bli <- bli_experiment   # one row per customer visit: 4,000 synthetic customers, 76 days
bli |> head()

# PDF p. 36 (slide 31): Linear Regression for Experimental Data
bli |>
    group_by(treat_ind) |>
    summarize(purchase = mean(purchase)) |>
    pivot_wider(names_from = treat_ind, values_from = purchase) |>
    mutate(ITT = `1` - `0`)

lm(purchase ~ treat_ind, data = bli) |> coef() |> round(5)

# PDF p. 37 (slide 32): Who Finishes the Ad?
bli |>
    filter(treat_ind == 1) |>
    group_by(finished) |>
    summarize(n = n(), purchase = mean(purchase))

# PDF p. 38 (slide 33): Compare by Assignment, Not by Choice
share <- mean(bli$finished[bli$treat_ind == 1])                  # share of slider visits that finished
itt <- coef(lm(purchase ~ treat_ind, data = bli))[["treat_ind"]]   # effect of assignment (PDF p. 36)
round(c(share = share, itt = itt, finishing = itt / share), 5)     # effect of finishing = itt / share

# PDF p. 40 (slide 35): Ad Data: 74 Slider Ads
bli_ads |> select(ad, completion, first_chars, late_chars, late_color, middle_face) |> head()
c(min(bli_ads$completion), max(bli_ads$completion))       # completion across the 74 ads (PDF p. 39)
c(min(bli_ads$total_slides), max(bli_ads$total_slides))   # number of panels (PDF p. 33)
median(bli_ads$total_slides)                              # the median number of panels

# PDF p. 41 (slide 36): Regression on 74 Ads: Do the Signs Match?
ads <- bli_ads |>  # completion: % of views that reached the last panel
    # z-scores of the 13 continuous features (1 = one standard deviation); middle_face stays 1 or 0
    mutate(across(total_slides:late_story, ~ (.x - mean(.x)) / sd(.x)))
lm(completion ~ first_chars + late_chars + late_color + middle_face, data = ads) |>
    coef() |> round(3)

# PDF p. 42 (slide 37): The Survey Data
survey <- bli_survey   # one row per participant and ad
survey |> head()
n_distinct(survey$person)   # number of participants

# PDF p. 45 (slide 40): Regression with Categorical Variables
survey <- survey |>   # levels 1 to 5; level 1 (strongly negative) is the baseline
    mutate(experience = factor(experience))

fit.exp <- lm(purchase_intent ~ experience, data = survey); fit.exp

# PDF p. 46 (slide 41): What R Does Internally w/ Factors in lm()
survey |> select(experience) |> pull() |> head()

model.matrix(fit.exp) |> head()

# PDF p. 47 (slide 42): Back to the Experiment: Book Dummies as Controls
lm(purchase ~ treat_ind + factor(book), data = bli) |> coef() |> head(2) |> round(5)
n_distinct(bli$book)   # number of books: factor(book) adds one binary variable for each book but the first


# Part 4. Interactions --------------------------------------------------------------------------

# PDF p. 50 (slide 44): Finishing x Experience in R
fit.int <- lm(purchase_intent ~ finished * experience + genre_match +
                  factor(person) + factor(book), data = survey)
coef(fit.int)[c("finished", paste0("finished:experience", 2:5))] |> round(3)

# The table: the gap between finished and unfinished ads at experience level k = finished + finished:experience k
b <- coef(fit.int)
round(b[["finished"]] + c(0, b[paste0("finished:experience", 2:5)]), 2)

# PDF p. 51 (slide 45): Plotting the Interaction
effects <- function(fit) {   # the effect of finishing at each experience level
  b <- coef(fit)
  extra <- b[paste0("finished:experience", 2:5)]   # extra effect at levels 2 to 5
  tibble(experience = 1:5, effect = b[["finished"]] + c(0, extra))
}
ggplot(effects(fit.int), aes(x = experience, y = effect)) + geom_line() + geom_point()

# The figure on the slide, with labels and colors. Larger text (base_size = 14) because the figure is small on
# the slide; theme_set() keeps it for the next figure too.
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

# PDF p. 52 (slide 46): Comparing Within the Same Person
fit.raw <- lm(purchase_intent ~ finished *
                experience + genre_match,
                data = survey)   # no dummies
effects(fit.raw)   # the orange line

# The figure on the slide: the gap with and without person and book dummies
eff <- bind_rows(effects(fit.int) |> mutate(model = "With person and book dummies"),
                 effects(fit.raw) |> mutate(model = "Without dummies"))
p_wp <- base +
  geom_line(data = eff, aes(color = model, group = model), linewidth = 1) +
  geom_point(data = eff, aes(color = model), size = 2.4) +
  scale_color_manual(values = c("With person and book dummies" = Tsinghua_Purple,   # the two line colors
                                "Without dummies" = "darkorange")) +
  labs(color = NULL) +
  theme(legend.position = "top")
p_wp  # the slide figure is 6 x 3.8 inches
# ggsave("B08_jnm_within_person_gap.pdf", p_wp, width = 6, height = 3.8)  # saves it at the slide's size
theme_set(theme_gray())   # back to the default text size

# PDF p. 53 (slide 47): Difference-in-Differences as a Regression
minwage <- as_tibble(read.csv(url("https://bit.ly/3QZmodH")))   # same data as before
long <- minwage |>
    mutate(id = 1:n(), nj = if_else(location == "PA", 0, 1),
           fte_before = fullBefore + 0.5 * partBefore,
           fte_after = fullAfter + 0.5 * partAfter) |>
    pivot_longer(c(fte_before, fte_after), names_to = "period", values_to = "fte") |>
    mutate(post = if_else(period == "fte_after", 1, 0))
lm(fte ~ nj * post, data = long) |> coef() |> round(2)

# PDF p. 54 (slide 48): Two-Way Fixed Effects
fit.twfe <- lm(fte ~ nj:post + post + factor(id), data = long)
coef(fit.twfe)[c("post", "nj:post")] |> round(2)
n_distinct(long$id)   # number of restaurants: factor(id) adds one binary variable for each restaurant but the first
