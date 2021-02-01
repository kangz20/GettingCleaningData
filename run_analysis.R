library(tidyverse)
#train
#read the training set
train <- read.table('UCI HAR Dataset/train/X_train.txt')
#read the features for training set and assign to R object
featureTrn <- read.table('UCI HAR Dataset/features.txt')
#read the activities for training set and assign to R object
activityTrn <- read.table('UCI HAR Dataset/train/y_train.txt')
#Read the corresponding subject information to the training set
subjectTrn <- read.table('UCI HAR Dataset/train/subject_train.txt')
colnames(train) <- featureTrn$V2
train$activity <- activityTrn
train$subject <- subjectTrn
#Keep required columns only. That is mean and standard deviation for each variable
train2 <- select(train, activity, subject, contains("mean()"), contains("std()"))
#test
#perform same tasks that were performed on training set
test <- read.table('UCI HAR Dataset/test/X_test.txt')
featureTst <- read.table('UCI HAR Dataset/features.txt')
activityTst <- read.table('UCI HAR Dataset/test/y_test.txt')
subjectTst <- read.table('UCI HAR Dataset/test/subject_test.txt')
colnames(test) <- featureTst$V2
test$activity <- activityTst
test$subject <- subjectTst
test2 <- select(test, activity, subject, contains("mean()"), contains("std()"))
#Once activity and subject columns have been added, also required mean and std columns are selected, combine train and test
all <- full_join(train2, test2)
#Change the activity codes to descriptive activity labels
all$activity <- ifelse(all$activity==1, "WALKING", ifelse(all$activity==2, "WALKING_UPSTAIRS",
                ifelse(all$activity==3, "WALKING_DOWNSTAIRS", ifelse(all$activity==4, "SITTING",
                ifelse(all$activity==5, "STANDING", "LAYING")))))
#Fix the colnames to make them tidy
colnames(all) <- gsub("\\()", "", colnames(all))
all$subject <- as.factor(all$subject$V1)
#Make tidy dataset with the average of each variable for each activity and each subject.
tidy <- aggregate(.~ activity + subject, data = all, FUN = mean)
write.table(tidy, file=‘tidy.txt, row.names=FALSE)