shinyServer(function(input, output, session) {
 
    output$carte_first_jan <- renderLeaflet({
        leaflet(doctolib_rennes_first) %>%
            addTiles() %>%
            addCircleMarkers(label = ~name, lng = ~lon, lat = ~lat, color = ~col, popup = ~content) %>% 
            addLegend("bottomleft", colors = c("green", "orange", "red"), labels = c("0-50", "51-150", "150+"), values = ~n_creneaux_fin_janvier,
                      opacity = 1
            )
    }) 

    
    dose <- reactive({
        switch(input$dose,
               "1ere doses" = doctolib_rennes_all$col_first,
               "Toutes doses confondues"= doctolib_rennes_all$col_all)
        
    })
    
    col <- reactive({
        switch(input$dose,
               "1ere doses" = doctolib_rennes_all$n_creneaux_first,
               "Toutes doses confondues" = doctolib_rennes_all$n_creneaux)
    })

    
    
    output$carte_all <- renderLeaflet({
        leaflet(doctolib_rennes_all) %>%
            addTiles() %>%
            addCircleMarkers(label = ~name, lng = ~lon, lat = ~lat, color = ~dose(), popup = ~content) %>% 
            addLegend("bottomleft", colors = c("green", "orange", "red"), labels = c("0-50", "51-150", "150+"), values = ~col(),
                      opacity = 1
            )
    })
    
    
    
})
