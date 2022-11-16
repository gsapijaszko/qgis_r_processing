##UAV=group
##Plan lotu=name
##ROI_shape=file
##Wysokosc=number 100
##Output=output table
##showplots

list.of.packages <- c("devtools")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

list.of.packages <- c("flightplanning")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) devtools::install_github("caiohamamura/flightplanning-R", dependencies=TRUE)

params = flightplanning::flight.parameters(height=Wysokosc,
                                           flight.speed.kmh=24,
                                           side.overlap = 0.8,
                                           front.overlap = 0.8)

params

# Load SpatialDataFrame polygon
roi = sf::st_read(ROI_shape) |>
  sf::st_transform(crs = "EPSG:2180") |>
  sf::as_Spatial()

class(roi)
roi
wynik = ("data/lot.csv")

# Create the csv plan 
flightplanning::litchi.plan(roi,
                            wynik,
                            params,
                            flight.lines.angle = -1,
                            max.waypoints.distance = 4000,
                            max.flight.time = 16)

Output = wynik

