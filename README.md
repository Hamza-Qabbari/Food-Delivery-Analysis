# 🛵 Food Delivery Service Efficiency Analysis & Shiny App

### 📊 Project Overview
This project presents a comprehensive analysis of a real-world dataset containing **912 delivery orders**, aimed at identifying the root causes of delivery delays. By leveraging advanced data science techniques, the project provides actionable, data-driven insights to optimize service efficiency, enhance customer satisfaction, and streamline operations.

The study encompasses the entire Data Science lifecycle, from data preprocessing and exploratory data analysis (EDA) to predictive modeling using **Decision Trees** and customer segmentation via **K-Means Clustering**, culminating in the deployment of an interactive **Shiny Web Application** for real-time decision support.

---

### 🤝 Development Team
This project was collaboratively developed by the **"El Cartel"** team as a capstone Data Science project. The team focused on implementing a robust analytical pipeline to solve logistical challenges in the food delivery sector.

---

### 🛠️ Technical Methodology

#### 1. Data Preprocessing & Feature Engineering
Rigorous data cleaning was performed to ensure high data quality:
* **Handling Missing Data:** Imputation strategies were applied to handle null values.
* **Outlier Detection:** Statistical methods were used to identify and treat anomalies.
* **Feature Engineering:** New derived metrics such as `Delivery_Speed` and `Late_Order_Flag` were created to enhance model performance.

#### 2. Exploratory Data Analysis (EDA)
In-depth visualization using `ggplot2` to uncover hidden patterns:
* **Correlation Analysis:** Investigated the relationship between `Distance_km` and `Delivery_Time_min`.
* **Operational Factors:** Analyzed the impact of **Traffic Levels**, **Weather Conditions**, and **Vehicle Types** on delivery performance.

#### 3. Machine Learning Implementation
* **Predictive Modeling (Decision Tree):**
    * Developed a classification model to predict the likelihood of late deliveries.
    * **Performance:** Achieved an accuracy of **86.35%** on the test set.
    * **Key Insight:** The model identified `Distance` and `Restaurant Preparation Time` as the most significant predictors of delay.
* **Clustering Analysis (K-Means):**
    * Segmented orders into **4 distinct clusters** based on delivery characteristics.
    * **Outcome:** Identified high-risk segments (Long distance/Slow prep) vs. high-efficiency segments to guide resource allocation.

#### 4. Interactive Dashboard (Shiny App) 📱
A user-friendly web interface was developed to democratize access to insights:
* **Dynamic Data Upload:** Supports `.csv` file integration.
* **Real-time Visualization:** Interactive charts for instant data exploration.
* **Model Deployment:** Allows stakeholders to run ML models on new data on-the-fly.

---

### 🚀 Key Findings & Recommendations
1.  **Primary Bottlenecks:** Analysis confirms that **Kitchen Preparation Time** and **Travel Distance** significantly outweigh environmental factors (traffic/weather) in causing delays.
2.  **Strategic Recommendations:**
    * **Operational:** Optimize kitchen workflows to reduce prep time.
    * **Logistical:** Assign high-speed vehicles (e.g., scooters/motorbikes) specifically to long-distance orders identified by the clustering model.

---

### 💻 Tech Stack
* **Language:** R
* **Framework:** Shiny (Web App)
* **Libraries:** `tidyverse` (Data Manipulation), `ggplot2` (Visualization), `rpart` & `rpart.plot` (Decision Trees), `stats` (Clustering).
