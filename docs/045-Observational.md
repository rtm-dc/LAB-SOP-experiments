# Observational Studies

We occasionally try to estimate causal effects using data from non-randomized, observational sources.

When we do so, we seek to embody the principle of "design before analysis" and the techniques in @rubin07. These techniques include designing with no outcomes in sight and pre-registering analyses where possible.

## Matching

There are many algorithms for producing matched samples.^[There are also many ways to estimate the conditional expectation function, of which ordinary least squares is only one.] By default, we implement several matching procedures and select the one that yields the best balance for our analysis. We developed this approach for our evaluation of a high school internship program; see [here](https://thelabprojects.dc.gov/reimagine-dc-high-schools) for details of that application.

### Methods

By default, we implement

* optimal full nearest-neighbor matching
* optimal full nearest-neighbor matching with calipers
* (if the optimal methods above cannot be implemented, we instead use generalized full matching)
* genetic matching using the Mahalanobis distance, without replacement, and a 1-1 treatment-control ratio,
* genetic matching using the Mahalanobis distance, without replacement, and a 1-2 treatment-control ratio,
* genetic matching including the propensity score as a covariate, using the Mahalanobis distance, without replacement, calipers, and a 1-1 treatment-control ratio,
* genetic matching including the propensity score as a covariate, using the Mahalanobis distance, without replacement, calipers, and a 1-2 treatment-control ratio,

If we encounter issues estimating the propensity score, where needed, we will exclude variables that are highly correlated with others. Our default procedure for doing so is to 

1. include all of the covariates of interest; 
2. if the propensity score model does not estimate due to highly-correlated variables, calculate the pairwise correlations between all covariates; 
3. using that pairwise correlation, identify the most correlated pair, randomly exclude one of the two covariates, and re-estimate the propensity score model; 
4. continue until enough variables are excluded to successfully estimate the propensity score.  

### Selecting the Method for Analysis

We select a matching method and parameters for that method for primary analysis based on which method minimizes the worst imbalance on a covariate. We use the standardized mean difference to assess balance in each covariate, with the control group standard deviation as the denominator.

For example, comparing two methods for three covariates with imbalance scores (where lower scores indicate better balance) of 


Table: (\#tab:matchingeval)Comparing Matching Methods using Variables' Balance Scores

|Method   |  x1|  x2|  x3|
|:--------|---:|---:|---:|
|Method 1 | 0.6| 0.9| 0.5|
|Method 2 | 0.8| 0.7| 0.6|

we select **Method 2**. Its _worst_ imbalance (0.8 on `x1`) is better than the worst balance of Method 1 (0.9 on `x2`).

### Calipers


### Alternatives

Depending on our data structures, we may consider 

* propensity score matching [@rosrub83], 
* Mahalanobis distance matching [@rubin80], 
* genetic matching [@diasek13], or 
* coarsened exact matching [@iackinpor12].

