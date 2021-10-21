#' Check md5 checksums
#'
#' @description This function allows users to (i) generate md5 checksums on
#'   files that have been copied/download/transferred and (ii) check that these
#'   match with md5 checksums generated on the original files.
#'
#' @param file_paths a `data.frame` or [tibble][tibble::tbl_df-class] object
#'   with the following two columns:
#' \itemize{
#'  \item `file_path`: full file path for files for which md5s should be
#'  generated
#'  \item `file_name`: file name, which should match the file name in the
#'  `original_md5` dataframe.
#'  }
#' @param original_md5 a `data.frame` or [tibble][tibble::tbl_df-class] object,
#'   with md5 checksums from the original files. Should include two columns:
#'  \itemize{
#'  \item `file_name`: file name
#'  \item `original_md5`: md5 checksum
#'  }
#' @param column_to_join_by `character()` vector, indicating the name of the
#'   column in the dataframe supplied to the argument `original_md5`, which
#'   will be used to join original and transfer md5 dataframes.
#'
#' @return a [tibble][tibble::tbl_df-class] object with the following columns:
#'  \itemize{
#'  \item `file_path`: full file path for files for which md5s were generated
#'  \item `file_name`: file name
#'  \item `original_md5`: original md5 checksum
#'  \item `new_md5`: generated md5 checksum
#'  \item `same_md5`: contains values TRUE/FALSE; FALSE if md5
#'   checksums do not match, and TRUE if they match.
#'  }
#' @export
#'
#' @importFrom tools md5sum
#'
#' @examples
#' file_path <-
#'     system.file(
#'         "testdata",
#'         package = "rutils",
#'         mustWork = TRUE
#'     )
#'
#' original_md5 <-
#'     readr::read_delim(
#'         file.path(file_path, "md5_test_data.txt"),
#'         delim = "\t"
#'     )
#'
#' file_paths <-
#'     tibble::tibble(
#'         file_path =
#'             list.files(
#'                 file_path,
#'                 pattern = "over.chain",
#'                 full.names = TRUE
#'             )
#'     ) %>%
#'     dplyr::mutate(
#'         file_name = basename(file_path)
#'     )
#'
#' md5_df <-
#'     md5_check(
#'         file_paths = file_paths,
#'         original_md5 = original_md5,
#'         column_to_join_by = "file_name"
#'     )
#'
#' md5_df
#'
#' print("All check sums match between files?")
#'
#' all(md5_df$same_md5)
md5_check <-
    function(file_paths,
    original_md5,
    column_to_join_by) {

        # Generate md5s using supplied file paths
        new_md5 <-
            file_paths %>%
            dplyr::mutate(
                new_md5 = tools::md5sum(.data$file_path)
            )

        # Create filtering vector for inner join
        filtering_vector <- "file_name"
        names(filtering_vector) <- column_to_join_by

        # Join dataframe
        check_df <-
            original_md5 %>%
            dplyr::inner_join(new_md5, by = filtering_vector) %>%
            dplyr::mutate(
                same_md5 =
                    dplyr::case_when(
                        original_md5 == new_md5 ~ TRUE,
                        TRUE ~ FALSE
                    )
            ) %>%
            dplyr::select(
                .data$file_path,
                .data$file_name,
                .data$original_md5,
                .data$new_md5,
                .data$same_md5
            )

        return(check_df)
    }
