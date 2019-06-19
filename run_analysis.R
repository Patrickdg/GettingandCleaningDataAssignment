library(reshape2)
library(data.table)

## Download zip file and unzip in current working directory
if(!file.exists("zip")){
      url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
      zip <- download.file(url,destfile = "zip.zip",method = "curl")
      unzip(zipfile="zip.zip")
}

## Identify desired 'mean' and 'std' features (to use for subsetting when reading train and test data later on)
features <- read.table("./UCI HAR Dataset/features.txt")
desired <- grep("mean|std", features[,2])
desiredfeatures <- features[desired,2] 

## Load train & test data sets, merge, and rename columns
trainX <- read.table("./UCI HAR Dataset/train/X_train.txt")[desiredfeatures]
trainsubj <- read.table("./UCI HAR Dataset/train/subject_train.txt") 
trainlabels <- read.table("./UCI HAR Dataset/train/y_train.txt")
train <- cbind(trainsubj, trainlabels,trainX)

testX <- read.table("./UCI HAR Dataset/test/X_test.txt")[desiredfeatures] 
testsubj <- read.table("./UCI HAR Dataset/test/subject_test.txt") 
testlabels <- read.table("./UCI HAR Dataset/test/y_test.txt") 
test <- cbind(testsubj, testlabels,testX)

data <- rbind(train,test)
names(data) <- c("subject","activity",as.character(desiredfeatures))

## Rename activity variables
labels <- read.table("./UCI HAR Dataset/activity_labels.txt"); labels
matchvector <- match(data$activity,labels[,1])
data$activity <- labels[matchvector,2]; data

## melt data frame based on subject + activity, then reshape using dcast and mean function to calculate means for each desired feature (by subject + activity permutations)
final <- dcast(melt(data,id=c("subject","activity")),subject + activity ~ variable, mean)
write.table(final,file = "tidy.txt",row.names = FALSE)

