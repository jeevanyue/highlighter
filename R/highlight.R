#'
#' Highlight code
#'
#' Highlight code using highlight.js
#'
#' @param code The original raw code.
#' @param file The file want highlight.
#' @param language Language name, supports r, python and sql. The default is r.
#' @param style Highlight style. The default is default.
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended. The default is \code{'100\%'}.
#' @param elementId Use an explicit element ID for the widget (rather than an automatically generated one). The default is NULL.
#'
#' @examples
#' highlight(code = "df <- head(mtcars)")
#' highlight(code = "df <- head(mtcars)", style = "dark")
#'
#' @import htmlwidgets
#' @export
highlight <- function(code = NULL, file = NULL, language = "r", style = "default", width = "100%", height = "100%", elementId = NULL){
	if (is.null(language)) language <- "r"
	if (is.null(style)) style <- "default"

	# read file
	if (!is.null(file)) {
		code <- readr::read_file(file)
	}

	htmlwidgets::createWidget(
		name = "highlighter",
		x = list(
			code = code,
			style = style,
			language = language
		),
		width = width,
		height = height,
		package = "highlighter",
		dependencies = htmltools::htmlDependency(
			name = paste0("highlighter-style-", style),
			version = "10.3.1",
			src = system.file("htmlwidgets/lib/highlight-10.3.1/styles", package = "highlighter"),
			stylesheet = paste0(style, ".css")
		),
		elementId = elementId
		)
}

#' Shiny bindings for HTML widgets
#'
#'
#' @param outputId The name of the input.
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#'
#' @examples
#' if (interactive()) {
#' library(shiny)
#' library(highlighter)
#'
#' ui <- fluidPage(
#' 	highlightOutput("hl1"),
#' 	highlightOutput("hl2"),
#' 	highlightOutput("hl3")
#' )
#'
#' server <- function(input, output, session) {
#' 	output$hl1 <- renderHighlight({
#' 		highlight("library('tidyverse')", style = "default2")
#' 	})
#' 	output$hl2 <- renderHighlight({
#' 		highlight("library('tidyverse')", style = "dark2")
#' 	})
#' 	output$hl3 <- renderHighlight({
#' 		highlight("library('tidyverse')", style = "solarized-dark2")
#' 	})
#' }
#'
#' shinyApp(ui, server)
#' }
#' @name highlight-shiny
#'
#' @export
highlightOutput <- function(outputId, width = "100%", height = "100%") {
	htmlwidgets::shinyWidgetOutput(
		outputId, name = "highlighter", width, height, package = "highlighter")
}

#' @param expr An expression that generates an HTML widget (or a
#'   \href{https://rstudio.github.io/promises/}{promise} of an HTML widget).
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @examples
#'
#' @name highlight-shiny
#'
#' @export
renderHighlight <- function(expr, env = parent.frame(), quoted = FALSE) {
	if (!quoted) { expr <- substitute(expr) } # force quoted
	htmlwidgets::shinyRenderWidget(expr, highlightOutput, env, quoted = TRUE)
}
