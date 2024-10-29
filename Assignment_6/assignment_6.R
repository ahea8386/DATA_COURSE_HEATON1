#Assignment 6 
library(tidyverse)
library(janitor)
library(skimr)
library(readxl)
library(gganimate)
df <- read_csv("./Data/BioLog_Plate_Data.csv")
View(dfclean)
skim(df)

dfclean <- df %>%
  pivot_longer(starts_with('Hr'),
               names_to = 'Hours',
               values_to = 'Absorbance') %>%
  mutate(Hours = case_when(Hours == 'Hr_24' ~ 24,
                           Hours == 'Hr_48' ~ 48,
                           Hours == 'Hr_144' ~ 144)) %>%
  mutate(Sample_Type = case_when(`Sample ID` == 'Clear_Creek' ~ "Water",
                                 `Sample ID` == 'Soil_1' ~ "Soil",
                                 `Sample ID` == 'Soil_2' ~ "Soil",
                                 `Sample ID` == 'Waste_Water' ~ "Water"))
View(dfclean)
dfclean$Hours <- as.numeric(dfclean$Hours)
unique(dfclean$`Sample ID`)

df_plot <- dfclean %>%
  filter(Dilution == 0.1) %>%
  ggplot(aes(x = Hours, y = Absorbance,
             color = Sample_Type)) +
  geom_smooth(se = F) +
  facet_wrap(~ Substrate)


#to take the mean of the triplicate well
absorbance_values = dfclean %>%
  filter(Substrate == 'Itaconic Acid') %>%
  group_by(`Sample ID`, Rep, Hours, Dilution) %>%
  summarise(absorbance_values = mean(Absorbance, na.rm = TRUE))
View(absorbance_values)

mean_absorbance = absorbance_values %>%
  group_by(`Sample ID`, Hours, Dilution) %>%
  summarise(mean_absorbance = mean(absorbance_values, na.rm = T))
View(mean_absorbance)

animated_plot = mean_absorbance %>%
  ggplot(aes(x = Hours, y = mean_absorbance,
             color = `Sample ID`)) +
  geom_line() +
  facet_wrap('Dilution') +
  labs(x = 'Time in Hours',
       y = 'Mean Absorbance',
       color = 'Type') +
  transition_reveal(Hours)

animate(animated_plot, nframes = 100, fps = 10)