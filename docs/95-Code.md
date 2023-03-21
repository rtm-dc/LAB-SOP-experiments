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
##   [5] "base"           "base64enc"      "BH"             "bit"           
##   [9] "bit64"          "blob"           "blockTools"     "bookdown"      
##  [13] "boot"           "boxr"           "brew"           "brio"          
##  [17] "broom"          "bslib"          "cachem"         "callr"         
##  [21] "car"            "carData"        "cellranger"     "checkmate"     
##  [25] "class"          "cli"            "clipr"          "cluster"       
##  [29] "codetools"      "collections"    "colorspace"     "commonmark"    
##  [33] "compiler"       "config"         "cpp11"          "crayon"        
##  [37] "credentials"    "crosstalk"      "curl"           "cyclocomp"     
##  [41] "data.table"     "datasets"       "DBI"            "dbplyr"        
##  [45] "desc"           "devtools"       "diffobj"        "digest"        
##  [49] "directlabels"   "downlit"        "dplyr"          "DT"            
##  [53] "dtplyr"         "ellipsis"       "estimatr"       "evaluate"      
##  [57] "fabricatr"      "fansi"          "farver"         "fastmap"       
##  [61] "fontawesome"    "forcats"        "foreach"        "foreign"       
##  [65] "forge"          "Formula"        "formula.tools"  "fs"            
##  [69] "gargle"         "generics"       "gert"           "ggplot2"       
##  [73] "gh"             "gitcreds"       "globals"        "glue"          
##  [77] "googledrive"    "googlesheets4"  "graphics"       "grDevices"     
##  [81] "grid"           "gridExtra"      "gtable"         "haven"         
##  [85] "here"           "highr"          "hms"            "htmltools"     
##  [89] "htmlwidgets"    "httpgd"         "httpuv"         "httr"          
##  [93] "ids"            "ini"            "isoband"        "iterators"     
##  [97] "janitor"        "jquerylib"      "jsonlite"       "KernSmooth"    
## [101] "knitr"          "labeling"       "languageserver" "later"         
## [105] "lattice"        "lazyeval"       "lifecycle"      "lintr"         
## [109] "lme4"           "lmtest"         "lubridate"      "magrittr"      
## [113] "markdown"       "MASS"           "Matrix"         "MatrixModels"  
## [117] "memoise"        "methods"        "metR"           "mgcv"          
## [121] "mime"           "miniUI"         "minqa"          "modelr"        
## [125] "multitestr"     "munsell"        "nlme"           "nloptr"        
## [129] "nnet"           "numDeriv"       "odbc"           "openssl"       
## [133] "openxlsx"       "operator.tools" "parallel"       "pbkrtest"      
## [137] "pillar"         "pkgbuild"       "pkgconfig"      "pkgdown"       
## [141] "pkgload"        "plyr"           "png"            "praise"        
## [145] "prettyunits"    "processx"       "profvis"        "progress"      
## [149] "promises"       "ps"             "purrr"          "quadprog"      
## [153] "quantreg"       "R.cache"        "R.methodsS3"    "R.oo"          
## [157] "R.utils"        "r2d3"           "R6"             "ragg"          
## [161] "randomizr"      "rappdirs"       "rcmdcheck"      "RColorBrewer"  
## [165] "Rcpp"           "RcppEigen"      "RcppTOML"       "readr"         
## [169] "readxl"         "rematch"        "rematch2"       "remotes"       
## [173] "renv"           "reprex"         "reticulate"     "rex"           
## [177] "rio"            "rJava"          "rlang"          "rmarkdown"     
## [181] "roxygen2"       "rpart"          "rprojroot"      "rstudioapi"    
## [185] "rversions"      "rvest"          "sandwich"       "sass"          
## [189] "scales"         "selectr"        "sessioninfo"    "shiny"         
## [193] "snakecase"      "sourcetools"    "sp"             "sparklyr"      
## [197] "SparseM"        "spatial"        "splines"        "stats"         
## [201] "stats4"         "stringi"        "stringr"        "styler"        
## [205] "survival"       "sys"            "systemfonts"    "tcltk"         
## [209] "testthat"       "textshaping"    "tibble"         "tidyr"         
## [213] "tidyselect"     "tidyverse"      "timechange"     "tinytex"       
## [217] "tools"          "translations"   "tzdb"           "urlchecker"    
## [221] "usethis"        "utf8"           "utils"          "uuid"          
## [225] "vctrs"          "viridisLite"    "vroom"          "vscDebugger"   
## [229] "waldo"          "whisker"        "withr"          "xfun"          
## [233] "xlsxjars"       "xml2"           "xmlparsedata"   "xopen"         
## [237] "xtable"         "yaml"           "zip"            "zoo"
```



