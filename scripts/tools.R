tool.htmlImageToBlob <- function(img) {
  blob = gsub("data:image/png;base64,", "", img, fixed=TRUE)
  blob <- base64enc::base64decode(blob)
  return(blob)
}

tool.writeBlob <- function(file, data) {
  to.write <- file(file, "wb")
  writeBin(data, to.write)
  close(to.write)
  invisible(NULL)
}

tool.readPNG <- function(file, resolution=64) {
  m = png::readPNG(file)
  if (dim(m)[3]==4) {
    m = (m[,,4]*m[,,1]+m[,,4]*m[,,2]+m[,,4]*m[,,3])/3
  } else {
    m = (m[,,1]+m[,,2]+m[,,3])/3
  }
  
  mSmall = array(numeric(64), dim=c(8,8))
  for (i in 1:8) {
    for (j in 1:8) {
      mSmall[j,i] = mean(m[(1+resolution*(i-1)):(1+resolution*(i-1)+(resolution-1)),(1+resolution*(j-1)):(1+resolution*(j-1)+(resolution-1))])
    }
  }
  # mSmall = mSmall / max(mSmall)
  return(mSmall)
}
