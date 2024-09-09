
## Input parameters

## The following parameters can be adjusted to fine-tune clustering outputs:
##    eps:  radius of an object's neighbourhood
##    minPts:  minimum points in an object's neighbourhood for it to be classified as a core object

## --------------------------------------------------------------------
## Author: Fraser Masterson; Fri Aug 2 15:36:45 2024


require(dbscan)
require(pbapply)

DVBSCAN <- function(data, eps, minPts) {

  # Function to find all neighbors of a point within a given radius 'eps'
  get_neighbours <- function(data, point, eps) {
    distances <- sqrt(rowSums((data - matrix(point, nrow(data), ncol(data), byrow = TRUE)) ^ 2))
    return(which(distances <= eps))
  }

  # Function to check if a point is a core object
  is_core_object <- function(data, point_idx, eps, minPts) {
    neighbours <- get_neighbours(data, data[point_idx, ], eps)
    return(length(neighbours) >= minPts)
  }

  # Function to calculate the density of a point's neighborhood
  calculate_density <- function(data, point_idx, eps) {
    neighbours <- get_neighbours(data, data[point_idx, ], eps)
    return(length(neighbours) / (pi * eps^2))
  }

  n <- nrow(data) 
  labels <- rep(0, n) # Initialize labels to 0 (i.e., unclassified)
  cluster_id <- 0 # Initialize cluster ID counter
  densities <- rep(0, n) # Initialize densities to 0

  # Calculate density for each point in the dataset (progress bar included)
  densities <- pbsapply(1:n, function(i) calculate_density(data, i, eps))

  # Iterate over each point in the dataset to perform clustering with progress bar
  pblapply(1:n, function(i) {
    if (labels[i] == 0) { # If the point is unclassified
      if (is_core_object(data, i, eps, minPts)) { # If the point is a core object
        cluster_id <<- cluster_id + 1 # Start a new cluster (using <<- to modify the outer scope variable)
        labels[i] <<- cluster_id # Assign the cluster ID to the point
        queue <- c(i) # Initialise a queue with this point

        # Expand the cluster using a queue
        while (length(queue) > 0) { # While there are points in the queue
          point_idx <- queue[1] # Get the first point in the queue
          queue <- queue[-1] # Then, remove the first point from the queue

          neighbours <- get_neighbours(data, data[point_idx, ], eps) # Get the neighbours for this point

          for (neighbour_idx in neighbours) { # For each neighbour
            if (labels[neighbour_idx] == 0 || labels[neighbour_idx] == -1) { # If the neighbour is unclassified or noise
              labels[neighbour_idx] <<- cluster_id # Assign the current cluster ID to the neighbour
              if (is_core_object(data, neighbour_idx, eps, minPts)) { 
                queue <- c(queue, neighbour_idx) # Add it to the queue for further expansion
              } 
            }
          } 
        } 
      } else {
        labels[i] <<- -1 # Mark as noise if not a core object
      }
    }
  })

  return(labels)
}

# Ram, A., Jalal, S., Jalal, A.S. and Kumar, M., 2010. A density based algorithm for discovering density varied clusters in large spatial databases. International Journal of Computer Applications, 3(6), pp.1-4.
