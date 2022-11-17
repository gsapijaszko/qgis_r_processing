##UAV=group
##Plan lotu (Litchi)=name
##ROI_shape=file
##AGL=number 100
##Gimbal_pitch=number -90
##Azimuth=number -1
##Output=output table
##showplots

# list.of.packages <- c("devtools")
# new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
# if(length(new.packages)) install.packages(new.packages)

# list.of.packages <- c("flightplanning")
# new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
# if(length(new.packages)) 
# devtools::install_github("gsapijaszko/flightplanning-R", force = TRUE, dependencies=TRUE,  method = "wget", extra = "-c --progress=bar:force")
library(flightplanning)
params = flightplanning::flight.parameters(height=AGL, flight.speed.kmh=24,
                                           side.overlap = 0.8, front.overlap = 0.8)

# Load SpatialDataFrame polygon
roi = sf::st_read(ROI_shape) |>
  sf::st_transform(crs = "EPSG:2180") |>
  sf::as_Spatial()

class(roi)
roi
wynik = "/home/tomasz/gis/dev/lot999.csv"
params
# Create the csv plan 
flightplanning::litchi.plan(roi,
                            wynik,
                            params,
                            gimbal.pitch.angle = Gimbal_pitch,
                            flight.lines.angle = Azimuth,
                            max.waypoints.distance = 400,
                            max.flight.time = 16)

Output = wynik