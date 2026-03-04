## ============================================================
## ISS5096 | ECI - Week 2: Randomization Inference
## In-Class Exercise
## ============================================================

## --- Data ---
## A small online retailer tested a new product page on 10 customers.
## 5 were randomly assigned to the new page (D=1), 5 to the old page (D=0).
## Y = number of items purchased that week.

Y <- c(8, 9, 7, 10, 8, 1, 2, 1, 1, 30)
D <- c(1, 1, 1, 1, 1, 0, 0, 0, 0, 0)
names(Y) <- LETTERS[1:10]  # Users A through J

## Take a look at the data first.
Y
mean(Y[D == 1])
mean(Y[D == 0])

## --- All possible treatment assignments ---
## 10C5 = 252 possible ways to assign 5 out of 10 to treatment.

n  <- length(Y)
n1 <- sum(D)

treated_combos <- combn(n, n1)
D_bold <- apply(treated_combos, 2, function(i) {
  d <- rep(0, n)
  d[i] <- 1
  d
})
ncol(D_bold)  # 252

## --- Baseline: two-sided RI with diff-in-means ---

T_obs <- abs(mean(Y[D == 1]) - mean(Y[D == 0]))
T_obs  # 1.4

rdist <- rep(NA, ncol(D_bold))
for (k in 1:ncol(D_bold)) {
  D_tilde <- D_bold[, k]
  rdist[k] <- abs(mean(Y[D_tilde == 1]) - mean(Y[D_tilde == 0]))
}

hist(rdist, main = "Randomization Distribution (Diff-in-Means)",
     xlab = expression(T[diff]))
abline(v = T_obs, col = "darkred", lwd = 3)

p_twosided <- mean(rdist >= T_obs)
p_twosided  # 0.95


## ============================================================
## Task 1: Diff-in-medians (two-sided)
## ============================================================
## Replace mean() with median() in BOTH T_obs and the loop.
## Keep the absolute value (two-sided test).
## Compare the p-value to the baseline (0.95).
## Look at the data, why do they differ?

## YOUR CODE HERE:



## ============================================================
## Task 2: One-sided test (diff-in-medians)
## ============================================================
## Using your Task 1 code, remove abs() from BOTH
## T_obs and the randomization distribution.
## Compute the one-sided p-value: Pr(T >= T_obs).
## How does it compare to Task 1? Why?

## YOUR CODE HERE:



## ============================================================
## Task 3: Changing an outcome
## ============================================================
## Pick one person and change their Y value. Re-run RI.
## Which of these changed, and why?
##   (i)   The set of possible treatment assignments
##   (ii)  The randomization distribution of T_diff
##   (iii) The observed test statistic T^obs

## YOUR CODE HERE:
## Y_new <- Y
## Y_new["J"] <- ???
## ...
