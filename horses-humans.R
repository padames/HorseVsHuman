#!/usr/bin/env Rscript

library(checkmate)

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

# let's separate the data into train, validation and test
data.horses.dir <- file.path(cur.dir, "data", "all-horses")

if (checkDirectoryExists(data.horses.dir) == TRUE) {
  f.lst <- list.files(data.horses.dir) 
  if (length(f.lst) < 628)
    source("aggregate-files.R")
}

# split the data into train, validation and test

cur.dir <- getwd()
train.horses.dir <- file.path(cur.dir, "data", "train", "horses")

# do a check to see if files have been aggregated, otherwise call the script that does it
if (checkDirectoryExists(train.horses.dir) == TRUE) {
  f.lst <- list.files(train.horses.dir) 
  if (length(f.lst) < 439)
    source("split-files.R")
}


# building the network





