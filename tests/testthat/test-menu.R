test_that("menu", {
  submenu <- new_menu(paste0("subkey", 1:3), list(tibble::tibble(a = 1:3)))
  menu <- new_menu(paste0("key", 1:3), list(submenu))
})
