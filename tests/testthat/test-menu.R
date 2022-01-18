test_that("menu", {
  subsubmenu <- new_menu(paste0("subsubkey", 1:3), list(tibble::tibble(a = 1:3)))
  submenu <- new_menu(paste0("subkey", 1:3), list(subsubmenu))
  menu <- new_menu(paste0("key", 1:3), list(submenu))
})
