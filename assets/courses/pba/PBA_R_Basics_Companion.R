# PBA: R Programming Basics, companion examples
# Run selected sections while reading the companion PDF.
# Most examples use base R. The missing-data example uses tibble.
# Install tibble once if needed: install.packages("tibble")
# The examples reuse names such as x and f; run each section in order.

# ---- assignment ----
x <- 2
y = 5
x <- y
x
3 -> z
a <- b <- 7
c(x, y, z, a, b)

# ---- precedence ----
1 + 2 * 3
(1 + 2) * 3
7 %% 3
7 %/% 3

# ---- comparison ----
2 == 3
2 != 3
2 < 3
2 >= 3
"data" == "stats"

# ---- numeric ----
i <- 5L
is.integer(i)
class(i)
typeof(5)
class(4L * 2.8)
class(5L / 2L)

# ---- character ----
x <- "data"
class(x)
nchar(x)
paste("Hello", x)
paste0("Hello", x)
substr(x, 1, 2)

# ---- factor ----
gender <- factor(c("Male", "Female", "Male"))
levels(gender)
as.integer(gender)
ordered_gender <- factor(gender, ordered = TRUE)
is.ordered(ordered_gender)

# ---- logical ----
TRUE * 5
FALSE * 5
3 & 0
3 | 0
!0
3 & 1
3 | 2
!1

# ---- customers ----
customers <- data.frame(
  id = 1:6,
  spend = c(500, 1200, 300, 750, 2000, 150),
  visits = c(12, 4, 30, 7, 20, 1)
)
customers$VIP <- (customers$spend > 1000) &
  (customers$visits > 10)
customers$AtRisk <- (customers$spend < 400) |
  (customers$visits < 5)
customers

# ---- missing ----
df <- tibble::tibble(
  age = c(25, -3, 45, 200, 30),
  income = c(50000, 20000, NA, 100000, 30000)
)
invalid <- (df$age < 0) | (df$age > 120) | is.na(df$income)
invalid
df[invalid, ]

# ---- na ----
NA == NA
is.na(c(50000, NA, 30000))
mean(c(50000, NA, 30000))
mean(c(50000, NA, 30000), na.rm = TRUE)

# ---- dates ----
date1 <- as.Date("2012-06-28")
class(date1)
as.numeric(date1)
date2 <- as.POSIXlt("2012-06-28 17:42", tz = "Asia/Taipei")
class(date2)
date2$hour
as.Date("2012-06-30") - date1

# ---- vector create ----
x <- c(1, 2, 4)
x
5:8
seq(5, 8)
rep(1:3, 2)
i <- 2
1:(i - 1)
1:i - 1

# ---- vector arithmetic ----
x <- c(1, 2, 4)
y <- c(5, 0, -1)
x + y
x - y
x * y
x / y
x^y
x %% y
x %/% y
x %*% y

# ---- vector logical ----
x <- c(1, 2, 4)
y <- c(5, 0, -1)
x > y
x <= y
x == y
x != y
!y
x >= 2 | y < 3
x < 2 & y >= 3
x <- 1:100
sum(x > 50)

# ---- vectorized ----
sqrt(1:3)
round(c(1.2, 3.9, 0.4))
y <- c(12, 5, 13)
y + 4
`+`(y, 4)

# ---- loop ----
y <- c(12, 5, 13)
for (i in 1:length(y)) {
  print(y[i] + 4)
}

# ---- recycling ----
c(1, 2, 4) + c(6, 0, 9)
c(1, 2, 4) + c(6, 0, 9, 20, 22)

# ---- index ----
y <- c(1.2, 3.9, 0.4, 0.12)
y[1]
y[2:3]
v <- 3:4
y[v]
z <- c(5, 12, 13)
z[-1]
z

# ---- filter ----
z <- c(5, 2, -3, 8)
z[c(TRUE, FALSE, TRUE, TRUE)]
which(z * z > 8)
z[which(z * z > 8)]
w <- z[z * z > 8]
w
x <- c(1, 3, 8, 2)
x[x > 3] <- 0
x

# ---- coercion ----
num.char.vec <- c(1, 3, "five", 7)
num.char.vec
num.vec <- c(1, 3, 5, 7)
comb.vec <- c(num.vec, num.char.vec)
comb.vec
typeof(comb.vec)

