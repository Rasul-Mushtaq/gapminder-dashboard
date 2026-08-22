library(shiny)
library(bslib)
library(dplyr)
library(ggplot2)
library(gapminder)
library(plotly)
library(DT)

# User Interface
ui <- page_sidebar(
  theme = bs_theme(bootswatch = "darkly"),
  title = "Global Economic & Public Health Explorer",
  sidebar = sidebar(
    title = "Dashboard Controls",
    selectInput(
      inputId = "continent",
      label = "Select Continent:",
      choices = c("All", levels(gapminder$continent)),
      selected = "All"
    ),
    sliderInput(
      inputId = "year",
      label = "Select Year:",
      min = min(gapminder$year),
      max = max(gapminder$year),
      value = max(gapminder$year),
      step = 5,
      sep = ""
    ),
    checkboxInput(
      inputId = "log_scale",
      label = "Logarithmic Scale for GDP",
      value = TRUE
    )
  ),
  layout_columns(
    card(
      card_header("Wealth vs. Life Expectancy (Hover over points)"),
      plotlyOutput(outputId = "scatter_plot")
    ),
    card(
      card_header("Life Expectancy Distribution"),
      plotlyOutput(outputId = "box_plot")
    )
  ),
  card(
    card_header("Top 10 Most Populous Nations in Selected Year"),
    DTOutput(outputId = "top_countries_table")
  )
)

# Server Logic
server <- function(input, output, session) {
  
  # Reactive dataset filtered by user inputs
  filtered_data <- reactive({
    df <- gapminder %>% filter(year == input$year)
    if (input$continent != "All") {
      df <- df %>% filter(continent == input$continent)
    }
    df
  })
  
  # Render Interactive Plotly Scatter Plot
  output$scatter_plot <- renderPlotly({
    p <- ggplot(
      filtered_data(), 
      aes(
        x = gdpPercap, 
        y = lifeExp, 
        size = pop / 1e6, 
        color = continent,
        text = paste0(
          "<b>Country:</b> ", country, "<br>",
          "<b>Life Expectancy:</b> ", round(lifeExp, 1), " yrs<br>",
          "<b>GDP per Capita:</b> $", round(gdpPercap, 0), "<br>",
          "<b>Population:</b> ", round(pop / 1e6, 2), "M"
        )
      )
    ) +
      geom_point(alpha = 0.7) +
      scale_size_continuous(name = "Pop. (M)", range = c(3, 10)) +
      labs(x = "GDP per Capita ($)", y = "Life Expectancy (Years)", color = "Continent") +
      theme_minimal(base_size = 12)
    
    if (input$log_scale) {
      p <- p + scale_x_log10()
    }
    
    ggplotly(p, tooltip = "text")
  })
  
  # Render Interactive Plotly Box Plot
  output$box_plot <- renderPlotly({
    p <- ggplot(filtered_data(), aes(x = continent, y = lifeExp, fill = continent)) +
      geom_boxplot(alpha = 0.6, show.legend = FALSE) +
      labs(x = "Continent", y = "Life Expectancy (Years)") +
      theme_minimal(base_size = 12)
    
    ggplotly(p)
  })
  
  # Render Interactive DT Data Table
  output$top_countries_table <- renderDT({
    filtered_data() %>%
      arrange(desc(pop)) %>%
      slice_head(n = 10) %>%
      transmute(
        Country = country,
        Continent = continent,
        `Population (M)` = round(pop / 1e6, 2),
        `Life Expectancy (Yrs)` = round(lifeExp, 1),
        `GDP per Capita ($)` = round(gdpPercap, 0)
      ) %>%
      datatable(
        options = list(pageLength = 10, dom = 't', ordering = TRUE),
        rownames = FALSE
      )
  })
}

# Run Application
shinyApp(ui = ui, server = server)
