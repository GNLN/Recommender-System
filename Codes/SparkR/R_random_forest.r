# Databricks notebook source
#Working random forest
filepath <- file.path('','mnt','bucket1prad','sampled_train.csv')

df <- read.df(sqlContext, filepath, header='true', source = "com.databricks.spark.csv", inferSchema='true')

#df <- read.df('','mnt','bucket1prad','sampled_train.csv')
training <- df
test <- df


#df_train <- createDataFrame(training)

# COMMAND ----------

filepath_test <- file.path('','mnt','bucket1prad','sampled_train.csv')

test <- read.df(sqlContext, filepath, header='true', source = "com.databricks.spark.csv", inferSchema='true')

# COMMAND ----------

training$srch_ci <- NULL
training$srch_co <- NULL
training$date_time <- NULL


train <- sample(df, withReplacement=FALSE, fraction=0.8, seed=42)
validation <- except(df, train)

# COMMAND ----------

model <- spark.randomForest(train, hotel_cluster ~ is_booking+site_name+posa_continent+site_name+user_location_country+user_location_city+user_location_region+user_id+is_package+is_mobile, "classification", numTrees = 5)

# get the summary of the model
summary(model)

# COMMAND ----------

# Prediction
predictions <- predict(model, test)
display(predictions)

# COMMAND ----------

 printSchema(training)

# COMMAND ----------

printSchema(training)

# COMMAND ----------

df_pred <- predictions$prediction

# COMMAND ----------

head(predictions, 10)

# COMMAND ----------



# COMMAND ----------

total_rows<- nrow(test)
predictions$result<- ifelse((predictions$hotel_cluster==predictions$prediction), 1 , 0)
correct<- nrow(predictions[predictions$result == 1,])
accuracy <- correct/total_rows


# COMMAND ----------

head(train, 10)

# COMMAND ----------

model_rf <- spark.randomForest(train, hotel_cluster ~ is_booking+site_name+posa_continent+site_name+user_location_country+user_location_city+user_location_region+user_id+is_package+is_mobile+ channel +hotel_continent + hotel_country+ hotel_market+ srch_destination_id  , "classification", numTrees = 5)

# COMMAND ----------

preds <- predict(model_rf, test)
test$rf_preds<-preds$prediction


# COMMAND ----------

preds <- predict(model_rf, test)
preds$result<- ifelse((preds$hotel_cluster==preds$prediction), 1 , 0)
correct<- nrow(preds[preds$result == 1,])
accuracy_1 <- correct/total_rows

# COMMAND ----------

print(accuracy_1)
layers = c(4, 5, 4, 3)


# COMMAND ----------



