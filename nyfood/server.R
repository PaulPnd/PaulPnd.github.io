



shinyServer(function(input, output, session) {
 
    

    
    quartier <- reactive({
        switch(input$quartier,
               "Tous les quartiers" = '{"$exists": true}',
               "Brooklyn" = '"Brooklyn"',
               "Bronx" = '"Bronx"',
               "Manhattan" = '"Manhattan"',
               "Queens" = '"Queens"',
               "Staten Island" = '"Staten Island"', 
               "Missing" = '"Missing"')
        
    })
    
    type_cuisine <- reactive({
        switch(input$type_cuisine,
               "Tous les types de cuisine" = '{"$exists": true}',
               "Juice, Smoothies, Fruit Salads" = ' "Juice, Smoothies, Fruit Salads" ',
               "Chinese" = ' "Chinese" ',
               "Bakery" = ' "Bakery" ',
               "Japanese" = ' "Japanese" ',
               "Café/Coffee/Tea" = ' "Café/Coffee/Tea" ',
               "Middle Eastern" = ' "Middle Eastern" ',
               "Other" = ' "Other" ',
               "American " = ' "American " ',
               "Pizza" = ' "Pizza" ',
               "Mexican" = ' "Mexican" ',
               "Latin (Cuban, Dominican, Puerto Rican, South & Central American)" = ' "Latin (Cuban, Dominican, Puerto Rican, South & Central American)"',
               "French" = ' "French" ',
               "Chinese/Japanese" = ' "Chinese/Japanese" ',
               "Caribbean" = ' "Caribbean" ',
               "Spanish" = ' "Spanish" ',
               "Ice Cream, Gelato, Yogurt, Ices" = ' "Ice Cream, Gelato, Yogurt, Ices" ',
               "Korean" = ' "Korean" ',
               "Vietnamese/Cambodian/Malaysia" = ' "Vietnamese/Cambodian/Malaysia" ',
               "Thai" = ' "Thai" ',
               "Pizza/Italian" = ' "Pizza/Italian" ',
               "Bangladeshi" = ' "Bangladeshi" ',
               "Indian" = ' "Indian" ',
               "Chicken" = ' "Chicken" ',
               "Australian" = ' "Australian" ',
               "Asian" = ' "Asian" ',
               "Italian" = ' "Italian" ',
               "Tex-Mex" = ' "Tex-Mex" ',
               "Delicatessen" = ' "Delicatessen" ',
               "Brazilian" = ' "Brazilian" ',
               "Seafood" = ' "Seafood" ',
               "Jewish/Kosher" = ' "Jewish/Kosher" ',
               "Continental" = ' "Continental" ',
               "Pakistani" = ' "Pakistani" ',
               "Turkish" = ' "Turkish" ',
               "Vegetarian" = ' "Vegetarian" ',
               "Russian" = ' "Russian" ',
               "Creole" = ' "Creole" ',
               "African" = ' "African" ',
               "Bagels/Pretzels" = ' "Bagels/Pretzels" ',
               "Sandwiches/Salads/Mixed Buffet" = ' "Sandwiches/Salads/Mixed Buffet" ',
               "Eastern European" = ' "Eastern European" ',
               "German" = ' "German" ',
               "Mediterranean" = ' "Mediterranean" ',
               "Irish" = ' "Irish" ',
               "Armenian" = ' "Armenian" ',
               "Peruvian" = ' "Peruvian" ',
               "Hamburgers" = ' "Hamburgers" ',
               "Sandwiches" = ' "Sandwiches" ',
               "Soul Food" = ' "Soul Food" ',
               "Polish" = ' "Polish" ',
               "Chinese/Cuban" = ' "Chinese/Cuban" ',
               "Steak" = ' "Steak" ',
               "Tapas" = ' "Tapas" ',
               "Moroccan" = ' "Moroccan" ',
               "Filipino" = ' "Filipino" ',
               "Donuts" = ' "Donuts" ',
               "English" = ' "English" ',
               "Barbecue" = ' "Barbecue" ',
               "Greek" = ' "Greek" ',
               "Pancakes/Waffles" = ' "Pancakes/Waffles" ',
               "Bottled beverages, including water, sodas, juices, etc." = ' "Bottled beverages, including water, sodas, juices, etc." ',
               "Soups & Sandwiches" = ' "Soups & Sandwiches" ',
               "Hotdogs/Pretzels" = ' "Hotdogs/Pretzels" ',
               "Iranian" = ' "Iranian" ',
               "Hawaiian" = ' "Hawaiian" ',
               "Ethiopian" = ' "Ethiopian" ',
               "Southwestern" = ' "Southwestern" ',
               "Soups" = ' "Soups" ',
               "Scandinavian" = ' "Scandinavian" ',
               "Portuguese" = ' "Portuguese" ',
               "Afghan" = ' "Afghan" ',
               "Indonesian" = ' "Indonesian" ',
               "Not Listed/Not Applicable" = ' "Not Listed/Not Applicable" ',
               "Polynesian" = ' "Polynesian" ',
               "Egyptian" = ' "Egyptian" ',
               "Hotdogs" = ' "Hotdogs" ',
               "Salads" = ' "Salads" ',
               "CafÃ©/Coffee/Tea" = ' "CafÃ©/Coffee/Tea" ',
               "Cajun" = ' "Cajun" ',
               "Czech" = ' "Czech" ',
               "Nuts/Confectionary" = ' "Nuts/Confectionary" ',
               "Californian" = ' "Californian"'
        )
        
    })
    
    url="mongodb://etudiant:ur2@clusterm1-shard-00-00.0rm7t.mongodb.net:27017,clusterm1-shard-00-01.0rm7t.mongodb.net:27017,clusterm1-shard-00-02.0rm7t.mongodb.net:27017/?ssl=true&replicaSet=atlas-l4xi61-shard-0"
    
    NYfood = mongo(collection="NYfood", db="food",
                   url=url,
                   verbose=TRUE)
    
    query <- reactive({
                paste('[{"$unwind" : "$grades"},
                   {"$match": {"$and": [{"borough": ', quartier(), '}, {"cuisine": ', type_cuisine(), '}]}},
                     {"$group" : {"_id" : {"Quartier" : "$borough",
                                        "Restaurants": "$name",
                                        "Cuisine" : "$cuisine",
                                        "Coord" : "$address.loc.coordinates",
                                        "Avenue" : "$address.street"},
                                        "moyenne_score" : {"$avg" : "$grades.score"}}},
                     {"$sort" : {"moyenne_score" : -1}},
                     {"$limit" : 10}
                    ]')
    })
    meilleur_resto <- reactive({NYfood$aggregate(query())})
    best_resto <- reactive({
        func_data(meilleur_resto())
    })

    
    output$map_ny <- renderLeaflet({
        leaflet(data = best_resto()) %>% 
            setView(lng = new_york[1], lat = new_york[2], zoom = 11) %>% 
            addTiles() %>%
            addCircleMarkers(lng = ~longitude , lat = ~latitude,
                             color=~col,
                             stroke = FALSE,
                             fillOpacity = 0.8,
                             popup = ~content) %>% 
            addLegend("bottomleft", colors = c("red", "orange", "green"), labels = c("Note basse", "Note moyenne", "Note élevée"), values = ~moyenne_score,
                      opacity = 1
            )
    }) 

    
    
    
})
