test_df <-
    dplyr::tibble(
        x = rep(c("hello", "world"), 6),
        var1 = sample(100, 12),
        var2 = sample(100, 12)
    )

test_summary <- get_sum_stats(test_df,
    sum_vars = c("var1", "var2"),
    sum_funcs = list(
        mean = mean,
        sd = sd
    )
)

test_summary_grouped <- get_sum_stats(test_df,
    sum_vars = c("var1"),
    sum_funcs = list(
        mean = mean
    ),
    group_vars = c("x")
)

test_that("get_sum_stats has correct output", {
    expect_true(methods::is(test_summary, "data.frame"))

    expect_equivalent(
        test_summary[["var1_mean"]],
        mean(test_df[["var1"]])
    )

    expect_equivalent(
        test_summary[["var1_sd"]],
        sd(test_df[["var1"]])
    )

    expect_equivalent(
        test_summary[["var2_mean"]],
        mean(test_df[["var2"]])
    )

    expect_equivalent(
        test_summary[["var2_sd"]],
        sd(test_df[["var2"]])
    )

    expect_equivalent(
        test_summary_grouped,
        test_df %>%
            dplyr::group_by(x) %>%
            dplyr::summarise_at("var1", mean)
    )
})

test_that("get_sum_stats catches user-input errors", {
    expect_error(
        get_sum_stats(df = 1:5, sum_vars = c("var1")),
        "no applicable method for 'tbl_vars'"
    )
    expect_error(
        get_sum_stats(df = test_df, sum_vars = c("z")),
        "Column `z` doesn't exist."
    )
})
