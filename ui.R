library(shiny)
library(dygraphs)
library(leaflet)
library(RColorBrewer)
library(plotly)

shinyUI(
  fluidPage(
  		fluidRow(
  			column(
  				3,
  				# h4("This is a test to control time and variable"),
  				selectInput("year", 
  						label = h5("Year"),
       					choices = list("2014" = 2014, "2015"=2015),
       					selected=2014)
  			),

  			column(
  				3,
  				selectInput("var", 
  						label = h5("Variable"), 
        				choices = list("Temperature" = "Temp", "Dissolved Oxygen" = "DO"), 
        				selected = "Temp")
  			),
  			column(
  				3,
  				dateInput("myDate", 
  					label = h5("Date"), 
  					value = "2014-08-01")
  			),
        column(
          3,
          selectInput("mapData", 
              label = h5("Spatial Variable"), 
                choices = list("Bathymetry" = "Bathy", "Logger Data" = "logData","Interpolation" = "Interpolated"), 
                selected = "Bathy")
        )
  		),

  		fluidRow(
  			column(
  				3,
  				selectInput("dataType", 
  						label = h5("Aggregrate Type"),
       					choices = list("Standard Dev" = "STD", "Average"="AVG","RAW"="Raw"),
       					selected="AVG")
  			),

  			column(
  				3,
  				selectInput("GroupRange", 
  						label = h5("Aggregrate Range"),
       					choices = list("Daily" = "daily", "Hourly"="hourly"),
       					selected="daily")
  			),

  			column(
  				3,
  				sliderInput("myHour", 
  					label = h5("Hour"), 
  					min = 0, max = 23,value=12)
  			),
			column(
  				2,
  				selectInput("colors", h5("Color Scheme"),
      			rownames(subset(brewer.pal.info, category %in% c("seq", "div"))))
      		)
  		),

  		hr(),
  		
  		fluidRow(
  			column(
  				5,
  				leafletOutput("mymap"),
          selectizeInput("selectedID", label=h5("Selected Loggers"), 
            choices=NULL, 
            selected = NULL, 
            multiple = TRUE,
            options = NULL),
          actionButton("ClearAll","clear all"),
          downloadButton("downloadData", label = "Download", class = NULL)

  				#actionButton("selectAllLogal","select all")

        ),
  			column(
  				7,
          tabsetPanel(
            
            tabPanel("Time Series",
              dygraphOutput('timeSeriesPlot'),
              # checkboxInput("scale", "Scaled?", value = FALSE, width = NULL),
              # checkboxInput("twoy", "Double Y?", value = FALSE, width = NULL),
              checkboxInput("withOther", "With Both Variables", value = FALSE, width = NULL),
              checkboxInput("withUpperLogger", "With Upper Logger", value = FALSE, width = NULL),
              checkboxInput("outlier", "Show outlier", value = FALSE, width = NULL)
              ),
            
            tabPanel("Correlation",
              tableOutput('corr')),

            tabPanel("Variogram",
                plotlyOutput("Variogram"),
                # dateRangeInput('dateRangeVariogram',
                      # label = paste("variogram date range"),
                    # separator = " to ", format = "mm/dd/yy",
                    # startview = 'year', weekstart =0
                # ),
                textInput("equation",h5("Variogram Expr"),value = "~longitude+latitude",placeholder="detrend: ~longitude+latitude＋bathymetry")),
            
            tabPanel("Hypoxia Extent",
                dygraphOutput('hypoxiaExtentPlot'),
                # actionButton("calHypoxiaButtom","Calculate Hypoxia Extent"),
                checkboxInput("usingRatio", "Show hypoxia area ratio", value = FALSE, width = NULL)
              )
           

            # tabPanel("Settings",
            #   selectInput("interpolationMethod", 
            #       label = h5("Method"),
            #       choices = list("IDW" = "IDW"),  
            #       selected ="IDW"),
            #   selectInput("inteprolationPara1", 
            #       label = h5("Para1"),
            #       choices = list("Para" = "Para1"),  
            #       selected ="Para1"),
            #   actionButton("Interpolation","Interpolate") # first is the action name, second is the UI name

              # )

          )
  			)
  		)
	)
)