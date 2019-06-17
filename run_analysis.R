library(data.table) 
library(reshape2)

zip <- "getdata_projectfiles_UCI HAR Dataset.zip"

# Download and unzip the data

if(!file.exists(zip)){
      fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
      download.file(fileURL,zip,method="curl")
      unzip(zip)
}


## Read activity labels and features data and change to character vector
labels <- read.table("UCI HAR Dataset/activity_labels.txt")
labels[,2] <- as.character(labels[,2])

features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

## Identify the wanted features within features dataset
wanted <- grep("mean|std", features[,2])


## load Train and Test data based on 'wanted' features subset, then merge

train <- read.table("UCI HAR Dataset/train/X_train.txt")[wanted]
trainAct <- read.table("UCI HAR Dataset/train/y_train.txt")
trainSubj <- read.table("UCI HAR Dataset/train/subject_train.txt")
trainset <- cbind(trainSubj,trainAct,train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[wanted]
testAct <- read.table("UCI HAR Dataset/test/y_test.txt")
testSubj <- read.table("UCI HAR Dataset/test/subject_test.txt")
testset <- cbind(testSubj,testAct,test)

data <- rbind(trainset,testset)
names(data) <- c("Subject","Activity",features[,2][wanted])


## Reshape data by subject and activity to create new tidy data set
melt <- melt(data,id=c("Subject","Activity"))
tidy <- dcast(melt,Subject + Activity ~ variable, mean)

write.table(tidy,"tidy.txt")