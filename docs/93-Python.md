# Python Basics (using R/RStudio)

## Installing tools, R packages, and Python

Posit provides instructions for using Python from RStudio (including `.py` files, and Python and R in the same document) at

https://support.posit.co/hc/en-us/articles/1500007929061-Using-Python-with-the-RStudio-IDE

### Get Rtools

You will need some developer tools. If you are on Windows, download the installer and click the `.exe` to install the latest version of Rtools from 

https://cran.rstudio.com/bin/windows/Rtools/rtools43/rtools.html

### Get `tinytex`

Install the `tinytex` package (and `tinytex` itself) at the R Console via


```r
install.packages("tinytex")
tinytex::install_tinytex()
```

### Get Python

Download and install Python from

https://www.python.org/downloads/

### Configure Python

Via, e.g., 


```zsh
./configure --enable-shared
make
make install
```

### Get `reticulate`

Install the `reticulate` package at the R Console via


```r
install.packages("reticulate")
```

## Using Python

### From a Python prompt


```r
reticulate::repl_python()
```

### From inside a Quarto document


