library(tidyverse)
library(janitor)
df <- read.csv('./FacultySalaries_1995.csv')
View(df)
cleandf <- df %>%
  pivot_longer(ends_with('Salary'),
             names_to = 'Rank',
             values_to = 'Salary') %>%
  transform(Rank=str_replace(Rank,"Avg","")) %>%
  transform(Rank=str_replace(Rank,"ProfSalary",""))

View(cleandf)
cleandf %>%
  filter(Tier != "VIIB") %>%
  ggplot(aes(x = Rank, y = Salary, fill = Rank)) +
  geom_boxplot() +
  facet_grid(~ Tier) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle =45))


aov <- cleandf %>% 
  aov(data = .,
      formula = Salary ~ State + Tier + Rank)
summary(aov)

oil_df <- read.csv('./Juniper_Oils.csv')
View(oil_df)
clean_names(oil_df)

names(oil_df) <- gsub("\\.", "-", names(oil_df))
names(oil_df)

new_df <- oil_df %>%
  pivot_longer(cols = c("alpha-pinene","para-cymene","alpha-terpineol","cedr-9-ene",
                        "alpha-cedrene","beta-cedrene","cis-thujopsene","alpha-himachalene","beta-chamigrene",
                        "cuparene","compound-1","alpha-chamigrene","widdrol","cedrol","beta-acorenol","alpha-acorenol",
                        "gamma-eudesmol","beta-eudesmol","alpha-eudesmol","cedr-8-en-13-ol","cedr-8-en-15-ol","compound-2","thujopsenal"),
               names_to = 'ChemicalID',
               values_to = 'Concentration')
View(new_df)

new_df %>%
  ggplot(aes(x = YearsSinceBurn, y = Concentration)) +
  geom_smooth() +
  facet_wrap(~ ChemicalID, scales = "free_y") +
  theme_minimal() 

mod1 <- glm(data = new_df,
            formula = Concentration ~ YearsSinceBurn * ChemicalID)
summary(mod1)

broom::tidy(mod1) %>%
  filter(p.value < 0.05)
