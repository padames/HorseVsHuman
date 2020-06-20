#!/usr/bin/env Rscript

# assumes data has been downloaded and lives in the `data` folder of the project root directory


cur.dir <- getwd()
data.dir <- file.path(cur.dir, "data", "original-train")
horses.dir <- file.path(data.dir, "horses")

# do a check to see if files have been downloaded, otherwise call the script that does it
if (checkDirectoryExists(horses.dir) == TRUE) {
  f.lst <- list.files(horses.dir) 
  if (length(f.lst) < 500)
    source("wrangle-files.R")
}

rm(data.dir, horses.dir)

all_human_dir <- file.path(cur.dir, "data", "all-humans")
all_horse_dir <- file.path(cur.dir,  "data", "all-horses")

dir.create(all_human_dir)
dir.create(all_horse_dir)


original_train_dir <- file.path(cur.dir, "data", "original-train")
original_test_dir <- file.path(cur.dir, "data", "original-test")

# copy all horse images to the all-horses directory:

train.horse.fnames <- list.files(path = file.path(original_train_dir, "horses"))
file.copy(file.path(original_train_dir, "horses", train.horse.fnames), file.path(all_horse_dir))

test.horse.fnames <- list.files(path = file.path(original_test_dir, "horses"))
file.copy(file.path(original_test_dir, "horses", test.horse.fnames), file.path(all_horse_dir))

# copy all human images to the all-humans directory:

train.human.fnames <- list.files(path = file.path(original_train_dir, "humans"))
file.copy(file.path(original_train_dir, "humans", train.human.fnames), file.path(all_human_dir))

test.human.fnames <- list.files(path = file.path(original_test_dir, "humans"))
file.copy(file.path(original_test_dir,  "humans", test.human.fnames), file.path(all_human_dir))


