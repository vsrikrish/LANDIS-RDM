library(readr)
library(ggplot2)
library(reshape2)

# read in data
dat_all <- read_csv('data/RDM_Summary_06109.csv')

# specify metrics (first is x axis, second is y axis)
metrics <- c('Oak_Shelterwood', 'C_stocks')

# subset data
dat_sub <- dat_all[(dat_all$Parameter %in% metrics) & (dat_all$Climate_Scenario != 'Historical'), ]
# specify labels for plotting based on metrics
units <- unique(as.character(dat_all[(dat_all$Parameter %in% metrics) & (dat_all$Climate_Scenario != 'Historical'), 'Units', drop=TRUE]))
labels <- paste(paste(metrics, '(', sep=' '), paste(units, ')', sep=''), sep='')

# cast data into more amenable shape for plotting
dat_cast <- dcast(dat_sub, Climate_GCM + Management_Scenario ~ Parameter, value.var = 'Metric')

# plot
plot_fname <- paste0('landis-tradeoff-', paste(metrics, collapse='-'), '.pdf')
pdf(file.path('figures', plot_fname), height=6, width=8)
ggplot(dat_cast) +
  geom_point(aes_string(x=metrics[1], y=metrics[2], color='Management_Scenario', shape='Climate_GCM'), size=3) +
  scale_x_continuous(labels[1]) +
  scale_y_continuous(labels[2]) +
  scale_color_brewer('Management Scenario', palette='Dark2') +
  scale_shape_discrete('Climate Projection') +
  theme_bw(base_size=18) +
  theme(panel.grid.major=element_blank(), panel.grid.minor=element_blank(), legend.position='bottom', legend.box='vertical') +
  guides(shape=guide_legend(nrow=2, byrow=TRUE))
dev.off()
