# Density Variation Based Spatial Clustering of Applications with Noise (R)

Isolating spatial data hotspots using the dvb-scan (Density Variation Based Spatial Clustering of Applications with Noise) algorithm (Ram et al. 2015).
Recommended for use after filtering spatial data to avoid cluster overlap.
The original use of this function was to identify fishing pings in scallop VMS data following speed threshold filtering.

This function returns the object 'labels', where a value of -1 indicates noise, and anything above is a cluster grouping.
   'labels' should be integrated into data before plotting; e.g, data$cluster <- labels

Noise can then be removed from the dataset using: data_clusters <- filter(data, cluster > -1)
   alternatively, when plotting, the argument 'col = labels +1' or 'col = data$cluster+1' hides noise from the plot

