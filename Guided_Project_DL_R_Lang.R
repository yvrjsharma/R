#Install required packages and load libraries
install.packages("keras")
library(keras)
install.packages("BiocManager")
BiocManager::install("EBImage")
library(EBImage)

#I have created a toy dataset of 12 images with  each of cars and aeroplanes
#Creating a vector of the image names
pics <- c("car1.jpg","car2.jpg","car3.jpg","car4.jpg","car5.jpg",
          "car6.jpg","aer1.jpg","aer2.jpg","aer3.jpg","aer4.jpg",
          "aer5.jpg","aer6.jpg"          )

#Display an element of vector
pics[1]

#Create an empty list
myimage <- list()

#Load images in this list using readImage from ENImage package
for (i in 1:12) {
  myimage[[i]] <- readImage(pics[i])
}

#Display new list and sample contents
myimage
print(myimage[[2]])
display(myimage[[1]])

#Resizing images to 28*28 pixels using EBImage package functions
for (i in 1:12) {
  myimage[[i]] <- resize(myimage[[i]],28,28)
}

#Display structure after resizing, check for 28 pixel dimension
str(myimage)
myimage[[2]]

#To use Keras, we need to create tensors as inputs
#Converting images to 3D tensor of dimensions - 28,28,3
#Corresponding pixel values indicate bright or dark intensity values at a point
for (i in 1:12) {
  myimage[[i]] <- array_reshape(myimage[[i]],c(28,28,3))
}

#Check for converted tensors
display(myimage[[2]])
#Check that new image tensors also show low brightness or smaller values as shown in image


#Training and Test sets
#Adding 5 images of cars and 5 of aeroplanes as training set
train <- NULL
#Cars
for (i in 1:5) {
  train <- rbind(train, myimage[[i]])
}
#Aeroplanes
for (i in 7:11) {
  train <- rbind(train, myimage[[i]])
}

#Verify dimensions of train set
dim(train)

#Test set
#Adding 6th and 12th images as test set for car and aeroplane respectively
test <- NULL
test <- rbind(test,myimage[[6]])
test <- rbind(test,myimage[[12]])

#Verify dimensions
dim(test)

#Creating the model
#Creating the labels 1/0 for car/aeroplane
train_labels <- c(1,1,1,1,1,0,0,0,0,0)
test_labels <- c(1,0)

#Basic building blocks of a Keras model - Output Label tensors
#Doing one hot coding using keras function to make output more suitable for Keras 
train_labels <- to_categorical(train_labels)
test_labels <- to_categorical(test_labels)

#Display new sets
train_labels
test_labels

#Building Sequential model using Keras
model <- keras_model_sequential()
model %>% 
  layer_dense(units = 256, activation = "relu", 
              input_shape = c(2352)) %>% 
  layer_dense(units = 128, activation = "relu") %>%
  layer_dense(units= 2, activation = "softmax")

#Check for parameters and layers created above
summary(model)

#Specifying the loss function and optimizer
model %>% 
  compile(loss = "binary_crossentropy",
          optimizer = optimizer_adam(),
          metrics = c("accuracy"))

#Fitting the model to train data, keeping batch size and validation set values as standard values
history <- model %>% 
  fit(train, 
      train_labels,
      epochs = 30,
      batch_size = 32,
      validation_split = 0.2)
#Plotting train and va,idation loss 
plot(history)

#Verifying Test images
display(myimage[[12]])
display(myimage[[6]])

#Testing the model we just created on Train data
model %>% 
  evaluate(train,train_labels)

#Predicting for Train data
pred <- model %>%
  predict_classes(train)

#Display accuracy over training set
pred


#Verify on test data
model %>% 
  evaluate(test, test_labels)

#Predict over test data
pred <- model %>%
  predict_classes(test)
#Displaying performance over test data
pred
