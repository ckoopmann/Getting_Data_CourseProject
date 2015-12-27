
setwd("/Users/Christian/Statistik_Studium/Online_Kurse/Getting_Data/course_project")

#Download zip-file
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fileDest <- "dataset.zip"
download.file(fileURL, fileDest, method = 'curl')
unzip(fileDest)

#Load labelnames
labeldata <- read.table(file = "./UCI HAR Dataset/features.txt" )

#Load and label testdata
testdata <- read.table(file = "./UCI HAR Dataset/test/X_test.txt")
names(testdata) <- labeldata[,2]
testsubjects <- read.table(file = "./UCI HAR Dataset/test/subject_test.txt")
testactivity <- read.table(file = "./UCI HAR Dataset/test/y_test.txt")
testdata$subjectid <- testsubjects[,1]
testdata$activity <- testactivity[,1]

#remove unneeded data to free memory
rm(testsubjects); rm(testactivity)

#Load and label traindata 
traindata <- read.table(file = "./UCI HAR Dataset/train/X_train.txt")
names(traindata) <- labeldata[,2]
trainsubjects <- read.table(file = "./UCI HAR Dataset/train/subject_train.txt")
trainactivity <- read.table(file = "./UCI HAR Dataset/train/y_train.txt")
traindata$subjectid <- trainsubjects[,1]
traindata$activity <- trainactivity[,1]

#remove unneeded data to free memory
rm(trainsubjects); rm(trainactivity); rm(labeldata)

#merge test and traindata
data <- rbind(testdata, traindata)
#remove test and traindatasets to free memory
rm(testdata); rm(traindata)
#create logical vector to only select subjectid, activity, mean and std values
selection <- grep("mean|std|subjectid|activity", names(data))
reddata <- data[,selection]

#remove unneeded data to free memory
rm(data); rm(selection)

#Reorder data to get subjectid and activity as first and second column respectively
reddata <- reddata[,c(80,81,1:79)]

#Labeling activities
activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
reddata$activity <- factor(reddata$activity, labels = tolower(activitylabels[,2]))

#Creating descriptive variable names
toreplace <- c("Freq", "^t", "^f", "Acc", "Gyro", "Jerk", "Mag", "mean", "std", "\\()", "\\-", "Body", "Gravity")
replace <- c("Frequency\\.", "TimeDomain\\.", "FrequencyDomain\\.", "Accelerometer\\.", "Gyroscope\\.", "JerkSignal\\.", "Magnitutde\\.", "MeanValue\\.", "StandardDeviation\\.",  "", "", "Body.", "Gravity.")
for(i in 1:length(replace)){
      names(reddata) <- gsub(pattern = toreplace[i], replacement = replace[i], x = names(reddata))   
}

#Creating New Dataset with averages for all subjects and activities
library(dplyr)
summarised_data <- reddata %>% group_by(subjectid, activity) %>% summarise_each(funs(mean))

#Writing output into file
