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
get_token <- function(host, user = "admin@opensilex.org", password = "admin") {
  call0 <- paste(host, "/security/authenticate", sep = "")
  post_authenticate <- httr::POST(
    call0,
    body = paste('{
  "identifier": "', user, '",
  "password": "', password, '"
}', sep = ""),
    httr::add_headers(
      `Content-Type` = "application/json",
      Accept = "application/json"
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
