#' @title Compress Files into 'zip'
#' @description A wrappper function to a `zip::zip()`
#' @param zipfile The zip file to create. If the file exists, `zip`
#'   overwrites it, but `zip_append` appends to it.
#' @param files List of file to add to the archive. See details below
#'    about absolute and relative path names.
#' @param recurse Whether to add the contents of directories recursively.
#' @param include_directories Whether to explicitly include directories
#'   in the archive. Including directories might confuse MS Office when
#'   reading docx files, so set this to `FALSE` for creating them.
#' @param root Change to this working directory before creating the
#'   archive.
#' @param mode Selects how files and directories are stored in
#'   the archive. It can be `"mirror"` or `"cherry-pick"`.
#'   See "Relative Paths" in [zip::zip()].
#' @seealso [zip::zip()]
#' @export
zip_files <- function(zipfile,
                      files,
                      recurse = TRUE,
                      include_directories,
                      root = ".",
                      mode = c("cherry-pick", "mirror")) {
  zip::zip(
    zipfile = zipfile,
    files = files,
    recurse = recurse,
    include_directories = include_directories,
    root = root,
    mode = mode
  )
}
