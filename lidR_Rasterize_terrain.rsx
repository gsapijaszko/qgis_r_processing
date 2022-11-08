##lidR=group
##LAS_file=file
##Resolution=number 1
##Output=output raster

l = lidR::readLAS(LAS_file)
Output = lidR::rasterize_terrain(l, Resolution, pkg = "raster")