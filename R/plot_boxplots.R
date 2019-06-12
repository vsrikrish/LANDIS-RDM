library(readr)
library(ggplot2)

# read in data
dat_all <- read_csv('data/RDM_Summary_06109.csv')

units <- as.character(dat_all[dat_all$Climate_Scenario != 'Historical'), 'Units', drop=TRUE])
labels <- paste(paste(metrics, '(', sep=' '), paste(units, ')', sep=''), sep='')

# plot
plot_fname <- 'landis-boxplot-all.pdf'
pdf(file.path('figures', plot_fname), height=6, width=8)
ggplot(dat_all) +
  geom_boxplot(aes(x=Management_Scenario, y=Metric)) +
  facet_wrap(vars(Parameter), scale='free') +
  scale_x_discrete('Harvest Scenario', labels=c('BAU', 'Less', 'More')) +
  theme_bw(base_size=14) +
  theme(panel.grid.major=element_blank(), panel.grid.minor=element_blank())
dev.off()
