require (dplyr)

dir1 <- "data/train"
dir2 <- "data/test"

#
#	Import features.txt to automate variable naming.
#

df_features <- read.table ( "data/features.txt" , sep = "" , header = FALSE )

#
#	Select the features with names containing mean and std.
#
#	To avoid meanFreq, () is appended.
#
features_1 <- grep("mean()", df_features$V2 , fixed=TRUE )
features_2 <- grep ("std()" , df_features$V2, fixed=TRUE) 

#
#	It is natural not having the parentheses for variable names.
#
#	Also - is replaced with _ just in case.
#
df_features$V2 <- gsub ( "()" , "" , df_features$V2 , fixed = TRUE )
df_features$V2 <- gsub ( "-" , "_" , df_features$V2 , fixed = TRUE )

#
#	Column numbers selected...
#
selected_features <- sort ( c ( features_1 , features_2 ) )

file_subject_train <- paste ( dir1 , "/" , "subject_train.txt" , sep = "")

file_train1 <- paste ( dir1 , "/" , "X_train.txt" , sep = "" )
file_train2 <- paste ( dir1 , "/" , "y_train.txt" , sep = "" )

#
#	Import activity labels.
#
df_labels <- read.table ( "data/activity_labels.txt" , sep = "" , header = FALSE )

#
#	Import subject numbers.
#
df_subject_train <- read.table ( file_subject_train , sep = "" , header = FALSE )
names(df_subject_train) = c ( "subject" )
#
#	Import activity numbers.
#
df_activity <- read.table ( file_train2 , sep = "" , header = FALSE )
names(df_activity) = c ( "activity" )
df_activity <- transform ( df_activity , activity = df_labels$V2 [ activity ] )

df_train <- read.table ( file_train1 , sep ="" , header = FALSE )

df_train <- select ( df_train , selected_features )
names(df_train) <- df_features$V2 [ selected_features ]

#
#	Prepared data frame for training data.
#
df_train_1 <- data.frame ( df_train , df_subject_train , df_activity )

#
#	Similar treatment is done for test data...
#
file_subject_test <- paste ( dir2 , "/" , "subject_test.txt" , sep = "")
file_test1 <- paste ( dir2 , "/" , "X_test.txt" , sep = "" )
file_test2 <- paste ( dir2 , "/" , "y_test.txt" , sep = "" )

df_subject_test <- read.table ( file_subject_test , sep = "" , header = FALSE )
names(df_subject_test) = c ( "subject" )

df_activity <- read.table ( file_test2 , sep = "" , header = FALSE )
names(df_activity) = c ( "activity" )
df_activity <- transform ( df_activity , activity = df_labels$V2 [ activity ] )

# df_activity <- read.table ( file_test2 , sep = "" , header = FALSE )
# names(df_activity) = c ( "activity" )

df_test <- read.table ( file_test1 , sep ="" , header = FALSE )

df_test <- select ( df_test , selected_features )
names(df_test) <- df_features$V2 [ selected_features ]

df_test_1 <- data.frame ( df_test , df_subject_test , df_activity )

#
#	Combine both data frames into one big data frame...
#
#	and write to a text file.
#
df_combined <- rbind ( df_train_1 , df_test_1 )

#write.table (df_combined , file = "result1.txt" , row.names = FALSE , col.names = TRUE )

#
#
#

df_result <- data.frame ( )

for ( x in unique ( df_combined$subject ) )
{
  for ( y in unique ( df_combined$activity ) )
  {
     a <- filter ( df_combined , ( subject == x ) & ( activity == y ) )
     a <- select ( a , -c(activity ,subject))
     df_temp = lapply ( a , mean )
     df_pre = data.frame ( subject = x , activity = y )
     df_temp = cbind (df_pre , df_temp )
     df_result = rbind ( df_result , df_temp )
  }
}

write.table (df_result , file = "result.txt" , row.names = FALSE , col.names = TRUE )
