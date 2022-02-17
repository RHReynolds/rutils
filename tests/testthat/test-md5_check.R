context("Testing md5 check function")

# Load data ---------------------------------------------------------------

test_data_path <- system.file("testdata", package = "rutils", mustWork = TRUE)

# Test file created by running `touch md5_test_file.txt` in inst/testdata
# Need test file to have no new line due to differences in line endings on OSs and how this impacts md5 hash
# https://stackoverflow.com/questions/23829553/different-hash-value-created-on-windows-linux-and-mac-for-same-image
test_files <-
    tibble::tibble(
        file_path =
          file.path(test_data_path, "md5_test_file.txt")
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
