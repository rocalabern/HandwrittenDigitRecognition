loadWorkspace = TRUE
startH2O = FALSE
useMXNETModel = TRUE

library(rplot)
library(rmodel)
library(data.table)

source('scripts/tools.R', local = TRUE)
lastRandomRow = 1

if (useMXNETModel) {
  library(mxnet)
  df = fread("./data/optdigits.data", sep=",", header=FALSE)
  dm = data.matrix(df)
  
  model = mx.model.load("mxnet_roger_", 1)
  
  mx.ctx.default(mx.cpu())
  
} else if (loadWorkspace) {
  library(h2o)
  load("data/ws.RData")
  if (startH2O) localH2O = h2o.init(startH2O = TRUE)
  else localH2O = h2o.init(startH2O = FALSE)
} else {
  library(h2o)
  # localH2O = h2o.init(ip="localhost", 54442, startH2O = FALSE)
  localH2O = h2o.init(startH2O = TRUE)
  
  list.files("data")
  
  df = fread("./data/optdigits.data", sep=",", header=FALSE)
    
  dim(df)
  
  df$V65 = as.factor(paste0("d_",df$V65))
  target = df$V65
  
  h2oDF = as.h2o(df, "optdigits")
  
  h2oDL = h2o.deeplearning(1:64, 65, h2oDF, hidden = c(400,400))
  
#   h2oPredictions <- h2o.predict(h2oDL, h2oDF)
#   pred = as.data.frame(h2oPredictions)[,1]
#   table(target, pred)
  
  # r.plot.matrix(t(m), main=paste0("i=",i," (",target[i],")"))
  # r.plot.matrix(t(mSmall), main=paste0("i=",i," (",target[i],")"))
  
  save.image("data/ws.RData")
}

