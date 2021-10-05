library(parallel)
library(BiocParallel)

source("helpers.R")

clObj <- parallel::makeCluster(2L)

# platform
cat("\n\nplatform: ", .Platform$OS.type, "\n")

# digest clObj
clparam <- getListOfBiocParallelParam2(clObj = clObj)
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
cat("\n\ntraceback:\n")
traceback()

cat("\n\nbplapply ret:\n")
print(ret)
