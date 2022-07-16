test_that("input", {
  mn <- new_input(c("key1", "key2", "key3"), letters[1:3]) |>
    mutate(key2 = letters,
           key3 = LETTERS)

  expect_equal(mn$value[mn$key == "key2"][[1]], letters)
  expect_equal(mn$value[mn$key == "key3"][[1]], LETTERS)
})
