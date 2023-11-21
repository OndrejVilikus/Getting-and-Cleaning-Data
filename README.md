The runAnalysis.R file gets the Samsung data and transforms them into a tidy dataset:

- The zip file with the data in downloaded
- All the necessary files (X, y and subject) for both test and trial are read and stored
- Metadata in features.txt activity_labels.txt is used to define the variable names and labels
- Tend and trial data are merged
- Only these columns are kept:
    - subject id
    - variables with averages (mean) or standard deviations (std)
    - activity 

- Further steps use libraries data.table and stringr so they need to be loaded
- To create a tidy set, columns with the mean and standard deviation values for each variable ar pivoted to rows
- original variable names witjout "-mean()" and "-std()" are stored in the variable column
- data is grouped by subject, activity and variable and summarized with means

- resulting tidy data set is saved in current workspace as tidy_data.txt

