##lidR=group
##LAZ_Folder=folder
##Filter=optional string "-keep_class 2 9"
##Create_index=selection TRUE;FALSE TRUE
##Output_directory=folder

convertLAZ <- function(lazfile, outdir = "", filter = "") {
  if(!dir.exists({{outdir}})) { dir.create({{outdir}}, recursive = TRUE)}
  print(lazfile)
  las <- lidR::readLAS(files = {{lazfile}}, filter = {{filter}})
  .file <- stringi::stri_replace_all_regex({{lazfile}}, "^.*/", "")
  lidR::writeLAS(las, file = paste0({{outdir}}, "/", stringi::stri_replace_all_fixed(.file, "laz", "las")), index = Create_index)
}

f <- list.files(LAZ_Folder, pattern = "*.laz", full.names = TRUE)
lapply(f, convertLAZ, outdir = Output_directory)
