context("Testing md5 check function")

# Load data ---------------------------------------------------------------

test_data_path <- system.file("testdata", package = "rutils", mustWork = TRUE)

test_files <-
    tibble::tibble(
        file_path =
            list.files(
                test_data_path,
                pattern = "over.chain",
                full.names = TRUE
            )
    ) %>%
    dplyr::mutate(
        file_name = basename(file_path)
    )

original_md5 <-
    readr::read_delim(
        file.path(test_data_path, "md5_test_data.txt"),
        delim = "\t"
    )

# Testing -----------------------------------------------------------------

test_md5 <-
    md5_check(
        file_paths = test_files,
        original_md5 = original_md5,
        column_to_join_by = "file_name"
    )

test_that("md5s generated match original md5s", {
    expect_true(methods::is(test_md5, "data.frame"))

    expect_equivalent(
        test_md5[["new_md5"]],
        original_md5[["original_md5"]]
    )
})
