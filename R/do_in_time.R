#' @title Evaluate an expression and interrupts it if it takes too long
#' @param expr The R expression to be evaluated
#' @param envir The environment in which the expression should be evaluated
#' @param timeout A numeric specifying the maximum number of seconds the
#' expression is allowed to run before being interrupted by the `timeout`
#' @details Function heavily instipred by [R.utils::withTimeout()]
#' @export
do_in_time <- function(expr,
                       envir = parent.frame(),
                       timeout) {
  expr <- substitute(expr)
  setTimeLimit(cpu = timeout, elapsed = timeout, transient = TRUE)
  on.exit({
    setTimeLimit(cpu = Inf, elapsed = Inf, transient = FALSE)
  })
  try(
    {
      eval(expr, envir = envir)
    },
    silent = TRUE
  )
}
