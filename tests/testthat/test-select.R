test_that("select", {
  mn <- new_select(c("key1", "key2", "key3"), letters[1:3]) %>%
    select(!key1)

  expect_equal(mn$key, c("key2", "key3"))
})
