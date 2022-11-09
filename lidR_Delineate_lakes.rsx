##lidR=group
##Delineate lakes (LAScatalog)=name
##LAS_directory=folder
##CRS=crs 1
##tol=number 0.001
##tol2.1=number 0.00033
##tol2.2=number 0.002
##trim=number 1000
##p=number 0.5
##res=number 5
##th1=number 25
##th2=number 6
##k=number 10
##Output=output vector

ctg <- lidR::readLAScatalog(LAS_directory)
lidR::crs(ctg) <- CRS

Output = lidRplugins::delineate_lakes(ctg,
  tol = tol,
  tol2 = c(tol2.1, tol2.2),
  trim = trim,
  p = p,
  res = res,
  th1 = th1,
  th2 = th2,
  k = k) |>
  sf::st_as_sf()

