### Include the necessary libraries
library(shiny)
library(datasets)
library(ggplot2)

### Code that is only run once at the start of the application

# Create a data frame that allows to translate the variable names into 
# better understandable longer descriptions.
axis.names <- data.frame(
    "short" = c("mpg", "cyl", "hp", "wt", "qsec", "am", "gear"),
    "long" = c("Miles per gallon", "Number of cylinders", "Horsepower",
               "Weight (in 1,000 pounds)", "1/4 mile time (in seconds)", 
               "Transmission (1 = automatic, 2 = manual)", "Number of gears"))

# Change the encoding for transmission in order to avoid problems with
# logarithmic scaling later on.
mtcars$am <- mtcars$am + 1 # Change encoding to 1 = automatic and 2 = manual

# Define server logic required for the Linear Regression Explorer
shinyServer(function(input, output) {
    
    # Make sure variable values gets updated when the user changes the input
    values <- reactiveValues()
    
    # Create data frame from the selected variables, scale it if required, and
    # create a summary of the linear model of the two variables.
    observe({
        
        # Select the variables and rename them to x and y
        cars <- data.frame(x = mtcars[input$var.x], y = mtcars[input$var.y])
        colnames(cars) <- c("x", "y")
        
        # Scale x-axis if required
        if (input$scale == "log") {
            cars["x"] <- log(mtcars[input$var.x])
        }
        if (input$scale == "quad") {
            cars["x"] <- mtcars[input$var.x] * mtcars[input$var.x]
        }
        if (input$scale == "cube") {
            cars["x"] <- mtcars[input$var.x] * mtcars[input$var.x] * 
                mtcars[input$var.x]
        }
        values$cars <- cars
        
        # Calculate the summary of the linear model
        values$summary <- summary(lm(values$cars$y ~ values$cars$x))
    })
   
    # Create the plot
    output$carsPlot <- renderPlot({
        
        # Create a scatter plot with title, axis labels, and guessed 
        # regression line
        plot <- ggplot(data = values$cars, aes(x = x, y = y), 
                       environment = environment()) +
        geom_point(shape=1, size=5) + 
            xlab(axis.names$long[axis.names$short == input$var.x]) + 
            ylab(axis.names$long[axis.names$short == input$var.y]) +
        ggtitle("Linear regression with data frome the mtcars dataset") +
        geom_abline(intercept = input$intercept, slope = input$slope)
        
        # Optional: Add true regression line
        if (input$regression.line) {
            plot <- plot + geom_smooth(method=lm, se=input$standard.error)
        }
        
        # Optional: Add area for standard error
        if (input$regression.line) {
            plot <- plot + geom_smooth(method=lm, se=input$standard.error)
        }
        plot
    })
    
    # Get output value for minimal residual standard error
    output$minimal.residual.error <- renderText({
        if (input$residual.error) {
            paste("Minimal residual standard error: ", values$summary$sigma)
        }
    })
    
    # Get output value for R squared
    output$minimal.r.squared <- renderText({
        if (input$r.squared) {
            paste("R-squared: ", values$summary$r.squared)
        }
    })
    
    # Calculate residual standard error for estimated regression line
    output$residual.error <- renderText({
        y_hat <- values$cars$x * input$slope + input$intercept
        re <- sqrt(sum((y_hat - values$cars$y) ^ 2) / (length(values$cars$y) - 2))
        paste("Residual standard error: ", re)
    })
    
})
