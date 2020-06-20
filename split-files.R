#!/usr/bin/env Rscript

# assumes data has been downloaded and aggregated into folders `all-humans` and `all-horses`

# organize human and horse files for train, validation, and test


cur.dir <- getwd()
all.horses.dir <- file.path(cur.dir, "data", "all-horses")
all.humans.dir <- file.path(cur.dir, "data", "all-humans")

# do a check to see if files have been aggregated, otherwise call the script that does it
if (checkDirectoryExists(all.horses.dir) == TRUE) {
  f.lst <- list.files(all.horses.dir) 
  if (length(f.lst) < 628)
    source("aggregate-files.R")
}

# split

split.train = 0.7
split.validation = 0.15
split.test = 0.15

set.seed(2941);

# train file names:
all.humans.fnames <- list.files(all.humans.dir)
train.human.fnames <- sample(x = all.humans.fnames, 
                             replace = F,
                             size = split.train * length(all.humans.fnames))

all.horses.fnames <- list.files(all.horses.dir)
train.horse.fnames <- sample(x = all.horses.fnames,
                             replace = F,
                             size = split.train * length(all.horses.fnames))


# validation file names:
available.human.fnames <- setdiff(x = all.humans.fnames, y = train.human.fnames)
validation.human.fnames <- sample(available.human.fnames,
                                  replace = F,
                                  size = split.validation * length(all.humans.fnames))


available.horse.fnames <- setdiff(x = all.horses.fnames, y = train.horse.fnames)
validation.horse.fnames <- sample(x = available.horse.fnames,
                                  replace = F,
                                  size = split.validation * length(all.horses.fnames))

# test file names:
test.horse.fnames <- setdiff(x = available.horse.fnames, y = validation.horse.fnames)

test.human.fnames <- setdiff(x = available.human.fnames, y = validation.human.fnames)


## Now copy the files to their respective folders:

train.human.dir <- file.path(cur.dir, "data", "train", "humans")
train.horse.dir <- file.path(cur.dir,  "data", "train", "horses")

dir.create(train.human.dir,recursive = T)
dir.create(train.horse.dir, recursive = T)

validation.human.dir <- file.path(cur.dir, "data", "validation", "humans")
validation.horse.dir <- file.path(cur.dir,  "data", "validation", "horses")

dir.create(validation.human.dir, recursive = T)
dir.create(validation.horse.dir, recursive = T)

test.human.dir <- file.path(cur.dir, "data", "test", "humans")
test.horse.dir <- file.path(cur.dir,  "data", "test", "horses")

dir.create(test.human.dir, recursive = T)
dir.create(test.horse.dir, recursive = T)

# copy files from all-horse to their respective train, validation, or test directories:

file.copy(file.path(all.horses.dir, train.horse.fnames), file.path(train.horse.dir))

file.copy(file.path(all.horses.dir, validation.horse.fnames), file.path(validation.horse.dir))

file.copy(file.path(all.horses.dir, test.horse.fnames), file.path(test.horse.dir))


# copy files from all-human to their respective train, validation, or test directories:

file.copy(file.path(all.humans.dir, train.human.fnames), file.path(train.human.dir))

file.copy(file.path(all.humans.dir, validation.human.fnames), file.path(validation.human.dir))

file.copy(file.path(all.humans.dir, test.human.fnames), file.path(test.human.dir))
