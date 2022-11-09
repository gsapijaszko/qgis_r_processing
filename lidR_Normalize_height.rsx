##lidR=group
##Normalize height (LAScatalog, tin())=name
##LAS_directory=folder
##CRS=crs 2180
##Chunk_size=number 0
##Chunk_buffer=number 30
##Output_directory=folder
library(lidR)
ctg <- lidR::readLAScatalog(LAS_directory)
lidR::crs(ctg) <- CRS
lidR::plot(ctg)

if(Chunk_size == 0) {
  lidR::opt_output_files(ctg) <- paste0(Output_directory, "/{*}_norm")
} else {
  lidR::opt_output_files(ctg) <- paste0(Output_directory, "/norm_{XLEFT}_{YBOTTOM}")
  lidR::opt_chunk_size(ctg) <- Chunk_size
}

lidR::opt_chunk_buffer(ctg) <- Chunk_buffer
lidR::normalize_height(ctg, tin())