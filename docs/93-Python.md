# Python Basics (using R/RStudio)

## Installing tools, R packages, and Python

For reference, Posit provides instructions for using Python from RStudio (including `.py` files, and Python and R in the same document) at

https://support.posit.co/hc/en-us/articles/1500007929061-Using-Python-with-the-RStudio-IDE

Follow the key steps below.

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

* You should tick "add python to PATH"
* Depending on the configuration of your machine, you may need to install _not_ as an admin


### Configure Python

From the RStudio menus, Tools -> Global Options -> Python -> Select -> (select one) -> OK.

Now restart RStudio.

### Get `reticulate`

Install the `reticulate` package at the R Console via


```r
install.packages("reticulate")
```

## Using Python

### From a Python prompt

To open a Python prompt from within R:


```r
reticulate::repl_python()
```

### From inside a Quarto document

Quarto documents can run both R and Python code.

From the RStudio menus, File -> New File -> Quarto Document. Name and save the `.qmd` file. 

Then, edit one of the code chunks to run `python` instead of `r`. Knit the `.qmd` to (e.g.) `.html` and see the output. Your Quarto document has run both R and Python. Here's some sample Python code:


```python
import pandas as pd

df = pd.read_csv("test.csv")

df.shape
```

To run code from a `.py` in a Python chunk:


```python
source("python.py")
```

To run a `.py` file from an R chunk:


```r
reticulate::source_python("python.py")
```




