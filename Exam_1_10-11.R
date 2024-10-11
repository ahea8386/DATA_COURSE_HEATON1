#read the covid data into a data frame
df <- read.csv('cleaned_covid_data.csv')
library(tidyverse)
library(ggplot2)
library(dplyr)
View(df)

#subset the data to just show states beginning with A
A_states <- df %>%
  filter(grepl("^A", Province_State))
View(A_states)

#create a plot of A_states showing Deaths over time with seperate facet for state

A_states$Last_Update <- as.Date(A_states$Last_Update)
str(A_states)

A_states %>%
  ggplot(mapping = aes(x = Last_Update,
                       y = Deaths)) +
  geom_point(size = 1, alpha = 0.4) +
  facet_wrap(~Province_State, scales = "free") + 
  geom_smooth(method = "loess", se = FALSE, color = 'blue')

#find max case fatality ratio for each state and save in df
#needs two columns prostate and fatality ratio
#descending order for max fatality ratio
state_max_fatality_rate <- df %>%
  group_by(Province_State) %>%
  summarize(Maximum_Fatality_Ratio = max(Case_Fatality_Ratio, na.rm = TRUE)) %>%
  arrange(desc(Maximum_Fatality_Ratio))
View(state_max_fatality_rate)

# Use df from previous question to create a plot
state_max_fatality_rate %>%
  mutate(Province_State = reorder(Province_State, -Maximum_Fatality_Ratio)) %>%
  ggplot(mapping = aes(x = Province_State,
                       y = Maximum_Fatality_Ratio)) +
  geom_col() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) 

#Extra credit- plot cumulative deaths for entire us over time
cum_deaths <- df %>%
  group_by(Last_Update) %>%
  summarise(cum_death = sum(Deaths))
View(cum_deaths)

cum_deaths %>%
  ggplot(aes(x = Last_Update,
             y = cum_death)) +
  geom_point() +
  labs(x = 'Time',
       y = 'Deaths in the US')