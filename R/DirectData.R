#' Direct Data import
#'
#' @param host url of the hosting opensilex service
#' @param user opensilex user
#' @param password opesnielx user's password
#' @param experiment_uri uri of the targeted experiment
#' @param scientific_object_type uri of the targeted scientific object type
#' @param variables \[OPTIONAL\] vector of variables's uri
#' @param mode \[OPTIONAL\] mode of the csv: one of "long" or "wide" (default to "long")
#'
#' @return
#' @export
#' @importFrom httr GET content add_headers
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr filter
#' @importFrom utils URLencode read.csv
#' @importFrom rlang .data
#' @examples
get_data <- function(host,
                     user,
                     password,
                     experiment_uri,
                     scientific_object_type,
                     variables = NULL,
                     mode = "wide") {
  token <- opensilexR::get_token(host = host, user = user, password = password)
  stopifnot(mode %in% c("long", "wide"))

  # Retrieve SO per type
  call1 <-
    paste0(
      host,
      "/core/scientific_objects",
      opensilexR::parse_query_parameters(
        page_size = 10000,
        experiment = experiment_uri,
        rdf_types = scientific_object_type,
        variables = variables
      )
    )

  get_result <- opensilexR::parse_status(
    httr::GET(call1, httr::add_headers(Authorization = token))
  )
  get_result_text <- httr::content(get_result, "text")
  get_result_json <- jsonlite::fromJSON(get_result_text, flatten = TRUE)
  so_list <- get_result_json$result


  call1 <- paste0(
    host,
    "/core/data/export"
  )
  body <- toString(jsonlite::toJSON(list(
    experiments = I(experiment_uri), # I() allows this to not be unboxed
    mode = mode,
    targets = so_list$uri
  ), auto_unbox = TRUE))

  get_result <- opensilexR::parse_status(
    httr::POST(
      call1,
      httr::add_headers(
        Authorization = token,
        `Content-Type` = "application/json"
      ),
      body = body
    )
  )
  get_result_text <- httr::content(get_result, "text")

  if (mode == "wide") {
    # skip variable description lines
    result_df <- utils::read.csv(text = get_result_text, header = TRUE, skip = 4,
                                 check.names = FALSE)
  } else if (mode == "long") {
    result_df <- utils::read.csv(text = get_result_text, header = TRUE,
                                 check.names = FALSE)
    # exclude an empty column
    result_df <- result_df[! colnames(result_df) %in% c("")]
  }
  final_df <- result_df %>% dplyr::filter(dplyr::cur_data_all()[["Target URI"]] %in% so_list$uri)
  return(final_df)
}
