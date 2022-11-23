
# diagram -------------------------------------------------------------------------------------

DiagrammeR::DiagrammeR("graph TB;
 A(LAS catalog)-->R(r - DTM, r); 
 A --> L(l - delineated areas, v)
 A --> V(v - water areas, v)
 L --> i[intersects]
 V --> i
 i-->W(w - delineated water only, v);
 R-->al[extract mean altitude from DEM under water areas and bind to vector]
 al-->W;
 W-->RA[ra - rasterize it, r];
 RA-->RB(rb, substitute DTM values with mean water altitude, r);
 R-->RB")

# implementation ------------------------------------------------------------------------------

r <- terra::vrt("data/dtm/rasterize_terrain.vrt")

l <- lidR::readLAScatalog("data/las/") |>
  lidRplugins::delineate_lakes(tol = 1/1000, tol2 = c(1/10^6, 2/10^4)) |>
  terra::vect(l) |>
  terra::project(terra::crs(r))

terra::plot(r, col = grDevices::gray.colors(50), mar = c(3, 6, 2, 6.4), plg = list(loc = "left"))
terra::plot(l, add = TRUE)

v <- lidR::readLAScatalog("data/las/", filter = "-keep_class 9") |>
  lidR::rasterize_density() |>
  terra::as.polygons() |>
  terra::subset(density > 0, NSE = TRUE) |>
  terra::project(terra::crs(r))

w <- l |>
  subset(terra::is.related(l, v, relation = "intersects"))
terra::writeVector(w, "data/w.gpkg", overwrite = TRUE)

terra::plot(r, col = grDevices::gray.colors(50), mar = c(3, 6, 2, 6.4), plg = list(loc = "left"))
terra::plot(w, add = TRUE)
terra::plot(ra, add = TRUE,
            plg = list(loc = "right"))


w <- terra::extract(r, w, fun=min, bind = TRUE, na.rm=TRUE)
w <- setNames(w, "mean_height")
terra::values(w)

ra <- r
ra[] <- NA

ra <- terra::rasterize(w,ra, field = w$mean_height)
terra::writeRaster(ra, file = "data/ra.tif", overwrite = TRUE)
terra::plot(ra, add = TRUE)

indx <- !is.na(ra)
rb <- r
rb[indx] <- ra[indx]
terra::writeRaster(rb, file = "data/rb.tif", overwrite = TRUE)


r_prod <- terra::terrain(r, v = c("slope", "aspect"), unit = "radians")
r_hillshade <- terra::shade(slope = r_prod$slope, aspect = r_prod$aspect)
terra::plot(r_hillshade, col = gray(0:50/50), legend = FALSE, 
     xlim = c(385000, 386000),
     ylim = c(409500, 410500))


# bzdury --------------------------------------------------------------------------------------


i <- v |>
  terra::subst(from = 0, to = NA)

i[which(terra::values(i) > 0)] <- 1

terra::plot(i, col = "black")

l@ptr$boundary()

# cd
