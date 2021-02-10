#' Liftover genomic coordinates from one genome build to another.
#'
#' @description This function allows users to lift genomic co-ordinates from one
#'   genome build to another. It uses an over.chain liftOver conversion file.
#'   Conversion files can be downloaded from
#'   [UCSC](http://hgdownload.soe.ucsc.edu/downloads.html#liftover).
#'
#' @param df a `data.frame` object with genomic coordinates. Must include the
#'   following columns: 
#'   \itemize{ 
#'   \item `CHR` - `character()` vector, with "chr"
#'   attached to the chromosome e.g. `chr1` 
#'   \item `BP` - base pair, as a
#'   `numeric()` vector } 
#'   Any additional columns included will be preserved.
#' @param path_to_chain a `character()` vector, with the file path to the UCSC
#'   chain file for transformation.
#'
#'
#' @return Dataframe with coordinates in different genome build.
#' @export
#' 
#' @examples 
#' file_path <- 
#'   system.file(
#'     "testdata", 
#'     "liftover_test_data.txt", 
#'     package = "rutils", 
#'     mustWork = TRUE
#'   )
#' 
#' hg19_path <- 
#'   system.file(
#'     "testdata", 
#'     "hg19ToHg38.over.chain", 
#'     package = "rutils", 
#'     mustWork = TRUE
#'   )
#' 
#' genomic_df <- 
#'   readr::read_delim(file_path,
#'                     delim = " ",
#'                     col_types =
#'                       readr::cols(
#'                         SNP = readr::col_character(),
#'                         CHR = readr::col_factor(),
#'                         BP_hg19 = readr::col_integer(),
#'                         BP_hg38 = readr::col_integer()
#'                       ))
#' 
#' liftover_coord(df = 
#'                  genomic_df %>% 
#'                  dplyr::select(SNP, 
#'                                CHR, 
#'                                BP = BP_hg19), 
#'                path_to_chain = hg19_path
#' )

liftover_coord <- function(df, path_to_chain){
  
  # Import chain file
  chain_file <- rtracklayer::import.chain(path_to_chain)
  
  # If CHR column does not have "chr" in name, add to allow liftover
  if(!stringr::str_detect(df$CHR[1], "chr")){
    
    df <- df %>%
      dplyr::mutate(CHR = stringr::str_c("chr", .data$CHR))
    
  }
  
  # Convert df to GRanges object
  df_gr <-
    GenomicRanges::makeGRangesFromDataFrame(df,
                                            keep.extra.columns = TRUE,
                                            ignore.strand = TRUE,
                                            seqinfo = NULL,
                                            seqnames.field = "CHR",
                                            start.field = "BP",
                                            end.field = "BP",
                                            starts.in.df.are.0based = FALSE)
  
  df_liftover <-
    rtracklayer::liftOver(df_gr, chain_file) %>%
    unlist() %>%
    tibble::as_tibble() %>%
    dplyr::rename(CHR = .data$seqnames,
                  BP = .data$start) %>%
    dplyr::select(-.data$end, -.data$width, -.data$strand) %>%
    dplyr::mutate(CHR = stringr::str_replace(.data$CHR, "chr", ""))
  
  return(df_liftover)
  
}
