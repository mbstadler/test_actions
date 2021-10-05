library(parallel)
library(BiocParallel)

source("helpers.R")

clObj <- parallel::makeCluster(2L)


# digest clObj
clparam <- getListOfBiocParallelParam(clObj = clObj)
cat("clparam:")
print(clparam)

nworkers <- unlist(lapply(clparam, BiocParallel::bpworkers))
cat("nworkers: ", nworkers)

# will use only one layer of parallelization, select best
clsel <- which.max(nworkers)
cat("clsel: ", clsel)

# use it in bplapply
ret <- BiocParallel::bplapply(seq.int(nworkers[clsel]),
                              function(i) i,
                              BPPARAM = clparam[[clsel]])
cat("bplapply ret:")
print(ret)
