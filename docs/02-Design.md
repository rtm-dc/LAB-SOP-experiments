---
output:
  html_document: default
  pdf_document: default
---
# Design

## Units

We carefully define the units of observation. They maybe households, automobile
registrations, 911 callers, or students, about which we are measuring
application status, traffic tickets, primary care visits, or days of attendance
in school, respectively.

## Level of Randomization

We define the level of randomization, which is not always the same as
the unit of observation. In particular, the units of observation may be assigned
in _clusters_. For example, we may assign some _classrooms_ to a particular
teacher-based intervention, and all students in intervention classrooms are
assigned to the same intervention. When clusters are meaningful, this has
substantial implications for our design and analysis. 

Generally, we prefer to randomize at lower levels of aggregation -- at the
student level rather than the classroom level, e.g. -- because we will have more
randomization units. However, there are often logistical or statistical reasons
for assigning conditions in clusters. For example, logistically, a teacher can
only deliver one particular curriculum to their class; statistically, we may be
concerned about interference between students, where students in one condition
interact with students in the other, and causal effects of the intervention are
difficult to isolate.

## Random Assignment Methods

As a general rule, our preference ordering over assignment methods is

1. Blocked assignment (e.g., 30% Tr, 70% Co _within_ homogeneous covariate groups)
2. Random allocation (e.g., 30% Tr, 70% Co overall)
3. Bernoulli assignment (e.g., each unit assigned independently, with probability 0.3 to Tr, 0.7 to Co)

