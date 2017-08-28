# Databricks notebook source
filepathtest <- file.path('','mnt','bucket1prad','sampled_test.csv')

test1 <- read.df(sqlContext, filepath, header='true', source = "com.databricks.spark.csv", inferSchema='true')


# COMMAND ----------

filepath <- file.path('','mnt','bucket1prad','sampled_train.csv')

df <- read.df(sqlContext, filepath, header='true', source = "com.databricks.spark.csv", inferSchema='true')
training <- df
test <- df

# Fit an binomial logistic regression model with spark.logit
model <- spark.logit(training, hotel_cluster ~ is_booking+site_name+posa_continent+site_name+user_location_country+user_location_city+user_location_region+user_id+is_package+is_mobile+ channel +hotel_continent + hotel_country+ hotel_market+ srch_destination_id, maxIter = 10, regParam = 0.3, elasticNetParam = 0.8)

# Model summary
summary(model)

# Prediction
predictions <- predict(model, test)
showDF(predictions)


# COMMAND ----------

preds <- predict(model, test1)

# COMMAND ----------

totalrows<- nrow(test1)
preds$result<- ifelse((preds$hotel_cluster==preds$prediction), 1 , 0)
correct<- nrow(preds[preds$result == 1,])
accuracy_lr <- correct/totalrows

# COMMAND ----------

print(accuracy_lr)

# COMMAND ----------

1/150

# COMMAND ----------


