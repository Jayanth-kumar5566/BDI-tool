# BDI Calculator - R Shiny GUI Instructions

## Overview
This R Shiny application provides a graphical user interface (GUI) for the BDI Calculator CLI tool.

## Prerequisites
- R (version 4.0 or higher recommended)
- RStudio (optional, but recommended)

## Installation

### Option 1: Automatic Installation (Recommended)
Open R or RStudio and run:
```r
source("install_and_run.R")
```

This script will:
1. Check for required packages
2. Install any missing packages
3. Launch the Shiny app automatically

### Option 2: Manual Installation
If you prefer to install packages manually:

```r
install.packages(c("shiny", "DT", "shinythemes"))
```

Then run the app:
```r
library(shiny)
runApp("app.R")
```

## Using the Application

### Step 1: Launch the App
- If using the automatic script, the app will open in your browser automatically
- If running manually, navigate to the URL shown in your R console (typically http://127.0.0.1:XXXX)

### Step 2: Upload Your Data
1. Click "Browse" to select your microbiome data file
2. Supported formats: `.txt`, `.csv`, `.tsv`
3. Select the appropriate field separator:
   - **Tab** (default for .txt and .tsv files)
   - **Comma** (for .csv files)
   - **Space** (for space-delimited files)

### Step 3: Preview Your Data (Optional)
- Click the "Input Preview" tab to view the first 10 rows of your uploaded file
- Verify that the data is being parsed correctly

### Step 4: Calculate BDI
1. Return to the "Results" tab
2. Click the "Calculate BDI" button
3. Wait for the calculation to complete (progress bar will be shown)

### Step 5: View and Download Results
- Results will be displayed in a table showing:
  - Sample ID
  - BDI Value (rounded to 6 decimal places)
- Click "Download Results" to save the results as a tab-separated text file

## Features

### Main Panel Tabs
1. **Results**: Displays calculated BDI values for all samples
2. **Input Preview**: Shows the first 10 rows of your uploaded data
3. **Help**: Detailed instructions and contact information

### Additional Features
- Sortable and searchable results table
- Pagination for large datasets
- Progress indicators during calculation
- Error notifications if something goes wrong
- Automatic formatting of BDI values

## Input File Requirements

Your input file should contain:
- **Rows**: Taxonomic abundance at species level (counts or relative abundance)
- **Columns**: Sample names/IDs
- **First column**: Species names (auto-detected format)

### Example Format (Tab-separated):
```
#NAME    sample_001    sample_002    sample_003
species_1    0.123    0.456    0.789
species_2    0.234    0.567    0.890
```

## Troubleshooting

### Binary Not Found Error
If you see "Error: Binary not found", ensure:
- The `Compiled-binaries` folder exists in the same directory as `app.R`
- The binary `bdi_calculator-aarch64-apple-darwin` is present
- You have execute permissions on the binary

### macOS Security Warning
If macOS blocks the binary:
```bash
sudo xattr -d com.apple.quarantine Compiled-binaries/bdi_calculator-aarch64-apple-darwin
```

### Package Installation Issues
If automatic installation fails, try installing packages individually:
```r
install.packages("shiny")
install.packages("DT")
install.packages("shinythemes")
```

### App Won't Launch
- Ensure you're in the correct directory (where `app.R` is located)
- Check that all required packages are installed
- Try restarting R/RStudio

## Quick Start Example

To test with the provided example file:

1. Launch the app:
   ```r
   source("install_and_run.R")
   ```

2. Upload `example.txt` from the app interface

3. Keep "Tab" as the separator (default)

4. Click "Calculate BDI"

5. View results and download if needed

## Advanced Usage

### Running on a Custom Port
```r
library(shiny)
runApp("app.R", port = 8080)
```

### Running in Showcase Mode (for development)
```r
library(shiny)
runApp("app.R", display.mode = "showcase")
```

## Contact

For questions or issues, please contact:
**Jayanth Kumar Narayana**
Email: contact@jayanthinmathmedicine.com

## License

[Same as BDI Calculator CLI tool]
