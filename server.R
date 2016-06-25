library(shiny)
library(shinyjs)

shinyServer(function(input, output, session) {
  sessionEnvironment = environment()
  
  onclick("exportButton", {
    message("Load draw")
    js$exportCanvas()
  })
  
  reactExportPNG <- reactive({
    if (is.null(input$jstextPNG) || nchar(input$jstextPNG)<=0) return()
    data = tool.htmlImageToBlob(input$jstextPNG)
    tool.writeBlob("data/exported.png", data)
    lastRandomRow <<- -1
  })
  observe(reactExportPNG())
  
  reactWriteRandomPNG <- reactive({
    if (input$randomButton<=0) return()
    message("Random draw")
    i = sample(1:nrow(df), 1)
    m  = matrix(as.numeric(df[i,1:64,with=FALSE]), nrow=8, byrow = FALSE)
    m = m[1:nrow(m),ncol(m):1]
    par.default = par()$mar
    png("data/exported.png", width=512, height=512)
    par(mar = c(0.14, 0, 0, 0))
    plot.new()
    image(m, col = rplot::r.color.gradient.palette(c("white", "black"), levels = 100), add=TRUE)
    dev.off()
    par(mar = par.default)
    rplot::r.plot.close()
    rplot::r.plot.reset()
    lastRandomRow <<- i
  })
  observe(reactWriteRandomPNG())
  
  output$plotLowResImage <- renderPlot({
    reactExportPNG()
    reactWriteRandomPNG()
    m = tool.readPNG("data/exported.png")
    if (is.null(m) || nrow(m)<=0) return()
    m = m[1:nrow(m),ncol(m):1]
    par.default = par()$mar
    par(mar = c(0.14, 0, 0, 0))
    plot.new()
    image(m, col = rplot::r.color.gradient.palette(c("black", "white"), levels = 100), add=TRUE)
    box()
    par(mar = par.default)
  })
  
  output$textRandom <- renderText({
    reactExportPNG()
    reactWriteRandomPNG()
    
    i <- lastRandomRow
    if (i<=0) {
      number = "-"
    } else {
      number = as.character(df$V65[i])
    }
    paste0("Number: ", number)
  })
  
  output$textPredict <- renderText({
    reactExportPNG()
    reactWriteRandomPNG()
    
    m = tool.readPNG("data/exported.png")
    # m = m[1:nrow(m),ncol(m):1]
    dfTemp = as.data.frame(data.frame(df[1,1:64,with=FALSE]))
    dfTemp[1,]= round(16*(1-m))
    
    if (useMXNETModel) {
      
      dm = data.matrix(dfTemp)
      pred = predict(model, dm)
      pred <- max.col(t(pred))-1
      
    } else {
      
      h2oDFTemp = as.h2o(dfTemp, "dfTemp")
        
      # i <- lastRandomRow
      # df[i,1:64,with=FALSE]
      # dfTemp
      
      # i <- lastRandomRow
      # m  = matrix(as.numeric(df[i,1:64,with=FALSE]), nrow=8, byrow = FALSE)
      # r.plot.matrix(t(m), main=paste0("i=",i," (",target[i],")"))
      # m  = matrix(as.numeric(dfTemp[1,1:64]), nrow=8, byrow = FALSE)
      # r.plot.matrix(t(m), main=paste0("i=",i," (",target[i],")"))
      
      h2oPredictions <- h2o.predict(h2oDL, h2oDFTemp)
      pred = as.data.frame(h2oPredictions)[,1]
    }
    paste0("Prediction: ", as.character(pred))
  })
  
})