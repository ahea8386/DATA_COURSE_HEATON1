library(tidyverse)
library(dplyr)
library(stringr)
library(easystats)

unicefdf <- read.csv('unicef-u5mr.csv')
View(unicefdf)
View(clean_df)

#cleaned data
clean_df <- unicefdf %>%
  pivot_longer(starts_with('U5MR'),
               names_to = 'Years',
               values_to = 'Mortality_Rate') %>%
  transform(Years=str_replace(Years,"U5MR.",""))

#plot U5MR over time (line plot facet by continent)

clean_df$Years <- as.numeric(clean_df$Years)

df_plot <- clean_df %>%
  filter(!is.na(Mortality_Rate)) %>%
  ggplot(aes(x = Years, y = Mortality_Rate)) +
  geom_path() +
  facet_wrap(~ Continent)

ggsave("HEATON_Plot_1.png")


# to make second plot need mean of U5MR for continent

#NEED TO SAVE AND CLEAN A LITTLE

mortality_mean = clean_df %>%
  filter(!is.na(Mortality_Rate)) %>%
  group_by(Continent, Years) %>%
  summarise(mortality_mean = mean(Mortality_Rate, na.rm = TRUE))
View(mortality_mean)


df_plot_2 <- mortality_mean %>%
  ggplot(aes(x = Years, y = mortality_mean, color = Continent)) +
  geom_path(size = 1.5) +
  theme_minimal()
ggsave("HEATON_Plot_2.png")

#models
mod1 <- glm(data = clean_df,
            formula = Mortality_Rate ~ Years)
mod2 <- glm(data = clean_df,
            formula = Mortality_Rate ~ Years + Continent)
mod3 <- glm(data = clean_df,
            formula = Mortality_Rate ~ Years * Continent)
summary(mod3)
report(mod3)
compare_performance(mod1, mod2, mod3) %>% plot()

# I would choose mod 3 since when it is compared against the 
#other two models it has the best R2 value and is the best

# to make the plot with all three models
View(mod1)
  
clean_df$mod1 <- predict(mod1, clean_df)
clean_df$mod2 <- predict(mod2, clean_df)
clean_df$mod3 <- predict(mod3, clean_df)

clean_df_3 <- clean_df %>%
  pivot_longer(starts_with('mod'))

View(clean_df_4)

clean_df_4 <- clean_df_3 %>%
  rename(Predicted_U5MR = value)

clean_df_4 %>%
  ggplot(aes(x = Years, y = Predicted_U5MR, color = Continent)) +
  geom_line() +
  facet_wrap(~ name) +
  labs(title = 'Model_Predictions',
       x = 'Year',
       y = 'Predicted _U5MR')



