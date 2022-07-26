#' Scientific Object Modalities
#'
#' @param host url of the hosting opensilex service
#' @param user opensilex user
#' @param password opesnielx user's password
#' @param experiment_uri uri of the targeted experiment
#' @param scientific_object_type uri of the targeted scientific object type
#'
#' @return
#' @export
#' @importFrom httr POST content add_headers
#' @importFrom jsonlite fromJSON
#' @importFrom utils read.csv
#' @examples
get_scientific_object_modalities <- function(host,
                                             user,
                                             password,
                                             experiment_uri,
                                             scientific_object_type,
                                             header_type="initial") {
  stopifnot(header_type %in% c("initial","translated","both"))
  token <- opensilexR::get_token(
    host = host,
    user = user,
    password = password
  )
  call1 <- paste0(host, "/core/scientific_objects/export")
  post_result <-
    httr::POST(
      call1,
      body = paste0(
        '{
          "experiment": "', experiment_uri, '",
          "factor_levels": [],
          "name": "",
          "order_by": ["name=asc"],
          "rdf_types": ["', scientific_object_type, '"]
         }'
      ),
      httr::add_headers(
        Authorization = token,
        `Content-Type` = "application/json"
      )
    )
  # Can't read 'httr::content:as' a csv, need to do it manually
  # also safer
  # see https://httr.r-lib.org/reference/content.html
  post_result_text <- httr::content(post_result, "text")
  # The two header lines doesn't render well -> need to choose one
  header_lines <- utils::read.csv(
    text = post_result_text,
    nrows = 2,
    header = FALSE,
    sep = ";"
  )
  if(header_type == "initial"){
    header <- header_lines[1,]
  } else if(header_type == "translated"){
    header <- header_lines[2,]
  } else if(header_type == "both"){
    header <- paste(header_lines[1, ], header_lines[2, ], sep = "/")
  }
  result_df <- read.csv(
    text = post_result_text,
    skip = 2,
    col.names = header,
    row.names = NULL,
    sep = ";",
    check.names = FALSE
  )
  return(result_df)
}
