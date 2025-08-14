## Objective

Put simply, creating answer options for ISCO codes takes too long. This is for one or more of the following reasons:

- Need to find the codes on the internet
- Need to determine the format that Survey Solutions needs
- Need to transform the data from its native format into the one Survey Solutions expects

This repository aims to address this problem by:

- Creating off-the-shelf usable answer option files
- Providing code that can be applied, in principle, to translations that follow the same format as the English schema

## Usage

This repo envisages two use cases. The usage for each is described in greater detail below.

- [Take the English answer options](#take-the-answer-options)
- [Run the code for translations](#run-the-code-for-translations)

### Take the answer options

If one simply needs answer options for cascading selections, they can be found in and downloaded from: `data/02_output/`

These tab-separated files (i.e., `.tsv`) can be uploaded as-is to Survey Solutions Designer.

### Run the code for translations

If one has a new translation that has the same file format and same data structure (e.g., `ISCO-08 ES.csv` for Spanish), one should:

- Download or clone the repository
- Install the bare essentials
  - R version in `renv.lock`: `4.4.1`
  - `renv` package project-specific virtual environments
- Open the project as an R project
- Place the target file in `data/01_input`
- Make a copy of the appropriate script and save it in `R/`. The English script assumes the most recent file format (CSV in tidy format). The French script assumes an older file format (Excel in a cascading format).
- Change the values of the following parameters in that file:
  - `isco_file` to the file name (with extension)
  - `isco_lang` to the language (e.g., two-letter language)
- Run `create_suso_isco_codes.R`
- Recover the output files in `data/02_output/`

## Details

This repo uses and ships with the English ISCO-08 structure downloaded from [here](https://www.ilo.org/ilostat-files/ISCO/newdocs-08-2021/ISCO-08/ISCO-08%20EN.csv).
