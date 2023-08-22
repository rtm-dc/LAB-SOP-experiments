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
##   [1] "abind"         "askpass"       "backports"     "bandit"       
##   [5] "base"          "base64enc"     "bit"           "bit64"        
##   [9] "blob"          "blockTools"    "bookdown"      "boot"         
##  [13] "brew"          "brio"          "broom"         "bslib"        
##  [17] "cachem"        "callr"         "car"           "carData"      
##  [21] "cellranger"    "class"         "cli"           "clipr"        
##  [25] "clock"         "cluster"       "codetools"     "colorspace"   
##  [29] "commonmark"    "compiler"      "conflicted"    "cpp11"        
##  [33] "crayon"        "credentials"   "crosstalk"     "curl"         
##  [37] "data.table"    "datasets"      "DBI"           "dbplyr"       
##  [41] "DeclareDesign" "desc"          "devtools"      "diagram"      
##  [45] "dials"         "DiceDesign"    "diffobj"       "digest"       
##  [49] "downlit"       "dplyr"         "DT"            "dtplyr"       
##  [53] "ellipsis"      "estimatr"      "evaluate"      "fabricatr"    
##  [57] "fansi"         "farver"        "fastmap"       "fontawesome"  
##  [61] "forcats"       "foreach"       "foreign"       "Formula"      
##  [65] "fs"            "furrr"         "future"        "future.apply" 
##  [69] "gam"           "gargle"        "generics"      "gert"         
##  [73] "ggplot2"       "gh"            "gitcreds"      "globals"      
##  [77] "glue"          "googledrive"   "googlesheets4" "gower"        
##  [81] "GPfit"         "graphics"      "grDevices"     "grid"         
##  [85] "gridExtra"     "gtable"        "hardhat"       "haven"        
##  [89] "here"          "highr"         "hms"           "htmltools"    
##  [93] "htmlwidgets"   "httpuv"        "httr"          "httr2"        
##  [97] "ids"           "infer"         "ini"           "ipred"        
## [101] "isoband"       "iterators"     "jquerylib"     "jsonlite"     
## [105] "kableExtra"    "KernSmooth"    "knitr"         "labeling"     
## [109] "later"         "lattice"       "lava"          "lazyeval"     
## [113] "lhs"           "lifecycle"     "listenv"       "lme4"         
## [117] "lubridate"     "magrittr"      "markdown"      "MASS"         
## [121] "Matrix"        "MatrixModels"  "memoise"       "methods"      
## [125] "mgcv"          "mime"          "miniUI"        "minqa"        
## [129] "modeldata"     "modelenv"      "modelr"        "munsell"      
## [133] "mvtnorm"       "nlme"          "nloptr"        "nnet"         
## [137] "numDeriv"      "openssl"       "parallel"      "parallelly"   
## [141] "parsnip"       "patchwork"     "pbkrtest"      "pillar"       
## [145] "pkgbuild"      "pkgconfig"     "pkgdown"       "pkgload"      
## [149] "plyr"          "png"           "praise"        "prettyunits"  
## [153] "processx"      "prodlim"       "profvis"       "progress"     
## [157] "progressr"     "promises"      "ps"            "purrr"        
## [161] "quantreg"      "R6"            "ragg"          "randomizr"    
## [165] "rappdirs"      "rcmdcheck"     "RColorBrewer"  "Rcpp"         
## [169] "RcppEigen"     "readr"         "readxl"        "recipes"      
## [173] "rematch"       "rematch2"      "remotes"       "renv"         
## [177] "reprex"        "reshape2"      "rlang"         "rmarkdown"    
## [181] "roxygen2"      "rpart"         "rprojroot"     "rsample"      
## [185] "rstudioapi"    "rversions"     "rvest"         "sass"         
## [189] "scales"        "selectr"       "sessioninfo"   "shape"        
## [193] "shiny"         "slider"        "sourcetools"   "SparseM"      
## [197] "spatial"       "splines"       "SQUAREM"       "stargazer"    
## [201] "stats"         "stats4"        "stringi"       "stringr"      
## [205] "survival"      "svglite"       "sys"           "systemfonts"  
## [209] "tcltk"         "testthat"      "textshaping"   "tibble"       
## [213] "tidymodels"    "tidyr"         "tidyselect"    "tidyverse"    
## [217] "timechange"    "timeDate"      "tinytex"       "tools"        
## [221] "translations"  "tune"          "tzdb"          "urlchecker"   
## [225] "usethis"       "utf8"          "utils"         "uuid"         
## [229] "vctrs"         "viridisLite"   "vroom"         "waldo"        
## [233] "warp"          "webshot"       "whisker"       "withr"        
## [237] "workflows"     "workflowsets"  "xfun"          "xml2"         
## [241] "xopen"         "xtable"        "yaml"          "yardstick"    
## [245] "zip"
```



