library(shiny)
library(ggplot2)

# Body Water constant
BW <- function(sex) {
    if (sex == "male") 0.58 else 0.49
}

# Metabolism 
MR <- function(sex) {
    if (sex == "male") c(0.013, 0.015, 0.017) else c(0.014, 0.017, 0.021)
}

# Estimated blood alcohol concentration
EBAC <- function(units, sex, weight, shots, hours) {
    wt <- if (units == "kg") weight else kilos(weight)
    ebac = (0.806 * shots * 1.2) / (BW(sex) * wt) - (MR(sex) * hours)
    ifelse(ebac > 0, ebac, 0)
}

# Convert pounds to kilos
kilos <- function(pounds) pounds / 2.2046

shinyServer(function(input, output) { 
    # Calculate BAC level
    bac <- reactive({
        round(EBAC(input$units, input$sex, input$weight, input$shots, input$hours)[2], 4)
    })
    
    # Show formatted BAC
    output$bac <- renderText({
        paste0(bac(), "%")
    })
    
    # Show advice based on BAC
    output$summary <- renderText({
        if (bac() == 0) "Congratulations! You are good to go!" 
        else if (bac() <= 0.02) "You are allowed to drive in some countries, but be careful!"
        else if (bac() >= 0.4) "Your level is dangerously high! Call the ambulance now!"
        else "Be safe and call taxi!"
    })
    
    # Render plot
    output$plot <- renderPlot({
        hrs <- seq(0, 24, 0.5)
        bac <- sapply(hrs, function(x) EBAC(input$units, input$sex, input$weight, input$shots, x))
        df <- data.frame(Hours = hrs, t(bac))
        dfNow <- subset(df, Hours == input$hours) 
        ggplot(df, aes(x = Hours, y = X2)) + 
            geom_line() + 
            geom_ribbon(aes(x = Hours, ymin = X1, ymax = X3, linetype = NA), alpha = 0.2) +
            xlab("Hours") +
            ylab("BAC (%)") +
            geom_point(data = dfNow, size = 3, color = "red") +
            geom_text(data = dfNow, label = "Your level", vjust = -1, hjust = 0) +
            geom_ribbon(aes(x = Hours, ymin = 0, ymax = 0.02, linetype = NA, fill = "green"), alpha = 0.2) +
            scale_fill_manual(values=c("green"="green")) +
            theme(legend.position = "none")
    })    
})
