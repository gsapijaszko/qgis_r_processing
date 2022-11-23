# R processing scripts for QGIS - *Work in progress* 

These scripts uses [lidR](https://cran.r-project.org/web/packages/lidR/index.html) and [lidRplugins](https://github.com/Jean-Romain/lidRplugins) packages to process LAS/LAZ files and catalogs.

### uav_planner_litchi.rsx

Script to create UAV flying plan for Litchi, it uses the modified [{flightplaner}](https://github.com/gsapijaszko/flightplanning-R) package.

### lidR_Convert_LAZ_2_LAS.rsx

As the name suggests, it converts a directory of .LAZ files to .LAS (uncompressed) files with optional filter. More on filters in [lidR Book](https://r-lidar.github.io/lidRbook/io.html#filter)

### lidR_Delineate_lakes.rsx

Just a wrapper for `delineate_lakes()` function from `lidRplugins` package.

### lidR_Rasterize_terrain.rsx

Rasterizes terrain for LAScatalog object with additional options.
