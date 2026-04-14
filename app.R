library(shiny)
library(DT)
library(shinythemes)

# Set maximum upload size to 100MB
options(shiny.maxRequestSize = 100 * 1024^2)

# Define UI
ui <- fluidPage(
  theme = shinytheme("flatly"),

  titlePanel("BDI Calculator - Microbiome Analysis Tool"),

  sidebarLayout(
    sidebarPanel(
      h4("Upload Data"),
      fileInput("inputFile",
                "Choose Input File",
                accept = c(".txt", ".csv", ".tsv")),

      selectInput("separator",
                  "Field Separator:",
                  choices = list("Tab" = "\t",
                                 "Comma" = ",",
                                 "Space" = " "),
                  selected = "\t"),

      hr(),

      actionButton("calculate",
                   "Calculate BDI",
                   class = "btn-primary btn-lg btn-block",
                   icon = icon("calculator")),

      hr(),

      conditionalPanel(
        condition = "output.resultsAvailable",
        downloadButton("downloadResults",
                       "Download Results",
                       class = "btn-success btn-block")
      ),

      hr(),

      h5("About"),
      p("This tool calculates BDI (Bronchiectasis Dysbiosis Index) values for microbiome data."),
      p("Upload a file containing species abundance data with samples as columns."),

      h5("Input Format:"),
      tags$ul(
        tags$li("Rows: Taxonomic abundance (species level)"),
        tags$li("Columns: Sample names"),
        tags$li("First column: Species names")
      )
    ),

    mainPanel(
      tabsetPanel(
        tabPanel("Results",
                 br(),
                 uiOutput("statusMessage"),
                 br(),
                 DTOutput("resultsTable")),

        tabPanel("Input Preview",
                 br(),
                 h4("First 10 rows of uploaded file:"),
                 DTOutput("inputPreview")),

        tabPanel("Help",
                 br(),
                 h4("How to Use"),
                 tags$ol(
                   tags$li("Upload your microbiome data file (tab-separated, comma-separated, or space-separated)"),
                   tags$li("Select the appropriate field separator"),
                   tags$li("Preview your data in the 'Input Preview' tab (optional)"),
                   tags$li("Click 'Calculate BDI' to run the analysis"),
                   tags$li("View results in the 'Results' tab"),
                   tags$li("Download results using the 'Download Results' button")
                 ),
                 hr(),
                 h4("Example Output Format"),
                 verbatimTextOutput("exampleOutput"),
                 hr(),
                 h4("Contact"),
                 p("For questions or issues, please contact:"),
                 p(strong("Jayanth Kumar Narayana"), br(),
                   "Email: contact@jayanthinmathmedicine.com")
        )
      )
    )
  )
)

# Define server logic
server <- function(input, output, session) {

  # Reactive values to store results
  results <- reactiveVal(NULL)
  inputData <- reactiveVal(NULL)

  # Read and preview input file
  observeEvent(input$inputFile, {
    req(input$inputFile)

    tryCatch({
      # Read the uploaded file for preview
      sep_char <- switch(input$separator,
                         "\t" = "\t",
                         "," = ",",
                         " " = " ")

      data <- read.table(input$inputFile$datapath,
                         header = TRUE,
                         sep = sep_char,
                         check.names = FALSE,
                         comment.char = "",
                         quote = "",
                         nrows = 10)

      inputData(data)
    }, error = function(e) {
      showNotification(paste("Error reading file:", e$message),
                       type = "error",
                       duration = 5)
    })
  })

  # Display input preview
  output$inputPreview <- renderDT({
    req(inputData())
    datatable(inputData(),
              options = list(scrollX = TRUE, pageLength = 10),
              rownames = FALSE)
  })

  # Calculate BDI
  observeEvent(input$calculate, {
    req(input$inputFile)

    # Show progress
    withProgress(message = 'Calculating BDI...', value = 0, {

      # Determine the binary path based on platform
      platform <- Sys.info()["sysname"]

      binary_name <- if (platform == "Darwin") {
        "bdi_calculator-aarch64-apple-darwin"
      } else if (platform == "Linux") {
        "bdi_calculator-x86_64-unknown-linux-musl"
      } else {
        showNotification(paste("Unsupported platform:", platform),
                         type = "error",
                         duration = 10)
        return(NULL)
      }

      binary_path <- file.path(getwd(), "Compiled-binaries", binary_name)

      # Check if binary exists
      if (!file.exists(binary_path)) {
        showNotification("Error: Binary not found. Please ensure the compiled binary exists.",
                         type = "error",
                         duration = 10)
        return(NULL)
      }

      # Make sure binary is executable
      system(paste("chmod +x", shQuote(binary_path)))

      incProgress(0.3, detail = "Running BDI calculator...")

      # Prepare separator for command line
      sep_arg <- input$separator
      if (sep_arg == "\t") {
        sep_arg <- "'\\t'"
      } else {
        sep_arg <- paste0("'", sep_arg, "'")
      }

      # Build command
      cmd <- sprintf("%s --input %s --sep %s",
                     shQuote(binary_path),
                     shQuote(input$inputFile$datapath),
                     sep_arg)

      incProgress(0.5, detail = "Processing data...")

      # Run the command
      tryCatch({
        output_raw <- system(cmd, intern = TRUE)

        incProgress(0.8, detail = "Parsing results...")

        # Parse output
        if (length(output_raw) > 0) {
          # Split each line into sample_id and bdi_value
          parsed <- strsplit(output_raw, "\\s+")
          result_df <- data.frame(
            Sample_ID = sapply(parsed, `[`, 1),
            BDI_Value = as.numeric(sapply(parsed, `[`, 2)),
            stringsAsFactors = FALSE
          )

          results(result_df)

          showNotification("BDI calculation completed successfully!",
                           type = "message",
                           duration = 3)
        } else {
          showNotification("No output received from calculator.",
                           type = "warning",
                           duration = 5)
        }

        incProgress(1, detail = "Done!")

      }, error = function(e) {
        showNotification(paste("Error running calculator:", e$message),
                         type = "error",
                         duration = 10)
      })
    })
  })

  # Display results
  output$resultsTable <- renderDT({
    req(results())
    datatable(results(),
              options = list(pageLength = 25, scrollX = TRUE),
              rownames = FALSE) %>%
      formatRound('BDI_Value', digits = 6)
  })

  # Status message
  output$statusMessage <- renderUI({
    if (is.null(results())) {
      div(class = "alert alert-info",
          icon("info-circle"),
          " Upload a file and click 'Calculate BDI' to see results.")
    } else {
      div(class = "alert alert-success",
          icon("check-circle"),
          sprintf(" Analysis complete! %d samples processed.", nrow(results())))
    }
  })

  # Check if results are available
  output$resultsAvailable <- reactive({
    !is.null(results())
  })
  outputOptions(output, "resultsAvailable", suspendWhenHidden = FALSE)

  # Download handler
  output$downloadResults <- downloadHandler(
    filename = function() {
      paste0("bdi_results_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".txt")
    },
    content = function(file) {
      req(results())
      write.table(results(), file,
                  row.names = FALSE,
                  col.names = TRUE,
                  sep = "\t",
                  quote = FALSE)
    }
  )

  # Example output for help tab
  output$exampleOutput <- renderText({
    "sample_001 0.234567
sample_002 0.456789
sample_003 0.123456"
  })
}

# Run the application
shinyApp(ui = ui, server = server)
