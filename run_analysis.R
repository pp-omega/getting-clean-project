## Load Prerequisite Package
if (!require("data.table")) {
  install.packages("data.table")
}

library("data.table")

if (!require("dplyr")) {
  install.packages("dplyr")
}

library("dplyr")

##Data set Definition
#- 'features_info.txt': Shows information about the variables used on the feature vector.
#- 'features.txt': List of all features.
#- 'activity_labels.txt': Links the class labels with their activity name.
#- 'train/X_train.txt': Training set.
#- 'train/y_train.txt': Training labels.
#- 'test/X_test.txt': Test set.
#- 'test/y_test.txt': Test labels.
#- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
#- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
#- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
#- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

##1. Merge the training and the test sets to create one data set

## Load Description for feature and  activitiy label
feature <- read.table("./UCI HAR Dataset/features.txt")
actLabel <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)

##Load Training Data
TrainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
TrainLabel <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
TrainSet <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)

##Load Test Data
TestSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
TestLabel <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
TestSet <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)

## Merge Test and Trainning Data
Mergesub<- rbind(TrainSubject, TestSubject)
MergeLabel <- rbind(TrainLabel, TestLabel)
MergeSet<- rbind(TrainSet, TestSet)

##Define Column Name and Definition
colnames(Mergesub) <- "Subject"
colnames(MergeLabel) <- "Activity"
colnames(MergeSet) <- t(SetNames[2])

## Merge to 1 Data Table
WearableData<-cbind(MergeSet,MergeLabel,Mergesub)

##2. Extracts only the measurements on the mean and standard deviation for each measurement. 

selectedColumn <- grep(".*mean.*|.*std.*", names(WearableData), ignore.case=TRUE)
# Now add the last two columns (subject and Activity Label)
reqColumn<- c(selectedColumn, 562, 563)
ExtractData <- WearableData[,reqColumn]

##3.Uses descriptive activity names to name the activities in the data set
ExtractData$Activity <- as.character(ExtractData$Activity)
for (i in 1:6){
  ExtractData$Activity[ExtractData$Activity == i] <- as.character(actLabel[i,2])
}
ExtractData$Activity<- as.factor(ExtractData$Activity)
ExtractData$Subject<- as.factor(ExtractData$Subject)
##4. Appropriately labels the data set with descriptive variable names