#' Get Token
#'
#' Function use to get the token for a user
#' @param host url of the hosting opensilex service
#' @param user opensilex user
#' @param password opensilex user's password
#'
#' @return A string token, used by every subsequent call
#' @export
#' @importFrom httr POST content add_headers
#' @importFrom jsonlite fromJSON
#' @examples
get_token <- function(host, user = "guest@opensilex.org", password = "guest") {
  call0 <- paste0(host, "/security/authenticate")
  post_authenticate <- opensilexR::parse_status(
      httr::POST(
        call0,
        body = paste0('{
          "identifier": "', user, '",
          "password": "', password, '"
          }'
        ),
        httr::add_headers(
          `Content-Type` = "application/json",
          Accept = "application/json"
      )
    )
  )
  post_authenticate_text <- httr::content(post_authenticate, "text")
  post_authenticate_json <- jsonlite::fromJSON(
    post_authenticate_text,
    flatten = TRUE
  )
  token <- post_authenticate_json$result$token
  return(token)
}
