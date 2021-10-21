#' Visualise reduced pathway enrichments
#'
#' \code{go_plot} plots GO terms that have been reduced using \code{\link{go_reduce}}.
#'
#' @param reduced_pathway_df the [tibble][tibble::tbl_df-class] derived from
#'   \code{\link{go_reduce}}.
#' @param col_gene_list a `character()` vector, with the name of column
#'   containing the name(s) of the inputted gene list(s). Defaults to
#'   `"gene_list"`.
#' @param col_fdr a `character()` vector, with the name of column containing
#'   enrichment p-values/fdr-values. Defaults to `"fdr"`.
#' @param fct_gene_list a `character()` vector, with the order in which input
#'   gene lists should be factored. Defaults to NULL.
#'
#' @return `ggplot` displaying the pathway enrichments using reduced perent
#'   terms. \itemize{
#'   \item x-axis displays the inputted gene list(s).
#'   \item
#'   y-axis displays the reduced parent term, with the number of associated
#'   child GO terms in brackets. Parent terms are ordered first by the factoring
#'   of the input gene list (as provided in the argument, `fct_gene_list`) and
#'   then by the number of associated child terms.
#'   \item size of the dot indicates the proportion of child terms associated
#'   with an inpute gene list that are annotated to the parent term.
#'   \item fill of dot indicates the minimum FDR
#'   assigned to a child term that is associated with the parent term (within an
#'   input gene list).
#'   }
#' @export
#'
#' @importFrom ggplot2 ggplot aes geom_point labs scale_size_continuous
#'   scale_colour_viridis_c theme_bw theme unit
#' @importFrom forcats fct_relevel
#' @importFrom stats setNames
#'
#' @family GO-related functions
#' @seealso \code{\link{go_reduce}} for reducing GO terms
#'
#' @examples
#' file_path <-
#'     system.file(
#'         "testdata",
#'         "go_test_data.txt",
#'         package = "rutils",
#'         mustWork = TRUE
#'     )
#'
#' pathway_df <-
#'     readr::read_delim(file_path,
#'         delim = "\t"
#'     ) %>%
#'     dplyr::mutate(
#'         gene_list = c(rep("a", 5), rep("b", 5)),
#'         fdr = runif(10, min = 0, max = 0.05)
#'     )
#'
#' reduced_pathway_df <-
#'     go_reduce(
#'         pathway_df = pathway_df,
#'         threshold = 0.9,
#'         scores = NULL,
#'         measure = "Wang"
#'     )
#'
#' go_plot(
#'     reduced_pathway_df,
#'     col_gene_list = "gene_list",
#'     col_fdr = "fdr",
#'     fct_gene_list = c("b", "a")
#' )
go_plot <- function(reduced_pathway_df,
    col_gene_list = "gene_list",
    col_fdr = "fdr",
    fct_gene_list = NULL) {
    if (!col_gene_list %in% colnames(reduced_pathway_df)) {
        stop(stringr::str_c(col_gene_list, " is not a column name in the inputted dataframe."))
    }

    if (!col_fdr %in% colnames(reduced_pathway_df)) {
        stop(stringr::str_c(col_fdr, " is not a column name in the inputted dataframe."))
    }

    go_data_to_plot <-
        .go_data_to_plot_get(
            reduced_pathway_df,
            col_gene_list = col_gene_list,
            col_fdr = col_fdr,
            fct_gene_list = fct_gene_list
        )

    plot <-
        go_data_to_plot$plot_data %>%
        ggplot(
            aes(
                x = .data[[col_gene_list]],
                y = fct_relevel(
                    .data$parent_labels,
                    go_data_to_plot$pathway_fct
                ),
                colour = -log10(.data$min_fdr),
                size = .data$prop_enriched_terms_per_gene_list
            )
        ) +
        geom_point() +
        geom_point(shape = 1, colour = "black") +
        labs(
            x = "Input gene list",
            y = "Reduced GO term"
        ) +
        scale_size_continuous(name = "Prop. enriched terms") +
        scale_colour_viridis_c(
            name = "-log"[1][0] ~ "(FDR)",
            na.value = "white",
            option = "cividis"
        ) +
        theme_bw(base_size = 10) +
        theme(legend.key.size = unit(0.35, "cm"))

    return(plot)
}

#' Tidy user input and prepare for plotting
#'
#' `.go_data_to_plot_get` will prepare the output of \code{\link{go_reduce}} for
#' plotting. Preparation steps include:
#' \enumerate{
#' <\item Counting the number of
#' child terms per parent term. These will be used to create the y-axis labels.
#' \item Calculate the proportion of child terms in an input gene list that are
#' annotated to the parent term.
#' \item Re-factor the parent terms, such that on
#' the y-axis they are ordered first by the order of the input gene list(s) on
#' the x-axis and then by the number of child terms it contains.
#' }
#'
#' @inheritParams go_plot
#'
#' @keywords internal
#' @noRd
#'

.go_data_to_plot_get <-
    function(reduced_pathway_df,
    col_gene_list = "gene_list",
    col_fdr = "fdr",
    fct_gene_list) {

        # Count number of child terms per parent term
        # And create label for y-axis
        child_parent_df <-
            reduced_pathway_df %>%
            dplyr::distinct(
                .data$go_id,
                .data$parent_term
            ) %>%
            dplyr::group_by(.data$parent_term) %>%
            dplyr::count(name = "n_child_terms") %>%
            dplyr::mutate(
                parent_labels =
                    stringr::str_c(
                        .data$parent_term,
                        " (",
                        .data$n_child_terms,
                        ")"
                    )
            )

        plot_data <-
            reduced_pathway_df %>%
            dplyr::group_by(
                .data[[col_gene_list]],
                .data$parent_term
            ) %>%
            dplyr::summarise(
                n_enriched_pathways_per_gene_list = dplyr::n(),
                min_fdr = min(.data[[col_fdr]])
            ) %>%
            dplyr::ungroup() %>%
            dplyr::inner_join(child_parent_df) %>%
            dplyr::mutate(
                prop_enriched_terms_per_gene_list =
                    .data$n_enriched_pathways_per_gene_list / .data$n_child_terms,
                parent_term =
                    stringr::str_to_sentence(.data$parent_term),
                gene_list =
                    .data[[col_gene_list]] %>%
                        fct_relevel(., fct_gene_list)
            )

        # Re-factor pathways to appear in order of
        # 1. gene_lists on x-axis
        # 2. n child terms in parent term
        pathway_fct <-
            plot_data %>%
            dplyr::distinct(
                .data[[col_gene_list]],
                .data$parent_labels,
                .data$n_child_terms
            ) %>%
            dplyr::arrange(
                .data[[col_gene_list]],
                -.data$n_child_terms,
                .data$parent_labels
            ) %>%
            .[["parent_labels"]] %>%
            unique() %>%
            as.character()

        go_data_to_plot <-
            setNames(
                object = list(plot_data, pathway_fct),
                nm = c("plot_data", "pathway_fct")
            )

        return(go_data_to_plot)
    }
