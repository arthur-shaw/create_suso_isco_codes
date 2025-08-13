# ==============================================================================
# setup
# ==============================================================================

# ⚠️ user input required ⚠️
isco_file <- "ISCO-08 EN.csv"
isco_lang <- "EN"

# set paths
dir_proj <- here::here()
dir_input <- here::here("data", "01_input")
dir_output <- here::here("data", "02_output")

# ensure that project's virtual environment is activated
renv::restore(prompt = FALSE)

# ==============================================================================
# create ISCO codes for cascading selections in Survey Solutions
# ==============================================================================

# ------------------------------------------------------------------------------
# ingest data
# ------------------------------------------------------------------------------

isco_08_raw <- fs::path(dir_input, isco_file) |>
  readr::read_csv(
    # so that `readr` doesn't guess incorrectly, dictate data types
    col_types = readr::cols(
        ISCO_version = readr::col_character(),
        # 1-digit
        major = readr::col_integer(),
        major_label = readr::col_character(),
        # 2-digit
        sub_major = readr::col_integer(),
        sub_major_label = readr::col_character(),
        # 3-digit
        minor = readr::col_integer(),
        minor_label = readr::col_character(),
        # 4-digit
        unit = readr::col_integer(),
        description = readr::col_character()
      )
  ) |>
  # since the file contains 08 and prior schemes, subset to 08 schema
  dplyr::filter(ISCO_version == "ISCO-08") |>
  # so that known conversion problems for older schema are not flagged
  suppressWarnings()

# ------------------------------------------------------------------------------
# 1-digit codes
# ------------------------------------------------------------------------------

isco_1_digit <- isco_08_raw |>
	dplyr::distinct(major, major_label) |>
	dplyr::select(value = major, title = major_label)

readr::write_tsv(
  x = isco_1_digit,
  file = fs::path(dir_output, glue::glue("isco_1_digit_{isco_lang}.tsv")),
  col_names = TRUE
)

# ------------------------------------------------------------------------------
# 2-digit codes
# ------------------------------------------------------------------------------

isco_2_digit <- isco_08_raw |>
	dplyr::distinct(sub_major, sub_major_label, major) |>
	dplyr::select(
    value = sub_major,
    title = sub_major_label,
    parentvalue = major
  )

readr::write_tsv(
  x = isco_2_digit,
  file = fs::path(dir_output, glue::glue("isco_2_digit_{isco_lang}.tsv")),
  col_names = TRUE
)

# ------------------------------------------------------------------------------
# 3-digit codes
# ------------------------------------------------------------------------------

isco_3_digit <- isco_08_raw |>
	dplyr::distinct(minor, minor_label, sub_major) |>
	dplyr::select(
    value = minor,
    title = minor_label,
    parentvalue = sub_major
  )

readr::write_tsv(
  x = isco_3_digit,
  file = fs::path(dir_output, glue::glue("isco_3_digit_{isco_lang}.tsv")),
  col_names = TRUE
)

# ------------------------------------------------------------------------------
# 4-digit codes
# ------------------------------------------------------------------------------

isco_4_digit <- isco_08_raw |>
	dplyr::distinct(unit, description, minor) |>
	dplyr::select(
    value = unit,
    title = description,
    parentvalue = minor
  )

readr::write_tsv(
  x = isco_4_digit,
  file = fs::path(dir_output, glue::glue("isco_4_digit_{isco_lang}.tsv")),
  col_names = TRUE
)
