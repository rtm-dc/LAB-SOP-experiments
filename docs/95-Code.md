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


``` r
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


``` r
# Use <- 

new_obj_name <- value_of_that_object

df <- df |> mutate()
```

8. Use the equals sign for setting argument values. The structure:


``` r
# Use =

mean(x, na.rm = TRUE)

# Use <- and =, as appropriate

mx <- mean(x, na.rm = TRUE)
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


``` r
library(here)
```

### See the working directory

To see the current working directory, type `getwd()`.

### See the project directory

The "project directory" is the top-level directory of your project. It should be the working directory, as well, if you follow the advice at \@ref(sec-projects), and start work by opening the `.Rproj` file. To see the project directory: 


``` r
here()
```

```
## [1] "/Users/ryanmoore/Documents/github/thelab/LAB-SOP-experiments"
```

### Create a path with `here()`

I have an object called `02-01-df.RData` in a subdirectory called `/data/`. The
`dir()` function shows what is in that subdirectory:


``` r
dir("data")
```

```
## [1] "02-01-df.RData"
```

To see its full path, 


``` r
here("data", "02-01-df.RData")
```

```
## [1] "/Users/ryanmoore/Documents/github/thelab/LAB-SOP-experiments/data/02-01-df.RData"
```

To use that path to read in the data, I first create the path, then use it to
read in the object:


``` r
my_rdata_path <- here("data", "02-01-df.RData")

# Use load() for an .RData object:
load(my_rdata_path) 
```

(These could be combined into a single line.)

The object `02-01-df.RData` contains a single dataframe called `df`. I can now see that dataframe in my environment:


``` r
ls()
```

```
## [1] "df"            "my_rdata_path"
```

and examine it


