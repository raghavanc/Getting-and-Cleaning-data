## Getting and Cleaning Data Course Project.

## Retieve the data about the activity mapping 
setwd("/Users/raghavanchandran/downloads/")
UCI_Activity <- read.table(file = 'UCI HAR Dataset-2/activity_labels.txt', header = FALSE, col.names = c('Activity','Activity_name'))
UCI_Feature <- read.table(file = 'UCI HAR Dataset-2/features.txt', col.names = c('Feature#','Feature_name'))

## Retreve the test data 
UCI_data_test <- read.table(file = 'UCI HAR Dataset-2/test/subject_test.txt', header = FALSE, col.names = "Subject")
UCI_data_test <- cbind(UCI_data_test, read.table(file = 'UCI HAR Dataset-2/test/y_test.txt', header = FALSE, col.names = "Activity"))
UCI_data_test <- cbind(UCI_data_test, read.table(file = 'UCI HAR Dataset-2/test/x_test.txt', header = FALSE))

## Retreve the training data 
UCI_data_train <- read.table(file = 'UCI HAR Dataset-2/train/subject_train.txt', header = FALSE, col.names = "Subject")
UCI_data_train <- cbind(UCI_data_train, read.table(file = 'UCI HAR Dataset-2/train/y_train.txt', header = FALSE, col.names = "Activity"))
UCI_data_train <- cbind(UCI_data_train, read.table(file = 'UCI HAR Dataset-2/train/x_train.txt', header = FALSE))

## Merge both test and training data 
UCI_data <- rbind(UCI_data_test, UCI_data_train)

## Mapping the colmn names 
UCI_Feature <- gsub("-", ".", gsub("[\\(\\)]", "", as.character(UCI_Feature$Feature_name)))
cols <- c("Subject", "Activity", UCI_Feature)
colnames(UCI_data) <- cols

## Replacing the activity number with the corresponding name 
for (i in 1:6) {
    UCI_data$Activity[UCI_data$Activity == i] <- as.character(UCI_Activity$Activity_name[[i]])
}

## Extract means and standard deviations
UCI_data_msd <- subset(UCI_data, select = cols[grep("mean|std|Subject|Activity", cols)])


## creating tidy data set 
ml <- melt(UCI_data_msd, id=c("Subject", "Activity"))
UCI_tidy_data <- dcast(ml, Subject + Activity ~ variable, mean)

write.table(UCI_tidy_data, file="UCI_tidy_data.txt", row.name=FALSE)
