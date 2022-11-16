##lidR=group
##Detect tree top with LMF (variable window size)=name
##LAS_file=file
##CRS=crs 1
##Output=output vector
library(lidR)
library(stringr)
# Ustawienia i funkcje pomocnicze ----
f <- function(x) {
  y <- 2.6 * (-(exp(-0.08*(x-2)) - 1)) + 3
  y[x < 2] <- 3
  y[x > 20] <- 5
  return(y)
}
# Wczytanie danych ----
las = lidR::readLAS(LAS_file)
lidR::crs(las) <- CRS
nlas <- normalize_height(las, knnidw())
ttops <- locate_trees(nlas, lmf(f))
# Output ----
Output = ttops
