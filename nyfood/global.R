library("mongolite")
library(leaflet)
library(dplyr)
library(shiny)
library(shinythemes)

func_data <- function(meilleur_resto){
  df_resto <- as.data.frame(meilleur_resto)
  names(df_resto)[names(df_resto) == "_id"] <- "Caract"
  
  v <- c()
  
  for (i in 1:10){
    v <- append(v, unlist(df_resto$Caract$Coord[i]))
  }
  
  longitude <- c()
  latitude <- c()
  
  for (i in c(1,3,5,7,9,11,13,15,17,19)){
    longitude <- append(longitude, v[i][1])
  }
  for (i in c(2,4,6,8,10,12,14,16,18,20)){
    latitude <- append(latitude, v[i][1])
  }
  
  df_resto$longitude <- longitude
  df_resto$latitude <- latitude
  
  
  
  
  
  for (i in 1:nrow(df_resto)){
    df_resto$content[i] <- paste(sep = "<br/>",
                                          paste("Nom du restaurant : ", as.character(df_resto$Caract$Restaurants[i])),
                                          paste("Quartier : ", as.character(df_resto$Caract$Quartier[i])),
                                          paste("Avenue : ", as.character(df_resto$Caract$Avenue[i])),
                                          paste("Type de cuisine : ", as.character(df_resto$Caract$Cuisine[i])),
                                          paste("Moyenne obtenue : ", as.character(df_resto$moyenne_score[i])))
  }
  
  
  ColorPal <- colorNumeric(c("red", "orange", "green"), domain = df_resto$moyenne_score)(df_resto$moyenne_score)
  
  df_resto$col <- ColorPal
  return(df_resto)
}

new_york <- c(-73.87332738625761, 40.7561057525584)
