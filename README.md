# Getdata030

## Overview

### Preparation
* Find out the column positions with names containing mean / std but not meanFreq.  
This is achieved by using grep on the dataframe read from the file features.txt.  
Extra treatment involves replacing - by _ and removing () to be more appropriate.
* Read activity_labels.txt to identify activity names.

### Processing
* Read the train and test data sets into data frames.
* Use select to extract wanted fields.
* Bind each obtained data frame with data frames from subject_{train,test}.txt and y_{train,test}.txt  
Use the data frame describing activity labels in this stage.
* Row bind the two data frames.

### Obtain tidy data
* Loop over the subject numbers and activity labels with an appropriate data filtering.  
Use lapply with mean to get columns' means...

### Variable name description...
* To save time, contents of features.txt are preserved as nuch as possible, except removing the parentheses and replacing - by _.
