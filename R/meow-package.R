#' meow package
#'
#' @name meow-package
#' @aliases meow
#' @docType package
#' @description Serves TNC Marine Ecoregions Of the World (MEOW).
#' @seealso [TNC's ArcHub contribution](https://hub.arcgis.com/datasets/903c3ae05b264c00a3b5e58a4561b7e6/about)
#' @importFrom utils download.file unzip
NULL

#' Read the ecoregions
#' 
#' @export 
#' @param filename character, the name of file to read
#' @return sf object
#' @examples
#' \dontrun{
#'   library(sf)
#'   x <- meow::read_meow()
#'   plot(x['Lat_Zone'])
#' }
read_meow <- function(filename = system.file("exdata/meow.geojson", 
                                             package = "meow")){
  
  if (!file.exists(filename[1])) stop("file not found: ", filename[1])
  sf::read_sf(filename)
} 


#' Fetch the MEOW data
#' 
#' @export
#' @param uri character, the uri of the data source
#' @param save_file character, to save the file, if left empty (""), NA or NULL
#'   then no data is saved to disk.
#' @return sf object
fetch_meow <- function(
    uri = file.path("https://www.arcgis.com/sharing/rest",
                    "content/items/903c3ae05b264c00a3b5e58a4561b7e6/data"),
    save_file = NULL){
  
  file = tempfile("meow", fileext = ".zip")
  ok <- download.file(uri[1], file)
  if (ok > 0) stop("error downloading: ", uri)
  path <- tempdir()
  ok <- unzip(file, exdir = path)
  x <- sf::read_sf(path)
  if (!is.null(save_file[1]) && !is.na(save_file[1]) && nchar(save_file[1]) > 0){
    sf::write_sf(x, file = save_file[1])
  }
  x
}
