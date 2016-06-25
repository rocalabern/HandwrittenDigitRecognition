library(mxnet)
library(data.table)
library(caret)

df = fread("./data/optdigits.data", sep=",", header=FALSE)

rnd = runif(nrow(df))
df_train = df[rnd<=0.7,]
df_test = df[rnd>0.7,]
dm = data.matrix(df)
dm_train = data.matrix(df_train)
dm_test = data.matrix(df_test)

data <- mx.symbol.Variable("data")
fc1 <- mx.symbol.FullyConnected(data, name="fc1", num_hidden=64)
act1 <- mx.symbol.Activation(fc1, name="relu1", act_type="relu")
fc2 <- mx.symbol.FullyConnected(act1, name="fc2", num_hidden=32)
act2 <- mx.symbol.Activation(fc2, name="relu2", act_type="relu")
fc3 <- mx.symbol.FullyConnected(act2, name="fc3", num_hidden=10)
softmax <- mx.symbol.SoftmaxOutput(fc3, name="sm")

devices = lapply(1:4, function(i) {
  mx.cpu(i)
})

temps <- proc.time()
mx.set.seed(0)
model <- mx.model.FeedForward.create(
  softmax, 
  X = t(dm_train[,1:64]), 
  y = dm_train[,65],
  array.layout = c(8,8),
  eval.metric = mx.metric.accuracy,
  optimizer = "sgd",
  learning.rate = 0.01, 
  momentum = 0.9,
  initializer = mx.init.Xavier(),
  num.round = 80,
  ctx = devices)
proc.time() - temps

pred_test = predict(model, dm_test[,1:64])
pred_test <- max.col(t(pred_test))-1
confusionMatrix(table(pred_test, dm_test[,65]))

mx.model.save(model, "mxnet_roger_", 1)

model = mx.model.load("mxnet_roger_", 1)

mx.ctx.default(mx.cpu())

pred_test = predict(model, dm_test[,1:64])
pred_test <- max.col(t(pred_test))-1
confusionMatrix(table(pred_test, dm_test[,65]))

