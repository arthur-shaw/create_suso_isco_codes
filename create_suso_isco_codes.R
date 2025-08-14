# ==============================================================================
# setup
# ==============================================================================

# ensure that project's virtual environment is activated
renv::restore(prompt = FALSE)

# set paths
dir_proj <- here::here()
dir_input <- here::here("data", "01_input")
dir_output <- here::here("data", "02_output")

# ==============================================================================
# create ISCO codes for cascading selections in Survey Solutions
# ==============================================================================

# run all language-specific scripts
fs::dir_ls(path = fs::path(dir_proj, "R"), regexp = "\\.R") |>
	purrr::walk(.f = ~ source(.x))
