# Analysis

In experiments, our standard operating procedure is to estimate the treatment
effect via

- the [unadjusted][The Unadjusted ITT] ITT 
- the [adjusted][Adjusting for covariates] ITT, where we have potentially informative covariates

We incorporate features of our design into our analysis. This includes blocking,
[clustering][Clusters, weights, fixed effects], and [weighting][Weights] when
treatment assignment probabilities vary.

By default, we perform parametric statistical inference using HC2 standard
errors if our assignment is not clustered. If our assignment is clustered, we
use CR2 standard errors with [clustering][Clusters, weights, fixed effects] at
the level of assignment.

Often, however, we specify that we will use design-based [randomization
inference][Randomization Inference] instead of parametric inference. This
design-based inference attempts to replicate all the features of our assignment
and analysis. Some times that we rely on randomization inference include when we
have a multistage or wave-based design that creates complex assignment
probabilities, a skewed outcome^[@gergre12 provides an instructive example.] or
other distributional concern, or a novel adjustment strategy. 

We report treatment effect estimates and associated confidence intervals. We
often report the [posterior probability][Posterior Probabilities] that one
condition is better than another.

## Notation

Notation:

* $n$ units, indexed $i \in \{1, \ldots, n\}$
* $Z_i \in \{0, 1\}$ indicates _assignment_ to the control or treatment condition 
* $D_i \in \{0, 1\}$ indicates _receipt_ of the control or treatment condition
* $Y_i(1)$ the potential outcome for unit $i$ if assigned to treatment (more explicitly, $Y_i(Z_i = 1)$)
* $Y_i(0)$ the potential outcome for unit $i$ if assigned to control
* $Y_i$ the _observed_ potential outcome for unit $i$



## Estimands

Below are some estimands (targets) that we may be interested in. 

- Average treatment effect: $ATE = \frac{1}{n} \sum\limits_{i=1}^{n} (Y_i(1) - Y_i(0))$
- LATE CACE
- Effect for those most helped [@rugfol21]

## The Unadjusted ITT {#sec-unadj-itt}

By default, in experiments, we estimate the intent-to-treat effect (ITT),
unadjusted for covariates, using HC2 standard errors for inference. We do so by
estimating the coefficients of the model

$$Y_i = \beta_0 + \beta_1 Z_i + \epsilon_i$$
using least squares. First, some preliminaries:


``` r
library(dplyr)
library(estimatr)
library(here)

# Load data:
load(here("data", "02-01-df.RData"))
```

Our estimation procedure:


``` r
lm_out <- lm_robust(y ~ z, data = df)

lm_out
```

```
##             Estimate Std. Error  t value     Pr(>|t|)  CI Lower CI Upper DF
## (Intercept) 2.631066  0.2866799 9.177716 7.370994e-15 2.0621596 3.199973 98
## z           1.548357  0.5367332 2.884779 4.816584e-03 0.4832272 2.613486 98
```

We can view the ITT treatment effect from the model object with
`summary(lm_out)` or extract it with `lm_out$coefficients["z"]`.

## Adjusting for Covariates {#sec-lin}

### Why we adjust for covariates

We adjust for covariates for two reasons. First, we adjust to address covariate imbalances that remain in our sample, in order to minimize our estimation error.  As @tukey91[p. 123] describes, 

> the degree of protection against either the consequences of inadequate randomization or the (random) occurrence of an unusual randomization is considerably increased by adjustment.  
> *Greater security, rather than increased precision, or increased sensitivity will often be the basic reason for covariance adjustment in a randomized trial.*

Despite the fact that the difference in means and regression equivalents are unbiased for the ATE under random allocation, we can only derive estimates from the sample at hand.

Second, adjustment can increase our ATE estimate precision.

### How we adjust for covariates

To estimate average treatment effects in experiments, we follow the guidance of @lin2013, using HC2 standard
errors for inference, and, where we adjust for covariates, centering and
interacting predictors with treatment status. Where $Z$ is treatment status and
$X$ is a covariate, $\beta_1$ below is the ATE:

