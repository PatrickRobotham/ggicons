library(ggplot2)
library(grid)

GeomIcon <- ggproto("GeomIcon", Geom,
  required_aes = c("x", "y", "file_path"),
  default_aes = ggplot2::aes(width = 0.1, height = 0.1),

  draw_panel = function(data, panel_scales, coord){
    coords <- coord$transform(data, panel_scales)
    iconGrob(x = coords$x,
             y = coords$y,
             file_path = coords$file_path,
             width = coords$width,
             height = coords$height)
  }
)

iconGrob <- function(x,y,file_path, width = 0.1, height = 0.1){
  grob(x = x, y = y, file_path = file_path, cl = "icon",
       width = width, height = height)
}

drawDetails.icon <- function(x, recording = FALSE){
  for(i in seq_along(x$file_path)){
    image <- png::readPNG(x$file_path[[i]])
    grid.raster(x$x[i], x$y[i], image = image,
                width = x$width[i], height = x$height[i])
  }
}

#'
#' @export
#' geom_icon
#' @title Icons
#'
#' @description
#' The icon geom, like the point geom, is used to create scatterplots.
#' Icons are specified by filepaths into an image file.
#'
#' @details
#'
#' @examples
#' data(tidyverse_downloads)
#' downloads_with_icon <- tidyverse_downloads %>%
#'    mutate(file_path = system.file("icons",paste0(package,".png"),"ggicons"))
#'  ggplot(downloads_with_icon, aes(x = Jan2017, y = change_percentage, file_path = file_path)) +
#'  geom_icon()
#'
geom_icon <- function(mapping = NULL, data = NULL, stat = "identity",
                      position = "identity", na.rm = FALSE, show.legend = NA,
                      inherit.aes = TRUE, ...){
  layer(
    geom = GeomIcon,  mapping = mapping, data = data, stat = stat,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}
