# Get the data
setwd("E:/S/Coursera/DS-JHU/3Getting and Cleaning Data/final project/UCI HAR Dataset")

if (!require("data.table")) {install.packages("data.table")}
if (!require("reshape2")) {install.packages("reshape2")}

require("data.table")
require("reshape2")

x_test <- read.table("test/X_test.txt",header=F)
y_test <- read.table("test/Y_test.txt",header=F)
subject_test <- read.table("test/subject_test.txt",header=F)

x_train <- read.table("train/X_train.txt",header=F)
y_train <- read.table("train/Y_train.txt",header=F)
subject_train <- read.table("train/subject_train.txt",header=F)

activity_labels <- read.table("activity_labels.txt",header=F)

features <- read.table("features.txt",header=F)

colnames(activity_labels)<- c("V1","Activity")

str(x_test)
str(x_train)

str(y_test)
str(y_train)

str(subject_test)
str(subject_train)

# Merges the training and the test sets to create one data set
datafeatures <- rbind(x_test,x_train) 
datasubject <- rbind(subject_test,subject_train)
dataactivity <- rbind(y_test,y_train) 

names(datasubject) <- c("Subject")
names(dataactivity) <- c("Activity")
names(datafeatures) <- features$V2

data0 <- cbind(datasubject,dataactivity)
data <- cbind(datafeatures,data0)

# Extracts only the measurements on the mean and standard deviation for each measurement
subdatafeatures<-features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]

selectednames <- c(as.character(subdatafeatures),"Subject","Activity")
data <- subset(data,select=selectednames)

str(data)

# Uses descriptive activity names to name the activities in the data set
head(data$Activity,30)

setnames(activity_labels,names(activity_labels))

names(data) <- gsub("t","time",names(data))
names(data) <- gsub("f","frequency",names(data))
names(data) <- gsub("Acc","Accelerometer",names(data))
names(data) <- gsub("Gyro","Gyroscope",names(data))
names(data) <- gsub("Mag","Magnitude",names(data))
names(data) <- gsub("BodyBody","Body",names(data))
names(data) <- gsub("std()","SD",names(data))
names(data) <- gsub("mean()","MEAN",names(data))

# Creates an independent tidy data 

data <- data.table(data)

library(plyr)
data2 <- aggregate(. ~Subject + Activity, data, mean)
data2 <- data2[order(data2$Subject,data2$Activity),]
write.table(data2,file="tidydata.txt",row.na=F)

# Prouduce Codebook
library(knitr)
knit2html("codebook.Rmd")
