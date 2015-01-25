CodeBook.md is a discription of the variables, data and functions used to complete The course project for "Getting and Cleaning Data". The stated project objectives were as follows.

Create one R script called run_analysis.R that does the following. 

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each
   activity.

R Libraries:

1. downloader
2. dplyr
3. data.table
4. plyr

Functions:

1. arrange
2. as.character
3. cbind
4. choose
5.colnames
6. ddply
7. grepl
8. install.packages
9. library
10. make.names
11. mean
12. ncol
13. read.csv
14. read.table
15. rename
16. setnames
17. unzip
18. write.table

Input Files: (row x columns)

1. X_test.txt - 2947 x 561 ascii table of test group accelerometer data.
2. subject_test.txt 2947 x 1 ascii table of test group subject id data.
3. y_test.txt 2947 x 1 ascii table of test group activity type data.
4. X_train.txt 7352 x 561 acii table of training group accelerometer data.
5. subject_train.txt 7352 x 1 acii table of training group subject id data.
6. y_train.txt 7352 x 1 acii table of training group activity type data.
7. features.txt 2 x 561 ascii table of observation names.

Variables:

1. ac_test_data - table of accelerometer data from  X_test.txt. 
2. ac_test_subject - table of subject id data from subject_test.txt
3. ac_test_activity - table of activity type data from y_test.txt
4. ac_train_data - table of accelerometer data from X_train.txt
5. ac_train_subject - table of subject id data from subject_test.txt
6. ac_train_acitivity - table of activity type data from y_train.txt
7. obs_labels - table of observation names (column names for ac_test_data and ac_train_data) from features.txt
8. ac_train_data_ready - table resulting from cbind of ac_train_subject, ac_train_activity, ac_train_data.
9. ac_test_data_ready - table resulting from cbind of ac_test_subject, ac_test_activity, ac_test_data.
10. ac_data - table resulting from rbind of ac_train_data_ready and ac_test_data_ready.
11. ac_mean_std_data - subset of ac_data that contains columns that measured a mean or standard deviation of an observation type. This subset completes objective 2.
12. col_count - counter used in FOR loop when subsetting data to build ac_mean_std_data
13. c_name - variable to grepl to find a case insensitive string of MEAN or STD.
14. tidy_data - data set contain the data set required for objective 5.

