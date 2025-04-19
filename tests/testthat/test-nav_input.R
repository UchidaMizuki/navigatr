test_that("input", {
  description_key1 <- "First key"
  description_key2 <- "Second key"
  description_key3 <- "Third key"

  mn <- new_nav_input(
    c("key1", "key2", "key3"),
    list(
      set_nav_description("a", description_key1),
      set_nav_description("b", description_key2),
      set_nav_description("c", description_key3)
    )
  ) |>
    itemise(
      key2 = letters,
      key3 = LETTERS
    )

  expect_equal(
    mn$value[mn$key == "key2"][[1]],
    set_nav_description(letters, description_key2)
  )
  expect_equal(
    mn$value[mn$key == "key3"][[1]],
    set_nav_description(LETTERS, description_key3)
  )

  expect_output(print(mn), "key1")
  expect_output(print(mn), "key2")
  expect_output(print(mn), "key3")
})
