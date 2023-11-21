##Download the zip file with the data
download <- tempfile()
download.file(
  "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
  download
)

# Read the variable and level labels
features <-
  read.table(unz(download, "UCI HAR Dataset/features.txt"), header = FALSE)
activity_labels <-
  read.table(unz(download, "UCI HAR Dataset/activity_labels.txt"), header = FALSE)

# Read the train data (subjects, variable values and levels)
subject_train <-
  read.table(unz(download, "UCI HAR Dataset/train/subject_train.txt"),
             header = FALSE)
X_train <-
  read.table(unz(download, "UCI HAR Dataset/train/X_train.txt"), header = FALSE)
y_train <-
  read.table(unz(download, "UCI HAR Dataset/train/y_train.txt"), header = FALSE)
subject_train <-
  read.table(unz(download, "UCI HAR Dataset/train/subject_train.txt"), header = FALSE)
X_train <-
  read.table(unz(download, "UCI HAR Dataset/train/X_train.txt"), header = FALSE)
y_train <-
  read.table(unz(download, "UCI HAR Dataset/train/y_train.txt"), header =  FALSE)

# Read the test data (subjects, variable values and levels)
subject_test <-
  read.table(unz(download, "UCI HAR Dataset/test/subject_test.txt"),
             header = FALSE)
X_test <-
  read.table(unz(download, "UCI HAR Dataset/test/X_test.txt"), header = FALSE)
y_test <-
  read.table(unz(download, "UCI HAR Dataset/test/y_test.txt"), header = FALSE)

#Close the temporary folder
unlink(download)

#Merge the data sets
subject <- rbind(subject_train, subject_test)
X <- rbind(X_train, X_test)
y <- rbind(y_train, y_test)

#Label variables and turn activity into factor
colnames(subject) = "subject"
colnames(X) = as.character(features[, 2])
colnames(y) = "activity"
y$activity = as.factor(y$activity)
levels(y$activity) = as.character(activity_labels[, 2])
data <- cbind(subject, X, y)

#Filter only subject id, variables with averages (mean) or standard deviations (std) and activity
selection <-
  grep("subject|.*mean\\(\\).*|.*std\\(\\).*|activity",
       colnames(data))
data_filtered <- (data[, selection])
df <- as.data.table(data_filtered)

# Libraries data.table and stringr are needed for the next step
library(data.table)
library(stringr)

# Unpivot the mean and standard deviation values for each variable
melted <-
  melt(
    df,
    id = c("subject", "activity"),
    measure = patterns(mean = "mean", std = "std"),
    value.factor = TRUE,
    na.rm = TRUE
  )

# Use the variable names as factor levels
melted$variable <- as.factor(melted$variable)
levels(melted$variable) = str_replace(colnames(df)[grep(".*mean\\(\\).*", colnames(df))], "-mean\\(\\)", "")

# Summarize the means of each variable for each activity and each subject
summary <- melted %>%
  group_by(subject, activity, variable) %>%
  summarise(mean = mean(mean), std = mean(std))

# Write the tidy data in your working directory
write.table(summary,"tidy_data.txt", row.name=FALSE)

