1. required libraries are installed and called
2. expedia datafile is read and stored in a variable named expedia
3. expedia$hotel_cluster which is the target variable is converted to as factor with 150 levels
4. sc is the spark through which expedia is written to a varaible titled ex on spark
5. ml-formula contains the formula of random forest with dependant and independent mentioned
6. model stores the spark random forest model with the given formula
7. mgpPredict is a function which takes in the values for user_continent, user_location_country, 
   site_name and is_booking and predict using the random forest model and return the predicted 
   cluster value from the mgpPredict function to the UI.