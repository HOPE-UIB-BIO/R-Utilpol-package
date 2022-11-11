.onAttach <- function(lib, pkg) {
    packageStartupMessage(
        paste(
            "R-Utilpol version",
            utils::packageDescription("RUtilpol",
                fields = "Version"
            ),
            "\n",
            paste(
                "This package is under active development.",
                "Therefore, the package is subject to chnage."
            )
        ),
        appendLF = TRUE
    )
}
