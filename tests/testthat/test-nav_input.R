test_that("input", {
  mn <- new_nav_input(c("key1", "key2", "key3"), as.list(letters[1:3])) |>
    itemise(key2 = letters,
            key3 = LETTERS)

  expect_equal(mn$value[mn$key == "key2"][[1]], letters)
  expect_equal(mn$value[mn$key == "key3"][[1]], LETTERS)

  expect_output(print(mn), "key1")
  expect_output(print(mn), "key2")
  expect_output(print(mn), "key3")
})
