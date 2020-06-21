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

rm(cur.dir, data.horses.dir)

# split the data into train, validation and test

cur.dir <- getwd()
train.horses.dir <- file.path(cur.dir, "data", "train", "horses")

# do a check to see if files have been aggregated, otherwise call the script that does it
if (checkDirectoryExists(train.horses.dir) == TRUE) {
  f.lst <- list.files(train.horses.dir) 
  if (length(f.lst) < 439)
    source("split-files.R")
}
rm(cur.dir,train.horses.dir)

# building the network

library(keras)
use_session_with_seed(disable_gpu = 2941, disable_gpu = TRUE)

model <- keras_model_sequential() %>%
  layer_conv_2d(filters = 32, kernel_size = c(3, 3), activation = "relu",                
                input_shape = c(300, 300, 3)) %>%  
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%  
  layer_conv_2d(filters = 64, kernel_size = c(3, 3), activation = "relu") %>%  
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%  
  layer_conv_2d(filters = 128, kernel_size = c(3, 3), activation = "relu") %>%  
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%  
  layer_conv_2d(filters = 128, kernel_size = c(3, 3), activation = "relu") %>%  
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%  
  layer_flatten() %>%  
  layer_dense(units = 512, activation = "relu") %>%  
  layer_dense(units = 1, activation = "sigmoid")

summary(model)

model %>% compile(  loss = "binary_crossentropy",  
                    optimizer = optimizer_rmsprop(lr = 1e-4),  
                    metrics = c("acc"))


train_datagen <- image_data_generator(rescale = 1/255)
validation_datagen <- image_data_generator(rescale = 1/255)

cur.dir <- getwd()

train_generator <- flow_images_from_directory(  file.path(cur.dir, "data", "train"),
                                                generator = train_datagen,           
                                                target_size = c(300, 300), 
                                                batch_size = 20,
                                                color_mode = "rgb",
                                                class_mode = "binary")

validation_generator <- flow_images_from_directory(  file.path(cur.dir, "data", "validation"),
                                                     generator = validation_datagen,
                                                     target_size = c(300, 300),  
                                                     batch_size = 20,  
                                                     color_mode = "rgb",
                                                     class_mode = "binary")


# bacth <- generator_next(train_generator)

history <- model %>% fit_generator(  train_generator,  
                                     steps_per_epoch = 50,  
                                     epochs = 10,  
                                     validation_data = validation_generator,
                                     validation_steps = 10)

# let's save the model
models.dir <- file.path(cur.dir, "models")
model.weights.dir <- file.path(cur.dir, "model-weights")

# do a check to see if the modeld directory exists
if (checkDirectoryExists(models.dir) != TRUE) {
  dir.create(models.dir)
}

if (checkDirectoryExists(model.weights.dir) != TRUE) {
  dir.create(model.weights.dir)
}


# save the model and the weights separately to allow loading them on python:
model %>% save_model_hdf5(file.path(models.dir, "horses_vs_humans_1.h5"))
model %>% save_model_weights_hdf5(file.path(model.weights.dir, "horses_vs_humans_wgts_1.h5"))

plot(history)


