
#read in data
religions <- read.csv('./Utah_Religions_by_County.csv')

View(religions)

library(tidyverse)
library(ggplot2)

religions %>%
  ggplot(aes(x = Pop_2010, y = Religious)) +
  geom_point() +
  labs(title = '% Religious by Population',
       x = 'Population size',
       y = '%_Religious') + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
#this plot shows that the counties in Utah are very religious 
#regardless of the size of the county.
#the population size of a county does not have an affect on % of population being religious
religions %>%
  ggplot(aes(x = Pop_2010, y = LDS)) +
  geom_point() +
  labs(title = '% LDS by Population size',
       x = 'Population size',
       y = '%_LDS') + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
#1
#when exploring population size effect % active in different religions
#there does not seem to be a correlation
religions %>%
  ggplot(aes(x = Non.Religious, y = LDS)) +
  geom_point() +
  labs(x = '% of a county not-religious',
       y = '%_LDS') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
#2
#There is a correlation between the % of a county being LDS
#and the percentage of people being non-religious
#as the percentage of people in a county being lds increases
#the percentage of people who are not religous decreases