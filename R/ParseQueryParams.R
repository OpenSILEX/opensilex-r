
#' parse_query_parameters
#'
#' Parse a named list into an url encoded http argument query string,
#' to be concatenate with the route
#' @param query_list A named list
#' @param ... other named elements, concatenated with the previous list.
#' Only named elements will be looped over
#'
#' @return The query argument string
#' @export
#' @importFrom utils URLencode
#' @examples
parse_query_parameters <- function(query_list, ...) {
    final_query_list <- c(query_list, list(...))
    if (is.null(final_query_list)) return("")

    query_string_array <- c()
    for (name in names(final_query_list)) {
        value <- final_query_list[[name]]
        if (is.null(value)) next
        query_string_array <- c(
            query_string_array,
            paste0(
                utils::URLencode(
                    as.character(name),
                    reserved = TRUE),
                "=",
                utils::URLencode(
                    as.character(value),
                    reserved = TRUE),
                collapse = "&"
            )
        )
    }
    query_string <- paste0(query_string_array, collapse = "&")
    if (query_string == '') {
        print(query_string)
        return("")
    }
    query_string <- paste0("?", query_string)
    return(query_string)
}


# query_list <- list(exp = "ha", lol = c(1, 2), d = NULL)
# parse_query_parameters(query_list)

# query_list <- list( NULL)
# parse_query_parameters(query_list)

# parse_query_parameters(NULL)

# query_list <- list(d = NULL)
# parse_query_parameters(query_list)

# query_list <- list(exp = "ha", lol = c(1, 2), d = NULL)
# parse_query_parameters(query_list, k = "jopjjo")
# parse_query_parameters(query_list, "jopjjo")