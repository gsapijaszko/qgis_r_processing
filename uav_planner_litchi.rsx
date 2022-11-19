##UAV=group
##Plan lotu (Litchi)=name
##ROI_polygon=vector
##AGL=number 119
##GSD_cm=number
##Side_Overlap=number 0.8
##Front_Overlap=number 0.8
##Gimbal_pitch=number -90
##Azimuth=number -1
##Grid_Rotate_90_deg=boolean FALSE
##Output_folder=folder
##Output_file_name=string "fly"
##Output_layer=output vector

# devtools::install_github("gsapijaszko/flightplanning-R", force = TRUE, dependencies=TRUE,  method = "wget", extra = "-c --progress=bar:force")
# library(flightplanning)
params = flightplanning::flight.parameters(height = AGL,
#                                          gsd=GSD_cm,
                                            focal.length35 = 24,
                                            flight.speed.kmh = 24,
                                           side.overlap = Side_Overlap, 
                                            front.overlap = Front_Overlap)

# Load SpatialDataFrame polygon
roi = ROI_polygon |> sf::st_transform(crs = "EPSG:2180") |>
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
                            max.flight.time = 18,
                            grid = Grid_Rotate_90_deg)


if(!file.exists(output)) {
  output <- paste0(Output_folder, "/", Output_file_name, "_entire.csv")
} 

if(file.exists(output)) {
    Output_layer <- read.csv(output) |>
        sf::st_as_sf(coords = c("longitude", "latitude"), crs = 4326)
}
