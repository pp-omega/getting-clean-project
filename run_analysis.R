## Load Prerequisite Package
if (!require("data.table")) {
  install.packages("data.table")
}

library("data.table")

if (!require("plyr")) {
  install.packages("plyr")
}

library("plyr")

if (!require("dplyr")) {
  install.packages("dplyr")
}

library("dplyr")

##1. Merge the training and the test sets to create one data set

## Load Description for feature and  activitiy label
feature <- read.table("./UCI HAR Dataset/features.txt")
actLabel <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("ActivityId", "Activity"),header = FALSE)

##Load Training Data
TrainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = c("Subject"), header = FALSE)
TrainLabel <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = c("ActivityId"), header = FALSE)
TrainSet <- read.table("./UCI HAR Dataset/train/X_train.txt",col.names = feature[,2], header = FALSE)

##Load Test Data
TestSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = c("Subject"), header = FALSE)
TestLabel <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = c("ActivityId"), header = FALSE)
TestSet <- read.table("./UCI HAR Dataset/test/X_test.txt",col.names = feature[,2], header = FALSE)

## Merge All Test and Trainning Data
Mergesub<- rbind(TrainSubject, TestSubject)
MergeLabel <- rbind(TrainLabel, TestLabel)
MergeSet<- rbind(TrainSet, TestSet)
## Merge to 1 Data Table
WearableData<-cbind(MergeSet,MergeLabel,Mergesub)

##2. Extracts only the measurements on the mean and standard deviation for each measurement. 

selectedColumn <- grep(".*mean.*|.*std.*|.*Subject.*|.*ActivityId.*", names(WearableData), ignore.case=TRUE)
dim(WearableData)
ExtractData <- WearableData[,reqColumn]
dim(ExtractData)
##3.Uses descriptive activity names to name the activities in the data set
ExtractData <- join(ExtractData, actLabel, by = "ActivityId", match = "first")
dim(ExtractData)
ExtractData <- ExtractData[,-1]
dim(ExtractData)
ExtractData$ActivityId<- as.factor(ExtractData$Activity)
ExtractData$Subject<- as.factor(ExtractData$Subject) 

##4. Appropriately labels the data set with descriptive variable names

names(ExtractData)<-gsub("Acc", "Accelerometer", names(ExtractData), ignore.case = TRUE)
names(ExtractData)<-gsub("Gyro", "Gyroscope", names(ExtractData), ignore.case = TRUE)
names(ExtractData)<-gsub("BodyBody", "Body", names(ExtractData), ignore.case = TRUE)
names(ExtractData)<-gsub("Mag", "Magnitude", names(ExtractData), ignore.case = TRUE)
names(ExtractData)<-gsub("^t", "Time", names(ExtractData), ignore.case = TRUE)
names(ExtractData)<-gsub("^f", "Frequency", names(ExtractData), ignore.case = TRUE)
names(ExtractData)<-gsub("tBody", "TimeBody", names(ExtractData), ignore.case = TRUE)
names(ExtractData)<-gsub("^mean", "Mean", names(ExtractData), ignore.case = TRUE)
names(ExtractData)<-gsub("^std", "StandardDeviation", names(ExtractData), ignore.case = TRUE)
names(ExtractData)<-gsub("^freq", "Frequency", names(ExtractData), ignore.case = TRUE)
names(ExtractData)<-gsub("angle", "Angle", names(ExtractData), ignore.case = TRUE)
names(ExtractData)<-gsub("gravity", "Gravity", names(ExtractData), ignore.case = TRUE)

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
ExtractData <- data.table(ExtractData)
tidyData <- ddply(ExtractData,c("Activity", "Subject") , numcolwise(mean,na.rm=TRUE))
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "Tidy.txt", row.names = FALSE)