library(shiny)

shinyUI(fluidPage(
    
    # Application title
    titlePanel("Blood Alcohol Concentration (BAC) Calculator"),
    
    # Description panel
    withTags({
        div(class="header", 
            span("Had couple of drinks and thinking about driving home?"),
            span("Check out how little is needed to change alcohol level in your blood!"),
            span("Read"),
            a(href="http://en.wikipedia.org/wiki/Blood_alcohol_content", "Wikipedia"),
            span("about more information on the subject.")
        )        
    }),
    helpText(
        span('This is a project for "Developing Data Products" class at Coursera.'),
        span('Sources are available on'),
        a(href="https://github.com/alexeq/devdataprod", "GitHub")
    ),
    
    # Sidebar with input controls
    sidebarLayout(
        sidebarPanel(            
            selectInput('units', 'Select Measurement Units:', 
                c("Kilograms" = "kg", "Pounds" = "lb")),
            helpText("Play with controls to see results:"),            
            
            radioButtons("sex", "Gender:",
                c("Male" = "male", "Female" = "female")),        
            numericInput("weight", "Body weight:", 
                value = 65, min = 40, max = 300, step = 1),
            sliderInput("shots", "Number of shots:", 
                value = 1, min = 1, max = 30),
            helpText("(One beer can or a glass of wine are equivalent to 1 shot)"),
            sliderInput("hours", "Hours since starting drinking:", 
                value = 1, min = 1, max = 24)          
        ),
        
        # Calculation results
        mainPanel(
            strong(
                span("Your estimated BAC level is:"), 
                textOutput("bac", inline = TRUE)),
            verbatimTextOutput("summary"),
            helpText(
                strong("Warning!"),
                span("Actual result may differ due to different metabolism and other factors!")
            ),
            span('Plot below shows how BAC degrades with time. 
                Your level is shown as a red dot and green area denotes "safe level".'),
            plotOutput("plot")
        )
    )    
))
