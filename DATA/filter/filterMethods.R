expressionFilter <- function(datExpr, colRange, thresh) {
    # <colRange>% of the passed expression values >= <thresh>
    # 0 <= colRange <= 1
    # Returns new data frame with rows satisfying condition
    ret.df <- datExpr[(apply(datExpr >= thresh, 1, sum)) >= colRange * ncol(datExpr),]
    return(ret.df)
}

varianceFilter <- function(datExpr, thresh, logTrans=F) {
    # Returns new data frame with rows that have variance ABOVE given threshold
    variances <- apply(datExpr, 1, var)
    if (logTrans) {
        variances <- log10(variances + 0.0001)
    }
    return(datExpr[variances >= thresh,])
}
