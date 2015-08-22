# server.R for devdataproducts project
library(shiny)
library(quantmod)

parse.tickers <- function(str) {
  head(unlist(strsplit(str, "\\s+", perl=TRUE)), n=8)
}

get.stock.data <- function(tickers) {
  dat <- list()
  for (s in tickers) {
    dat[[s]] <- getSymbols(s, auto.assign = FALSE)
  }
  dat  
}

calc.daily.returns <- function(stock.data, days) {
  start.date = Sys.Date() - days
  date.string = format(start.date, '%Y%m%d::')
  ret <- xts()
  for (s in names(stock.data)) {
    y <- dailyReturn(stock.data[[s]], subset=date.string)
    dimnames(y)[[2]] <- s
    ret <- cbind(ret,y)
  }
  ret
}

colorRamp <- colorRampPalette(c('blue','white','red'))(15)

perf <- function(inv) {
  calc.daily.returns(get.stock.data(inv),days=15)
}

shinyServer(
  function(input,output){
    # Only query stock data if the "go" button has been pressed.
    data <- reactive({
      input$goStockLookup
      isolate({get.stock.data(parse.tickers(input$tickers))})
    })
    p <- reactive({cor(calc.daily.returns(data(), days=input$nodays), use='pairwise.complete.obs')})
    output$outdebug <- renderPrint(p())
    output$heatmap <- renderPlot({
      heatmap(p(), symm=TRUE, zlim=c(-1,1), col=colorRamp)
    })
  }
)