library(shiny)
      
shinyUI(navbarPage(title = "Calculates Car Fuel Efficiency",
                   
        tabPanel(title = "PREDICTION",
                sidebarLayout(
                        sidebarPanel(
                                h4("Predicts the fuel efficiency of your
                                car in MPG (miles per gallon)"),
                                br(),
                                
                                # Get the number of Cylinder
                                numericInput(inputId="cyl", 
                                            label= c("Number of Cyclinder (even number): ",min(mtcars$cyl), " to ", max(mtcars$cyl)),
                                            value = min(mtcars$cyl),
                                            min = min(mtcars$cyl), 
                                            max = max(mtcars$cyl), 
                                            step = 2),
                                
                                # Get the horse power  
                                numericInput(inputId="hp", 
                                            label= c("Horse Power: ", min(mtcars$hp)," to ", max(mtcars$hp)), 
                                            value = min(mtcars$hp),
                                            min = min(mtcars$hp),
                                            max = max(mtcars$hp),
                                            step = 1),
                                
                                # Get the weight  
                                numericInput(inputId="wt", 
                                            label= c("Car Weight (1000 lbs): ", min(mtcars$wt)," to ", max(mtcars$wt)), 
                                            value = min(mtcars$wt),
                                            min = min(mtcars$wt),
                                            max = max(mtcars$wt),
                                            step = 1/1000),
                                
                                # Get the transmission type (checked means Auto transmission)   
                                radioButtons("am",
                                             "Transmission Type", 
                                             c("Automatic","Manual"),
                                             selected = NULL ),
                                
                                submitButton("Submit")
                       ),
                        
                         
                        mainPanel(
                                h2("Your Car Specs Are:"),
                                br(),
                                h4("Number of Cylinder:"),
                                verbatimTextOutput("cyl"),
                                h4("Horse Power:"),                
                                verbatimTextOutput("hp"),
                                h4("Weight (1000 lbs):"),
                                verbatimTextOutput("wt"),
                                h4("Transmission Type:"),
                                verbatimTextOutput("am"),
                                br(),                
                                h4("The average fuel efficiency (MPG) of your car is as:"),                
                                verbatimTextOutput("mpg_avg")
                        )
                )
                ),
        tabPanel(title = "DOCUMENTATION",
                 includeMarkdown("readme.md"))
)
)
