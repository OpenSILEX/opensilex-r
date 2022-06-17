# opensilexR

A set of basic functions to ease data access to an opensilex instance. This package is purposely "low level", and its source code can easily be adapted and reused for custom or more specific need to call the opensilex API.

# Installation

```R
library(remotes)
install_github("guilhemheinrich/R-opensilex-package")
```

# Usage

There is (mainly) two ways this package can be used: either directly to quickly get data when we know an experiment uri (and we gete credential allowing access to it), and some utility functions to build more complex scenarios when using the opensilex API.

## Quick data example

Retrieve data from the public phis's opensilex public instance.
Let start by setting up authaurization and our target

```R
configuration <- list(
  host = "http://opensilex.org:8084/rest",
  user = "admin@opensilex.org",
  password = "admin",
  experiment_uri = "http://www.phenome-fppn.fr/m3p/ARCH2017-03-30",
  scientific_object_type = "vocabulary:Plant" 
)
```
First we will get all data relative to our scientfic object: it can be factor level or germplasm for example.
```R
os_modalities <- opensilexR::get_scientific_object_modalities(
    host = configuration$host,
    user = configuration$user,
    password = configuration$password,
    experiment_uri = configuration$experiment_uri,
    scientific_object_type = configuration$scientific_object_type
)
```
os_modalities is a *data.frame* and can be explored by the usual ways
```R
summary(os_modalities)
head(os_modalities)
```

and to retrieve the actual data ("directly") linked to those scientific objects: 
```R
data <- opensilexR::get_data(
    host = configuration$host,
    user = configuration$user,
    password = configuration$password,
    experiment_uri = configuration$experiment_uri,
    scientific_object_type = configuration$scientific_object_type
)
```

we can also specified one or more variables
```R
data <- opensilexR::get_data(
    host = configuration$host,
    user = configuration$user,
    password = configuration$password,
    experiment_uri = configuration$experiment_uri,
    scientific_object_type = configuration$scientific_object_type,
    variables = c(
      "publictest:id/variable/leaf_area_imageanalysis_squaremeter", "publictest:id/variable/plant_height_imageanalysis_millimetre"
    )
)
```
data is also a *data.frame*
```R
summary(data)
head(data)
```
Those two functions should get you started very quick, but for the ones who want a finest control about what data they want, and when, the whole opensilex api is available.
See next chapter !
## Methodology
The two previous function mainly use the *httr* and *jsonlite* packages. Those are considered quite "low level" and should work on a vast spectre of R versions.
To make your own call, we can take a look at the implementation of the previous function to have a rough idea of how we can handle the query, and at the api-docs of the opensilex instance you want to interract with.

### Is it a GET, a POST, or something else ?

### Is the parameters in the body ?

### Take a look at the header
## Known issue

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
