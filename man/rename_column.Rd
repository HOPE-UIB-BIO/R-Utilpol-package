% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/proc_rename_column.R
\name{rename_column}
\alias{rename_column}
\title{Change the name of a column id data.frame}
\usage{
rename_column(data_source, old_name, new_name)
}
\arguments{
\item{data_source}{Data.frame to use}

\item{old_name}{Character. The old name of a column}

\item{new_name}{Character. The new name of a column}
}
\value{
Data.frame with the new name
}
\description{
Detect if a table has a column with \code{old_name} and replace
it with \code{new_name}
}
