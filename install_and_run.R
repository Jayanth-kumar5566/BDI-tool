# Install and Run BDI Calculator Shiny App
# Run this script in RStudio or R console to install required packages and launch the app

# Function to check and install packages
install_if_missing <- function(packages) {
  new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
  if(length(new_packages)) {
    cat("Installing missing packages:", paste(new_packages, collapse = ", "), "\n")
    install.packages(new_packages, dependencies = TRUE)
  } else {
    cat("All required packages are already installed.\n")
  }
}

# Required packages
required_packages <- c("shiny", "DT", "shinythemes")

# Install missing packages
install_if_missing(required_packages)

# Load packages
cat("Loading packages...\n")
library(shiny)
library(DT)
library(shinythemes)

# Launch the app
cat("Launching BDI Calculator Shiny App...\n")
cat("Server accessible at: http://0.0.0.0:3939\n")
runApp("app.R", host = "0.0.0.0", port = 3939, launch.browser = FALSE)
