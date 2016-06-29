# GettingAndCleaningDataProject

What needs to be kept in mind is that the full data set is made up of various text files.
I will go over the example for the test data set, but the same applies to the train data set.

The 'features.txt' file contains all of the measures that were tracked in the study. These measures correspond to the columns in the 'x_test.txt' files. In other words, the one column in the features file corresponds to the multiple columns in the test file. We must somehow pivot the columns in the measures file and make them be the column names of the test file.

Additionally, two other text files are of importance to us: the subject_test and the y_test. the subject_test lets us know which subject performed the data colected in rows of the x_test file. That is, if row #5 in the subject_test file is equal to 20, that means that subject id #20 performed the activity, and the #5 record in x_test belongs to him. Likewise, the y_test file lets us know which activity was performed each line. 

Thus, adding these to the dataset is rather easy. A simple cbind or a mutate will do.

Once those relationships are established, all there is to do is unpivot (or melt) the data, group it, and find the mean for each activity and each subject, which can be achieved by using summarize.
