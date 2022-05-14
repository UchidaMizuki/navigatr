test_that("dplyr-select", {
  mn <- new_menu(c("key1", "key2", "key3"), letters[1:3]) %>%
    select(!key1)

  expect_equal(mn$key, c("key2", "key3"))
})
