##lidR=group
##Tree crown delineate=name
##LAS_file=file
##CRS=crs 1
##Output=output vector
library(lidR)
library(stringr)
las = lidR::readLAS(LAS_file)
lidR::crs(las) <- CRS
# Ustawienia i funkcje pomocnicze ----
f <- function(x) {
  y <- 2.6 * (-(exp(-0.08*(x-2)) - 1)) + 3
  y[x < 2] <- 3
  y[x > 20] <- 5
  return(y)
}
# CHM i jego wygładzenie ----
nlas <- normalize_height(las, knnidw())
chm_p2r_05 <- rasterize_canopy(nlas, 0.5, p2r(subcircle = 0.2), pkg = "terra")
kernel <- matrix(1,3,3)
chm_p2r_05_smoothed <- terra::focal(chm_p2r_05, w = kernel, fun = median, na.rm = TRUE)
# Wierzchołki ----
ttops <- locate_trees(nlas, lmf(f))
algo <- dalponte2016(chm_p2r_05_smoothed, ttops)
# Segmentacja ----
drzewa <- segment_trees(nlas, algo) # segment point cloud
# Obrysy ----
crowns <- crown_metrics(drzewa, func = .stdtreemetrics, geom = "convex")
Output = crowns