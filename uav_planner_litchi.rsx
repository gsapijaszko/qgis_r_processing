##UAV=group
##Plan lotu (Litchi)=name
##ROI_shape=vector
##AGL=number 100
##Gimbal_pitch=number -90
##Azimuth=number -1
##Output_folder=folder
##Output_file_name=string "fly"
##Output_layer=output vector

# list.of.packages <- c("devtools")
# new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
# if(length(new.packages)) install.packages(new.packages)

# list.of.packages <- c("flightplanning")
# new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
# if(length(new.packages)) 
devtools::install_github("gsapijaszko/flightplanning-R", force = TRUE, dependencies=TRUE,  method = "wget", extra = "-c --progress=bar:force")
# library(flightplanning)
params = flightplanning::flight.parameters(height=AGL, flight.speed.kmh=24,
                                           side.overlap = 0.8, front.overlap = 0.8)

# Load SpatialDataFrame polygon
roi = ROI_shape |>
  sf::st_transform(crs = "EPSG:2180") |>
  sf::as_Spatial()
if(nchar(Output_file_name) == 0) {
    Output_file_name <- "fly"
}

output = paste0(Output_folder, "/", Output_file_name, ".csv")

# Create the csv plan 
flightplanning::litchi.plan(roi,
                            output,
                            params,
                            gimbal.pitch.angle = Gimbal_pitch,
                            flight.lines.angle = Azimuth,
                            max.waypoints.distance = 400,
                            max.flight.time = 16)


if(!file.exists(output)) {
  output <- paste0(Output_folder, "/", Output_file_name, "_entire.csv")
} 

if(file.exists(output)) {
    Output_layer <- read.csv(output) |>
        sf::st_as_sf(coords = c("longitude", "latitude"), crs = 4326)
}
