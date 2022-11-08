##lidR=group
##Rasterize terrain (LAScatalog)=name
##LAS_directory=folder
##Resolution=number 1
##CRS=crs 2180
##Chunk_size=number 0
##Chunk_buffer=number 30
##Output_directory=folder
##Output=output raster

ctg <- lidR::readLAScatalog(LAS_directory)
lidR::crs(ctg) <- CRS
lidR::plot(ctg)

ctg@output_options$drivers$Raster$param$overwrite <- TRUE

if(Chunk_size == 0) {
  lidR::opt_output_files(ctg) <- paste0(Output_directory, "/*")
} else {
  lidR::opt_output_files(ctg) <- paste0(Output_directory, "/chunk_{XLEFT}_{YBOTTOM}")
  lidR::opt_chunk_size(ctg) <- Chunk_size
}

lidR::opt_chunk_buffer(ctg) <- Chunk_buffer

Output = lidR::rasterize_terrain(ctg, Resolution, algorithm = lidR::tin(), pkg = "raster")