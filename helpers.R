# return a list(2) of BiocParallel::BiocParallelParam for nested parallelization
#  [[1]] is used to parallelize across files
#  [[2]] is used to parallelize across threads (accessing a single file) -> has to be a MulticoreParam or SerialParam object
# for downwards compatibility, a parallel::cluster object can be passed that will be used to create the BiocParallel parameter objects
getListOfBiocParallelParam <- function(clObj = NULL) {
    if (is.null(clObj)) { # no 'clObj' argument
        bppl <- list(BiocParallel::SerialParam(), BiocParallel::SerialParam())
    } else {             # have 'clObj' argument
        if (inherits(clObj, "SOCKcluster")) {
            # get node names
            tryCatch({
                nodeNames <- unlist(parallel::clusterEvalQ(clObj, Sys.info()['nodename']))
            }, error = function(ex) {
                message("FAILED")
                stop("The cluster object does not work properly on this system. Please consult the manual of the package 'parallel'\n", call. = FALSE)
            })
            coresPerNode <- table(nodeNames)
            # subset cluster object (represent each node just a single time)
            clObjSub <- clObj[!duplicated(nodeNames)]
            bppl <- if (min(coresPerNode) == 1)
                list(methods::as(clObj, "SnowParam"), BiocParallel::SerialParam())
            else
                list(methods::as(clObjSub, "SnowParam"),
                     BiocParallel::MulticoreParam(workers = min(coresPerNode)))
        } else if (is.list(clObj) &&
                   all(vapply(clObj, FUN = inherits,
                              FUN.VALUE = TRUE, "BiocParallelParam"))) {
            bppl <- clObj
        }
    }
    if (length(bppl) == 1)
        bppl[[2]] <- BiocParallel::SerialParam()
    if (!inherits(bppl[[2]], c("MulticoreParam", "SerialParam")))
        stop('Error configuring the parallel backend. The second registered backend (registered()[[2]] or clObj[[2]]) has to be of class "MulticoreParam" or "SerialParam"')
    return(bppl[seq_len(2)])
}
