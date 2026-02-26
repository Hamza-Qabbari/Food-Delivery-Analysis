  #libraries 
  library(shiny)
  library(ggplot2)
  library(rpart)
  library(rpart.plot)
  library(dplyr)
  library(DT)   
  
  #GUI
  ui <- fluidPage(
    
    titlePanel("Food Delivery Service Efficiency Analysis"),
    
    sidebarLayout(
      sidebarPanel(
        h4("Upload & Settings"),
        

        fileInput("file", "Upload delivery data (.csv)", accept = ".csv"),
        
        tags$hr(),
        

        sliderInput("kclusters", "Number of clusters (K-means):",
                    min = 2, max = 10, value = 3),
        
        tags$hr(),
        

        actionButton("runModels", "Run Models")
      ),
      
      mainPanel(
        tabsetPanel(
          

          tabPanel("Data Preview",
                   DTOutput("data_all")
          ),
          

          tabPanel("Visualizations",
                   h4("1) Delivery Time Distribution"),
                   plotOutput("plot_delivery_time"),
                   
                   h4("2) Distance Distribution"),
                   plotOutput("plot_distance"),
                   
                   h4("3) Preparation Time Distribution"),
                   plotOutput("plot_prep"),
                   
                   h4("4) Delivery Time by Vehicle Type"),
                   plotOutput("plot_vehicle"),
                   
                   h4("5) Delivery Time by Traffic Level"),
                   plotOutput("plot_traffic"),
                   
                   h4("6) Delivery Time by Weather"),
                   plotOutput("plot_weather"),
                   
                   h4("7) Distance vs Delivery Time"),
                   plotOutput("plot_dist_vs_time"),
                   
                   h4("8) Preparation Time vs Delivery Time"),
                   plotOutput("plot_prep_vs_time")
          ),
          

          tabPanel("Decision Tree",
                   h4("Decision Tree (Late Delivery)"),
                   plotOutput("tree_plot"),
                   h4("Model Performance"),
                   verbatimTextOutput("tree_metrics")
          ),
          

          tabPanel("K-means Clustering",
                   h4("Clusters Plot"),
                   plotOutput("cluster_plot"),
                   h4("Cluster Summary"),
                   tableOutput("cluster_summary")
          ),
          

          tabPanel("Insights",
                   h4("Key Insights & Recommendations"),
                   verbatimTextOutput("insights_text")
          )
        )
      )
    )
  )
  
  # Server
  server <- function(input, output, session) {
    

    data_reactive <- reactive({
      req(input$file) 
      
      df <- read.csv(input$file$datapath)
      
      df
    })
    

    output$data_all <- renderDT({
      datatable(
        data_reactive(),
        options = list(pageLength = 10, scrollX = TRUE)
      )
    })
    
    #visualizations
    
    # 1) توزيع وقت التوصيل
    output$plot_delivery_time <- renderPlot({
      df <- data_reactive()
      ggplot(df, aes(x = Delivery_Time_min)) +
        geom_histogram(bins = 30, fill = "steelblue", color = "black") +
        labs(x = "Delivery Time (min)", y = "Count",
             title = "Delivery Time Distribution")
    })
    
    # 2) توزيع المسافة
    output$plot_distance <- renderPlot({
      df <- data_reactive()
      ggplot(df, aes(x = Distance_km)) +
        geom_histogram(bins = 30, fill = "darkorange", color = "black") +
        labs(x = "Distance (km)", y = "Count",
             title = "Distance Distribution")
    })
    
    # 3) توزيع وقت التحضير
    output$plot_prep <- renderPlot({
      df <- data_reactive()
      ggplot(df, aes(x = Preparation_Time_min)) +
        geom_histogram(bins = 30, fill = "seagreen", color = "black") +
        labs(x = "Preparation Time (min)", y = "Count",
             title = "Preparation Time Distribution")
    })
    
    # 4) وقت التوصيل حسب نوع المركبة
    output$plot_vehicle <- renderPlot({
      df <- data_reactive()
      ggplot(df, aes(x = Vehicle_Type, y = Delivery_Time_min, fill = Vehicle_Type)) +
        geom_boxplot() +
        labs(x = "Vehicle Type", y = "Delivery Time (min)",
             title = "Delivery Time by Vehicle Type")
    })
    
    # 5) وقت التوصيل حسب مستوى الزحمة
    output$plot_traffic <- renderPlot({
      df <- data_reactive()
      ggplot(df, aes(x = Traffic_Level, y = Delivery_Time_min, fill = Traffic_Level)) +
        geom_boxplot() +
        labs(x = "Traffic Level", y = "Delivery Time (min)",
             title = "Delivery Time by Traffic Level")
    })
    
    # 6) وقت التوصيل حسب حالة الطقس
    output$plot_weather <- renderPlot({
      df <- data_reactive()
      ggplot(df, aes(x = Weather, y = Delivery_Time_min, fill = Weather)) +
        geom_boxplot() +
        labs(x = "Weather", y = "Delivery Time (min)",
             title = "Delivery Time by Weather")
    })
    
    # 7) علاقة المسافة بوقت التوصيل
    output$plot_dist_vs_time <- renderPlot({
      df <- data_reactive()
      ggplot(df, aes(x = Distance_km, y = Delivery_Time_min)) +
        geom_point(alpha = 0.7, size = 2, color = "purple") +
        labs(x = "Distance (km)", y = "Delivery Time (min)",
             title = "Distance vs Delivery Time")
    })
    
    # 8) علاقة وقت التحضير بوقت التوصيل
    output$plot_prep_vs_time <- renderPlot({
      df <- data_reactive()
      ggplot(df, aes(x = Preparation_Time_min, y = Delivery_Time_min)) +
        geom_point(alpha = 0.7, size = 2, color = "brown") +
        labs(x = "Preparation Time (min)", y = "Delivery Time (min)",
             title = "Preparation Time vs Delivery Time")
    })
    
    #Decision Tree=
    tree_result <- eventReactive(input$runModels, {
      df <- data_reactive()
      
     
      set.seed(123)
      index <- sample(c(TRUE, FALSE), nrow(df), replace = TRUE, prob = c(0.7, 0.3))
      train <- df[index, ]
      test  <- df[!index, ]
      
     
      tree <- rpart(
        late_order ~ Distance_km + Weather + Traffic_Level +
          Time_of_Day + Vehicle_Type + Preparation_Time_min +
          Courier_Experience_yrs,
        data = train,
        method = "class"
      )
      
     
      pred <- predict(tree, test, type = "class")
      cm   <- table(Actual = test$late_order, Predicted = pred)
      acc  <- sum(diag(cm)) / sum(cm)
      
      list(tree = tree, cm = cm, acc = acc)
    })
    
    output$tree_plot <- renderPlot({
      req(tree_result())
      rpart.plot(tree_result()$tree)
    })
    
    output$tree_metrics <- renderPrint({
      req(tree_result())
      cat("Confusion Matrix:\n")
      print(tree_result()$cm)
      cat("\nAccuracy:\n")
      print(tree_result()$acc)
    })
    
    #K-means Clustering
    cluster_result <- eventReactive(input$runModels, {
      df <- data_reactive()
      
     
      num_data <- df %>%
        select(Distance_km, Delivery_Time_min, Preparation_Time_min, Courier_Experience_yrs)
      
      num_scaled <- scale(num_data)
      
      set.seed(123)
      km <- kmeans(num_scaled, centers = input$kclusters)
      
      df$cluster <- as.factor(km$cluster)
      
      list(df = df, km = km)
    })
    
    output$cluster_plot <- renderPlot({
      req(cluster_result())
      df <- cluster_result()$df
      
      ggplot(df, aes(x = Distance_km, y = Delivery_Time_min, color = cluster)) +
        geom_point(alpha = 0.7, size = 2) +
        labs(x = "Distance (km)", y = "Delivery Time (min)",
             title = "K-means Clusters by Distance & Delivery Time")
    })
    
    output$cluster_summary <- renderTable({
      req(cluster_result())
      df <- cluster_result()$df
      
      df %>%
        group_by(cluster) %>%
        summarise(
          avg_distance      = mean(Distance_km, na.rm = TRUE),
          avg_delivery_time = mean(Delivery_Time_min, na.rm = TRUE),
          avg_prep_time     = mean(Preparation_Time_min, na.rm = TRUE),
          avg_experience    = mean(Courier_Experience_yrs, na.rm = TRUE),
          n_orders          = n()
        )
    })
    
    # Insights
    output$insights_text <- renderPrint({
      cat(
        "Main Insights:
  
  1) Distance_km and Preparation_Time_min are strong predictors of late deliveries.
  2) Long distances combined with long preparation times lead to a high probability of late orders.
  3) K-means clustering shows different groups of orders (short & fast, long & risky, etc.).
  4) The company can reduce delays by improving preparation time and assigning suitable vehicles for long distances."
      )
    })
  }
  
 
  shinyApp(ui = ui, server = server)