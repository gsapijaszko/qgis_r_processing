##lidR=group
##Tree crown delineate=name
##LAS_directory=folder
##CRS=crs 1
##Chunk_size=number 0
##Chunk_buffer=number 30
##Output_directory=folder
##Output=output vector


# data download and preparation ---------------------------------------------------------------
dane <- c(
  "https://opendata.geoportal.gov.pl/NumDaneWys/DanePomiaroweLAZ/74960/74960_1080723_M-33-23-B-c-4-2-1.laz",
  "https://opendata.geoportal.gov.pl/NumDaneWys/DanePomiaroweLAZ/74960/74960_1080724_M-33-23-B-c-4-2-2.laz",
  "https://opendata.geoportal.gov.pl/NumDaneWys/DanePomiaroweLAZ/74960/74960_1080725_M-33-23-B-c-4-2-3.laz",
  "https://opendata.geoportal.gov.pl/NumDaneWys/DanePomiaroweLAZ/74960/74960_1080726_M-33-23-B-c-4-2-4.laz")

# dorobić

# def -----------------------------------------------------------------------------------------
LAS_directory <- "data/las/"
CRS <- "EPSG:2180"
Output_directory <- "data/norm"
Chunk_size <- 0
# a -------------------------------------------------------------------------------------------

# clean up output dir
f <- list.files(path = Output_directory, recursive = TRUE, full.names = TRUE)
sapply(f, unlink)

library(lidR)
# library(stringr)
# Ustawienia i funkcje pomocnicze ----
f <- function(x) {
  y <- 2.6 * (-(exp(-0.08*(x-2)) - 1)) + 3
  y[x < 2] <- 3
  y[x > 20] <- 5
  return(y)
}
ctg <- lidR::readLAScatalog(LAS_directory)
lidR::crs(ctg) <- CRS

# ctg@output_options$drivers$Raster$param$overwrite <- TRUE
# ctg_norm@output_options$drivers$SpatVector$param$overwrite  <- TRUE
# ctg_norm@output_options$drivers$sf$delete_dsn <- TRUE

# CHM i jego wygładzenie ----
if(Chunk_size == 0) {
  lidR::opt_output_files(ctg) <- paste0(Output_directory, "/*")
} else {
  lidR::opt_output_files(ctg) <- paste0(Output_directory, "chunk_{XLEFT}_{YBOTTOM}")
  lidR::opt_chunk_size(ctg) <- Chunk_size
}

ctg_norm <- normalize_height(ctg, knnidw())
chm_p2r_05 <- rasterize_canopy(ctg_norm, 0.5, p2r(subcircle = 0.2), pkg = "terra")

kernel <- matrix(1,3,3)
chm_p2r_05_smoothed <- terra::focal(chm_p2r_05, w = kernel, fun = median, na.rm = TRUE)
# Wierzchołki ----
ctg_norm@output_options$drivers$sf$param$delete_dsn <- TRUE
ctg_norm@output_options$drivers$sf$extension <- ".gpkg"
ttops <- locate_trees(ctg_norm, lmf(f), uniqueness = "bitmerge")
if(is.character(ttops)) {
  ttops <- lapply(ttops, sf::read_sf)
  ttops <- do.call(rbind, ttops)
  ttops <- ttops[!duplicated(ttops["treeID"]),]
}

algo <- dalponte2016(chm_p2r_05_smoothed, ttops)
algo
# Segmentacja ----
opt_output_files(ctg_norm) <- paste0(Output_directory, "/{*}_segmented")
ctg_segmented <- segment_trees(ctg_norm, algo) # segment point cloud

# dotąd działa, niżej się wywala z błędem -----------------------------------------------------

# Obrysy ----
crowns <- crown_metrics(ctg_segmented, func = .stdtreemetrics, geom = "convex")
Output = crowns