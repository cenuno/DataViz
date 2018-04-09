Data Visualizations
================
Cristian E. Nuno
April 09, 2018

-   [Reshaping `iris` into Tidy Format](#reshaping-iris-into-tidy-format)

Reshaping `iris` into Tidy Format
=================================

> Tidy datasets are easy to manipulate, model and visualise, and have a specific structure: each variable is a column, each observation is a row, and each type of observational unit is a table. - Hadley Wickham

Using the concepts laid out in [Tidy Data](http://vita.had.co.nz/papers/tidy-data.pdf), I reshape [Edgar Anderson's `iris` Data](https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/iris.html).

``` r
# load library
library( tidyverse )
```

    ## ── Attaching packages ───────────────────── tidyverse 1.2.1 ──

    ## ✔ ggplot2 2.2.1     ✔ purrr   0.2.4
    ## ✔ tibble  1.4.2     ✔ dplyr   0.7.4
    ## ✔ tidyr   0.8.0     ✔ stringr 1.3.0
    ## ✔ readr   1.1.1     ✔ forcats 0.3.0

    ## ── Conflicts ──────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
# view structure of iris
str( datasets::iris )
```

    ## 'data.frame':    150 obs. of  5 variables:
    ##  $ Sepal.Length: num  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
    ##  $ Sepal.Width : num  3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
    ##  $ Petal.Length: num  1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
    ##  $ Petal.Width : num  0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
    ##  $ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...

`iris` contains 150 rows by 5 columns. Each row contains **multiple** measurement values by each observation.

Below demonstrates how to transfrom `iris` so that each row contains **one** measurement value by each observation.

``` r
# reshape iris
# to long format
# where each row represents a measurement
# of type (Length, Width)
# by each part (Sepal, Petal)
# for each Species (setosa, virginica, versicolor)
iris.tidy <-
  iris %>%
  gather( key = "Measure"
          , value = "Value"
          , -Species ) %>% 
  separate( col = Measure
            , into = c("Part", "Measure")
            , sep = "\\." )

# view results
str( iris.tidy )
```

    ## 'data.frame':    600 obs. of  4 variables:
    ##  $ Species: Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ Part   : chr  "Sepal" "Sepal" "Sepal" "Sepal" ...
    ##  $ Measure: chr  "Length" "Length" "Length" "Length" ...
    ##  $ Value  : num  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...

`iris.tidy` contains 600 rows by 4 columns.

The number of rows in `iris.tidy` grew by 4 because the use of [`gather()`](https://www.rdocumentation.org/packages/tidyr/versions/0.8.0/topics/gather) combined the Sepal.Length, Sepal.Width, Petal.Length, Petal.Width values into the newly created `Value` column.

At the same time, `iris.tidy` retains two important distinctions:

1.  Measurement type - length or width - in the newly created `Measure` column; and

2.  Flower part - sepal or petal - in the newly created `Part` column.

Each row in `iris.tidy` now follows the tenants of being tidy since each row contains **one** measurement value by each observation.

``` r
# visualize results
ggplot( data = iris.tidy
        , aes( x = Measure, y = Value, col = Species ) ) +
  geom_jitter() +
  facet_grid( facets = . ~ Species )
```

![](README_files/figure-markdown_github/Visualize%20Tidy%20Iris-1.png)