$$y_i = \beta_0 + \beta_1 Z_i + \beta_2 (X_i - \bar{X}) + \beta_3 Z_i (X_i - \bar{X}) + \epsilon_i$$
To implement this, we can use `lm_lin()` from the `estimatr` package^[In the
original paper, @lin2013 describes "the OLS regression of $Y_i$ on $T_i$, $z_i$,
and $T_i(z_i − \bar{z})$", where the covariates are only centered in the
interaction. The implementation in @blacoocop22 and Lin's supplementary materials, however, center the covariates
in their linear terms, using $T_i$, $z_i-\bar{z}$, and $T_i(z_i − \bar{z})$. We
show elsewhere that it doesn't matter which of these models we estimate.]:


``` r
lin_out <- lm_lin(y ~ z, covariates = ~ x, data = df)
lin_out
```

```
##              Estimate Std. Error  t value     Pr(>|t|)    CI Lower  CI Upper DF
## (Intercept) 2.8816525 0.15663330 18.39744 3.088795e-33  2.57073780 3.1925671 96
## z           0.9487427 0.23402169  4.05408 1.023250e-04  0.48421335 1.4132721 96
## x_c         0.8773304 0.06813581 12.87620 1.239045e-22  0.74208190 1.0125789 96
## z:x_c       0.1224778 0.08153824  1.50209 1.363561e-01 -0.03937434 0.2843299 96
```

We can view the adjusted ITT treatment effect from the model object with
`summary(lin_out)` or extract it with `lin_out$coefficients["z"]`.



The estimate of the average treatment effect is $0.949$, with a 95% confidence
interval covering $(0.484, 1.413)$.

When we want to adjust for a factor variable that has many levels, the interactions in the Lin estimator may not all be identified. In this case, when we want the Lin estimate of the ATE, we coarsen the factor into fewer categories. 

Sometimes we are interested in quantities other than average treatment effects. For example, in an [experiment](https://thelabprojects.dc.gov/high-risk-drivers) involving safety messaging, we might have exploratory interest in whether different models of cars' registrants appear to behave differently. In such an exploration, we estimate a linear model with a coefficient for each car model without centering and interacting the predictors. Here, we are not interested in the average treatment effect; further, the Lin version of this model demands more than the data can provide -- a treatment and control unit for every car model. 

### Adjusting for Blocks {#sec-adjust-blocks}

Where treatment probabilities or sample sizes vary across blocks we account for our blocking by either treating the block indicators $B_j$ as Lin covariates and estimating

\begin{eqnarray*}
y_i & = &  \beta_0 + \beta_1 Z_i + \beta_2 (X_i - \bar{X}) + \beta_3 Z_i (X_i - \bar{X}) + \ldots \\
&& \gamma_1 (B_1 - \bar{B}_1) + \gamma_2 (B_2 - \bar{B}_2) + \ldots \\
&& \delta_1 Z_i (B_1 - \bar{B}_1) + \delta_2 Z_i (B_2 - \bar{B}_2) + \ldots + \epsilon_i
\end{eqnarray*}

or by estimating the blocked difference-in-means (i.e., taking the average of the block-level ATEs, weighted by their sample sizes). We can do so via


``` r
lm_lin(y ~ z, covariates = ~ x + block1_id + block2_id + ..., data = df)
lm_lin(y ~ z, covariates = ~ x + block_id_factor, data = df)
```

We do this because the "least squares dummy variable" approach produces biased
estimates of the ATE and its standard error. This approach weights block-level
effects by $p_j(1-p_j)n_j$, where $p_j$ is the probability of treatment in the
block, and $n_j$ is the sample size in the block. See the helpful blog post
[here](https://declaredesign.org/blog/posts/biased-fixed-effects.html).


## Binary or Count Outcomes {#sec-binary-outcomes}

We estimate the linear models above, even when we have binary or count outcomes. The Lin 
estimator returns a good estimate of the difference in means of non-normal outcomes; @lin2013 
provides an example with a highly skewed outcome, e.g.


## Clusters, Weights, Fixed Effects

To specify other design or estimation components for `lm_robust()` or
`lm_lin()`, start at the help file at
https://declaredesign.org/r/estimatr/reference/lm_robust.html. For example, for
a clustered assignment analysis,


``` r
lm_robust(y ~ z, data = df, clusters = cluster_id)
```

Though our standard procedure is to cluster at the level of assignment, we note
that "[[s]ometimes you need to cluster standard errors above the level of
treatment](https://declaredesign.org/blog/posts/sometimes-you-need-to-cluster-standard-errors-above-level-of-treatment.html)."

### Weights

When our units have different probabilities of assignment, we weight each unit
by the reciprocal of the probability of being assigned to the condition that the
unit is finally assigned to. We use _inverse probability weights_ (IPW).^[The
intuition: if the treatment and control groups look different, then we up-weight
the controls that look more like the treateds, and vice versa. If you're a
control that looks like all the other controls, you're less informative about
the causal effect than if you're a control that looks like the treateds.]

For example, suppose we have a monthly lottery from January to March, and those
not selected for the program in the first month are still eligible to be
selected in the second month. See @avimammoo23 for an example. Person $A$ is
eligible for all three waves of a lottery because they apply in January and
could be repeatedly assigned to the control group; person $B$ applies in March
and is only eligible in the last lottery.

If the probability of treatment in each wave is $p$, then the probabilities of
treatment and control for $A$ and $B$ are

Unit|Entry|  $Pr(Z = 1)$ |  $Pr(Z = 0)$
:--:|:--:| :-----------: | :-----------:
$A$ | January | $p + (1-p)p + (1-p)^2p$ | $1-[p + (1-p)p + (1-p)^2p]$
$B$ | March | $p$ | $1-p$

and the weights are 

Unit| Entry |  IPW if $(Z = 1)$ |  IPW if $Z = 0$
:--:|:---: | :-----------: | :-----------:
$A$ |January | $\frac{1}{p + (1-p)p + (1-p)^2p}$ | $\frac{1}{1-[p + (1-p)p + (1-p)^2p]}$
$B$ | March | $\frac{1}{p}$ | $\frac{1}{1-p}$

If the assignment probability varies by wave, i.e., $p$ is not constant, then
this fact needs to be taken into account.

### Fixed Effects

We note that treatment effect estimates from two-way fixed effect (TWFE)
event-study regressions "[can be severely
biased](https://bcallaway11.github.io/did/articles/TWFE.html)", even with
homogeneous treatment effects.

## Randomization Inference {#sec-rand-inf}

Often, we prefer to rely on our _design_, rather than asymptotic or
distributional assumptions, for statistical inference. In particular, when we
have complex designs or analysis strategies, we use randomization inference.

For example, with modest sample sizes and a complex experimental design, in
@avimammoo23 we use randomization inference. Below is an annotated example of
doing so, using a `for` loop. We set the seed using the method in Section
\@ref(sec-set-seed); we simulate treatment assignments using the method in
Section \@ref(sec-create-treatment). More simulations reduces simulation error.


``` r
# Set seed:
set.seed(534722898)

# Set simulation size:
n_sims <- 1000

# Create empty storage vector:
store_te <- vector("double", length = n_sims)

# Rerandomise and perform estimation n_sims times:
for(i in 1:n_sims){
  
  # Reassign 0/1 treatment:
  df_tmp <- df |> mutate(z_tmp = sample(0:1, n(), replace = TRUE))
  
  # Estimate treatment effect:
  lm_tmp <- lm_robust(y ~ z_tmp, data = df_tmp)
  
  # Store estimate:
  store_te[i] <- lm_tmp$coefficients["z_tmp"]
}

# Estimate treatment effect from actual assignment:
te_est <- lm_out$coefficients["z"]

# The p-value:
# "What proportion of effects estimated under sharp null hypothesis
#  are at least as extreme as that which we observed?"
mean(abs(store_te) >= abs(te_est))
```

```
## [1] 0.003
```

Sometimes, this will differ greatly from the parametric $p$-value. Here, the
parametric $p$-value is 0.00482.

For another example, see @gergre12, Chapter 3 for a demonstration using highly skewed data.

## Addressing Non-compliance

## Missing Data

Unless we have solid justification to believe the missingness mechanism is MCAR
(missing completely at random), we prefer to treat missing data with multiple
imputation.

We recognize that not all missing data are the same, however. We can confidently
impute values that we are certain exist, but we should be more circumspect
regarding other values. For example, we can confidently impute a household
income, but we should be more circumspect about a student's grade point average
(GPA) or a survey preference. How would we interpret that GPA if the student
actually dropped out of school? How can we be confident that the survey
respondent actually has a preference for alternative $A$ or $B$, rather than
being indifferent or having never considered the question?

After multiple imputation, we analyze each of the completed data sets and
combine estimates and uncertainties from across the completed data sets into a
single estimate and uncertainty.

## Multiple Comparisons

In frequentist hypothesis testing, the more tests we conduct, the more likely we
become to "detect" a causal effect that isn't real, but is only an artifact of
natural variation and random assignment. However, we are often interested in
learning as much as we can from an experiment, such as the effect of an
intervention on several outcomes, or the effect in subgroups, or the effect of
several conditions. This tension underlies the problem of multiple comparisons.

One way to avoid this problem is to use Bayesian multilevel modeling, where
post-analysis adjustment to probability statements or uncertainty intervals is
usually not necessarily [@gelhilyaj12].

Another approach is to adjust frequentist $p$-values. Our default strategy for
multiple comparisons is to control the family-wise error rate (FWER). This
approach also controls the false discovery rate (FDR), but can be very
conservative.

We account for multiple tests when a) we declare the tests to be confirmatory,
and b) the tests form a family. Otherwise, we do not account for multiple tests.

By default, we control the FWER using the Holm-Bonferroni procedure [@holm79].
With many tests or correlated tests, this adjustment can result in significant
losses in power. When we anticipate highly correlated tests, such as testing
several outcome measures of the same construct, or are interested in interval
estimation, we use a bootstrap resampling procedure [@wesyou93].^[This procedure
strongly controls the FWER under _subset pivotality_, a condition likely to
obtain when we estimate the effect of a single treatment on many outcomes.]

If we test a single outcome in several time periods, these tests are likely to
be highly correlated with each other. For example, in the ATE project, we expect
to test whether treatment affected the outcome at 3 months and at 6 months. In
such cases, we adjust for performing two tests using the bootstrap resampling
procedure of @wesyou93.

### Holm-Bonferroni Adjustment

Suppose we have conducted three confirmatory hypothesis tests in a family, with
$p$-values $p_1 = .01$, $p_2 = .02$, and $p_3 = .08$, in increasing order. To
adjust these $p$-values with the Holm procedure, we use


``` r
p.adjust(c(0.01, 0.02, 0.08), method = "holm")
```

```
## [1] 0.03 0.04 0.08
```

We see that the three adjusted $p$-values are $0.03$, $0.04$, and $0.08$. (Here, these are $p_1 \times 3$, $p_2 \times 2$, and $p_3 \times 1$.) 

### Westfall-Young Adjustment

@wesyou93 provides a bootstrapping approach to $p$-value adjustment that tends to be more powerful than the Holm-Bonferroni procedure.^[@morgan17 shows that resampling and reallocation methods behave very similarly (up to $\frac{n-1}{n}$) in testing, and argues that, for interval estimation, we should prefer bootstrap resampling methods to reallocation methods (which depend on an equal-variances assumption and additivity).] It strongly controls the FWER under the assumption of subset pivotality. We show an example using the implementation of @hidalgo17 below. 


```r
# Add another outcome and centered covariate:
df <- df |> mutate(y2 = 0.5 * z + rnorm(nrow(df), sd = 1),
                   x_c = as.vector(scale(x, scale = FALSE)))

# Install multitestr:
# devtools::install_github("fdhidalgo/multitestr")
library(multitestr)

# Define formulas with treatment (and interaction):
ff <- lapply(list(
  "y ~ z + x_c + z * x_c", 
  "y2 ~ z + x_c + z * x_c"),
  as.formula)

# Define null formulas without treatment:
ff_null <- lapply(list(
  "y ~ x_c", 
  "y2 ~ x_c"),
  as.formula)

wy_out <- boot_stepdown(
  full_formulas = ff,
  null_formulas = ff_null,
  data = df,
  coef_list = list(coef = c("z", "z:x_c")),
  nboots = 1000,
  parallel = FALSE,
  boot_type = "wild",
  pb = FALSE)

wy_out |> mutate(across(where(is.numeric), round, 3))
```

```
## Warning: There was 1 warning in `mutate()`.
## ℹ In argument: `across(where(is.numeric), round, 3)`.
## Caused by warning:
## ! The `...` argument of `across()` is deprecated as of dplyr 1.1.0.
## Supply arguments directly to `.fns` through an anonymous function instead.
## 
##   # Previously
##   across(a:b, mean, na.rm = TRUE)
## 
##   # Now
##   across(a:b, \(x) mean(x, na.rm = TRUE))
```

```
##     Hypothesis  coef bs_pvalues_unadjusted bs_pvalues_adjusted
## 1 Hypothesis 1     z                 0.001               0.001
## 2 Hypothesis 2 z:x_c                 0.148               0.268
## 3 Hypothesis 1     z                 0.073               0.247
## 4 Hypothesis 2 z:x_c                 0.180               0.268
```


## Posterior Probabilities

We may be interested in the probability that one treatment condition outperforms
another. In @mooganmin22, we calculate that open deadlines have probability 0.79
of being better than specific deadlines. These probabilities can provide
guidance for agencies about which treatment condition(s) to continue
implementing after an experiment ends, especially when there appears to be
little difference between conditions in effect or cost.


