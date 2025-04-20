test_that("input", {
  mn <- new_nav_input(
    key = c("key1", "key2", "key3"),
    value = list("a", "b", "c"),
    description = c(
      "First key",
      "Second key",
      "Third key"
    )
  ) |>
    itemise(
      key2 = letters,
      key3 = LETTERS
    )

  expect_equal(
    mn$value[mn$key == "key2"][[1]],
    letters
  )
  expect_equal(
    mn$value[mn$key == "key3"][[1]],
    LETTERS
  )

  expect_output(print(mn), "key1")
  expect_output(print(mn), "key2")
  expect_output(print(mn), "key3")
})
