% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/save_latest_file.R
\name{save_latest_file}
\alias{save_latest_file}
\title{Save the newest version of data}
\usage{
save_latest_file(
  object_to_save,
  file_name,
  dir = here::here(),
  current_date = Sys.Date(),
  prefered_format = c("rds", "qs", "csv"),
  preset = c("high", "balanced", "fast", "uncompressed", "archive"),
  use_sha = TRUE,
  verbose = TRUE
)
}
\arguments{
\item{object_to_save}{Object to save. Optionally, can be a character with the name of object
present in the parent frame.}

\item{file_name}{Character. Name of the file use to saving. If missing,
file will be named as \code{object_to_save}}

\item{dir}{Character. Directory path}

\item{current_date}{Character. Current date}

\item{prefered_format}{Character. format to save as: "rds", "qs" or "csv"}

\item{preset}{Character. Used for "qs" only.
One of "fast", "balanced", "high" (default), "archive",
"uncompressed". See `qs::qsave()`` for details}

\item{use_sha}{Logical. If True, the file will be given SHA code in the
file name. when comapring files, if file has SHA code, the comparison can
be done via SHA (without loading the file -> less memory).}

\item{verbose}{Logical. Should there be output message?}
}
\description{
Look into the folder and find the version of the file with
the most recent name. Compare the last saved file and selected file and
save file if something changed since recent.
Note that if file has changes and it has the same date as \code{current_date},
the file will be overwritten (old file deleted).
}
\details{
The functionality of previous iteration (\code{RFossilpol::util_save_if_latests})
is kept in the currentl version but will deprecated in the next version.
Therefore, it is possible to use just \code{file_name} (in quotes) with the name
of the object present in the parent frame without the \code{object_to_save}.
}
\seealso{
\code{\link[qs:qsave]{qs::qsave()}} \code{\link[readr:read_rds]{readr::write_rds()}}
}
