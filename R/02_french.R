# ------------------------------------------------------------------------------
# setup
# ------------------------------------------------------------------------------

isco_file <- "ISCO-08 FR.xls"
isco_lang <- "FR"

# ------------------------------------------------------------------------------
# ingest data
# ------------------------------------------------------------------------------

isco_08_fr <- fs::path(dir_input, isco_file) |>
	readxl::read_excel() |>
  dplyr::rename(
    code = `ISCO 08 Code`,
    desc = `Titre FR`
  ) |>
	# major
  dplyr::mutate(
    major = dplyr::if_else(
      condition = nchar(code) == 1,
      true = code,
      false = NA_character_
    )
  ) |>
	tidyr::fill(major, .direction = "down") |>
  # sub-major
  dplyr::mutate(
    sub_major = dplyr::if_else(
      condition = nchar(code) == 2,
      true = code,
      false = NA_character_
    )
  ) |>
	tidyr::fill(sub_major, .direction = "down") |>
  # minor
  dplyr::mutate(
    minor = dplyr::if_else(
      condition = nchar(code) == 3,
      true = code,
      false = NA_character_
    )
  ) |>
	tidyr::fill(minor, .direction = "down") |>
  # unit
  dplyr::mutate(
    unit = dplyr::if_else(
      condition = nchar(code) == 4,
      true = code,
      false = NA_character_
    )
  )

# ------------------------------------------------------------------------------
# major: 1-digit codes
# ------------------------------------------------------------------------------

isco_1_digit_fr <- isco_08_fr |>
	dplyr::filter(nchar(code) == 1) |>
	dplyr::select(
    value = major,
    title = desc
  )

readr::write_tsv(
  x = isco_1_digit_fr,
  file = fs::path(dir_output, glue::glue("isco_1_digit_{isco_lang}.tsv")),
  col_names = TRUE
)

# ------------------------------------------------------------------------------
# sub-major: 2-digit codes
# ------------------------------------------------------------------------------

isco_2_digit_fr <- isco_08_fr |>
	dplyr::filter(nchar(code) == 2) |>
  dplyr::mutate(
    dplyr::across(
      .cols = c(sub_major, major),
      .fns = ~ as.numeric(.x)
    )
  ) |>
	dplyr::select(
    value = sub_major,
    title = desc,
    parentvalue = major
  )

readr::write_tsv(
  x = isco_2_digit_fr,
  file = fs::path(dir_output, glue::glue("isco_2_digit_{isco_lang}.tsv")),
  col_names = TRUE
)

# ------------------------------------------------------------------------------
# minor: 3-digit codes
# ------------------------------------------------------------------------------

isco_3_digit_fr <- isco_08_fr |>
	dplyr::filter(nchar(code) == 3) |>
  dplyr::mutate(
    dplyr::across(
      .cols = c(minor, sub_major),
      .fns = ~ as.numeric(.x)
    )
  ) |>
	dplyr::select(
    value = minor,
    title = desc,
    parentvalue = sub_major
  )

readr::write_tsv(
  x = isco_3_digit_fr,
  file = fs::path(dir_output, glue::glue("isco_3_digit_{isco_lang}.tsv")),
  col_names = TRUE
)

# ------------------------------------------------------------------------------
# unit: 4-digit codes
# ------------------------------------------------------------------------------

isco_4_digit_fr <- isco_08_fr |>
	dplyr::filter(nchar(code) == 4) |>
  dplyr::mutate(
    dplyr::across(
      .cols = c(unit, minor),
      .fns = ~ as.numeric(.x)
    )
  ) |>
	dplyr::select(
    value = unit,
    title = desc,
    parentvalue = minor
  )

readr::write_tsv(
  x = isco_4_digit_fr,
  file = fs::path(dir_output, glue::glue("isco_4_digit_{isco_lang}.tsv")),
  col_names = TRUE
)
