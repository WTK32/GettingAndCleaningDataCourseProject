setwd("C:/Users/fruit/OneDrive/Documents/R/Coursera/Data Cleaning/CourseProject/UCI HAR Dataset")
getwd()

##### Read "activity_labels.txt" #####
activity_labels <- read.table("activity_labels.txt")
colnames(activity_labels) <- c("a_label","activityName")
dim(activity_labels)
# 6 obs. of 2 variables

##### Read "features.txt" #####
features_labels <- read.table("features.txt")
colnames(features_labels) <- c("f_label","feature")
# 561 obs. of 2 variables

##### Read training set "X_train.txt" #####
X_train <- read.table("train/X_train.txt")
class(X_train) # data.frame
head(X_train)
# 7352 obs. of 561 variables

##### Read training set "y_train.txt" #####
y_train <- read.table("train/y_train.txt")
class(y_train)
head(y_train)
summary(y_train)   # min 1, max 6 => activity labels
# 7352 obs. of 1 variable

##### Read training set "subject_train.txt" #####
subject_train <- read.table("train/subject_train.txt")
summary(subject_train) #min 1, max 30, mean 17.41 
table(subject_train) # frequency  chart
length(table(subject_train)) # 21. meaning 21 unique subjects(testers)
# 7352 obs. of 1 variable

##### Read testing set "X_test.txt" #####
X_test <- read.table("test/X_test.txt")
class(X_test) # data.frame
head(X_test)
dim(X_test)
# 2947 obs. of 561 variables

##### Read testing set "y_test.txt" #####
y_test <- read.table("test/y_test.txt")
class(y_test)
head(y_test)
dim(y_test)
summary(y_test)   # min 1, max 6 => activity labels
table(y_test)
# 2947 obs. of 1 variable

##### Read testing set "subject_test.txt" #####
subject_test <- read.table("test/subject_test.txt")
summary(subject_test) #min 2, max 24, mean 12.99 
dim(subject_test)
table(subject_test)
length(table(subject_test)) # 9. meaning 9 subjects(testers)
# 2947 obs. of 1 variable

##### Combine test and train #####
total_X <- rbind(X_test, X_train)
total_y <- rbind(y_test, y_train)
total_subject <- rbind(subject_test, subject_train)

dim(total_X) # 10299  561
dim(total_y) # 10299 1
dim(total_subject) # 10299  1

table(total_y) # frequency of activities
#    1    2    3    4    5    6 
#  1722 1544 1406 1777 1906 1944 

table(total_subject) # frequency of subjects(testers)
#   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27 
#  347 302 341 317 302 325 308 281 288 294 316 320 327 323 328 366 368 364 360 354 408 321 372 381 409 392 376 

#  28  29  30 
# 382 344 383

##### extract only mean and std for measurements #####
measurement <- grep("mean\\(\\)|std\\(\\)", features_labels[,2], perl = T)
# escape () using double backslash "\\"
total_X_meanstd <- total_X[,measurement]
dim(total_X_meanstd)

##### join y and subject to the X dataset #####
data <- cbind(total_X_meanstd, total_y, total_subject)
names(data)
##### rename the col names #####
newcolnames <- gsub("\\()","",as.character(features_labels[measurement,2])) # replace ()
library(stringr)
row_2body <- which(str_count(newcolnames, "Body")>1) # find out which col names repeat "Body" more than once
newcolnames[row_2body] <- sub("Body","",newcolnames[row_2body])
colnames(data) <- c(newcolnames,"y","personID")
names(data)

##### name the activities #####
library(dplyr)
data_activity <- left_join(data, activity_labels, by = c("y" = "a_label"))
names(data_activity)

##### Check if each activity has every tester #####
freq_activity_person <- table(data_activity[,c(68,69)]) 
# yes, each tester has performed every activity, though not the same counts.

##### Summarize by each activity and by each tester #####
gp_data_activity <- group_by(data_activity,activityName,personID)
summary_activity_test <- summarise_all(gp_data_activity, funs(mean))
summary_activity_test$personID <- as.character(summary_activity_test$personID)
summary_activity_test$activityName <- as.character(summary_activity_test$activityName)
summary_activity_test <- as.data.frame(summary_activity_test)

# summarize(gp_data_activity,mean(`tBodyAccMag-mean`))    Using backticks ` to escape hyphen "-"
# https://stackoverflow.com/questions/22842232/dplyr-select-column-names-containing-white-space

##### Summarize by each activity #####
gpA_data_activity <- group_by(data_activity, activityName)
summaryA_activity_test <- summarise_all(gpA_data_activity, funs(mean))
summaryA_activity_test$personID <- "All"
summaryA_activity_test$activityName <- as.character(summaryA_activity_test$activityName)

##### Summarize by each tester #####
gpP_data_activity <- group_by(data_activity, personID)
summaryP_activity_test <- summarise_all(gpP_data_activity, funs(mean))
summaryP_activity_test$activityName <- "All"
summaryP_activity_test$personID <- as.character(summaryP_activity_test$personID)

# names(summary_activity_test)[c(1:68)]
# names(summaryA_activity_test)[c(1,69,2:67)]
# names(summaryP_activity_test)[c(69,1,2:67)]

##### Stack 3 summary tables on top of each other #####
summaryAll <- rbind(summary_activity_test[,c(1:68)],summaryA_activity_test[,c(1,69,2:67)],summaryP_activity_test[,c(69,1,2:67)])

##### Save the summary table as an excel file #####
library(xlsx)
write.xlsx(summaryAll, "Summary.xlsx", row.names = FALSE)

write.table(summaryAll, "Summary.txt", row.names = FALSE)



##### No need to look into the files in Inertial Signals - Please disregard #####
##### Read training set Inertial Signals #####
body_acc_x_train <- read.table("train/Inertial Signals/body_acc_x_train.txt")
# 7352 obs. of 128 variables

body_acc_y_train <- read.table("train/Inertial Signals/body_acc_y_train.txt")
# 7352 obs. of 128 variables

body_acc_z_train <- read.table("train/Inertial Signals/body_acc_z_train.txt")
# 7352 obs. of 128 variables

body_gyro_x_train <- read.table("train/Inertial Signals/body_gyro_x_train.txt")
# 7352 obs. of 128 variables

body_gyro_y_train <- read.table("train/Inertial Signals/body_gyro_y_train.txt")
# 7352 obs. of 128 variables

body_gyro_z_train <- read.table("train/Inertial Signals/body_gyro_z_train.txt")
# 7352 obs. of 128 variables

total_acc_x_train <- read.table("train/Inertial Signals/total_acc_x_train.txt")
# 7352 obs. of 128 variables

total_acc_y_train <- read.table("train/Inertial Signals/total_acc_y_train.txt")
# 7352 obs. of 128 variables

total_acc_z_train <- read.table("train/Inertial Signals/total_acc_z_train.txt")
# 7352 obs. of 128 variables




