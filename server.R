## =============================== License ========================================
## ================================================================================
## This work is distributed under the MIT license, included in the parent directory
## Copyright Owner: University of Oxford
## Date of Authorship: 2016
## Author: Martin John Hadley (orcid.org/0000-0002-3039-6849)
## Academic Contact: Mireia Borrell-Porta (orcid.org/0000-0003-2328-1258)
## Data Source: local file
## ================================================================================

library("plyr")
library("tidyverse")
library("shiny")
library("DT")
library("lubridate")
library("plotly")
library("shinyBS")
library("scales")
library("rfigshare")
library("readxl")
library("forcats")


## =========================== Beautification ===================================
## ==============================================================================

gantt_labeler <-
  function(start_date = NA,
           end_date = NA,
           y_axis = NA,
           color = NA) {
    paste0(
      "Policy Name: ",
      y_axis,
      "</br>",
      "Enforcement Period: ",
      as.Date(start_date),
      " to ",
      as.Date(end_date),
      "</br>",
      "Policy Type: ",
      color
    )
  }

new_lines_to_p_tags <- function(text) {
  gsub(pattern = "\n", replacement = "<br />", text)
}


## =========================== Shiny Server Fn ===================================
## ==============================================================================

source("data-processing.R", local = T)
# source("figshare.R", local = T)
source("long-colnames-replacements.R", local = T)

