# opensilexR

A set of basic functions to ease data access to an opensilex instance. This package is purposely "low level", and its source code can easily be adapted and reused for custom or more specific need to call the opensilex API.

# Installation

```R
library(remotes)
install_github("guilhemheinrich/R-opensilex-package")
```

# Usage

There is (mainly) two ways this package can be used: either directly to quickly get data when we know an experiment uri (and we gete credential allowing access to it), and some utility functions to bild more complex scenario when using the opensilex API.

## Quick data example

Retrieve data from the public Sixtine's opensilex instance.

Let's start with scientific object modalities:
```R
opensilexR::os_modality(
    host = "https://sixtine.mistea.inrae.fr/rest",
    user = "admin@opensilex.org",
    password = "admin",
    experiment_uri = "sixtine:set/experiments#qualite-du-fruit-2017",
    scientific_object_type = "http://www.opensilex.org/vocabulary/oeso#SubPlot")
)
```

and the actual data ("directly") linked to those: 
```R
opensilexR::data_import(
    host = "https://sixtine.mistea.inrae.fr/rest",
    user = "admin@opensilex.org",
    password = "admin",
    experiment_uri = "sixtine:set/experiments#qualite-du-fruit-2017",
    scientific_object_type = "http://www.opensilex.org/vocabulary/oeso#SubPlot")
)
```

## Using the opensilex api example

A simple call to retrieve all experiments of the SIXTINE instance
```R
opensilexR::data_import(
    host = "https://sixtine.mistea.inrae.fr/rest",
    user = "admin@opensilex.org",
    password = "admin",
    experiment_uri = "sixtine:set/experiments#qualite-du-fruit-2017",
    scientific_object_type = "http://www.opensilex.org/vocabulary/oeso#SubPlot")
)

token <- opensilexR::get_token(
    host = "https://sixtine.mistea.inrae.fr/rest",
    user = "admin@opensilex.org",
    password = "admin",
)
url <-
  paste0("https://sixtine.mistea.inrae.fr/rest",
         "/core/experiments",
         "?page_size=10000")
get_result <-
  httr::GET(url, httr::add_headers(Authorization = token))
get_result_text <- httr::content(get_result, "text")
get_result_json <-
  jsonlite::fromJSON(get_result_text, flatten = TRUE)
experiments_df <- get_result_json$result
colnames(experiments_df)[which(names(experiments_df) == "uri")] <-
  "experiment_uri"
colnames(experiments_df)[which(names(experiments_df) == "name")] <-
  "experiment_label"
```
