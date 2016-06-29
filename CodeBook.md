##This codebook is to describe the variables and transformations used in my run_analysis.R script.

'vars' is a variable that tracks the column names. At first, the read.table() command brings all of the variables, then i change the name of the columns to "nbr" and "feature".

meanObs does a search within the feature column to extract only those that have a "mean"
stdObs does the same as above but for standard deviation.
obs combines these two vectors.

I then proceed to shrink the 'vars' variable to hold only those rows that match either mean or std by doing a vars <- vars[obs,]

'act_labels' is a read.table() of the activity labels.
'test_subject' is a read.table() of the subjects involved in the test.
'test_activity' is a read.table() of the activity performed by each subject.
'test_df' is the actual data. I then transform this into a table data frame to be able to filter and select columns easier.

The same is performed in the training dataset, with the exception of 'act_labels'

test_act_table merges act_labels with the test_activity, producing labels for each activity performed.
the names of the two columns produced by the merge are then changed to "code" and "activity"

likewise, for the train dataset, the same merge is performed.

I then reshare my test_df and train_df dateframes by selecting only the column names that match the 'vars' table.

I proceed to change the name of the variables to be the actual measure names.

The next transformation for both the test_df and train_df tables is to mutate (or add) two columns to the data frames: the activity and the subject id. These are done by doing "test_df <- mutate(test_df, subject_id = test_subject$V1, activity = test_act_table$activity)"

I then proceed to rearrange the data frames so that the activity and subject_ids show up first. I do this by creating a 'len' variable equal to the number of columns minus two.

I then do a select on each data frame and choose the subject_id, activity, and the reamining columns in the data frame minus the last two (which are really the first two that i chose).

I then do an rbind of the two data frames and make it a table data frame.

Once that's done, i melt the dataframe (or Unpivot) so that the column names become part of a column called "measure".

I proceed to group that by the non-value columns, and then i create a 'results' table that summarizes the data by subject, activity, and produces the mean for each.



