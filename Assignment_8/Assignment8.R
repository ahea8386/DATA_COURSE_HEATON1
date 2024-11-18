df <- read.csv('mushroom_growth.csv')
View(df)
library(tidyverse)
library(ggplot2)
library(easystats)
library(modelr)

#some plots exploring the data
df %>%
  ggplot(aes(x = GrowthRate, y = Light)) +
  geom_point() +
  facet_wrap(~ Species)

df %>%
  ggplot(aes(x = GrowthRate, y = Nitrogen)) +
  geom_point() +
  facet_wrap(~ Species)

df %>%
  ggplot(aes(x = Humidity, y = Nitrogen)) +
  geom_point() +
  facet_wrap(~ Species)

#models describing GrowthRate

mod1 <- glm(data = df,
            formula = GrowthRate ~ Species)
mod2 <- glm(data = df,
            formula = GrowthRate ~ Species + Light)
mod3 <- glm(data = df,
            formula = GrowthRate ~ Species * Light)
mod4 <- glm(data = df,
            formula = GrowthRate ~ Species * Nitrogen)

#the smaller, the better
mean(mod1$residuals^2)
mean(mod2$residuals^2)
mean(mod3$residuals^2)
mean(mod4$residuals^2)
#mod3 is the best since it has the smallest mean sq error


#add predictions based on hypothetical values
preddf <- df %>%
  add_predictions(mod3)
preddf %>% dplyr::select("GrowthRate", "pred")

newdf = data.frame(Light = c(2.5,5,7.5,12.5,15,17.5), Species = c('P.cornucopiae'
))
pred = predict(mod3, newdata = newdf)
hyp_preds <- data.frame(Light = newdf$Light,
                        Species = newdf$Species,
                        pred = pred)
preddf$PredictionType <- "real"
hyp_preds$PredictionType <- "hypothetical"
fullpreds <- full_join(preddf, hyp_preds)

#plot for hypothetical values
ggplot(fullpreds,aes(x=Light,y=pred,color=PredictionType)) +
  geom_point() +
  geom_point(aes(y=GrowthRate),color="Black") +
  theme_minimal()

#answers to ?
#1. No all of the values are positive growth rates and 
#looking at the graph they make sense with the data given.

#2. No the relationship between Light and GrowthRate is linear. 
#https://www.geeksforgeeks.org/non-linear-regression-in-r/
#I used the above resource to write the code below. It helps convert
#non linear relationships to something that can be used in R

#3 
install.packages(minpack.lm)
library(minpack.lm)
nonlinear <- read.csv('./Data/non_linear_relationship.csv')

start_values <- c(a=4, b=2)
fit <- nls(y ~ a * exp(b * x),
           start = start_values,
           algorithm = "port",
           control = nls.control(maxiter = 1000))
summary(fit)
