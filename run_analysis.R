#Reading in all the files
test <- read.csv("./Data/UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE)
train <- read.csv("./Data/UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE)
mergedSet <- rbind(test,train) 

testAct <- read.csv("./Data/UCI HAR Dataset/test/y_test.txt", sep = "", header = FALSE)
trainAct <- read.csv("./Data/UCI HAR Dataset/train/y_train.txt", sep = "", header = FALSE)
mergedAct <- rbind(testAct, trainAct)

testPerson <- read.csv("./Data/UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE)
trainPerson <- read.csv("./Data/UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE)
mergedPerson <- rbind(testPerson, trainPerson)

features <- read.csv("./Data/UCI HAR Dataset/features.txt", sep = " ", header = FALSE)
activities <- read.csv("./Data/UCI HAR Dataset/activity_labels.txt", sep = " ", header = FALSE)

#Convert activtynumbers 1, 2, ..., 6 from 'mergedAct' to descriptive names
names(mergedAct)[names(mergedAct)=="V1"]<-"ActNumber"
names(activities)[names(activities)=="V1"]<-"ActNumber"
ActivityName<-merge(mergedAct,activities,all=TRUE)[,2]

#Convert variablename V1 from 'mergedPerson' to more descriptive name
names(mergedPerson)<-"PersonID"

#Convert variablenames V1, V2, ..., V561 from 'mergedSet' to descriptive (feature)names
names(mergedSet)<-features[,2]

#Extracts only the measurements on the mean and standard deviation for each measurement.
m<-grep("mean",names(mergedSet))
s<-grep("std",names(mergedSet))
M<-grep("Mean",names(mergedSet))
mergedSet <- mergedSet[,c(m, s, M)]

#Bind together: Person Names, Activities & Measurements
data<-cbind(mergedPerson,ActivityName,mergedSet)

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(dplyr)
TidyData<-group_by(data, PersonID, ActivityName) 
    summarise_each(tbl = TidyData, funs=mean)
    
#Create Output table
    write.csv(TidyData, file="./Output/TidyData.csv")
