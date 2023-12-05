# Managing Code and Scientific Communication

## Best Practices

1. Use "R projects" and the `here` package to manage the working directory and
paths. See below in \@ref(sec-projects) and \@ref(sec-working-dir) for some details.
This is how we promote replication and collaboration (including with our future
selves). 

2. Use high-quality names for objects, files, and directories, like `df_resume`, `03-analysis.R`, and `/code/` (not `finalTHING` or `more stuff.R` or `/Next Try/`). Names should be human- and machine-readable. File names should 
    * start with numbers, so that default ordering is correct, as in `00-prelims.R`, `01-power-calcs.R`, etc., 
    * be informative,
    * not have spaces, and
    * separate words with `-` or `_` to enable human reading and globbing. 

Object and directory names also should be informative, not have spaces, and use `_` to
separate words. See these
[slides](https://www2.stat.duke.edu/~rcs46/lectures_2015/01-markdown-git/slides/naming-slides/naming-slides.pdf)
for more detail and painful counterexamples.

3. Use [GitHub](97-Git.Rmd). But do not put sensitive data there.

4. Begin your code file with a `library()` command for every package required
for that file to run. Keep these in alphabetical order.


```r
library(here)
library(tidyverse)
```

5. Do **not** include your "workflow" in your code files. Anything that's
interactive or changes the environment should be excluded. Do not include
`install.packages()`, `View()`, `setwd()`, in your `.R` file. Do not start your `.R` file with `rm(list = ls())`; it is both too strong and too weak.^[It is "too weak" in that you should start a new R session regularly to ensure replicability. Removing objects from the workspace does nothing to packages, session options, graphical `par()`'s, etc.]

6. Don't open or change the original data. Read it in programmatically with,
e.g., `read_csv()` or `read_excel()`. See
[here](https://thelab.dc.gov/LAB-SOP-experiments/r-basics.html#read-in-data-files)
for examples in R.

7. Use the assignment arrow for assignment. The structure: 


```r
new_obj_name <- value_of_that_object
```

8. Use space around operators (write `3 + 4 = 7`, not `3+4=7`) and after a
comma, as in English (write `f(x, y)`, not `f(x,y)`).

9. Use the native pipe, `|>`. (If you use RStudio keyboard shortcuts, you can toggle the default pipe shortcut to use the native pipe. See Tools, Global Options, Code, "Use native pipe operator".)



## Style

### R

When we write in R, we tend to prefer the `tidyverse` style. See https://style.tidyverse.org for the full treatment with many examples. Of course, there is a package, `styler`, with functions that will style your code for you. See [here](https://r-pkgs.org/r.html?q=style#code-style) for more detail.

### Equations

When we use mathematical notation, we strive to make it as accurate and representative as possible. For example, we may write, "we will estimate the model below via least squares, where $\beta_1$ is our treatment effect estimate:

$$y_i= \alpha + \beta_1 Z_i + \beta_2 X_i + \beta_{[3-20]} B_i^{[3-20]}+ \epsilon_i".$$

Some stylistic notes embodied by this example:

1. Quantities that vary by unit are indexed with $i$.
2. For each unit $i$, for $j \in {3, ..., 20}$, each $B_i^j$ represents a different variable, perhaps one of 18 block indicators (though see [here](https://declaredesign.org/blog/biased-fixed-effects.html) before including such terms). Each $\beta_j$ represents the coefficient on one such variable. Each $B_i^j$ should be accompanied by a $\beta_j$. Another way to represent this would be to use a bold vector $\boldsymbol\beta$ and a bold $\boldsymbol B$. For another way that groups by variable type, see equation 4.1 on page 9 [here](http://www.stat.columbia.edu/~gelman/research/published/improving_mrp.pdf).  
3. For each variable, there should be a coefficient if we are going to estimate one. 
3. If there is only one coefficient represented by a particular Greek letter, it should not be numbered. See $\alpha$ above. 
4. It can be difficult to write good notation in Google Drive, e.g. (For example, I don’t see a way to make a bold $\beta$.) One suggestion is to write the equation in \LaTeX and export the equation or an image of the equation into your document. (You can do this via Mac OS Pages, e.g.)

### Statistical Quantities

- Where we report statistical significance, we do so relative to an $\alpha$ level on $[0, 1]$. E.g., "$\hat{\beta}_1$ is statistically significant at $\alpha = 0.05$."

## Projects {#sec-projects}

Create a `.Rproj` file in your project's top-level directory, making your
project an "R project". In RStudio, File - New Project - Existing Directory (or
New Directory, if no project folder exists).

Then, to start work, always open the `.Rproj` file. This ensures that you have a fresh
instance of R and RStudio, and the working directory is always the same. The working directory is the top-level directory (that is, the directory within which the `.Rproj` file lives).


## Working Directory and Relative Paths {#sec-working-dir}

The "working directory" is the directory where R will look for data, code files,
etc. and save your output objects (a new `.csv` or a plot `.pdf`) by default.

Opening the `.Rproj` file ensures that the working directory always starts at
the top-level directory of your project.

We create paths to our objects using the `here` package. This ensures that a) we
are not hard-coding a path that no one else has (like `~/Me/My
Docs/my_special_folder/my_subfolder/`, etc.), and b) our code is
platform-independent. For more on the `here` package, see
[here](https://github.com/jennybc/here_here).

The code below requires the following packages to be loaded and attached:


```r
library(here)
```

### See the working directory

To see the current working directory, type `getwd()`.

### See the project directory

The "project directory" is the top-level directory of your project. It should be the working directory, as well, if you follow the advice at \@ref(sec-projects), and start work by opening the `.Rproj` file. To see the project directory: 


```r
here()
```

```
## [1] "/Users/ryanmoore/Documents/github/thelab/LAB-SOP-experiments"
```

### Create a path with `here()`

I have an object called `02-01-df.RData` in a subdirectory called `/data/`. The
`dir()` function shows what is in that subdirectory:


```r
dir("data")
```

```
## [1] "02-01-df.RData"
```

To see its full path, 


```r
here("data", "02-01-df.RData")
```

```
## [1] "/Users/ryanmoore/Documents/github/thelab/LAB-SOP-experiments/data/02-01-df.RData"
```

To use that path to read in the data, I first create the path, then use it to
read in the object:


```r
my_rdata_path <- here("data", "02-01-df.RData")

# Use load() for an .RData object:
load(my_rdata_path) 
```

(These could be combined into a single line.)

The object `02-01-df.RData` contains a single dataframe called `df`. I can now see that dataframe in my environment:


```r
ls()
```

```
## [1] "df"            "my_rdata_path"
```

and examine it


```r
head(df)
```

```
##           x z         y
## 1 5.8873201 0 5.6125511
## 2 2.3428286 0 2.0830483
## 3 3.9439262 0 2.5861546
## 4 3.3373187 1 2.6527890
## 5 2.7946122 0 0.6784908
## 6 0.6943772 0 2.8216648
```

## What Packages are Installed?

To see what packages are installed, 


```r
library()
```

or 


```r
lapply(.libPaths(), dir)
```

```
## [[1]]
##   [1] "abind"         "askpass"       "assertthat"    "backports"    
##   [5] "bandit"        "base"          "base64enc"     "bayestestR"   
##   [9] "BH"            "bigmemory"     "bigmemory.sri" "bit"          
##  [13] "bit64"         "blob"          "blockTools"    "bookdown"     
##  [17] "boot"          "boxr"          "brew"          "brio"         
##  [21] "broman"        "broom"         "bslib"         "cachem"       
##  [25] "callr"         "car"           "carData"       "cellranger"   
##  [29] "class"         "classInt"      "cli"           "clipr"        
##  [33] "clock"         "cluster"       "cmm"           "codetools"    
##  [37] "coin"          "colorspace"    "commonmark"    "compiler"     
##  [41] "conflicted"    "cpp11"         "crayon"        "credentials"  
##  [45] "crosstalk"     "curl"          "data.table"    "datasets"     
##  [49] "datawizard"    "DBI"           "dbplyr"        "DeclareDesign"
##  [53] "desc"          "devtools"      "diagram"       "dials"        
##  [57] "DiceDesign"    "diffobj"       "digest"        "downlit"      
##  [61] "dplyr"         "DT"            "dtplyr"        "e1071"        
##  [65] "ellipsis"      "estimatr"      "evaluate"      "fabricatr"    
##  [69] "fansi"         "farver"        "fastmap"       "fontawesome"  
##  [73] "forcats"       "foreach"       "foreign"       "Formula"      
##  [77] "fs"            "furrr"         "future"        "future.apply" 
##  [81] "gam"           "gargle"        "generics"      "gert"         
##  [85] "ggplot2"       "gh"            "gitcreds"      "glmnet"       
##  [89] "globals"       "glue"          "googledrive"   "googlesheets4"
##  [93] "gower"         "GPfit"         "graphics"      "grDevices"    
##  [97] "grid"          "gridExtra"     "gtable"        "hardhat"      
## [101] "haven"         "here"          "highr"         "hms"          
## [105] "htmltools"     "htmlwidgets"   "httpuv"        "httr"         
## [109] "httr2"         "ids"           "infer"         "ini"          
## [113] "insight"       "ipred"         "isoband"       "iterators"    
## [117] "janitor"       "jomo"          "jquerylib"     "jsonlite"     
## [121] "kableExtra"    "KernSmooth"    "knitr"         "labeling"     
## [125] "later"         "lattice"       "lava"          "lazyeval"     
## [129] "lhs"           "libcoin"       "lifecycle"     "listenv"      
## [133] "lme4"          "lmtest"        "lubridate"     "magrittr"     
## [137] "markdown"      "MASS"          "Matching"      "Matrix"       
## [141] "MatrixModels"  "matrixStats"   "memoise"       "methods"      
## [145] "mgcv"          "mice"          "mime"          "miniUI"       
## [149] "minqa"         "mipfp"         "mitml"         "modeldata"    
## [153] "modelenv"      "modelr"        "modeltools"    "multcomp"     
## [157] "multitestr"    "munsell"       "mvtnorm"       "nlme"         
## [161] "nloptr"        "nnet"          "numDeriv"      "openssl"      
## [165] "ordinal"       "pan"           "parallel"      "parallelly"   
## [169] "parameters"    "parsnip"       "party"         "patchwork"    
## [173] "pbkrtest"      "pillar"        "pkgbuild"      "pkgconfig"    
## [177] "pkgdown"       "pkgload"       "plyr"          "png"          
## [181] "polspline"     "praise"        "prettyunits"   "processx"     
## [185] "prodlim"       "profvis"       "progress"      "progressr"    
## [189] "promises"      "proto"         "proxy"         "ps"           
## [193] "purrr"         "quantreg"      "R.methodsS3"   "R.oo"         
## [197] "R.utils"       "R6"            "ragg"          "randomForest" 
## [201] "randomizr"     "ranger"        "rappdirs"      "rcmdcheck"    
## [205] "RColorBrewer"  "Rcpp"          "RcppEigen"     "RcppTOML"     
## [209] "readr"         "readxl"        "recipes"       "rematch"      
## [213] "rematch2"      "remotes"       "renv"          "reprex"       
## [217] "reshape2"      "reticulate"    "rio"           "rlang"        
## [221] "rmarkdown"     "rmutil"        "roxygen2"      "rpart"        
## [225] "rprojroot"     "rsample"       "Rsolnp"        "rstudioapi"   
## [229] "rversions"     "rvest"         "sandwich"      "sass"         
## [233] "scales"        "selectr"       "sessioninfo"   "shape"        
## [237] "shiny"         "slider"        "snakecase"     "sourcetools"  
## [241] "SparseM"       "spatial"       "splines"       "SQUAREM"      
## [245] "stargazer"     "stats"         "stats4"        "stringi"      
## [249] "stringr"       "strucchange"   "survival"      "svglite"      
## [253] "synthpop"      "sys"           "systemfonts"   "tcltk"        
## [257] "testthat"      "textshaping"   "TH.data"       "tibble"       
## [261] "tidymodels"    "tidyr"         "tidyselect"    "tidyverse"    
## [265] "timechange"    "timeDate"      "tinytex"       "tools"        
## [269] "translations"  "truncnorm"     "tune"          "tzdb"         
## [273] "ucminf"        "urlchecker"    "usethis"       "utf8"         
## [277] "utils"         "uuid"          "vctrs"         "viridisLite"  
## [281] "vroom"         "waldo"         "warp"          "webshot"      
## [285] "whisker"       "withr"         "workflows"     "workflowsets" 
## [289] "writexl"       "xfun"          "xml2"          "xopen"        
## [293] "xtable"        "yaml"          "yardstick"     "zip"          
## [297] "zoo"
```



