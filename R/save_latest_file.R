#' @title Save the newest version of data
#' @param file_to_save Object to save
#' @param dir Character. Directory path
#' @param current_date Character. Current date
#' @param prefered_format Character. format to save as: "qs" or "csv"
#' @param preset
#' Charatcer. One of "fast", "balanced", "high" (default), "archive",
#'  "uncompressed". See `qs::qsave()`` for details
#' @return NULL
#' @description Look into the folder and find the version of the file with
#'  the most recent name. Compare the last saved file and selected file and
#'   save file if something changed since recent.
#' Note that if file has changes and it has the same date as `current_date`,
#'  the file will be overwritten (old file deleted)
#' @export
#' @seealso [qs::qsave()]
save_latest_file <-
    function(file_to_save,
             dir,
             current_date = Sys.Date(),
             prefered_format = c("qs", "csv"),
             preset = c(
                 "high",
                 "balanced",
                 "fast",
                 "uncompressed",
                 "archive"
             )) {
        current_frame <-
            sys.nframe()
        current_env <-
            sys.frame(which = current_frame)

        check_class("dir", "character")

        check_class("prefered_format", "character")

        check_vector_values(
            "prefered_format",
            c(
                "qs",
                "csv"
            )
        )

        prefered_format <- match.arg(prefered_format)

        check_class("preset", "character")

        check_vector_values(
            "preset",
            c(
                "high",
                "balanced",
                "fast",
                "uncompressed",
                "archive"
            )
        )

        preset <- match.arg(preset)

        file_name <-
            substitute(file_to_save) %>%
            deparse()

        assign("file_to_save", file_to_save, envir = current_env)

        check_if_loaded(
            file_name = "file_to_save",
            env = current_env,
            silent = TRUE
        )

        if (
            prefered_format == "csv"
        ) {
            save_command <-
                paste0(
                    "readr::write_csv(file_to_save, '", dir, "/",
                    file_name, "_(", current_date, ").csv",
                    "')"
                )
        } else if (
            prefered_format == "qs"
        ) {
            file_sha <-
                digest::sha1(file_to_save)

            save_command <-
                paste0(
                    "qs::qsave(file_to_save, '", dir, "/",
                    file_name, "_(", current_date, ")__",
                    file_sha, ".qs",
                    "',preset = '", preset, "')"
                )
        }

        latest_file_name <-
            get_latest_name_file(
                file_name = file_name,
                dir = dir,
                silent = TRUE
            )

        # if there is not a previous version of the file
        if (
            is.na(latest_file_name)
        ) {
            usethis::ui_done(
                paste(
                    "Have not find previous version of the file.",
                    "Saving the file with",
                    prefered_format, "format."
                )
            )

            eval(parse(text = save_command), envir = current_env)

            # stop the funtcion
            return("Done")
        }

        lastest_file_format <-
            guess_format(latest_file_name)

        if (
            prefered_format != lastest_file_format
        ) {
            usethis::ui_info(
                paste0(
                    "The previous version of the file has",
                    "different format than the 'prefered_format'. ",
                    "Will save as", prefered_format
                )
            )
        }

        # We neeed to compare with previous file
        is_the_lastest_same <- FALSE

        if (
            lastest_file_format == "qs" && prefered_format == "qs"
        ) {
            lastest_file_sha <-
                get_sha_from_name(latest_file_name)

            if (
                file_sha == lastest_file_sha
            ) {
                is_the_lastest_same <- TRUE
            }
        }

        if (
            is_the_lastest_same == FALSE
        ) {
            # construct the command to load the file
            if (
                lastest_file_format == "csv"
            ) {
                load_command <-
                    paste0(
                        "lastest_file <- readr::read_csv(",
                        "'", dir, "/", latest_file_name, "',",
                        "show_col_types = FALSE",
                        ")"
                    )
            } else if (
                lastest_file_format == "qs"
            ) {
                load_command <-
                    paste0(
                        "lastest_file <- qs::qread(",
                        "'", dir, "/", latest_file_name, "')"
                    )
            }

            # load the file (evaluate )
            eval(parse(text = load_command), envir = current_env)

            assign("lastest_file", lastest_file, envir = current_env)

            is_the_lastest_same <-
                compare_files(
                    file_a = file_to_save,
                    file_b = lastest_file
                )
        }

        # if there are changes is the current file to the saved one
        if (
            is_the_lastest_same == FALSE
        ) {
            usethis::ui_done(
                "Found older file, overwriting it with new changes."
            )

            latest_file_date <-
                get_date_from_name(latest_file_name)

            # rewrite the file if same date
            if (
                current_date == latest_file_date
            ) {
                file.remove(
                    paste0(
                        dir, "/", latest_file_name
                    )
                )
            }

            eval(parse(text = save_command), envir = current_env)

            return("Done")
        }

        usethis::ui_info(
            "Found older file but did not detect any changes. Not overwritting."
        )

        return("Done")
    }