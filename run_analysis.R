# load required libraries -------------------------------------------------
library(magrittr) # piping

# Download .zip if it does not exist at desired path ----------------------
setwd("./coursera/data_science_specialization/data_cleaning/")

file_name <- "UCI HAR Dataset"

remote_file_path = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
local_file_path = "HAR_DATASET.zip"

if(!file.exists(local_file_path)) {
  download.file(url = remote_file_path, destfile = local_file_path)
}

# extract .zip if it does not exist ---------------------------------------
if (!file.exists(file_name)) {
  unzip(local_file_path)
}

# extract activity and feature labels -------------------------------------
setwd(file_name)

activity_labels <-
  read.table(
    "./activity_labels.txt"
    , header = F
    , sep = " "
    , col.names = c("activity_label", "activity_description")
    , colClasses = c("numeric", "character")
  )

feature_labels <-
  read.table(
    "./features.txt"
    , header = F
    , sep = " "
    , col.names = c("feature_label", "feature_description")
    , colClasses = c("numeric", "character")
  )

# filter down to only mean and sd measurements ----------------------------
feature_labels <-
  feature_labels %>%
  dplyr::mutate(
    feature_description_cleansed = stringr::str_replace_all(feature_description, pattern = "\\(|\\)", replacement = "")
    , feature_description_cleansed = stringr::str_replace_all(feature_description_cleansed, pattern = ",|-", replacement = "_")
  )

feature_labels_subset <-
  feature_labels %>%
  dplyr::filter(stringr::str_detect(feature_description_cleansed, "mean|std"))

# load test and train datasets --------------------------------------------
training_data <-
  read.table(
    "./train/X_train.txt"
    , header = F
    , nrows = -1
    , colClasses = "numeric"
    , col.names = feature_labels$feature_description_cleansed
  ) %>%
  dplyr::select(feature_labels_subset$feature_label)

test_data <-
  read.table(
    "./test/X_test.txt"
    , header = F
    , nrows = -1
    , colClasses = "numeric"
    , col.names = feature_labels$feature_description_cleansed
  ) %>%
  dplyr::select(feature_labels_subset$feature_label)

# load test and train activities ------------------------------------------
training_activities <- read.table(
  "./train/y_train.txt"
  , nrows = -1
  , colClasses = "numeric"
  , col.names = "activity_label"
)

test_activities <- read.table(
  "./test/y_test.txt"
  , nrows = -1
  , colClasses = "numeric"
  , col.names = "activity_label"
)

# load test and train subjects --------------------------------------------
training_subjects <- read.table(
  "./train/subject_train.txt"
  , nrows = -1
  , colClasses = "numeric"
  , col.names = "subject_label"
)

test_subjects <- read.table(
  "./test/subject_test.txt"
  , nrows = -1
  , colClasses = "numeric"
  , col.names = "subject_label"
)

# return to parent directory ----------------------------------------------
setwd("..")

# create full test and train datasets with key ----------------------------
train <- cbind(training_subjects, training_activities, training_data)
test <- cbind(test_subjects, test_activities, test_data)

# merge test and train ----------------------------------------------------
test_and_train <- rbind(train, test)

# convert from wide to long -----------------------------------------------
test_and_train_long <-
  test_and_train %>%
  tidyr::gather(feature_label, feature_value, -subject_label, -activity_label)


# calculate mean for each feature for each subject - activity combination ------------------
test_and_train_mean_by_subject_and_activity <-
  test_and_train_long %>%
  dplyr::group_by(subject_label, activity_label, feature_label) %>%
  dplyr::summarise(mean_feature_value = mean(feature_value)) #%>%
  # tidyr::spread(feature_label, mean_feature_value) # optional conversion back to wide dataset

# write output to file ----------------------------------------------------
write.table(
  x = test_and_train_mean_by_subject_and_activity
  , file = "./tidy.txt"
  , row.names = F
)
