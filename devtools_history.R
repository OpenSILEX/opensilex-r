usethis::use_mit_license()                        # Setup licensing
usethis::use_package('httr')                      # Use httr package
usethis::use_package('jsonlite')                  # Use jsonlite package
usethis::use_build_ignore("devtools_history.R")   # Ignore this file while checking
usethis::use_package('dplyr')                     # Use dplyr package
usethis::use_pipe(export = TRUE)                  # Use magrittr pipe
