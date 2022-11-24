##UAV=group
##Fly planing (Litchi)=name
##ROI_polygon=vector
##AGL=number 119
##GSD_cm=number
##Flight_speed_kmh=number 24
##Side_Overlap=number 0.8
##Front_Overlap=number 0.8
##Gimbal_pitch=number -90
##Azimuth=number -1
##Grid_Rotate_90_deg=boolean FALSE
##Max_Flight_Time_min=number 18
##Max_Waypoints_Distance_m=number 400
##Output_folder=folder
##Output_file_name=string "fly"
##Output_layer=output vector

# list.of.packages <- c("devtools")
# new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
# if(length(new.packages)) install.packages(new.packages)

# list.of.packages <- c("flightplanning")
# new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
# if(length(new.packages)) devtools::install_github("gsapijaszko/flightplanning-R", force = TRUE, dependencies=TRUE, method = "wget", extra = "-c --progress=bar:force")

# library(flightplanning)
params = flightplanning::flight.parameters(height = AGL,
#                                          gsd=GSD_cm,
                                           focal.length35 = 24,
                                           flight.speed.kmh = Flight_speed_kmh,
                                           side.overlap = Side_Overlap, 
                                           front.overlap = Front_Overlap)

# Load polygon
roi = ROI_polygon |>
  sf::st_as_sf()

if(nchar(Output_file_name) == 0) {
    Output_file_name <- "fly"
}

output <- paste0(Output_folder, "/", Output_file_name, ".csv")

# Create the csv plan 
flightplanning::litchi_sf(roi,
                            output,
                            params,
                            gimbal.pitch.angle = Gimbal_pitch,
                            flight.lines.angle = Azimuth,
                            max.waypoints.distance = Max_Waypoints_Distance_m,
                            max.flight.time = Max_Flight_Time_min,
                            grid = Grid_Rotate_90_deg)


if(!file.exists(output)) {
  output <- paste0(Output_folder, "/", Output_file_name, "_entire.csv")
} 

if(file.exists(output)) {
    Output_layer <- read.csv(output) |>
        sf::st_as_sf(coords = c("longitude", "latitude"), crs = 4326)
}