shinyServer(function(input, output, session) {
  output$timeline_selected_cols_UI <- renderUI({
    selectInput(
      "timeline_selected_cols",
      label = "Columns to show: ",
      choices = long_colnames_replacements,
      selected = initial_columns,
      multiple = TRUE,
      width = "100%"
    )
  })
  
  output$timeline <- renderPlotly({
    timeline_data$type.of.policy <-
      gsub("allowances policy",
           "</br>allowances policy",
           timeline_data$type.of.policy)
    cutoff_timeline_data <- timeline_data
    
    cutoff_timeline_data$valid.from.b[cutoff_timeline_data$valid.from.b < as.Date("1997/01/01")] <-
      as.Date("1997/01/01")
    
    
    policy_separators <- cutoff_timeline_data %>%
      filter(valid.from.b > as.Date("1997/01/01") &
               valid.until.c > as.Date("1997/01/01"))
    
    timeline_ggplot <- ggplot(
      cutoff_timeline_data,
      aes(
        x = valid.from.b,
        xend = valid.until.c,
        y = name.of.policy,
        yend = name.of.policy,
        colour = type.of.policy
      )
    ) +
      geom_segment(
        size = 4,
        aes(
          # x = Valid.from.b. + 60*60*24*10*3,
          # xend = Valid.until.c. - 60*60*24*10*3,
          x = valid.from.b,
          xend = valid.until.c,
          # Draw tooltipped geom_segments over everything, make almost invisible
          y = name.of.policy,
          yend = name.of.policy,
          text = NULL
        )
      )  +
      geom_segment(
        data = policy_separators,
        size = 4,
        aes(
          # x = Valid.from.b. - 60*60*24*10*3,
          # xend = Valid.from.b. + 60*60*24*10*3,
          x = valid.from.b - 18,
          xend = valid.from.b + 18,
          y = name.of.policy,
          yend = name.of.policy,
          text = NULL
        ),
        color = "black"
      ) +
      geom_segment(
        size = 4,
        show.legend = F,
        aes(
          x = valid.from.b,
          xend = valid.until.c,
          y = name.of.policy,
          yend = name.of.policy,
          text = gantt_labeler(
            start_date = valid.from.b,
            end_date = valid.until.c,
            y_axis = name.of.policy,
            color = type.of.policy
          ),
          alpha = 0.001 # Draw tooltipped geom_segments over everything, make almost invisible
        )
      )  +
      scale_x_date(
        breaks = seq(as.Date("1997/01/01"), as.Date(paste0(
          year(max(
            cutoff_timeline_data$valid.until.c
          )) + 1, "-01-01"
        )), "years"),
        labels = date_format("%Y"),
        limits = c(as.Date("1997/01/01"), as.Date(
          max(cutoff_timeline_data$valid.until.c)
        ))
      ) +
      xlab("") + ylab("") + scale_colour_brewer(name = "Type of Policy",
                                                type = "qual",
                                                palette = "Dark2") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1),
            plot.margin = unit(c(0, 0, 1, 1), "cm"))
    
    
    ggplotly(timeline_ggplot, tooltip = "text", source = "timeline")
    
  })
  
  output$timeline_selected_Policy_Table <- DT::renderDataTable({
    event_data <- event_data("plotly_click", source = "timeline")
    
    selected_Policy <-
      levels(timeline_data$name.of.policy)[event_data$y]
    
    data_to_show <-
      timeline_data %>% filter(as.character(name.of.policy) == selected_Policy)
    data_to_show <- data_to_show[, input$timeline_selected_cols]
    
    colnames(data_to_show) <- mapvalues(
      colnames(data_to_show),
      from = long_colnames_replacements %>% as.character(),
      to = long_colnames_replacements %>% names(),
      warn_missing = F
    )
    
    data_to_show
    
  }, extensions = c("FixedHeader", "Buttons"),
  rownames = FALSE,
  escape = FALSE,
  
  class = 'cell-border stripe',
  options = list(
    autoWidth = FALSE,
    scrollX = TRUE,
    paging = FALSE,
    dom = 'Bfrtip',
    buttons = list(
      list(
        extend = "excel",
        text = "Download current view of data",
        filename = "Filtered Policies",
        exportOptions = list(modifier = list(selected = FALSE))
      )
    ),
    defer = TRUE,
    fixedHeader = list(header = TRUE),
    columnDefs = list(list(width = "200px", targets = 0))
    # fixedColumns = list(leftColumns = 2, rightColumns = 1)
  ))
  
  output$plain_datatable_selected_cols_UI <- renderUI({
    selectInput(
      "plain_datatable_selected_cols",
      label = "Columns to show: ",
      choices = long_colnames_replacements,
      multiple = TRUE,
      selected = initial_columns,
      width = "100%"
    )
  })
  
  output$plain_datatable_selected_Policy_Table <-
    DT::renderDataTable({
      data_to_show <- timeline_data[, input$plain_datatable_selected_cols]
      
      colnames(data_to_show) <- mapvalues(
        colnames(data_to_show),
        from = long_colnames_replacements %>% as.character(),
        to = long_colnames_replacements %>% names(),
        warn_missing = F
      )
      
      data_to_show
      
    }, extensions = c("FixedHeader", "Buttons"),
    rownames = FALSE,
    filter = 'top',
    escape = FALSE,
    
    class = 'cell-border stripe',
    options = list(
      autoWidth = FALSE,
      paging = FALSE,
      scrollX = TRUE,
      dom = 'Bfrtip',
      fixedHeader = list(header = TRUE),
      buttons = list(
        list(
          extend = "excel",
          text = "Download current view of data",
          filename = "Filtered Policies",
          exportOptions = list(modifier = list(selected = FALSE))
        )
      ),
      columnDefs = list(list(width = "200px", targets = 0))
      # fixedColumns = list(leftColumns = 2, rightColumns = 1)
    ))
  
  output$timeline_selected_Policy_UI <- renderUI({
    event_data <- event_data("plotly_click", source = "timeline")
    
    if (is.null(event_data)) {
      wellPanel("Select an event in the timeline to view more details about the policy.")
    } else {
      fluidRow(column(
        uiOutput("timeline_selected_cols_UI"),
        bsTooltip(
          "timeline_selected_cols_UI",
          "Add/remove columns to the table by typing/removing names from here",
          "top",
          options = list(container = "body")
        ),
        uiOutput("type_of_details"),
        DT::dataTableOutput("timeline_selected_Policy_Table", width = "100%"),
        width = 12
      ))
      
    }
    
  })
  
  # output$download_spreadsheet <- downloadHandler(
  #   filename = "policies.xlsx",
  #   # desired file name on client
  #   content = function(con) {
  #     file.copy("data/policies.xlsx", con)
  #   }
  # )
  #
})