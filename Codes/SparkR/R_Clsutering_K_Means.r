# Databricks notebook source
filepath <- file.path('','mnt','bucket1prad','sampled_train.csv')
df <- read.df(sqlContext, filepath, header='true', source = "com.databricks.spark.csv", inferSchema='true')

filepath <- file.path('','mnt','bucket1prad','sampled_test.csv')
test <- read.df(sqlContext, filepath, header='true', source = "com.databricks.spark.csv", inferSchema='true')
training <- df
#test <- df

#hotelDF <- suppressWarnings(createDataFrame(iris))
#kmeansDF <- irisDF
#kmeansTestDF <- irisDF
kmeansModel <- spark.kmeans(training, hotel_cluster ~ is_booking+site_name+posa_continent+site_name+user_location_country+user_location_city+user_location_region+user_id+is_package+is_mobile+ channel +hotel_continent + hotel_country+ hotel_market+ srch_destination_id, k = 150)

# Model summary
summary(kmeansModel)

# Get fitted result from the k-means model
showDF(fitted(kmeansModel))


# COMMAND ----------


# Prediction
kmeansPredictions <- predict(kmeansModel, test)
showDF(kmeansPredictions)

# COMMAND ----------

totalrows<- nrow(test)
kmeansPredictions$result<- ifelse((kmeansPredictions$hotel_cluster== kmeansPredictions$prediction), 1 , 0)
correct<- nrow(kmeansPredictions[kmeansPredictions$result == 1,])
accuracy_km <- correct/totalrows

# COMMAND ----------

print(accuracy_km)

# COMMAND ----------

a<-nrow(kmeansPredictions$hotel_cluster== kmeansPredictions$prediction)
print(a)
