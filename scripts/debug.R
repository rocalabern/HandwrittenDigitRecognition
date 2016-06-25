aMargin = seq(0,0.25,0.01)
aError = aMargin
pos = 1
for (bMargin in aMargin) {
  aError[pos] = 0
  # for (i in 1:nrow(df)) {
  for (i in sample(1:nrow(df), 50)) {
    arraySource = matrix(as.numeric(df[i,1:64,with=FALSE]), nrow=8, byrow = FALSE)
    m  = matrix(as.numeric(df[i,1:64,with=FALSE]), nrow=8, byrow = FALSE)
    m = m[1:nrow(m),ncol(m):1]
    png("data/exported.png", width=512, height=512)
    par(mar = c(bMargin, 0, 0, 0))
    plot.new()
    image(m, col = rplot::r.color.gradient.palette(c("white", "black"), levels = 100), add=TRUE)
    dev.off()
    rplot::r.plot.close()
    
    m = tool.readPNG("data/exported.png")
    # m = m[1:nrow(m),ncol(m):1]
    arrayTarget = round(16*(1-m))
    error = sum(abs(arraySource-arrayTarget)^2)
    aError[pos] = aError[pos] + error
  }
  print(paste0("bMargin: ",bMargin," | error: ",aError[pos]))
  pos = pos + 1
}
r.plot(aMargin, aError)


i=1
bMargin = 0.14
arraySource = matrix(as.numeric(df[i,1:64,with=FALSE]), nrow=8, byrow = FALSE)
m  = matrix(as.numeric(df[i,1:64,with=FALSE]), nrow=8, byrow = FALSE)
m = m[1:nrow(m),ncol(m):1]
png("data/exported.png", width=512, height=512)
par(mar = c(bMargin, 0, 0, 0))
plot.new()
image(m, col = rplot::r.color.gradient.palette(c("white", "black"), levels = 100), add=TRUE)
dev.off()
rplot::r.plot.close()

m = tool.readPNG("data/exported.png")
# m = m[1:nrow(m),ncol(m):1]
arrayTarget = round(16*(1-m))
error = sum(abs(arraySource-arrayTarget)^2)
error
arraySource
arrayTarget

# Predict ----
bMargin = 0.14
# nsample = 1:nrow(df)
nsample = sample(1:nrow(df), 500)
target = df$V65[nsample]
pred = target
pos = 1
for (pos in 1:length(nsample)) {
  i = nsample[pos]
  m  = matrix(as.numeric(df[i,1:64,with=FALSE]), nrow=8, byrow = FALSE)
  m = m[1:nrow(m),ncol(m):1]
  png("data/exported.png", width=512, height=512)
  par(mar = c(bMargin, 0, 0, 0))
  plot.new()
  image(m, col = rplot::r.color.gradient.palette(c("white", "black"), levels = 100), add=TRUE)
  dev.off()
  rplot::r.plot.close()
  
  m = tool.readPNG("data/exported.png")
  # m = m[1:nrow(m),ncol(m):1]
  dfTemp = as.data.frame(data.frame(df[1,1:64,with=FALSE]))
  dfTemp[1,]= round(16*(1-m))
  h2oDFTemp = as.h2o(dfTemp, localH2O, "dfTemp")
  
  h2oPredictions <- h2o.predict(h2oDL, h2oDFTemp)
  pred[pos] = as.data.frame(h2oPredictions)[,1]
}
table(target, pred)

h2oPredictions <- h2o.predict(h2oDL, h2oDF)
table(target, as.data.frame(h2oPredictions)[,1])