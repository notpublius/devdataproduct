# ui.R for devdataprod project
library(shiny)

intro <- c('This application will compare the recent performance of up to 8 stocks.',
  'For each of the entered stocks, the daily returns will be calculated over an adjustable window.',
  'A heat map showing the correlation relationships between the investments will be displayed.')
intro <- paste(intro, sep=" ")

shinyUI(pageWithSidebar(
  headerPanel('Stock Correlation Explorer'),
  sidebarPanel(p(intro),
               textInput("tickers", label= "Ticker Symbols", value = "BND GLD ^GSPC VFINX GOOG"),
               p('To be included, an investment must be entered using the ticker symbol as used by ',
                   a('Yahoo! Finance.', href='http://finance.yahoo.com/')),
               actionButton("goStockLookup", 'Load stock information'),
               p('Once the stock information is loaded, you can compare performance correlation over a varying time window.'),
               p('If you change the stock tickers, you must click the button to reload the stock information'),
               sliderInput("nodays", label= "Days of price history to use", value=30, 
                           step=5, min=15, max=90)
  ),
  mainPanel(p('Stocks with strong positive correlations are shown in red, strong negative correlations are shown in blue, and uncorrelated stocks are shown in white.'),
            plotOutput('heatmap'),
            p('The actual numeric values of correplation are shown below.'),
            verbatimTextOutput("outdebug")
  )
))