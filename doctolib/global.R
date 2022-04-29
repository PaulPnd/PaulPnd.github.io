library("mongolite")
library(leaflet)
library(dplyr)
library(shiny)
library(shinythemes)

url="mongodb://etudiant:ur2@clusterm1-shard-00-00.0rm7t.mongodb.net:27017,clusterm1-shard-00-01.0rm7t.mongodb.net:27017,clusterm1-shard-00-02.0rm7t.mongodb.net:27017/?ssl=true&replicaSet=atlas-l4xi61-shard-0"


doctolib = mongo(collection="dump_Jan2022", db="doctolib",
                 url=url,
                 verbose=TRUE)


################## doctolib_rennes_first


query <- '[{"$geoNear" : { "near" : {"type": "Point", "coordinates": [-1.6776809942162452, 48.115956553567905]}, "distanceField": "dist.calculated", "spherical" : true, "maxDistance" : 50000} } ,
                            {"$unwind" : "$visit_motives"},
                            {"$match" : {"$and": 
                                [{"visit_motives.first_shot_motive" : true}, {"visit_motives.slots.1": {"$exists": true}}]
                            }
                            }
          ]'

doctolib_rennes_first <- doctolib$aggregate(query)



doctolib_rennes_first$lon <- lapply(doctolib_rennes_first$location$coordinates, function(x){return(x[1])})
doctolib_rennes_first$lat <- lapply(doctolib_rennes_first$location$coordinates, function(x){return(x[2])})
for (i in 1:nrow(doctolib_rennes_first)){
  doctolib_rennes_first$lon[i] <- doctolib_rennes_first$location$coordinates[[i]][1]
  doctolib_rennes_first$lat[i] <- doctolib_rennes_first$location$coordinates[[i]][2]
}
doctolib_rennes_first$lon <- unlist(doctolib_rennes_first$lon)
doctolib_rennes_first$lat <- unlist(doctolib_rennes_first$lat)

doctolib_rennes_first$visit_motives$slots <- lapply(doctolib_rennes_first$visit_motives$slots, as.Date)


doctolib_rennes_first$n_creneaux_fin_janvier <- unlist(lapply(lapply(doctolib_rennes_first$visit_motives$slots, function(x){return(x>="2022-01-26" & x<="2022-01-29")}), sum))

for (i in 1:nrow(doctolib_rennes_first)){
  doctolib_rennes_first$content[i] <- paste("<h3>", doctolib_rennes_first$name[i], "</h3>", 
                                            "Nombre de première dose : ", doctolib_rennes_first$n_creneaux_fin_janvier[i], "<br/>",
                                            "<a href=", doctolib_rennes_first$url_doctolib[i], ">", "Lien vers les données (json) du centre","</a>")
}


doctolib_rennes_first$col <- cut(doctolib_rennes_first$n_creneaux_fin_janvier, breaks = c(0,50,150,Inf), labels = c("green", "orange", "red"))



################ doctolib_rennes_all


query2 <- '[{"$geoNear" : { "near" : {"type": "Point", "coordinates": [-1.6776809942162452, 48.115956553567905]}, "distanceField": "dist.calculated", "spherical" : true, "maxDistance" : 50000} } ,
                            {"$unwind" : "$visit_motives"},
                            {"$match" : {"visit_motives.slots.1": {"$exists": true}}
                            
                            }
          ]'


doctolib_rennes_all <- doctolib$aggregate(query2)


doctolib_rennes_all$lon <- lapply(doctolib_rennes_all$location$coordinates, function(x){return(x[1])})
doctolib_rennes_all$lat <- lapply(doctolib_rennes_all$location$coordinates, function(x){return(x[2])})
for (i in 1:nrow(doctolib_rennes_all)){
  doctolib_rennes_all$lon[i] <- doctolib_rennes_all$location$coordinates[[i]][1]
  doctolib_rennes_all$lat[i] <- doctolib_rennes_all$location$coordinates[[i]][2]
}
doctolib_rennes_all$lon <- unlist(doctolib_rennes_all$lon)
doctolib_rennes_all$lat <- unlist(doctolib_rennes_all$lat)

doctolib_rennes_all$visit_motives$slots <- lapply(doctolib_rennes_all$visit_motives$slots, as.Date)


doctolib_rennes_all$n_creneaux <- unlist(lapply(lapply(doctolib_rennes_all$visit_motives$slots, function(x){return(x>="2022-01-01" & x<="2022-06-01")}), sum))

agg <- aggregate(x = doctolib_rennes_all$n_creneaux, by = list(doctolib_rennes_all$name), FUN = sum)

for (i in 1:nrow(doctolib_rennes_all)){
  name <- doctolib_rennes_all$name[i]
  doctolib_rennes_all$n_creneaux[i] <- agg$x[agg$Group.1==name]
  doctolib_rennes_all$n_creneaux_first[i] <- length(unlist(doctolib_rennes_all$visit_motives$slots[(doctolib_rennes_all$visit_motives$first_shot_motive == T & doctolib_rennes_all$name == name)]))
  doctolib_rennes_all$content[i] <- paste("<h5>", doctolib_rennes_all$name[i], "</h5>", 
                                          "Nombre de créneaux pour une première dose : ", doctolib_rennes_all$n_creneaux_first[i], "<br/>",
                                          "Nombre de créneaux total : ", doctolib_rennes_all$n_creneaux[i], "<br/>",
                                          "<a href=", doctolib_rennes_all$url_doctolib[i], ">", "Lien vers les données (json) du centre","</a>")
}


doctolib_rennes_all$col_all <- cut(doctolib_rennes_all$n_creneaux, breaks = c(0,50,150,Inf), labels = c("green", "orange", "red"), include.lowest=TRUE)

doctolib_rennes_all$col_first <- cut(doctolib_rennes_all$n_creneaux_first, breaks = c(0,50,150,Inf), labels = c("green", "orange", "red"), include.lowest=TRUE)


ColorPal <- colorNumeric(scales::seq_gradient_pal(low = "red", high = "green", 
                                                  space = "Lab"), domain = c(0,700))




