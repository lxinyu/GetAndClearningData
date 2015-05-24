# Download the dataset file if not exists and unzip it
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destfile <- "UCI HAR Dataset.zip"
destDir <- "UCI HAR Dataset"
if (!file.exists(destfile)) {
    download.file(fileUrl, destfile, method="curl")
}
if (!file.exists(destDir)) {
    unzip(destfile, exdir = ".")
}

# Read feature list
features <- tbl_df(read.table(paste(destDir, "/features.txt", sep="")))

# Read traing and test data from dataset
x_train <- read.table(paste(destDir, "/train/X_train.txt", sep=""))
x_test <- read.table(paste(destDir, "/test/X_test.txt", sep=""))
y_train <- read.table(paste(destDir, "/train/Y_train.txt", sep=""))
y_test <- read.table(paste(destDir, "/test/Y_test.txt", sep=""))
subject_train <- read.table(paste(destDir, "/train/subject_train.txt", sep=""))
subject_test <- read.table(paste(destDir, "/test/subject_test.txt", sep=""))

# Combine the data
x_all <- rbind(x_train, x_test)
y_all <- rbind(y_train, y_test)
subject_all <- rbind(subject_train, subject_test)

# Assign column names
colnames(x_all) <- features$V2
colnames(y_all) <- "Activities"
colnames(subject_all) <- "Subject"

# Keep only Mean or Std columns
x_all <- x_all[,grep("(mean|std)\\(\\)",names(x_all))]

#replace numerical values in y with strings from the activity_labels
activity <- read.table(paste(destDir, "/activity_labels.txt", sep=""))
y_all[,1] <- activity[y_all[,1],2]

mergedData <- cbind(subject_all,y_all,x_all)

# Tidy Data set with averages of each variable for each Activity and each Subject
tidyData <- ddply(mergedData, .(Activities,Subject), function(mergedData) colMeans(mergedData[,-c(1,2)]))
write.table(tidyData, "UCI HAR Tidy Data.txt",row.name=FALSE)
