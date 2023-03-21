# Observational Studies

We occasionally try to estimate causal effects using data from non-randomized, _observational_ sources.

When we do so, we seek to embody the principle of "design before analysis" and the techniques in @rubin07. These techniques include designing with no outcomes in sight and pre-registering analyses where possible.

## Matching

There are many algorithms for producing matched samples.^[Incidentally, there are many ways to estimate the conditional expectation function as well, of which ordinary least squares is only one.] Depending on our data structures, we may consider 

* propensity score [@rosrub83], 
* Mahalanobis distance [@rubin80], 
* genetic [@diasek13], or 
* coarsened exact matching [@iackinpor12].

