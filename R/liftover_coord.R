#' Liftover genomic coordinates from one genome build to another.
#'
#' @param df Dataframe with genomic coordinates. Must include columns, \code{CHR} and
#'   \code{BP}, with chromosome and base pair, respectively. If additional
#'   columns included these will be preserved.
#' @param path_to_chain Path to UCSC chain file for transformation. This can
#'   either be from hg19 to hg38 or hg38 to hg19.
#'
#' @return Dataframe with coordinates in different genome build.
#' @export

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
