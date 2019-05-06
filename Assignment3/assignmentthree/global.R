outliers <- function(x, mult=1.5, na.rm = TRUE, ...) {
  if (is.numeric(x)) {
    qnt <- quantile(x, probs=c(.25, .75), na.rm = na.rm, ...)
    H <- mult * (qnt[2]-qnt[1])
    H1 <- qnt[1] - H
    H2 <- qnt[2] + H
    tf <- x < H1 | x > H2
  } else {
    tf <- rep(FALSE, length(x))
  }
}

outlierRows <- function(data, mult=1.5, na.rm = TRUE, ...) {
  tf <- rep(x=FALSE, times=dim(data)[1])
  for (col in 1:dim(data)[2]) {
    coltf <- outliers(as.vector(data[,col]), mult, na.rm, ...)
    tf <- tf | coltf
  }
  tf[is.na(tf)] <- FALSE
  tf
}
