## Make sure to have all the required files in your working directory.

require(dplyr)
require(reshape2)

## reading the variable table, and assigning it names.

vars <- read.table("./features.txt")
names(vars) = c("nbr", "feature")

## Here we find which observations are either means or SDs and pull those out only.
meanObs <- grep("[Mm]ean", vars$feature)
stdObs <- grep("[Ss][Tt][Dd]", vars$feature)
obs <- c(meanObs, stdObs)

#shrink the vars table to only show means or SDs.
vars<- vars[obs,]

#  Remove the helper table and variables
rm("meanObs", "stdObs")

## Here we bring in the activity labels, as well as all of the test data in order
## to get prepare ourselves for the first merge.
act_labels <- read.table("activity_labels.txt")
test_subject <- read.table("./test/subject_test.txt")
test_activity <- read.table("./test/y_test.txt")
test_df <- read.table("./test/x_test.txt")
test_df <- tbl_df(test_df) ## Making this a table DF.

## Same as aboe, but with the trainig dataset.
train_subject <- read.table("./train/subject_train.txt")
train_activity <- read.table("./train/y_train.txt")
train_df <- read.table("./train/x_train.txt")
train_df <- tbl_df(train_df) ## Making this a table DF.

## Merging the activity labels with the test_activity.
test_act_table <- merge(act_labels, test_activity, by.x = "V1", by.y = "V1", all = TRUE)
names(test_act_table) <- c("code", "activity")

train_act_table <- merge(act_labels, train_activity, by.x = "V1", by.y = "V1", all = TRUE)
names(train_act_table) <- c("code", "activity")

## Selecting only the columns in the dataset that involve means and SDs
test_df <- select(test_df, vars$nbr)
train_df <- select(train_df, vars$nbr)

## Renaming the columns of the test dataset.
names(test_df) <- as.vector(vars$feature)
names(train_df) <- as.vector(vars$feature)

##Adding the subject_id and the activity to the dataset.
test_df <- mutate(test_df, subject_id = test_subject$V1, activity = test_act_table$activity)
len = length(colnames(test_df)) - 2
test_df <- select(test_df, subject_id, activity, 1:len) ##Reorganizing the dataset.

train_df <- mutate(train_df, subject_id = train_subject$V1, activity = train_act_table$activity)
len = length(colnames(train_df)) - 2
train_df <- select(train_df, subject_id, activity, 1:len) ##Reorganizing the dataset.

## removing additional helper datasets and variables.
rm("test_act_table", "train_act_table", "act_labels", "test_activity", "test_subject","train_activity","train_subject", "len", "vars", "obs")

## Merging the two formatted datasets and making it a tbl_df.
df_merged <- rbind(train_df, test_df)
df_merged <- tbl_df(df_merged)

## Unpivoting all the columns and dumping them as rows in a variable called "measure"
test_df_final <- melt(df_merged, id.vars = c(1:2))
names(test_df_final)[3] = "measure"

#Grouping by id, activity, and measure.
test_df_final <- group_by(test_df_final, subject_id, activity, measure)

#final results after averaging records grouped by the description above.
results <- summarize(test_df_final, mean = mean(value, na.rm = TRUE))