#' Calculate summary statistics
#'
#' @author David Zhang \url{https://github.com/dzhang32/rutils}
#'
#' @param df a `data.frame` object.
#' @param sum_vars `character()` vector with name of columns to `summarize`.
#' @param sum_funcs either function or list of functions. By default, uses
#'   `base::mean()`, `stats::sd()`, `stats::median()`, `stats::IQR()`.
#' @param group_vars `character()` vector with name of columns to `group_by()`
#'
#' @return [tibble][tibble::tbl_df-class] object containing summarized data.
#' @export
#'
#' @examples
#' iris_summary <-
#'     get_sum_stats(
#'         iris,
#'         sum_vars = "Sepal.Length",
#'         group_vars = "Species"
#'     )
get_sum_stats <- function(df,
    sum_vars,
    group_vars = NULL,
    sum_funcs =
        list(
            mean = base::mean,
            sd = stats::sd,
            median = stats::median,
            iqr = stats::IQR
        )) {
    if (!is.null(group_vars)) {
        df <- df %>%
            dplyr::group_by_at(.vars = group_vars)
    }

    df_summary <- df %>%
        dplyr::summarise_at(
            .vars = sum_vars,
            .funs = sum_funcs
        ) %>%
        dplyr::ungroup()

    return(df_summary)
}
