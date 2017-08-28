#install.packages("faraway")
#install.packages("sparklyr")
#install.packages("party")
#*****note required******
library(sparklyr)
spark_install(version = "1.6.2")
sc <- spark_connect(master = "local")
#************************
library(faraway)
library(shiny)
library(dplyr)
library(randomForest)
library(party)
data("mtcars")


#predictions <- predict(model, ex)

#select(predictions, hotel_cluster, prediction)


#if (nchar(Sys.getenv("SPARK_HOME")) < 1) {
  #Sys.setenv(SPARK_HOME = "/home/sathya/BigData/spark-1.6.1-bin-hadoop1")
#}
#library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))
##sparkR.session(master = "local[*]", sparkConfig = list(spark.driver.memory = "2g"))
#sc <- sparkR.init(master = "local[*]", sparkEnvir = list(spark.driver.memory = "5g"))
#sqlContext <- sparkRSQL.init(sc)


expedia <- read.csv(file="sampled_train.csv",head=TRUE,sep=",")
expedia$date_time <- NULL
#expedia_df <- createDataFrame(sqlContext, expedia)
#printSchema(expedia_df)
#SparkR::head(expedia_df)

expedia$hotel_cluster <- as.factor(expedia$hotel_cluster)


ex <- copy_to(sc, expedia, overwrite = TRUE)

ml_formula <- formula(hotel_cluster~ site_name+ posa_continent+user_location_country+is_booking)

(model <- ml_random_forest(ex, ml_formula))


#spark_model <- glm(expedia_df, hotel_cluster ~ is_booking+site_name+posa_continent+user_location_country, maxIter = 10, regParam = 0.3, elasticNetParam = 0.8)
###model <- randomForest(hotel_cluster ~ site_name + posa_continent + user_location_country + is_booking, data = expedia,  ntree=5, keep.forest=FALSE, importance=TRUE)

#model <- spark.randomForest(expedia_df, hotel_cluster ~ site_name + posa_continent + user_location_country + is_booking, type = "regression", maxDepth = 5, maxBins = 16)

mpgPredict <- function(site_name, posa_continent, user_location_country, is_booking)
{
    test <- data.frame(site_name, posa_continent, user_location_country,is_booking)
    ex1 <- copy_to(sc,test , overwrite = TRUE)
    predict(model, ex1)[1]
}
  
shinyServer(
  function(input, output){
    output$site_name <- renderPrint({input$site_name})
    output$posa_continent <- renderPrint({input$posa_continent})
    output$user_location_country <- renderPrint({input$user_location_country})
    output$is_booking <- renderPrint({input$is_booking})
    output$prediction <- renderPrint({mpgPredict(as.numeric(input$site_name), 
                                                 input$posa_continent, input$user_location_country,
                                                 input$is_booking)})
    #pred <- mpgPredict(as.numeric(input$site_name), input$posa_continent, input$user_location_country,input$is_booking)
    #maxclass -> which.max(pred)
    #output$prediction <- renderPrint({maxclass})
  }
)