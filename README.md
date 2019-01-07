# Getting and Cleaning Data
##### https://www.coursera.org/learn/data-cleaning/peer/FIZtT/getting-and-cleaning-data-course-project
### Course Project

This project utilizes `run_analysis.R` to complete the following steps:
1. Download accelerometer and gyroscope sensor test and training source zip data from `https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip` to the working directory if not already present
2. Extract zip data if not already unzipped
3. Read in dimension data to contextualize numeric id's for activities performed by subjects and features collected
4. Cleanse dimension data and extract subset of features corresponding to mean and standard deviation
5. Combine test and training data sets with identifying subject and activity datasets
6. Merge fully-identified test and training data sets into a single unioned output
7. Convert unioned wide data set to long
8. Calculate means for each subject-activity-feature combination in desired set from step 4
9. Write output from step 8 to `tidy.txt`
