library(shiny)


shinyUI(fluidPage(
  titlePanel("Hotel recommendation system"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("site_name", label = h3("Site Name"), 1, min = 1, max = 37),
      #selectInput("select", label = h3("Choose gender"),
      #           choices = list("Male" = 0, "Female" = 1),
      #          selected = 0),
      #helpText(" '0' represents male and '1' represents female"),
      numericInput("posa_continent", label = h3("User Continent"), 1, min = 1, max = 6),
      numericInput("user_location_country", label = h3("User Country"), 66, min = 66, max = 240),
      #sliderInput("verbal", label = h3("Verbal score in words out of 12 correctly defined"),
      #           min = 1, max = 12, value = 6),
      numericInput("is_booking", label = h3("Booking done or not"), 0, min = 0, max = 1),
      submitButton('Submit')
      
    ),
    mainPanel(
      h2('Results of prediction'),
      h4('You entered'),
      verbatimTextOutput("site_name"),
      textOutput("text1"),
      verbatimTextOutput("posa_continent"),
      verbatimTextOutput("user_location_country"),
      verbatimTextOutput("is_booking"),
      h4('predicted hotel cluster'),
      verbatimTextOutput("prediction"),
      h4('Hotel recommendation')
      #img(src="Poker.jpg", height = 417, width = 626),
      #a("Photo credit: https://image.slidesharecdn.com/expediacasestudy-150804134456-lva1-app6891/95/expedia-case-study-1-638.jpg?cb=1438696055")
      ) 
    
  )
))



