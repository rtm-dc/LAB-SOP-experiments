# Managing Code

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

When we write in R, we tend to prefer the `tidyverse` style. See https://style.tidyverse.org for the full treatment with many examples. Of course, there is a package, `styler`, with functions that will style your code for you. See [here](https://r-pkgs.org/r.html?q=style#code-style) for more detail.


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
##   [1] "abind"          "askpass"        "assertthat"     "backports"     
##   [5] "base"           "base64enc"      "bit"            "bit64"         
##   [9] "blob"           "bookdown"       "boot"           "brew"          
##  [13] "brio"           "broom"          "bslib"          "cachem"        
##  [17] "callr"          "car"            "carData"        "cellranger"    
##  [21] "checkmate"      "class"          "cli"            "clipr"         
##  [25] "cluster"        "codetools"      "colorspace"     "commonmark"    
##  [29] "compiler"       "cpp11"          "crayon"         "credentials"   
##  [33] "crosstalk"      "curl"           "data.table"     "datasets"      
##  [37] "DBI"            "dbplyr"         "desc"           "devtools"      
##  [41] "diffobj"        "digest"         "directlabels"   "downlit"       
##  [45] "dplyr"          "DT"             "dtplyr"         "ellipsis"      
##  [49] "estimatr"       "evaluate"       "fabricatr"      "fansi"         
##  [53] "farver"         "fastmap"        "fontawesome"    "forcats"       
##  [57] "foreach"        "foreign"        "Formula"        "formula.tools" 
##  [61] "fs"             "gargle"         "generics"       "gert"          
##  [65] "ggplot2"        "gh"             "gitcreds"       "glue"          
##  [69] "googledrive"    "googlesheets4"  "graphics"       "grDevices"     
##  [73] "grid"           "gridExtra"      "gtable"         "haven"         
##  [77] "here"           "highr"          "hms"            "htmltools"     
##  [81] "htmlwidgets"    "httpuv"         "httr"           "ids"           
##  [85] "ini"            "isoband"        "iterators"      "jquerylib"     
##  [89] "jsonlite"       "KernSmooth"     "knitr"          "labeling"      
##  [93] "later"          "lattice"        "lazyeval"       "lifecycle"     
##  [97] "lme4"           "lmtest"         "lubridate"      "magrittr"      
## [101] "markdown"       "MASS"           "Matrix"         "MatrixModels"  
## [105] "memoise"        "methods"        "metR"           "mgcv"          
## [109] "mime"           "miniUI"         "minqa"          "modelr"        
## [113] "multitestr"     "munsell"        "nlme"           "nloptr"        
## [117] "nnet"           "numDeriv"       "openssl"        "operator.tools"
## [121] "parallel"       "pbkrtest"       "pillar"         "pkgbuild"      
## [125] "pkgconfig"      "pkgdown"        "pkgload"        "plyr"          
## [129] "png"            "praise"         "prettyunits"    "processx"      
## [133] "profvis"        "progress"       "promises"       "ps"            
## [137] "purrr"          "quadprog"       "quantreg"       "R6"            
## [141] "ragg"           "randomizr"      "rappdirs"       "rcmdcheck"     
## [145] "RColorBrewer"   "Rcpp"           "RcppEigen"      "readr"         
## [149] "readxl"         "rematch"        "rematch2"       "remotes"       
## [153] "renv"           "reprex"         "rlang"          "rmarkdown"     
## [157] "roxygen2"       "rpart"          "rprojroot"      "rstudioapi"    
## [161] "rversions"      "rvest"          "sandwich"       "sass"          
## [165] "scales"         "selectr"        "sessioninfo"    "shiny"         
## [169] "sourcetools"    "sp"             "SparseM"        "spatial"       
## [173] "splines"        "stats"          "stats4"         "stringi"       
## [177] "stringr"        "survival"       "sys"            "systemfonts"   
## [181] "tcltk"          "testthat"       "textshaping"    "tibble"        
## [185] "tidyr"          "tidyselect"     "tidyverse"      "timechange"    
## [189] "tinytex"        "tools"          "translations"   "tzdb"          
## [193] "urlchecker"     "usethis"        "utf8"           "utils"         
## [197] "uuid"           "vctrs"          "viridisLite"    "vroom"         
## [201] "waldo"          "whisker"        "withr"          "xfun"          
## [205] "xml2"           "xopen"          "xtable"         "yaml"          
## [209] "zip"            "zoo"
```



