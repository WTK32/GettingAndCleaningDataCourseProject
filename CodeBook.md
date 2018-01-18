Steps To Clean Up the Data Before the Analysis:
===============================================

- Combine(Stack) testing and training data in measurement, activity, and volunteer information. Note that each volunteer performed each activities at different number of times.

- Only select the measurements which names includes "mean()" and "std()". There are 66 measurements selected. 

- Make the selected measurements data wider by adding activity and volunteer information. 

- Rename the selected measurement variable names by taking out "()" and removing "Body" if it shows up twice. Note that the special character "-" is kept, because it is a good way to break out feature factor, statistics, and 3-axial dimensions in my opinions.

- Name the activity instead of activity label in the data set. 



Summary Analysis:
=================

- The summary table is the **AVERAGE** of selected measurement data for each activity and each volunteer. 

- There are total 216 rows in the summary table. It includes 180 rows of 30 volunteers performing 6 activities (30 x 6), 6 rows of 6 activities performed by all volunteers, 30 rows of 30 volunteers performing all activities. 



Descriptions of the Variables:
==============================
- activityName: a character string describing the activity was performed by volunteer in the experiment, including 
    - Laying
    - Sitting
    - Standing
    - Walking
    - Walking downstairs
    - Walking upstairs
    
- personID: an unique sequential identifier for 30 volunteers if the average summary is presented for each volunteer. "All" when the average summary is for each activity only. It has a range of values from 1 to 30 and "All". 

- 66 measurements variables. The data is normalized and bounded within [-1,1]. 
The variable names follow a certain schema.  The following shows how a variable name is constructed. There are 4 parts to form a variable name:

    1. First letter is either "t" or "f". "t" indicates time, whereas "f" indicates frequency.  
    2. Second letter to the letter before the first "-" indicates the signal. There are 4 sub-parts in the signal.
        - First sub-part is either "Body" or "Gravity".
        - Second sub-part is either "Acc" or "Gyro". "Acc" indicates the data comes from accelerometer, whereas "Gyro" is from gyroscope.
        - Third sub-part is whether Jerk signal is obtained. If it is obtained, it is included in the third sub-part of the variable name as "Jerk". If it is not obtained, it is simply ignored and not included in the variable name. 
        - Forth sub-part is whether magnitude signal is calculated. If it is, it is included in the forth sub-part of the variable name as "Mag". If it is not, it is simply ignored and not included in the variable name.  
    3. First letter after the first "-" to the letter before the second "-" or to the end indicates the statistics were estimated from the signals. It is either "mean" or "std".  
    4. The letter after the second "-" if exists indicates the 3-axial signals in the X, Y and Z directions.  
    
    For example,  
    
    **tBodyAccJerk-mean-Y** is the mean of time domain of Jerk signal in Body from accelerometer in Y dimension.  
    **tGravityAccMag-std** is the standard deviation of time domain of Magnitude signal in Gravity from accelerometer. 
