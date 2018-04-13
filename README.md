# Titanic-code
This is my first machine learning project.
The Analysis on Titanic Dataset is divided into namely into three modules: -
1.	Data cleansing.
2.	Visualization.
3.	Predictions.
The First part is the most important one as it makes the selected data compatible for tests. Data Cleansing consists of various stages: Cleaning or erasing or unwanted data, Replacing the blank columns with meaningful data, reformatting the present data into usable format etc.
Once the data is cleansed it is ready to use. In the visualization module, various visualizations are created using the R packages like “Amelia” and “ggplot2” to name a few. The visualization by means of Histogram is used for depicting the survival with respect to sex, class and age. There are mix visualizations created showing the survival of different sex with respect to class, age etc.
The third and final module is prediction. The Titanic data set is divided into two parts called ‘Train’ and ‘Test’. The Train dataset consists of 891 rows of data, which consists of the survival column of each passenger depicting whether that particular passenger survived or not. The Test dataset consists 441 rows of data, without the survival column being present. The third module focuses on use of predictive algorithms like Random tree and Naive Bayes algorithm, to predict the rate of survival. The initial step involves using the algorithm on train dataset to derive the expected values. Next using these as the base parameters we need to predict the survival rate or chances of survival of the passengers present in test dataset.
