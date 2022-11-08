##lidR=group
##Convert LAZ to LAS (directory)=name
##LAZ_directory=folder
##Filter=optional string "-keep_class 2 9"
##Create_index=selection TRUE;FALSE TRUE
##Output_directory=folder

convertLAZ <- function(lazfile, outdir = "", filter = "", index = "") {
  if(index == 0) { .i = TRUE }
    else { .i = FALSE }

  if(!dir.exists({{outdir}})) { dir.create({{outdir}}, recursive = TRUE)}
  print(lazfile)
  las <- lidR::readLAS(files = {{lazfile}}, filter = {{filter}})
  .file <- stringi::stri_replace_all_regex({{lazfile}}, "^.*/", "")
  lidR::writeLAS(las, file = paste0({{outdir}}, "/", stringi::stri_replace_all_fixed(.file, "laz", "las")), index = .i)
}

f <- list.files(LAZ_directory, pattern = "*.laz", full.names = TRUE)
lapply(f, convertLAZ, outdir = Output_directory, filter = Filter, index = Create_index)
