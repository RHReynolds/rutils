#' Reduce redundancy of human GO terms
#'
#' @description This function will reduce GO redundancy first by creating a
#'  semantic similarity matrix (using
#'  \code{GOSemSim::\link[GOSemSim:mgoSim]{mgoSim}}), which is then passed
#'  through \code{rrvgo::\link[rrvgo:reduceSimMatrix]{reduceSimMatrix()}},
#'  which will reduce a set of GO terms based on their semantic similarity and
#'  scores (in this case, a default score based on set size is assigned.)
#'
#' @details Semantic similarity is calculated using the "Wang" method, a
#'  graph-based strategy to compute semantic similarity using the topology of
#'  the GO graph structure. \code{GOSemSim::\link[GOSemSim:mgoSim]{mgoSim}} does
#'  permit use of other measures (primarily information-content measures), but
#'  "Wang" is used as the default in GOSemSim (and was, thus, used as the
#'  default here).
#'
#'  \code{rrvgo::\link[rrvgo:reduceSimMatrix]{reduceSimMatrix()}} creates a
#'  distance matrix, defined as (1-simMatrix). The terms are then hierarchically
#'  clustered using complete linkage (an agglomerative, or "bottom-up"
#'  clustering approach), and the tree is cut at the desired threshold. The term
#'  with the highest "score" is used to represent each group.
#'
#' @param pathway_df a `data.frame` or [tibble][tibble::tbl_df-class] object,
#'  with the following columns:
#'  \itemize{
#'  \item `go_type`: the sub-ontology the
#'  GO term relates to. Should be one of `c("BP", "CC", "MF")`.
#'  \item `go_id`: the gene ontology identifier (e.g. GO:0016209)
#'  }
#' @param threshold `numeric()` vector. Similarity threshold (0-1) for
#'  \code{rrvgo::\link[rrvgo:reduceSimMatrix]{reduceSimMatrix()}}. Some
#'  guidance: Large (allowed similarity=0.9), Medium (0.7), Small (0.5), Tiny
#'  (0.4) Defaults to Medium (0.7).
#' @param scores \strong{named} vector, with scores (weights) assigned to each
#'  term. Higher is better. Can be NULL (default, means no scores. In this case,
#'  a default score based on set size is assigned, thus favoring larger sets).
#'  Note: if you have p-values as scores, consider log-transforming them
#'  (`-log10(p)`).
#'
#' @return a [tibble][tibble::tbl_df-class] object of pathway results, a
#'  "reduced" parent term to which pathways have been assigned. New columns:
#'  \itemize{
#'  \item `parent_id`: the GO ID of the parent term
#'  \item `parent_term`: a description of the GO ID
#'  \item `parent_sim_score`: the similarity score between the child GO term and
#'  its parent term
#'  }
#' @export
#'
#' @references \itemize{
#'  \item Yu et al. (2010) GOSemSim: an R package for measuring semantic
#'  similarity among GO terms and gene products \emph{Bioinformatics} (Oxford,
#'  England), 26:7 976--978, April 2010.
#'  \url{http://bioinformatics.oxfordjournals.org/cgi/content/abstract/26/7/976}
#'  PMID: 20179076
#'  \item Sayols S (2020). rrvgo: a Bioconductor package to
#'  reduce and visualize Gene Ontology terms. \url{https://ssayols.github.io/rrvgo}
#'  }
#'  
#' @importFrom stats setNames
#' @importFrom tidyselect contains
#'
#' @examples
#' file_path <- 
#'   system.file(
#'     "testdata", 
#'     "go_test_data.txt", 
#'     package = "rutils", 
#'     mustWork = TRUE
#'   )
#'   
#' pathway_df <- 
#'   readr::read_delim(file_path,
#'                     delim = "\t")
#' 
#' reduce_go_redundancy(
#'   pathway_df = pathway_df,
#'   threshold = 0.9,
#'   scores = NULL)
#'   

reduce_go_redundancy <- function(
  pathway_df,
  threshold = 0.7,
  scores = NULL) {
  
  ont <- 
    pathway_df %>% 
    .[["go_type"]] %>% 
    unique()
  
  if(!ont %in% c("BP", "CC", "MF")){
    stop('Column go_type does not contain the recognised sub-ontologies, c("BP", "CC", "MF")')
  }

  go_similarity <-
    setNames(
      object =
        vector(
          mode = "list",
          length = length(ont)
        ),
      nm = ont
    )


  for (i in 1:length(ont)) {
    hsGO <-
      GOSemSim::godata(
        OrgDb = "org.Hs.eg.db",
        ont = ont[i],
        computeIC = FALSE
      )

    # Get unique ont terms from pathway_df
    terms <-
      pathway_df %>%
      dplyr::filter(.data$go_type == ont[i]) %>%
      .[["go_id"]] %>%
      unique()

    # Calculate semantic similarity
    sim <-
      GOSemSim::mgoSim(
        GO1 = terms,
        GO2 = terms,
        semData = hsGO,
        measure = "Wang",
        combine = NULL
      )

    # Reduce terms as based on scores or set size assigned
    go_similarity[[i]] <-
      rrvgo::reduceSimMatrix(
        sim = sim,
        threshold = threshold,
        orgdb = "org.Hs.eg.db",
        scores = scores
      ) %>%
      tibble::as_tibble() %>% 
      dplyr::rename(parent_id = .data$parent,
                    parent_term = .data$parentTerm,
                    parent_sim_score = .data$parentSimScore)
  }

  go_sim_df <-
    go_similarity %>%
    qdapTools::list_df2df(col1 = "go_type")

  pathway_go_sim_df <-
    pathway_df %>%
    dplyr::inner_join(go_sim_df %>%
                        dplyr::select(.data$go_type, go_id = .data$go, contains("parent"))) %>% 
    dplyr::arrange(.data$go_type, .data$parent_id, -.data$parent_sim_score)

  return(pathway_go_sim_df)
  
}
