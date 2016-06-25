library(shiny)
library(shinyjs)
library(shinythemes)

niceThemes = c("cerulean", "cosmo", "flatly", "spacelab")
selectedTheme = niceThemes[4]

shinyUI(
  navbarPage(
    theme = shinytheme(selectedTheme), 
    title="Handwritten Digit Recognition",
    windowTitle="Handwritten Digit Recognition",
    
    tabPanel("Sketch", 
             fluidPage(
               
               tags$head(tags$script(src="jquery-latest.js")),
               tags$head(tags$script(src="sketch.min.js")),
               
               useShinyjs(),
               extendShinyjs("scripts/tools.js"),
               
               fluidRow(
                 column(2,
                        NULL
                 ),
                 column(5,
                        fluidRow(
                          column(6,
                                 tags$div(class="tools",
                                          tags$a(href='#tools_sketch', "data-tool"='marker', "Marker")
                                          # tags$a(href='#tools_sketch', "data-tool"='eraser', "Eraser")
                                          # tags$a(href='#tools_sketch', "data-download"='marker', "Download")
                                 )
                          ),
                          column(6,
                                 tags$div(class="tools",
                                          # tags$a(href='#tools_sketch', "data-tool"='marker', "Marker"),
                                          tags$a(href='#tools_sketch', "data-tool"='eraser', "Eraser")
                                          # tags$a(href='#tools_sketch', "data-download"='marker', "Download")
                                 )
                          )
                        ),
                        fluidRow(
                          tags$div(style="border: 2px solid #9999BB; width: 512px; height:512px;",
                                   tags$canvas(id='tools_sketch', width='512px', height='512px'))
                        ),
                        fluidRow(
                          tags$div(class="tools",
                                   tags$a(href='#tools_sketch', "data-size"='8', "8"),
                                   tags$a(href='#tools_sketch', "data-size"='12', "12"),
                                   tags$a(href='#tools_sketch', "data-size"='16', "16"),
                                   tags$a(href='#tools_sketch', "data-size"='24', "24"),
                                   tags$a(href='#tools_sketch', "data-size"='32', "32"),
                                   tags$a(href='#tools_sketch', "data-size"='48', "48")
                          )
                        )
                 ),
                 column(1,
                        fluidRow(align="center",
                                 actionButton("exportButton", "Load Draw"),
                                 actionButton("randomButton", "Load Random Image")
                        ),
                        fluidRow(align="center",
                                 tags$p(""),
                                 plotOutput("plotLowResImage", width = "200px", height = "200px")
                        ),
                        fluidRow(align="center",
                                 textOutput("textRandom"),
                                 textOutput("textPredict")
                        )
                 ),
                 column(4,
                        NULL
                 )
               ),
               
               tags$script(type="text/javascript", "$(function() {
                          $('#tools_sketch').sketch({defaultColor: '#AAA'});
                                  });
                                  ")
               
             )
    )
  )
)