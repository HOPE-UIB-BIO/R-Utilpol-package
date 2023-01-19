#' @title Evaluate an expression and interrupts it if it takes too long
#' @description A wrapper to `R.utils::withTimeout()`
#' @param expr The R expression to be evaluated
#' @param envir The environment in which the expression should be evaluated
#' @param timeout A numeric specifying the maximum number of seconds the 
#' expression is allowed to run before being interrupted by the timeout
#' @param onTimeout A character specifying what action to take if 
#' a `timeout`` event occurs
#' @param ... other parameters passed to `R.utils::withTimeout()`
#' @seealso [R.utils::withTimeout()]
#' @export 
do_in_time <- function(expr,
                       envir = parent.frame(),
                       timeout,
                       onTimeout = c("error", "warning", "silent"),
                       ...) {
  R.utils::withTimeout(
    expr = expr,
    envir = envir,
    timeout = timeout,
    onTimeout = onTimeout,
    ...
  )
}
