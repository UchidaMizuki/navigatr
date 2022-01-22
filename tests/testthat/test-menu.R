test_that("menu", {
  library(dplyr)
  mn1 <- new_menu(key = c("band_members", "band_instruments"),
                  value = list(band_members, band_instruments))
  expect_s3_class(mn1, "menu")

  mn1_1 <- mn1 %>%
    activate(band_members)
  expect_s3_class(mn1_1, "item")

  mn1_2 <- mn1_1 %>%
    filter(band == "Beatles")
  mn1_3 <- mn1_2 %>%
    deactivate() %>%
    activate(band_members)
  expect_equal(nrow(mn1_2), nrow(mn1_3))

  expect_error({
    mn1 %>%
      activate(band_members, 1)
  })

  mn2 <- new_menu(key = c("key1", "key2"),
                  value = list(mn1, mn1))
  expect_s3_class(mn2, "menu")

  mn2_1 <- mn2 %>%
    activate(key1, band_instruments)
  expect_s3_class(mn2_1, "item")
})
