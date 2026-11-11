# PBA 9. More on Regression (Fall 2026)
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
# A model fit many times uses the for loop from PBA 7 (Prediction and Iteration): 1. output, 2. sequence, 3. body.
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

# Slide 10 (PDF p. 13): Comparing Model Fits
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

# Slide 11 (PDF p. 14): Predicted Values from R
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

# Slide 12 (PDF p. 15): Predictions from Several Models
evals_26 |>
    filter(ID == 464) |>
    gather_predictions(fit.bty, mult.fit)

# Slide 13 (PDF p. 16): Predictions from New Data
tibble(bty_avg = c(2.5, 4.5), age = 36) |>
    gather_predictions(fit.bty, mult.fit)

# The last line of the slide: the coefficient that the random ages got on slide 10.
coef(fit.rand) |> round(4)   # the last one, for sample(age), is 0.0017: not 0


# Part 2. Many Predictors: Ridge, Lasso, and Elastic Net ----------------------------------------

# Slide 15 (PDF p. 19): Ames Data in R: 40 Training Houses
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

# Slide 16 (PDF p. 20): Polynomial Regression Can Overfit
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

# Slide 17 (PDF p. 21): Few Houses: 27 Predictors Overfit
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

# Slide 18 (PDF p. 22): Too Many Columns, Even with Many Houses
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

# Slide 19 (PDF p. 23): Penalized Regression: Penalty on Large Coefficients
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

# Slide 20 (PDF p. 24): Ridge Shrinks; Lasso Sets Some to Zero
# The figure: ridge and lasso coefficients for 8 predictors as lambda grows (all 2,904 houses).
# Each predictor becomes a z-score (PBA 6): mean 0 and standard deviation 1, so the 8 are on the same scale.
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

# Slide 21 (PDF p. 25): Choosing lambda: Cross-Validation
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

# Slide 22 (PDF p. 26): In R: Penalized Models Predict Better
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

# Slide 23 (PDF p. 27): Three Test Houses: Which Model Predicts Closer?
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

# Slide 24 (PDF p. 28): Careful: Lasso Picks Predictors, Not Causes
# Garage cars and garage area carry almost the same information:
cor(ames$`Garage Cars`, ames$`Garage Area`)   # correlation 0.89
# The 60% on the slide comes from the loop of appendix slide 1 at the end of this script.


# Part 3. Categorical Predictors and an Experiment ----------------------------------------------

# Slide 28 (PDF p. 33): Ad Experiment Data (Synthetic)
# today's data are in the course data package pbadata (update it once: see the top of the R script)
library(pbadata)
bli <- bli_experiment   # one row per customer visit: 4,000 synthetic customers, 76 days
bli |> head()

# Slide 29 (PDF p. 34): Linear Regression for Experimental Data
bli |>
    group_by(treat_ind) |>
    summarize(purchase = mean(purchase)) |>
    pivot_wider(names_from = treat_ind, values_from = purchase) |>
    mutate(ITT = `1` - `0`)

lm(purchase ~ treat_ind, data = bli) |> coef() |> round(5)

# Slide 30 (PDF p. 35): Who Finishes the Ad?
bli |>
    filter(treat_ind == 1) |>
    group_by(finished) |>
    summarize(n = n(), purchase = mean(purchase))

# Slide 32 (PDF p. 37): Ad Data: 74 Slider Ads
bli_ads <- bli_ads |>   # add any_face: 1 if a human face appears on any panel, 0 if on none
    mutate(any_face = if_else(first_face + middle_face + late_face > 0, 1, 0))
bli_ads |> select(ad, completion, first_chars, late_chars, late_color, any_face) |> head()
c(min(bli_ads$completion), max(bli_ads$completion))       # completion across the 74 ads (slide 31)
c(min(bli_ads$total_slides), max(bli_ads$total_slides))   # number of panels (slide 26)
median(bli_ads$total_slides)                              # the median number of panels

# Slide 33 (PDF p. 38): Regression on 74 Ads: Do the Signs Match?
ads <- bli_ads |>  # completion: % of views that reached the last panel
    # z-scores of the 13 continuous features (1 = one standard deviation); any_face stays 1 or 0
    mutate(across(total_slides:late_story, ~ (.x - mean(.x)) / sd(.x)))
lm(completion ~ first_chars + late_chars + late_color + any_face, data = ads) |>
    coef() |> round(3)

# Slide 34 (PDF p. 39): The Survey Data
survey <- bli_survey   # one row per participant and ad
survey |> head()
n_distinct(survey$person)   # number of participants

# Slide 37 (PDF p. 42): Regression with Categorical Variables
survey <- survey |>   # levels 1 to 5; level 1 (strongly negative) is the baseline
    mutate(experience = factor(experience))

fit.exp <- lm(purchase_intent ~ experience, data = survey); fit.exp

# Slide 38 (PDF p. 43): What R Does Internally w/ Factors in lm()
survey |> select(experience) |> pull() |> head()

model.matrix(fit.exp) |> head()

# Slide 39 (PDF p. 44): Back to the Experiment: Book Dummies as Controls
lm(purchase ~ treat_ind + factor(book), data = bli) |> coef() |> head(2) |> round(5)
n_distinct(bli$book)   # number of books: factor(book) adds one binary variable for each book but the first


# Part 4. Interactions --------------------------------------------------------------------------

# Slide 41 (PDF p. 47): Finishing x Experience in R
# The model on the slide (Table 8 of the article)
fit.int <- lm(purchase_intent ~ finished + finished:experience + genre_match +
                  factor(person) + factor(book), data = survey)
coef(fit.int)[c("finished", paste0("finished:experience", 2:5))] |> round(3)

# The table: the gap between finished and unfinished ads at experience level k = finished + finished:experience k
b <- coef(fit.int)
round(b[["finished"]] + c(0, b[paste0("finished:experience", 2:5)]), 2)

# Slide 42 (PDF p. 48): Plotting the Interaction
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

# Appendix slide 1 (PDF p. 55): A Little Bias for Much Less Variance
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

# Appendix slide 2 (PDF p. 56): Lasso for Controls: Use Double Selection
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

# Appendix slide 3 (PDF p. 57): Compare by Assignment, Not by Choice
share <- mean(bli$finished[bli$treat_ind == 1])                  # share of slider visits that finished
itt <- coef(lm(purchase ~ treat_ind, data = bli))[["treat_ind"]]   # effect of assignment (slide 29)
round(c(share = share, itt = itt, finishing = itt / share), 5)     # effect of finishing = itt / share

# Appendix slide 4 (PDF p. 58): Difference-in-Differences as a Regression
minwage <- as_tibble(read.csv(url("https://bit.ly/3QZmodH")))   # same data as before
long <- minwage |>
    mutate(id = 1:n(), nj = if_else(location == "PA", 0, 1),
           fte_before = fullBefore + 0.5 * partBefore,
           fte_after = fullAfter + 0.5 * partAfter) |>
    pivot_longer(c(fte_before, fte_after), names_to = "period", values_to = "fte") |>
    mutate(post = if_else(period == "fte_after", 1, 0))
lm(fte ~ nj * post, data = long) |> coef() |> round(2)   # nj * post: nj + post + nj:post

# Appendix slide 5 (PDF p. 59): Two-Way Fixed Effects
fit.twfe <- lm(fte ~ nj:post + post + factor(id), data = long)
coef(fit.twfe)[c("post", "nj:post")] |> round(2)
n_distinct(long$id)   # number of restaurants: factor(id) adds one binary variable for each restaurant but the first