``` r
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


``` r
library()
```

or 


``` r
lapply(.libPaths(), dir)
```

```
## [[1]]
##   [1] "abind"          "animation"      "askpass"        "assertthat"    
##   [5] "backports"      "bandit"         "base"           "base64enc"     
##   [9] "bayestestR"     "BH"             "bit"            "bit64"         
##  [13] "bitops"         "blob"           "blockTools"     "bookdown"      
##  [17] "boot"           "boxr"           "brew"           "brio"          
##  [21] "broom"          "bslib"          "cachem"         "callr"         
##  [25] "car"            "carData"        "cellranger"     "checkmate"     
##  [29] "class"          "cli"            "clipr"          "clock"         
##  [33] "cluster"        "codetools"      "colorspace"     "commonmark"    
##  [37] "compiler"       "conflicted"     "cowplot"        "cpp11"         
##  [41] "crayon"         "credentials"    "crosstalk"      "curl"          
##  [45] "dagitty"        "data.table"     "datasets"       "datawizard"    
##  [49] "DBI"            "dbplyr"         "DeclareDesign"  "Deriv"         
##  [53] "desc"           "devtools"       "diagram"        "dials"         
##  [57] "DiceDesign"     "diffobj"        "digest"         "doBy"          
##  [61] "doFuture"       "downlit"        "dplyr"          "DT"            
##  [65] "dtplyr"         "ellipsis"       "estimatr"       "evaluate"      
##  [69] "fabricatr"      "fansi"          "farver"         "fastmap"       
##  [73] "fontawesome"    "forcats"        "foreach"        "foreign"       
##  [77] "Formula"        "fs"             "furrr"          "future"        
##  [81] "future.apply"   "gam"            "gargle"         "generics"      
##  [85] "gert"           "ggdag"          "ggforce"        "ggplot2"       
##  [89] "ggraph"         "ggrepel"        "gh"             "gitcreds"      
##  [93] "glmnet"         "globals"        "glue"           "goftest"       
##  [97] "googledrive"    "googlesheets4"  "gower"          "GPfit"         
## [101] "graphics"       "graphlayouts"   "grDevices"      "grid"          
## [105] "gridExtra"      "gtable"         "hardhat"        "haven"         
## [109] "here"           "highr"          "hms"            "htmltools"     
## [113] "htmlwidgets"    "httpuv"         "httr"           "httr2"         
## [117] "ids"            "igraph"         "infer"          "ini"           
## [121] "insight"        "ipred"          "isoband"        "iterators"     
## [125] "janitor"        "jomo"           "jose"           "jquerylib"     
## [129] "jsonlite"       "kableExtra"     "KernSmooth"     "knitr"         
## [133] "labeling"       "later"          "lattice"        "lava"          
## [137] "lazyeval"       "lhs"            "lifecycle"      "lintr"         
## [141] "listenv"        "litedown"       "lme4"           "lubridate"     
## [145] "magick"         "magrittr"       "maps"           "markdown"      
## [149] "MASS"           "Matching"       "Matrix"         "MatrixModels"  
## [153] "memoise"        "methods"        "mgcv"           "mice"          
## [157] "microbenchmark" "mime"           "miniUI"         "minqa"         
## [161] "mitml"          "modeldata"      "modelenv"       "modelr"        
## [165] "modelsummary"   "munsell"        "nlme"           "nloptr"        
## [169] "NLP"            "nnet"           "nortest"        "numDeriv"      
## [173] "olsrr"          "openssl"        "ordinal"        "pan"           
## [177] "parallel"       "parallelly"     "parameters"     "parsnip"       
## [181] "patchwork"      "pbkrtest"       "performance"    "pillar"        
## [185] "pkgbuild"       "pkgconfig"      "pkgdown"        "pkgload"       
## [189] "png"            "polyclip"       "praise"         "prettyunits"   
## [193] "processx"       "prodlim"        "profvis"        "progress"      
## [197] "progressr"      "promises"       "ps"             "purrr"         
## [201] "qss"            "quantreg"       "R.cache"        "R.methodsS3"   
## [205] "R.oo"           "R.utils"        "R6"             "ragg"          
## [209] "randomizr"      "rappdirs"       "rbibutils"      "rcmdcheck"     
## [213] "RColorBrewer"   "Rcpp"           "RcppArmadillo"  "RcppEigen"     
## [217] "RcppTOML"       "RCurl"          "Rdpack"         "readr"         
## [221] "readxl"         "recipes"        "reformulas"     "rematch"       
## [225] "rematch2"       "remotes"        "renv"           "reprex"        
## [229] "reticulate"     "rex"            "rio"            "rlang"         
## [233] "rmarkdown"      "roxygen2"       "rpart"          "rprojroot"     
## [237] "rsample"        "rstudioapi"     "rversions"      "rvest"         
## [241] "sass"           "scales"         "selectr"        "sessioninfo"   
## [245] "sfd"            "shape"          "shiny"          "slam"          
## [249] "slider"         "snakecase"      "SnowballC"      "sourcetools"   
## [253] "SparseM"        "sparsevctrs"    "spatial"        "splines"       
## [257] "SQUAREM"        "stargazer"      "stats"          "stats4"        
## [261] "stringi"        "stringr"        "styler"         "survival"      
## [265] "svglite"        "swirl"          "sys"            "systemfonts"   
## [269] "tables"         "tcltk"          "testthat"       "textshaping"   
## [273] "tibble"         "tidygraph"      "tidymodels"     "tidyr"         
## [277] "tidyselect"     "tidyverse"      "timechange"     "timeDate"      
## [281] "tinytable"      "tinytex"        "tm"             "tools"         
## [285] "translations"   "tune"           "tweenr"         "tzdb"          
## [289] "ucminf"         "urlchecker"     "usethis"        "utf8"          
## [293] "utils"          "uuid"           "V8"             "vctrs"         
## [297] "viridis"        "viridisLite"    "vroom"          "waldo"         
## [301] "warp"           "whisker"        "withr"          "wordcloud"     
## [305] "workflows"      "workflowsets"   "writexl"        "xfun"          
## [309] "xml2"           "xmlparsedata"   "xopen"          "xplorerr"      
## [313] "xtable"         "yaml"           "yardstick"      "zip"
```