# ---- conversion ----
numbers.vec <- c(-3, -2, -1, 0, 1, 2, 3)
num2char <- as.character(numbers.vec)
num2char
as.logical(numbers.vec)
char.vec <- c("1", "3", "five", "7")
char2num <- as.numeric(char.vec)
char2num

# ---- matrix ----
y <- matrix(c(1, 2, 3, 4), nrow = 2, ncol = 2)
y
z <- matrix(c(1, 2, 3, 4), nrow = 2, byrow = TRUE)
z
z[1, 2]
z[1, ]
z[, 2]
z[, 2, drop = FALSE]

# ---- matrix recycle ----
matrix(c(1, 2, 3, 4), nrow = 3)

# ---- array ----
a <- array(1:8, dim = c(2, 2, 2))
a
a[1, 2, 2]
a[, , 2]

# ---- list ----
j <- list(name = "Joe", salary = 55000, union = TRUE)
j
jalt <- list("Joe", 55000, TRUE)
names(jalt)
z <- vector(mode = "list")
length(z)

# ---- list extract ----
j$salary
j[["salary"]]
j[[2]]
class(j[[2]])
j["salary"]
class(j[2])

# ---- dataframe ----
kids <- c("Jack", "Jill")
ages <- c(2, 10)
data <- data.frame(kids, ages, stringsAsFactors = FALSE)
data
data[[1]]
data$kids
data[, 1]

# ---- dataframe subset ----
data[2, ]
data[, "kids", drop = FALSE]
data["kids"]
data[data$ages > 3, ]
str(data)

# ---- function ----
f <- function(x) (x - 32) / 1.8
f(100)
f <- function(x) { (x - 32) / 1.8 }
f(100)
f <- function(x) return((x - 32) / 1.8)
f(100)
f <- function(x) x * 1.8 + 32
f(37.7778)

# ---- defaults ----
f <- function(a, b = 1, c = 2, d = NULL) {
  cat(a, b, c, d, "\n")
}
f(1)
f(1, 2, 3, 4)
f(1, 2, 3)
f(3, c = 5)
try(f(d = 7)) # Intentional missing-argument error

# ---- nesting ----
f <- function(x, y) {
  print(x)
  g <- function(y) { print(y) }
  g(y)
}
f(1, 2)
args(f)

# ---- dots ----
f <- function(x, y) {
  print(x)
  print(y)
}
g <- function(z, ...) {
  print(z)
  f(...)
}
g(1, 2, 3)

# ---- total ----
total <- 0
add_to_total <- function(value) {
  total <- total + value
  print(paste("Total is now:", total))
}
add_to_total(10)
add_to_total(5)
print(total)

# ---- scope global ----
n <- 1
f <- function() print(n)
f()
n <- 2
f()
n <- 100
f <- function() { n <- 1; print(n) }
f()
n

# ---- scope local ----
f <- function() x_local <- 1
f()
exists("x_local")
n <- 100
f <- function(n) print(n)
f(1)
n

# ---- scope nested ----
f <- function(x) {
  a <- 2
  g <- function(y) { print(y + a) }
  g(x)
}
a <- 100
f(1)

# ---- scope super ----
b <- 0
f <- function() {
  a <- 1
  g <- function(a, b) {
    a <<- 2
    b <<- 2
    print(a)
    print(b)
  }
  g(3, 3)
  print(a)
  print(b)
}
f()

# ---- binary ----
"%a2b%" <- function(a, b) return(a + 2 * b)
3 %a2b% 5
"%sdf%" <- function(a, b) {
  sdfxy <- setdiff(a, b)
  sdfyx <- setdiff(b, a)
  return(union(sdfxy, sdfyx))
}
x <- c(1, 2, 5)
y <- c(5, 1, 8, 9)
x %sdf% y

# ---- Import reference (run only with the actual course file) ----
# Original reference-slide URL:
# exam1 <- read.csv(url("https://bit.ly/3ZqTQLY"))
# Equivalent for the same CSV:
# exam1 <- read.table(url("https://bit.ly/3ZqTQLY"),
#                     sep = ",", header = TRUE)
# For a downloaded file in your R project:
# exam1 <- read.csv("import_data.csv")
# head(exam1)
# str(exam1)
