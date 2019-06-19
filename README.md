# GettingandCleaningDataAssignment
Course Project for Getting &amp; Cleaning Data - Data Science Specialization (Coursera)

run_analysis.R script:
This script produces a tidy data set containing the means of select body sensor variables from the UCI HAR dataset, listed by subject id and activity id. 



SCRIPT STEPS:

Preliminary
- run library() on data.table and reshape2 to load relevant R functions

Downloading 
- download.file() is used to download the zip file containing the relevant sensor data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Reading tables and identifying the select features to pull into the dataset: 
- Using read.table(), the desired features from the features vector set is extracted by matching the literals 'mean' or 'std' to the features.txt data. These desired features will be used later in subsetting the final train + test data set. 

Reading all data
- all relevant data from the train and test sets are read and cbinded, and both train and test datasets are then rbinded to produce a complete dataset. 
- However, from the X_train.txt and X_test.txt files, the only columns selected are the ones that have been identified by the 'desiredfeatures' variable created above. 

Melting & Casting
- The data is reshaped using melt() by the Subject & Activity IDs
- The final data set is then set as a result of the dcast() function on our newly reshaped data, and we use the 'mean' argument to produce the means of each wanted features based on the subject ID and activity ID. 
- This tidy set is then written to a text file called 'tidy.txt'
      
