library(shiny)

trait.choices = list("Aridity","SummerPrecip","MaxAvgHigh","WinterPrecip","WinterAvgHigh")

shinyUI(fluidPage(
  titlePanel("Phylogenetic Comparative Methods"),
  tabsetPanel(
    id='mainpanel',
    tabPanel('Introduction',
          tags$iframe(style="height:600px; width:100%", src="Applied_Phylogenetics_InClass.pdf")),
    
    
    tabPanel('Trait Table',div(dataTableOutput("traitTable")),style='font-size:80%'),
    tabPanel('Tree Plot',
             plotOutput("treePlot")
    ),
    
    tabPanel('Simple Regression',
             fluidPage(
               fluidRow(
                 column(3,
                        wellPanel(
                          selectInput("dependent",
                                      label= "Choose a dependent variable",
                                      choices = trait.choices,
                                      selected = "Aridity"
                          ),
                          selectInput("independent",
                                      label= "Choose an independent variable",
                                      choices = trait.choices,
                                      selected = "SummerPrecip"
                          )
                        ),
                        wellPanel(
                          textOutput("r.text"),
                          textOutput("p.text")
                        )
                 ),
                 
                 column(9,
                        mainPanel(plotOutput("simpleRegression"))
                 )
               )
             )
    ),
    tabPanel('Independent Contrasts',
             fluidPage(
               fluidRow(
                 column(3,
                        wellPanel(
                          selectInput("dependent.pic",
                                      label= "Choose a dependent variable",
                                      choices = trait.choices,
                                      selected = "Aridity"
                          ),
                          selectInput("independent.pic",
                                      label= "Choose an independent variable",
                                      choices = trait.choices,
                                      selected = "SummerPrecip"
                          )
                        ),
                        wellPanel(
                          textOutput("r.pic.text"),
                          textOutput("p.pic.text")
                        )
                 ),
                 
                 column(9,
                        mainPanel(plotOutput("picRegression"))
                 )
               )
             )
     ),
     tabPanel('Phylogenetic Signal',
              fluidPage(
                fluidRow(
                  column(3,
                         wellPanel(
                           selectInput("phenogram.trait",
                                       label= "Choose a trait",
                                       choices = trait.choices,
                                       selected = "Aridity"
                           )
                           ),
                        wellPanel(
                          selectInput("statistic",
                                      label = "Choose a test statistic",
                                      choices = list("K","lambda"),
                                      selected = "K"),
                          checkboxInput("do.test",label="Conduct Hypothesis Test")
                        ),
                        wellPanel(
                          verbatimTextOutput("phylosignal")
                        )
                         
                  ),
            
                  column(9,
                         
                         mainPanel(plotOutput("my.phenogram",width = '100%'))
                         
                  )
                )
      )
     )
  ),
  sliderInput("treenum",
              "Pick a Tree:",
              min = 1,
              max = 330,
              value = 30),
  p("All data for this module comes from:  Evans ME, Hearn DJ, Hahn WJ, Spangle JM, and Venable DL. 2007. Climate and life-history evolution in evening primroses (Oenothera, Onagraceae): a phylogenetic comparative analysis. Evolution 59(9): 1914-1927.")
  
  
  ))


