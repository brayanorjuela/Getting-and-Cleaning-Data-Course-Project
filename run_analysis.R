library(tidyverse)

Features <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt")
names(Features) <- c("Number", "Feature_Capability")
Activity_Labels <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
names(Activity_Labels) <- c("Key_Number","Label")

Subject_Train <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
names(Subject_Train) <- c("Subject_Number")
X_Train <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
names(X_Train) <- Features$Feature_Capability
Y_Train <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
names(Y_Train) <- c("Key_Number")

Subject_Test <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
names(Subject_Test) <- c("Subject_Number")
X_Test <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
names(X_Test) <- Features$Feature_Capability
Y_Test <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
names(Y_Test) <- c("Key_Number")

Merged_Sets <- data.frame(Subject=rbind(Subject_Train,Subject_Test), y=rbind(Y_Train,Y_Test), x=rbind(X_Train,X_Test))

Subject_Col <- grepl("Subject",names(Merged_Sets))
Key_Number_Col <- grepl("Key_Number",names(Merged_Sets))
Mean_Col <- grepl("mean",names(Merged_Sets))
Std_Col <- grepl("std",names(Merged_Sets))
Columns_to_select <- as.logical(Subject_Col + Key_Number_Col + Mean_Col + Std_Col)

Selected_Variables <- Merged_Sets[,Columns_to_select]

Selected_Variables$Key_Number <- as.character(Selected_Variables$Key_Number) 
Selected_Variables$Key_Number <- gsub("1", Activity_Labels[1,2],Selected_Variables$Key_Number) 
Selected_Variables$Key_Number <- gsub("2", Activity_Labels[2,2],Selected_Variables$Key_Number)  
Selected_Variables$Key_Number <- gsub("3", Activity_Labels[3,2],Selected_Variables$Key_Number)  
Selected_Variables$Key_Number <- gsub("4", Activity_Labels[4,2],Selected_Variables$Key_Number)  
Selected_Variables$Key_Number <- gsub("5", Activity_Labels[5,2],Selected_Variables$Key_Number)  
Selected_Variables$Key_Number <- gsub("6", Activity_Labels[6,2],Selected_Variables$Key_Number)

names(Selected_Variables) <- gsub("^x.","", names(Selected_Variables))
names(Selected_Variables) <- gsub("Acc","Accelerometer", names(Selected_Variables))
names(Selected_Variables) <- gsub("Gyro","Gyroscope", names(Selected_Variables))
names(Selected_Variables) <- gsub("^t","Time", names(Selected_Variables))
names(Selected_Variables) <- gsub("Mag","Magnitude", names(Selected_Variables))
names(Selected_Variables) <- gsub("^f","Frequency", names(Selected_Variables))
names(Selected_Variables) <- gsub("mean..","Mean", names(Selected_Variables))
names(Selected_Variables) <- gsub("std..","Standard_Deviation", names(Selected_Variables))
names(Selected_Variables) <- gsub("Key_Number","Activity", names(Selected_Variables))
names(Selected_Variables) <- gsub("Meaneq..", "MeanFreq", names(Selected_Variables))
# following line is to fix up an error to replace unwished repetition of word Body in some of the variable names
names(Selected_Variables) <- gsub("BodyBody","Body", names(Selected_Variables))

First_Data_Set <- Selected_Variables

Data_Set_to_be_submitted <- First_Data_Set %>%
  group_by(Activity, Subject_Number) %>%
  summarise_all(mean)

write.table(Data_Set_to_be_submitted,"Data_set_to_be_submitted.txt", row.names = FALSE)
