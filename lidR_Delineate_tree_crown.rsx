##lidR=group
##Tree crown delineate=name
##LAS_directory=folder
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
ctg <- lidR::readLAScatalog(LAS_directory)
lidR::crs(ctg) <- CRS
# CHM i jego wygładzenie ----
nlas <- normalize_height(ctg, knnidw())
chm_p2r_05 <- rasterize_canopy(nlas, 0.5, p2r(subcircle = 0.2), pkg = "terra")
kernel <- matrix(1,3,3)
chm_p2r_05_smoothed <- terra::focal(chm_p2r_05, w = kernel, fun = median, na.rm = TRUE)
# Wierzchołki ----
ttops <- locate_trees(nlas, lmf(f))
algo <- dalponte2016(chm_p2r_05_smoothed, ttops)
# Segmentacja ----
ctg <- segment_trees(las, algo) # segment point cloud
# Obrysy ----
crowns <- crown_metrics(las, func = .stdtreemetrics, geom = "convex")
Output = crowns