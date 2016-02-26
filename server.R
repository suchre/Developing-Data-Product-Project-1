# Perform all necessary initialization
init <- function(){
        library(shiny)  # load Shiny Library
        data(mtcars)    # load mtcars dataset
        set.seed(888)   # set seed for reproducibility
}        

regression <- function(){
        mtcars$am[mtcars$am == 0]  <- "Automatic"
        mtcars$am[mtcars$am == 1]  <- "Manual"    
        mtcars$cyl <- as.factor(mtcars$cyl)
        mtcars$vs <- as.factor(mtcars$vs)
        mtcars$am <- as.factor(mtcars$am)
        mtcars$gear <- as.factor(mtcars$gear)
        mtcars$carb <- as.factor(mtcars$carb)
        temp <- lm(mpg~., data = mtcars) # Linear Regression for Model 3
        step(temp, direction = "backward")
}        

init()
model <- regression()


shinyServer(
        function(input, output, session){

                invalid <- reactiveValues(cyl = 0, hp = 0, wt = 0)
                cyl <- reactive(input$cyl)
                hp <- reactive(input$hp)                
                wt <- reactive(input$wt)
                am <- reactive(input$am)
               
                # Check if Cylinder is out of range or not
                observe({
                        if((cyl() %% 1 != 0) | (cyl() %% 2 != 0)){
                                output$cyl <- renderPrint({"Cylinder is Invalid."})
                                invalid$cyl <- 1
                        }else if((cyl() < min(mtcars$cyl)) | (cyl() > max(mtcars$cyl))){
                                output$cyl <- renderPrint({"Number of Cylinder is Out of Range."})
                                invalid$cyl <- 1     
                        }else {
                                output$cyl <- renderPrint({input$cyl})
                                invalid$cyl <- 0
                        }

                },
                label = "cyl", priority = 2)                
                
                # Check if Horse Power is out of range or not
                observe({
                        if((hp() < min(mtcars$hp)) | (hp() > max(mtcars$hp))){
                                output$hp <- renderPrint({"Horse Power is Out of Range"})
                                invalid$hp <- 1
                        } else {    
                                output$hp <- renderPrint({input$hp})
                                invalid$hp <- 0
                        }
                },
                label = "hp", priority = 2)                
                
                # Check if Weight is out of range or not
                observe({
                        if((wt() < min(mtcars$wt)) | (wt() > max(mtcars$wt))){
                                output$wt <- renderPrint({"Weight is Out of Range"})
                                invalid$wt <- 1
                        } else {    
                                output$wt <- renderPrint({input$wt})
                                invalid$wt <- 0
                        }
                },
                label = "wt", priority = 2)

                output$am <- renderPrint({input$am})    
                
                
                # Perform prediction with the regression model from mtcar dataset
                # using the parameters that the user entered.
                observe({
                        if(!(invalid$cyl | invalid$hp | invalid$wt)){
                                carspecs <- data.frame(cyl = cyl(), hp = hp(),
                                                       wt = wt(), am = am())
                                carspecs$cyl <- as.factor(carspecs$cyl)

                                mpg_predict <- predict(model, carspecs,
                                                       interval = "predict",
                                                       level = 0.95)
                                output$mpg_avg <- renderPrint({mpg_predict[1]})
                                output$mpg_min <- renderPrint({mpg_predict[2]})                                
                        } else{
                                output$mpg_avg <- renderPrint({"Invalid Car Specs. Please check your inputs"})
                        }
                },
                label = "predict", priority = 1)
        }
)
