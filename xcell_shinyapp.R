# ================= DESCRIPTION ======================== #
#Title: Xcell Viewer app
#Author: Ana Ferreira

# ================= IMPORTS ========================= #

library(shiny)
library(ggplot2)
library(RColorBrewer)

# ================= DATA ========================= #
# load your csv files with xCell results (first Mixture column are samples, 
# remaining columns are xCell results for each cell type identified)
xcellapp <- read.csv("xcellapp.csv")
colourCount = length(unique(xcellapp$Mixture))
getPalette = colorRampPalette(brewer.pal(9, "Set3"))

# ================= UI ========================= #
# add elements to my app as arguments
ui <- fluidPage(
  ## Application title
  titlePanel("Xcell Viewer"),
  sidebarLayout(
    sidebarPanel("An app for visualizing results from cell type enrichment analysis with Xcell (https://xcell.ucsf.edu/)"),
    mainPanel()
    ),
  
  # Input() functions for selecting cell type from xCell results
  selectInput(inputId= "celltype",  label = " Select cell type", 
              choices =  colnames(xcellapp[7:73])), #separate arguments with commas
  plotOutput("plot")) #fluid page parenthesis

# ================= SERVER ========================= #

server <- function(input, output) {
  
  output$plot <- renderPlot({ 
    # plotting the Relative Mode, with no Batch correction
    ggplot(xcellapp, aes(x=TumorType, y=.data[[input$celltype]], fill=Subtype))+
      geom_boxplot(show.legend = T) +
      ggtitle("Distribution of cell counts by cell type") +
      scale_fill_manual(values = getPalette(colourCount)) +
      theme(axis.text=element_text(angle=45, hjust=1)) +
      theme_classic()
    
  }) #renderPlot function brackets
} #function brackets


# ================= RUN APP ========================= #

shinyApp(ui = ui, server = server)

