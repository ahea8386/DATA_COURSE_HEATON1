
penguins %>%
  ggplot(mapping = aes(x = body_mass_g,
                       y = bill_depth_mm,
                       color = species,
                       shape = island)) +
  geom_point(size = 15, alpha = 0.8) +
  labs(title = 'UglY PloT',
       x = 'BODY MASS',
       y = 'bill    depth') +
  scale_color_manual(values = c('orange', 'red', 'brown2')) +
  scale_shape_manual(values = c(8, 17, 18)) +
  theme(axis.text.x = element_text(angle = 180, hjust = 1, color = 'red')) +
  theme(axis.text.y = element_text(angle = 270, hjust = 1, color = 'darkred')) +
  theme(axis.title.x = element_text(color = 'green', angle = 180, size = 13),
        axis.title.y = element_text(color = 'brown4', angle = 180, size = 6),
        legend.position = "bottom",
        panel.background = element_rect(fill = 'green', color = 'purple'),
        panel.grid.major = element_line(color = "magenta", size = 2),
        panel.grid.minor = element_line(color = 'brown2', linetype = "dashed"),
        plot.title = element_text(hjust = 0.5, size = 17, color = 'yellow', face = 'bold')
  )



