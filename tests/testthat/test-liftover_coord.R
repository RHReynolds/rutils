context("Testing liftover of genomic coordinates")

# Load data ---------------------------------------------------------------

test_data_path <- system.file("testdata", "liftover_test_data.txt", package = "rutils", mustWork = TRUE)
hg19_path <- system.file("testdata", "hg19ToHg38.over.chain", package = "rutils", mustWork = TRUE)
hg38_path <- system.file("testdata", "hg38ToHg19.over.chain", package = "rutils", mustWork = TRUE)

test_data <- 
  readr::read_delim(test_data_path,
                    delim = " ",
                    col_types =
                      readr::cols(
                        SNP = readr::col_character(),
                        CHR = readr::col_factor(),
                        BP_hg19 = readr::col_integer(),
                        BP_hg38 = readr::col_integer()
                      ))


# Testing -----------------------------------------------------------------

test_liftover_hg19 <- 
  liftover_coord(df = test_data %>% 
                   dplyr::select(SNP, CHR, BP = BP_hg19), 
                 path_to_chain = hg19_path
                 )

test_liftover_hg38 <- 
  liftover_coord(df = test_data %>% 
                   dplyr::select(SNP, CHR, BP = BP_hg38), 
                 path_to_chain = hg38_path
  )

test_that("liftover_coord correctly converts hg19 to hg38", {
  expect_true(methods::is(test_liftover_hg19, "data.frame"))

  expect_equivalent(
    test_liftover_hg19[["BP"]],
    test_data[["BP_hg38"]]
  )
  
})

test_that("liftover_coord correctly converts hg38 to hg19", {
  expect_true(methods::is(test_liftover_hg38, "data.frame"))
  
  expect_equivalent(
    test_liftover_hg38[["BP"]],
    test_data[["BP_hg19"]]
    )

})