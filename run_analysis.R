## Read in features.  Assumes data files are in working directory.
features <- read.table("./features.txt")

## Create logical vector for only mean and standard devation features
meanstd <- grepl("mean\\(\\)|std\\(\\)", features[,2])

## Read in test meansurementss table
testX <- read.table("./test/X_test.txt")

## Filter out any column not containing a mean or standard deviation measurement
testfiltX <- testX[,meanstd]

## Read in test activities
testy <- read.table("./test/y_test.txt")

## Read in test subjects
testsubjects <- read.table("./test/subject_test.txt")

## Combine the activites with subjects and measurements
test <- cbind(testy, testsubjects, testfiltX)

## Read in train measurements table
trainX <- read.table("./train/X_train.txt")

## Filter out any column not containing a mean or standard deviation measurement
trainfiltX <- trainX[,meanstd]

## Read in train activities
trainy = read.table("./train/y_train.txt")

## Read in train subjects
trainsubjects = read.table("./train/subject_train.txt")

## Combine the activities with the measurements
train = cbind(trainy, trainsubjects, trainfiltX)

## Combine test and train tables
full = rbind(test, train)

## Name columns
measurementnames <- as.character(features[meanstd,2])
colnames(full) <- c("activity", "subject", measurementnames)

## Descriptive activity names
activities = read.table("./activity_labels.txt")
colnames(activities) = c("activity", "activity_name")

## Merge activities with measurements
merged <- merge(activities, full)

## Turn subjects column into factor
merged$subject <- as.factor(merged$subject)

## Aggregate data by subject and activity
agg <- aggregate(merged, by=list(merged$subject, merged$activity_name), mean)

## Clean up unnecessary columns
drop <- c("activity", "activity_name", "subject")
aggClean <- agg[,!(names(agg) %in% drop)]

## Rename columns appropriately
names(aggClean)[1] <- "subject"
names(aggClean)[2] <- "activity"

## Write table to disk
write.table(aggClean, "tidy_data.txt", row.names=FALSE)
