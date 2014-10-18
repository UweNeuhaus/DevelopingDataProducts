library(shiny)

# Define UI for the Linear Regression Explorer
shinyUI(pageWithSidebar(
    
    # Application title
    headerPanel("Linear Regression Explorer"),
    
    sidebarPanel(
        
        # Part 1: Select the data to analyse
        h5("1. Select data"),
        
        # Variable for y-axis
        selectInput("var.y", "Select variable for y-axis:",
                    list("Miles per gallon" = "mpg",
                         "Number of cylinders" = "cyl",
                         "Horsespower" = "hp",
                         "Weight (lb/1000)" = "wt",
                         "1/4 mile time" = "qsec",
                         "Transmission" = "am",
                         "Number of gears" = "gear")),
        
        # Variable for x-axis
        selectInput("var.x", "Select variable for x-axis:",
                     list("Miles per gallon" = "mpg",
                          "Number of cylinders" = "cyl",
                          "Horsespower" = "hp",
                          "Weight (lb/1000)" = "wt",
                          "1/4 mile time" = "qsec",
                          "Transmission" = "am",
                          "Number of gears" = "gear"),
                    selected = "hp"),
        
        # Use different scaling for x-axis if desired
        radioButtons("scale", "Scale x-axis",
                    c("linear" = "linear",
                        "logarithmic" = "log",
                        "quadratic" = "quad",
                        "cubic" = "cube")),
        br(),
        
        # Part 2: Try to guess the regression line 
        h5("2. Guess linear regression line"),
        
        # Enter guessed value for the intercept and slope
        numericInput("intercept", "Guess intercept:", value = 15, step = 0.1),
        numericInput("slope", "Guess Slope::", value = 0.05, step = 0.01),
        br(),
        br(),
        
        # Display additional information that helps finding the right line
        h5("3. Display supporting information"),
        checkboxInput("residual.error", " Show residual standard error", FALSE),
        checkboxInput("regression.line", " Show true regression line", FALSE),
        checkboxInput("standard.error", " Show standard error area", FALSE),
        checkboxInput("r.squared", " Show R-squared", FALSE)
    ),
    
    mainPanel(
        
        # Short instructions
        p(paste("1. This application allows you to explore the relationship ",
                "between different variables of the mtcars data set. You ",
                "can select the variables for the x- and y-axis. ",
                "Additionally you can scale the values of the x-axis if ",
                "desired.")),
       
        p(paste("2. Your task for the selected variables is to estimate the ",
                "linear regression line. Choose the apropriate values for ",
                "the intercept and slope. The corresponding line will ",
                "be drawn into the plot.")),
        
        p(paste("3. To help you find the correct line, the residual error of ",
                "your chosen line is calculated. Try to minimize this value. ",
                "After you positioned the line, you can compare it with the ",
                "true regression line. Additionally, the standard error ",
                "area and R-squared can be displayed.")),
        
        # Show plot
        plotOutput("carsPlot"),
        
        # Show calculated values
        p(textOutput("residual.error")),
        p(textOutput("minimal.residual.error")),
        p(textOutput("minimal.r.squared"))
    )
))