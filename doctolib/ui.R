shinyUI(fluidPage(theme = shinytheme("slate"),

                  navbarPage(HTML('<a href="https://paulpnd.github.io/ProjetMongo"> Retour à la page principale du projet </a>'),
            
                             tabPanel("Carte des premieres doses du 26-01 au 29-01 inclus",
                                      HTML("<p>Cette carte affiche les centres de vaccinations étant situés à moins de 50 kilomètres de Rennes, et ayant eu des visites liées à des premières doses de vaccin contre le coronavirus entre le 26-01 et le 29-01 inclus.</br>
                                           Il est possible de cliquer sur un centre de vaccinations pour afficher son nom, son nombre de créneaux pendant cette période, et l'url permettant d'accéder aux données de ce centre.</p>"),
                                      div(class="outer",
                                       tags$head(includeCSS("styles.css")),
                                       
                                       leafletOutput("carte_first_jan", height = 800)
                                       )
                                        ),
                                        tabPanel("Carte entre le 01-01 et le 01-06",
                                                 HTML("<p>Cette carte affiche les mêmes résultats, mais sur la période s'étendant du 01-01 au 01-06, et un boutton permet de choisir entre l'affichage des premières doses uniquement, ou de toutes les doses."),
                                                 
                                                 div(class = "outer",
                                                     tags$head(includeCSS("styles.css")),
                                                     
                                                     leafletOutput("carte_all", height = 800),
                                                     
                                                     absolutePanel(id = "controls", class = "panel panel-default",
                                                                   top = 400, left = 100, width = 250, fixed=TRUE,
                                                                   draggable = TRUE, height = "auto",
                                                                   
                                                                   selectInput("dose", label = h3("Doses affichees :"),
                                                                               choices = list("1ere doses",
                                                                                              "Toutes doses confondues"),
                                                                               selected = "1ere doses")
                                                                   
                                                     )
                                                   )
                                        )

)
)
)