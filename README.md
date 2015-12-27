# Getting_Data_CourseProject
Repository for the Course Project of the Coursera Course on Getting and Cleaning Data

This repository contains the R-Script "run_analysis.R" which was used to convert the raw data found at this link : https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  into a tidy data set which contains the average values for all Mean and StandardDeviation values from the raw data for each subject and activity.
For further information regarding the raw data see: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The script works works in the following steps, which are indicated by comments within the script:

1. The raw data is downloaded from above link as a zip file and unziped in the working directory

2. From the file "features.txt" the names of the variables in the raw data are loaded into a data.frame

3. The data from the test and train dataset is loaded into seperate dataframes and then merged with the subjectid and activitynumber for each row loaded in from the corresponding files in the raw data. Also the the loaded labelnames are used to name the columns in each data set.

4. Test and traindata are combined into one dataset ("data")

5. The data is reduced to such columns where the columnname contains either one of the following strings: "subjectid" "activity" "mean" "std"

6. The columns of the data are reordered such that subjectid and activity are the first two columns of the dataset (This is optional and not necessary for the script to work)

7. The variable activity is changed from a numeric to a factor variable. The necessary labels are loaded from the file "activity_labels.txt"

8. The Abrrevations used in the raw data variable names are replaced with complete words. For example "Freq" is replaced with "Frequeny". The necessary understanding for this substitution was obtained from the readme file of the raw data.

9. Using the dplyr packaged the data is first grouped by subjectid and activity. Then each of the remaining variable is summarised using the mean function. The result is saved in the data.frame summarised_data

10.  The contents of the data.frame summarised_data is written into the txt file output.txt using the write.table function

In between these steps unneeded variables and dataframes are deleted from memory