For blocked assignments, see our motivations and methods in Section \@ref(sec-blocking), the slides [here](https://github.com/ryantmoore/discussions/blob/main/997-2024-06-11_blocking.pdf), and @moore12.

For random allocation, see the example below and the vignettes [here](https://github.com/DeclareDesign/randomizr) and [here](https://declaredesign.org/r/randomizr/articles/randomizr_vignette.html).


``` r
library(randomizr)

# Assign 30 of 100 to Tr:
rand_alloc <- complete_ra(N = 100, m = 30)
table(rand_alloc)
```

```
## rand_alloc
##  0  1 
## 70 30
```

``` r
# Assign 100 to T1, T2, T3 with probabilities (.2, .3, .5):
rand_alloc <- complete_ra(N = 100, prob_each = c(.2, .3, .5))
table(rand_alloc)
```

```
## rand_alloc
## T1 T2 T3 
## 20 30 50
```

For simple Bernoulli assignments, we use `sample()` or `randomizr::simple_ra()`.

## Blocking on Background Characteristics {#sec-blocking}

In order to create balance on potential outcomes, which promotes less estimation error and more precision, we block using prognostic covariates. A _blocked_ randomization first creates groups of similar randomization units, and then randomizes within those groups. In a _random allocation_, by contrast, one assigns a proportion of units to each treatment condition from a single pool. See @moore12 or the slides [here](https://github.com/ryantmoore/discussions/blob/main/997-2024-06-11_blocking.pdf) for an introduction and discussion.

### Examples

The Lab's TANF recertification experiment [@mooganmin22] blocked participants on
service center and assigned visit date.

## Setting the Assignment Seed {#sec-set-seed}

Whenever our design or analysis involves randomization, we set the seed so that
our results can be perfectly replicated.

We set the seed at the top of the file, just after the (e.g., `library()`) commands that load and attach that file's packages. In a short random assignment file, e.g., we might have


``` r
# Packages:
library(dplyr) 

# Set seed:
set.seed(SSSSSSSSS)

# Conduct Bernoulli randomization:
df <- df |> mutate(
  treatment = sample(0:1, 
                     size = n(),
                     replace = TRUE))
```

### Seeding Procedures

We use two types of seeds: _date_ seeds and _sampled_ seeds, which we describe below. By default, we use them in the following conditions:

1. Public-relevant implementations: _date_
2. Other implementations: _sampled_

We consider _public-relevant implementations_ to include situations like a random assignment of a program to some members of a waitlist, a random selection of some households to participate in a survey, and random assignment of hypothetical treatments during confirmatory randomization inference.

We consider other implementations to include simulations to create example datasets, simulations to estimate power or bias, or other design or diagnostic procedures.

#### _Date_ Seeds

To seed the random seed, run at the R prompt


``` r
set.seed(YYMMDDHH)
```

where `YY` is the two-digit year (`23` for 2023), `MM` is the two-digit month,
`DD` is the two-digit date, and `HH` is the two-digit hour (between `00` and
`23`) of implementation.

#### _Sampled_ Seeds

To set the random seed, run at the R prompt only once


``` r
sample(1e9, 1)
```

then copy and paste the result as the argument of `set.seed()`. If the result of
`sample(1e9, 1)` is `SSSSSSSSS`, then set the seed with


``` r
set.seed(SSSSSSSSS)
```


### Updating the Seed

We update `date` seeds to reflect the last time that the code was run for implementation. 

We do not need to update `sampled` seeds in our other design, demonstration, or diagnostic code.

### Motivation

We want to ensure that our stochastic work can be exactly replicated. We do not
manipulate seeds to obtain particular results. However, we do not want our draws
to be entirely dependent within a given date, and we note that some
seemingly-random phenomena are sometimes later found to have patterns. For an
example of dependence, consider these two different draws that use the same
seed:


``` r
set.seed(758296545)
sample(100, 10)
```

```
##  [1] 11 22 88 94 25 76  1  4 64 12
```

``` r
set.seed(758296545)
sample(100, 20)
```

```
##  [1] 11 22 88 94 25 76  1  4 64 12 35 45 65 77 34 91 90  6 27  3
```

Note that the first 10 cases are identical.

## Power

We conduct power analysis to determine how precise our experiment are likely to
be. Power analysis should go beyond sample size, and attempt to account for as
many features of the design, implementation, and analysis as possible. Sometimes
we can achieve this with "formula-based" power strategies; other times we need
to use simulation-based techniques. Power analyses should be conducted in code,
so that they are replicable. If we use an online calculator for a quick
calculation, we replicate the results in code.^[An online power calculator is
available from [EGAP](https://egap.shinyapps.io/Power_Calculator/), e.g.]

If our design and analysis plan match the assumptions of a formula-based power
calculation well, we perform a formula-based power calculation. For example, if
the design is complete randomization and the analysis plan is to conduct a
two-sample $t$-test, we might use R's `power.t.test()`, as below. However, if
the design includes blocked assignment in several waves, untreated units stay in
the pool across waves, and assignment probabilities vary by wave, with an
analysis plan of covariance-adjusted Lin [estimation](#sec-lin) with strong
covariates, then we need to use simulation. If we can't find a formula-based
approach that sufficiently approximates our design and analysis plan, we use
simulation.



### Formula-based Power Analysis

An example of formula-based power calculation, where the design is complete randomization and the analysis plans for a two-sample $t$-test:


```{.r .fold.hide}
power_out <- power.t.test(delta = 1, 
                          sd = 1,
                          sig.level = 0.05,
                          power = 0.8)
power_out
```

```
## 
##      Two-sample t test power calculation 
## 
##               n = 16.71477
##           delta = 1
##              sd = 1
##       sig.level = 0.05
##           power = 0.8
##     alternative = two.sided
## 
## NOTE: n is number in *each* group
```

For two equally-sized samples drawn from a population with standard normal
outcomes, we need 17 observations in each group to have a
probability of 0.8 of detecting a true effect that is one
standard deviation of the outcome in size, where "detecting" means rejecting a
null hypothesis of $H_0: \mu_{Tr} = \mu_{Co}$ against an alternative of $H_a:
\mu_{Tr} \neq \mu_{Co}$ using $\alpha = 0.05$.

### Formula-based MDE (minimum detectable effect)

An example of a formula-based MDE calculation follows, where the analysis plans
for a two-sample test of proportions. The sample size is 75 (in _each_ group),
and we want to detect stipulated effects with probability 0.8. Below, we make
the most conservative (SE-maximizing) possible assumption about the base rate,
that it is 0.5.


```{.r .fold.hide}
power_out_mde <- power.prop.test(n = 75, 
                                 p1 = 0.5,
                                 power = 0.8)
power_out_mde
```

```
## 
##      Two-sample comparison of proportions power calculation 
## 
##               n = 75
##              p1 = 0.5
##              p2 = 0.7213224
##       sig.level = 0.05
##           power = 0.8
##     alternative = two.sided
## 
## NOTE: n is number in *each* group
```

```{.r .fold.hide}
power_out_mde$p2 - power_out_mde$p1
```

```
## [1] 0.2213224
```

We see a minimum detectable effect of about 0.22, over a base rate of 0.5.

### Simulation-based Power Analysis

Simulation-based power analysis allows us to estimate the power of any
combination of randomization technique, missing data treatment, estimation
strategy, etc. that we like.

Create some data to illustrate simulation-based power analysis:

``` r
library(estimatr)
library(here)
library(tidyverse)

set.seed(988869862)

n_samp <- 100
df <- tibble(x = rchisq(n_samp, df = 3),
             z = rbinom(n_samp, 1, prob = 0.5),
             y = x + z + rnorm(n_samp, sd = 1.1))

save(df, file = here("data", "02-01-df.RData"))
```

Suppose the estimation strategy is linear regression $y_i = \beta_0 + \beta_1 z_i +  \beta_2 x_i + \epsilon_i$ with heteroskedasticity-robust HC2 standard errors, and the coefficient of interest is $\beta_1$. Perform 1000 reassignments and determine what proportion of them reveal $\hat{\beta}_1$ that is statistically significant at $\alpha = 0.05$.


``` r
n_sims <- 1000
alpha <- 0.05
true_te <- 1

is_stat_sig <- vector("logical", n_sims) # Storage

for(idx in 1:n_sims){
  
  # Re-assign treatment and recalculate outcomes n_sims times:
  # (Note: conditions on original x in df, but not original y.)
  df <- df |> mutate(z_tmp = rbinom(n_samp, 1, prob = 0.5),
                     y_tmp = true_te * z_tmp + x + rnorm(100, sd = 1.1))
  
  # Estimation:
  lm_out <- lm_robust(y_tmp ~ z_tmp + x, data = df)
  
  # Store p-value:
  stat_sig_tmp <- lm_out$p.value["z_tmp"]
  
  # Store whether true effect is 'detected':
  is_stat_sig[idx] <- (stat_sig_tmp <= alpha)
}

mean(is_stat_sig)
```

```
## [1] 0.995
```

So the probability of detecting the true average treatment effect of 1 is about 0.995. This high power comes largely from the strongly predictive nature of the covariate `x`. Note that a naïve formula-based approach that ignores the data generating process estimates the power to be roughly 0.45.

## Balance Checking

To increase our certainty that our treatment and control conditions are balanced on predictive covariates, we compare the distributions of covariates. For example, in @mooganmin22, we describe 

> the median absolute deviation (MAD) of appointment dates is about 0.15 days (about 3.5 hours) or less in 99% of the trios.  In other words, the medians of the treatment and control groups tend to vary by much less than a day across the months and Service Centers.

