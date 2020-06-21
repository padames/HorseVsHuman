#!/usr/bin/env Rscript

# load models and execute them on the test set for a sense of accuracy on unseen data

library(keras)
# assume we start on the project root directory
cur.dir <- getwd()
models.dir <- file.path(cur.dir, "models")

# do a check to see if there is a folder for models and if it is not empty
if (all(dir.exists(models.dir))) {
  f.lst <- list.files(models.dir) 
  if (length(f.lst) > 0) {
    print(paste0("Found ", length(f.lst), " model(s) to test"))
  }
  else {
    print(paste0("No models found"))
  }
} else stop(paste0("The directory '", models.dir, " was not found!"))

# prepare the test data:

test.human.dir <- file.path(cur.dir, "data", "test", "humans")
test.horse.dir <- file.path(cur.dir,  "data", "test", "horses")

# load the model in a loop
# https://tensorflow.rstudio.com/tutorials/beginners/basic-ml/tutorial_save_and_restore/


results <- list(loss=c(), acc=c())
test.dir <- file.path(cur.dir, "data", "test")
# test.dir <- file.path(cur.dir, "data", "original-test")

models.fnames <- list.files(models.dir)
models.fnames <- paste0(file.path(models.dir, models.fnames))
for (i in 1:length(models.fnames)) {
  model <- load_model_hdf5(models.fnames[[i]])
  summary(model)
  test_datagen <- image_data_generator(rescale = 1/255)
  test_generator <- flow_images_from_directory(
    test.dir,
    test_datagen,
    target_size = c(300,300),
    batch_size = 20,
    class_mode = "binary"
  )
  models.results <- model %>% evaluate_generator( test_generator, steps = 50)
  results$loss <- c(results$loss, models.results$loss)
  results$acc <- c(results$acc, models.results$acc)
}


