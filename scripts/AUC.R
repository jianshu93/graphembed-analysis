#############################################
# 1) Install/load plotly
#############################################
# install.packages("plotly")  # Uncomment if needed
library(plotly)

#############################################
# 2) Read your data
#############################################
# Assume your file is "Dblb_sketch_AUC.txt", tab-separated:
df <- read.table("Dblb_sketch_AUC.txt",
                 header = TRUE,
                 row.names = 1,   # Remove if no actual row indices
                 sep = "\t")

# We expect columns: hop, decay, AUC
# head(df)

#############################################
# 3) Build z-matrix: AUC for each (decay, hop)
#############################################
decay_vals <- sort(unique(df$decay))
hop_vals   <- sort(unique(df$hop))

nx <- length(decay_vals)
ny <- length(hop_vals)

zvals <- matrix(NA, nrow = nx, ncol = ny)

for (i in seq_along(decay_vals)) {
  sub_decay <- df[df$decay == decay_vals[i], ]
  for (j in seq_along(hop_vals)) {
    val <- sub_decay$AUC[sub_decay$hop == hop_vals[j]]
    if (length(val) == 1) {
      zvals[i, j] <- val
    } else {
      zvals[i, j] <- NA
    }
  }
}

#############################################
# 4) Define color scale (blue -> yellow),
#    clamp range to [0.6, 1.0]
#############################################
my_colorscale <- list(
  list(0, "blue"),
  list(1, "yellow")
)
# If AUC < 0.6 => same color as 0.6 (blue)
# If AUC > 1.0 => same color as 1.0 (yellow)

#############################################
# 5) Axis tick setup
#    (A) X-axis: log scale
#        - Major ticks at a few decades
#        - Minor lines at every data point
#############################################
# Define "major" ticks for decay in log scale
major_x <- c(0.01, 0.1, 0.5, 1, 10)

# Combine with all data points => full set of tick positions
x_tickvals <- sort(unique(c(major_x, decay_vals)))

# Build labels: show text if it's in major_x, else ""
x_ticktext <- sapply(x_tickvals, function(xv) {
  if (xv %in% major_x) as.character(xv) else ""
})

#############################################
# 6) Y-axis ticks
#    - We'll treat all integer hops from your data as "major"
#    - Minor lines if there are any non-integer hops
#############################################
major_y <- sort(unique(df$hop))  # assume all are major
y_tickvals <- sort(unique(c(major_y, hop_vals)))
y_ticktext <- sapply(y_tickvals, function(yv) {
  # Label if in major_y, else ""
  if (yv %in% major_y) as.character(yv) else ""
})

#############################################
# 7) Z-axis ticks
#    - We'll pick major ticks at 0.6, 0.7, 0.8, 0.9, 1.0
#    - Also add any actual data points for completeness
#############################################
major_z <- c(0.6, 0.7, 0.8, 0.9, 1.0)
# Collect all AUC data (clamp them to [0.6,1.0] if you prefer).
all_z <- sort(unique(c(zvals)))
z_tickvals <- sort(unique(c(major_z, all_z)))

# Label only the major ones
z_ticktext <- sapply(z_tickvals, function(zv) {
  if (zv %in% major_z) sprintf("%.2f", zv) else ""
})

#############################################
# 8) Create the 3D Plotly surface
#    - Axis lines in solid black
#    - Tickmode=array => custom ticks
#    - showgrid=TRUE => draws lines at each tick
#    - linecolor="black", linewidth=2 => solid black edges
#    - Helvetica black font everywhere
#############################################
fig <- plot_ly(
  x = decay_vals,
  y = hop_vals,
  z = zvals,
  type = "surface",
  colorscale = my_colorscale,
  cmin = 0.6,
  cmax = 1.0
) %>%
  layout(
    # Global font: black Helvetica
    font = list(family = "Helvetica", color = "black"),
    
    title = "3D Surface: AUC vs. Decay (log) vs. Hop",
    
    scene = list(
      xaxis = list(
        title       = "Decay (log)",
        type        = "log",
        tickmode    = "array",
        tickvals    = x_tickvals,
        ticktext    = x_ticktext,
        showgrid    = TRUE,           # draw grid lines
        showline    = TRUE,           # draw axis line
        linecolor   = "black",
        linewidth   = 2,
        mirror      = TRUE            # axis line on "both sides"
      ),
      yaxis = list(
        title       = "Hop",
        tickmode    = "array",
        tickvals    = y_tickvals,
        ticktext    = y_ticktext,
        showgrid    = TRUE,
        showline    = TRUE,
        linecolor   = "black",
        linewidth   = 2,
        mirror      = TRUE
      ),
      zaxis = list(
        title       = "AUC",
        tickmode    = "array",
        tickvals    = z_tickvals,
        ticktext    = z_ticktext,
        showgrid    = TRUE,
        showline    = TRUE,
        linecolor   = "black",
        linewidth   = 2,
        mirror      = TRUE
      )
    )
  )

# Show the interactive figure
fig
