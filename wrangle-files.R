#!/usr/bin/env Rscript

library(checkmate)

# downloaded the data
# original reference: http://www.laurencemoroney.com/horses-or-humans-dataset/

url.train <- "https://storage.googleapis.com/laurencemoroney-blog.appspot.com/horse-or-human.zip"

url.val <- "https://storage.googleapis.com/laurencemoroney-blog.appspot.com/validation-horse-or-human.zip"

tmp.train <- tempfile()

download.file(url.train, tmp.train)

cur.dir <- getwd()

data.train.dir <- file.path(cur.dir, "data", "original-train")
data.test.dir <- file.path(cur.dir, "data", "original-test")

if (checkDirectoryExists(data.train.dir) != TRUE)
  dir.create(data.train.dir)

# create the subolders under the data directory
unzip(zipfile = tmp.train, exdir = data.train.dir)

unlink(tmp.train)

rm(tmp.train)

tmp.val <- tempfile()

download.file(url.val, tmp.val)

if (checkDirectoryExists(data.test.dir) != TRUE)
  dir.create(data.test.dir)

unzip(zipfile = tmp.val, exdir = data.test.dir)

unlink(tmp.val)

rm(tmp.val)
rm(url.train)
rm(url.val)


train.horse.lst <- list.files(path = file.path(data.train.dir, "horses"))
print(paste0("There are ", length(train.horse.lst), " training horse files"))

train.human.lst <- list.files(path = file.path(data.train.dir, "humans"))
print(paste0("There are ", length(train.human.lst), " training human files"))

test.horse.lst <- list.files(path = file.path(data.test.dir, "horses"))
print(paste0("There are ", length(test.horse.lst), " test horse files"))

test.human.lst <- list.files(path = file.path(data.test.dir, "humans"))
print(paste0("There are ", length(test.human.lst), " test human files"))



