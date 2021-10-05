library(parallel)
library(BiocParallel)

source("helpers.R")

clObj <- parallel::makeCluster(2L)


# digest clObj
clparam <- getListOfBiocParallelParam(clObj = clObj)
cat("\n\nclparam:\n")
print(clparam)

nworkers <- unlist(lapply(clparam, BiocParallel::bpworkers))
cat("\n\nnworkers: ", nworkers, "\n")

# will use only one layer of parallelization, select best
clsel <- which.max(nworkers)
cat("\n\nclsel: ", clsel, "\n")

# use it in bplapply
ret <- BiocParallel::bplapply(seq.int(nworkers[clsel]),
                              function(i) i,
                              BPPARAM = clparam[[clsel]])
cat("\n\nbplapply ret:\n")
print(ret)
