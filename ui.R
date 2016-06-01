
library(shiny)

# Define UI for slider demo application
shinyUI(navbarPage("Weather Comfort Index Predictor",
  
  #  Application title
  #titlePanel("Weather Comfort Index Predictor"),
  
  # Sidebar with sliders that demonstrate various available
  # options
  #sidebarLayout(
      tabPanel(
          "Input",
        sidebarLayout(  
        sidebarPanel(
      
        sliderInput("t", "Temperature (df):", 
                  min=-15, max=115, value=70,
                  step = 1, animate=
                    animationOptions(interval=500, loop=FALSE)),
      
      # Decimal interval with step value
        sliderInput("hp", "Humidity (%):", 
                  min = 0, max = 100, value = 30, step= 1),
      
      # Specification of range within an interval
        sliderInput("ws", "Wind Speed (mph):",
                  min = 0, max = 75, value = 8, step = 1),
      
      # Provide a custom currency format for value display, 
      # with basic animation
      # sliderInput("format", "Custom Format:", 
      #             min = 0, max = 10000, value = 0, step = 2500,
      #             format="$#,##0", locale="us", animate=TRUE),
      # 
      # # Animation with custom interval (in ms) to control speed,
      # # plus looping
      # sliderInput("animation", "Looping Animation:", 1, 2000, 1,
      #             step = 10, animate=
      #             animationOptions(interval=300, loop=TRUE)),
      helpText("Note: The temperature for the comfort index will not be calculated until the Calculate button is pressed.."),
      
      
      actionButton("calcButton","Calculate Comfort Index")
      ),
    
    # Show a table summarizing the values entered
    mainPanel(
        column(8, wellPanel(
          titlePanel("Input Values"),
          tableOutput("values"),
        
          h3("Predicted Comfort Index (df)"),
          textOutput("result"),
          h3("Celsius"),
          textOutput("resultc")
          
         ) # wellpanel
         ) # column

        ) # mainpanel
        ) # sidebarlayout
      ), # tabpanel
  tabPanel ("Plots",
            sidebarLayout(
                sidebarPanel(
                    radioButtons("plotType", "Plot type",
                                 c("Wind Chill"="w", "Heat Index"="h")
                    )
                ),
                mainPanel(
                    plotOutput("plot")
                )
            )            
            ),
  tabPanel("About",
           mainPanel(includeMarkdown("About.Rmd"))
    )# tabpanel
)
)

