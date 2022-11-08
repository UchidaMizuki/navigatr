test_that("menu-bands", {
  mn1 <- new_nav_menu(key = c("band_members", "band_instruments"),
                      value = list(dplyr::band_members, dplyr::band_instruments))
  expect_true(is_nav_menu(mn1))

  mn1_1 <- mn1 |>
    activate(band_members)
  expect_true(is_item(mn1_1))

  mn1_2 <- mn1_1 |>
    dplyr::filter(band == "Beatles")
  mn1_3 <- mn1_2 |>
    deactivate() |>
    activate(band_members)
  expect_equal(nrow(mn1_2), nrow(mn1_3))

  expect_error({
    mn1 |>
      activate(band_members, 1)
  })

  mn2 <- new_nav_menu(key = c("key1", "key2"),
                      value = list(mn1, mn1))
  expect_true(is_nav_menu(mn2))

  mn2_1 <- mn2 |>
    activate(key1, band_instruments)
  expect_true(is_item(mn2_1))
})

test_that("menu-vector", {
  mn <- new_nav_menu(as.character(1:3), 1:3)
  expect_true(is_nav_menu(mn))

  mn_1 <- mn |>
    activate(1)
  expect_true(is_item(mn_1))

  expect_error({
    mn |>
      activate(4)
  })
})

test_that("menu-attrs", {
  mn <- new_nav_menu(as.character(1:3), 1:3,
                     attrs = data_frame(col1 = 1:3,
                                        col2 = list(1, 2, 3)))
  expect_true(is_nav_menu(mn))

  mn_1 <- mn |>
    activate(1)
  expect_true(is_item(mn_1))

  attr(mn_1, "col1") <- 123
  attr(mn_1, "col2") <- 1234

  mn_new <- mn_1 |>
    deactivate()
  expect_true(is_nav_menu(mn_new))

  expect_equal(mn_new$attrs$col1[[1]], 123)
  expect_equal(mn_new$attrs$col2[[1]], 1234)
})

test_that("menu-rekey", {
  mn <- new_nav_menu(c("key1", "key2", "key3"), 1:3,
                     attrs = data_frame(col1 = 1:3,
                                        col2 = list(1, 2, 3)))
  mn <- mn |>
    activate(key1) |>
    rekey("new_key1") |>
    deactivate()

  expect_equal(mn$key, c("new_key1", "key2", "key3"))

  nested_mn <- new_nav_menu(c("key1", "key2"),
                            list(mn, mn))
  nested_mn <- nested_mn |>
    activate(key1, key2) |>
    rekey("new_key2") |>
    deactivate(deep = FALSE)

  expect_equal(nested_mn$key, c("new_key1", "new_key2", "key3"))

  nested_mn <- nested_mn |>
    rekey(new_key3 = key3)

  expect_equal(nested_mn$key, c("new_key1", "new_key2", "new_key3"))
})
