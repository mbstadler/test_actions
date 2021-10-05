library(parallel)
library(BiocParallel)

source("helpers.R")

clObj <- parallel::makeCluster(2L)

res <- getListOfBiocParallelParam(clObj = clObj)

print(res)
