library(shiny)

# Define server logic for slider examples
shinyServer(function(input, output) {
  source("helper.R")
  # Reactive expression to compose a data frame containing all of
  # the values
  sliderValues <- reactive({
    
    # Compose data frame
    data.frame(
        Name = c("Temperature (df)", 
                "Temperature (c)",
               "Relative Humidity (%)",
               "Wind Speed (mph)"),
        Value = as.character(c(input$t,
                             convertF2C(input$t),  
                             input$hp,
                             paste(input$ws)
                             )), 
      stringsAsFactors=FALSE)
  }) 
  resultValues = reactive({
      data.frame(
          Name = c("Comfort Index (df)",
                   "Comfort Index (c)")
      )
  })
  # Show the values using an HTML table

  output$plot <- renderPlot({
      getPlot (input$plotType)
  })
  
  output$values <- renderTable({
      sliderValues()})
 
  output$result <- renderText({
      input$calcButton
      #isolate(paste(input$t + input$hp))  
      isolate(paste(calcComfort(input$t,input$hp,input$ws)))
  }
  )

  output$resultc <- renderText({
      input$calcButton

      isolate(paste(convertF2C(calcComfort(input$t,input$hp,input$ws))))      
  }) 
}
)