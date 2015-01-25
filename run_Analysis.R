# run_Analys.R is an R script that messages and processes two sets of accelerometer data. The script:
# 1. Reads in two data sets from a testing group and a training group as well as a file containing the subject id of the person generating the
#    observation and the activity that was being done to produce the observation
# 2. Produces a single data set of all the observations and assigns  descriptive names to each activity and to each data column.
# 3. Subsets a table of all the columns that stored either mean observation data or standard deviation observation data.
# 4. Groups date buy acitivity within subject and generates a mean of the data of each observation type (column). This file is then output as 
#    tidy_data.txt
#
# Get the data
#
# Load libraries
#
library(downloader)
library(plyr)
library(dplyr)
library(data.table)
#
# Get the data
#
chooseCRANmirror()
install.packages("downloader")
#
download("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",dest="Dataset.zip",mode="wb")
unzip("Dataset.zip")
#
# Read data into data frames.
#
ac_test_data <- read.csv("./data/test/X_test.txt", header = FALSE, sep = "")
ac_test_subject <- read.csv("./data/test/subject_test.txt", header = FALSE, sep = "")
ac_test_activity <- read.csv("./data/test/y_test.txt", header = FALSE, sep = "")
#
ac_train_data <- read.csv("./data/train/X_train.txt", header = FALSE, sep = "")
ac_train_subject <- read.csv("./data/train/subject_train.txt", header = FALSE, sep = "")
ac_train_activity <- read.csv("./data/train/y_train.txt", header = FALSE, sep = "")
#
# Assume that the rows for the activity, subject, and data files align and put them together using cbind
# but first give meaningful column names to the subject and activity files and to the activity type data.
#
names(ac_train_subject)[names(ac_train_subject)=="V1"] <- "Subject_id"
names(ac_train_activity)[names(ac_train_activity)=="V1"] <- "Activity_type"
names(ac_test_subject)[names(ac_test_subject)=="V1"] <- "Subject_id"
names(ac_test_activity)[names(ac_test_activity)=="V1"] <- "Activity_type"
#
ac_train_activity[ac_train_activity$Activity_type == 1,] <- "WALKING"
ac_train_activity[ac_train_activity$Activity_type == 2,] <- "WALKING_UPSTAIRS"
ac_train_activity[ac_train_activity$Activity_type == 3,] <- "WALKING_DOWNSTAIRS"
ac_train_activity[ac_train_activity$Activity_type == 4,] <- "SITTING"
ac_train_activity[ac_train_activity$Activity_type == 5,] <- "STANDING"
ac_train_activity[ac_train_activity$Activity_type == 6,] <- "LAYING"
#
ac_test_activity[ac_test_activity$Activity_type == 1,] <- "WALKING"
ac_test_activity[ac_test_activity$Activity_type == 2,] <- "WALKING_UPSTAIRS"
ac_test_activity[ac_test_activity$Activity_type == 3,] <- "WALKING_DOWNSTAIRS"
ac_test_activity[ac_test_activity$Activity_type == 4,] <- "SITTING"
ac_test_activity[ac_test_activity$Activity_type == 5,] <- "STANDING"
ac_test_activity[ac_test_activity$Activity_type == 6,] <- "LAYING"
#
# Rename columns for  X-train.txt and X-test.txt using features.txt. Because some of the dpply functions had issues with the column name text
# I used make.names to create valid column names.
#
obs_labels <- read.table("features.txt")
obs_labels <- as.character(obs_labels[[2]])
obs_labels <- make.names(obs_labels,unique=TRUE)
#
col_count <- ncol(ac_train_data)
for(i in 1:col_count)setnames(ac_train_data, old = c(i), new = c(obs_labels[i]))
#
col_count <- ncol(ac_test_data)
for(i in 1:col_count)setnames(ac_test_data, old = c(i), new = c(obs_labels[i]))
#
# First combine subject, activity, and data for the test group and training group using cbind and then combine the testing and training group
# also using rbind.
#
ac_train_data_ready <- cbind(ac_train_subject,ac_train_activity,ac_train_data)
ac_test_data_ready <- cbind(ac_test_subject,ac_test_activity,ac_test_data)
ac_data <- rbind(ac_test_data_ready,ac_train_data_ready)
#
# Now sort the data set by Activity_type within Subject_id
#
ac_data <- arrange(ac_data, Subject_id, Activity_type)
#
# At this point objectives 1,3 and 4 have been completed. Now we will work on objective 2. Extract measurements that represent the mean or
# standard deviation of another measurement. This is done by subsetting columns that have the string "mean" or "std" in any upper or lower case form 
# as part of the column header. This is an educated guess. It would be helpful here to better understand the application.
#
col_count <- ncol(ac_data)
ac_mean_std_data <- ac_data[c(1,2,3)]
for(i in 4:col_count){
        c_name <- colnames(ac_data[i])
        if(isTRUE(grepl("mean",c_name,ignore.case = TRUE))){ac_mean_std_data <- cbind(ac_mean_std_data,ac_data[i])}
        if(isTRUE(grepl("std",c_name,ignore.case = TRUE))){ac_mean_std_data <- cbind(ac_mean_std_data,ac_data[i])}
}
ac_mean_std_data
#
# Objective 5. Calculate means and standard deviations for each measurement for every Subject/Activity pair and output to a tidy data set.
# This group_by looks repetitive after doing the arrange() above but summarise_each() needed it.
#
tidy_data <- ac_data %>% group_by(Subject_id, Activity_type)
tidy_data <- tidy_data %>% summarise_each(funs(mean))
#
# Now write data to file. I spaced the columns a little more than the default.
#
write.table(tidy_data, file="tidy_data.txt",sep="     ",row.names=FALSE)
