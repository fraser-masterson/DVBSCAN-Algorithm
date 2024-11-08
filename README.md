# Density Variation Based Spatial Clustering of Applications with Noise (R)

This function isolates spatial data hotspots using the dvb-scan (Density Variation Based Spatial Clustering of Applications with Noise) algorithm (Ram et al. 2015).
The original use of this function was to identify fishing pings in scallop VMS data following speed threshold filtering.

## Models and Data

This function returns the object 'labels', where a value of -1 indicates noise, and anything above is a cluster grouping.
 - 'labels' should be integrated into data before plotting; e.g, data$cluster <- labels.

This function also allows for the adjustment of parameters to best fit clusters in different spatial data.

## Prerequisites
- R 4.0 or higher

# Using the DVBSCAN Algorithm

1. Filter spatial data using preferred variable thresholds (in my case, speed and turn-rate were filtered).
2. Convert x and y values in your dataset into a matrix:
```{r}
data_coords = as.matrix(data[,c("x", "y")])
```
3. Adjust the 'eps' and 'minPts' values to fine-tune clustering output. Example:
```{r}
eps = 0.5 # Radius of point's neighbourhood
minPts = 20 # Minimum points required to define a new cluster
```
4. Load the DVBSCAN function.
5. Run the DVBSCAN function on the coordinates matrix, with the output being 'labels':
```{r}
labels = DVBSCAN(data_coords, eps, minPts)
```
6. Assign a cluster column in the original dataset:
```{r}
data$cluster = as.factor(labels)
```
7a. Plot the results, adjusting 'eps' and 'minPts' if necessary:
```{r}
plot(data$x, data$y, col = data$cluster+1)
```
7b. Alternatively, you can create two seperate datasets that represent clustered points and noise
```{r}
datanoise = filter(data, cluster == -1)
datacluster = filter(data, cluster > -1)

plot(datacluster$x, datacluster$y, col = data$cluster)
points(datanoise$x, datanoise$y, col = "lightgrey")
```

# Examples

## 1. Generic spatial data that contains clear density hotspots

![image](https://github.com/user-attachments/assets/13aa498b-e6b9-4d72-8245-8b8a617221fc)

## 2. Spatial data compiled into one dataset and assigned same values

![image](https://github.com/user-attachments/assets/3f4a97d3-b40b-4ba7-a9ea-1497f5dda38a)

## 3. Post-DVBSCAN, high density areas are assigned unique cluster values (remaining points classified as noise)

![image](https://github.com/user-attachments/assets/ea277691-df2c-44bb-b1c9-8f6d15eadb3b)








