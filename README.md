# Gas_Flaring_Analysis
## 1. Introduction
Gas flaring is the controlled burning of natural gas that is released during the extraction of oil and gas. This typically occurs at oil production sites where infrastructure to capture and transport the gas is unavailable, uneconomical or undeveloped. While it may be necessary for safety and operational reasons, it also represents a major source of greenhouse gas emissions and energy waste. Globally, billions of cubic meters of natural gas are flared every year, contributing significantly to climate change and air pollution.

The World Bank’s Global Gas Flaring Reduction (GGFR) Partnership provides publicly available, satellite-based estimates of gas flaring by country and oil production site. This dataset offers a valuable opportunity to examine global trends, identify high-flaring regions and assess the effectiveness of reduction initiatives.

## 2. Problem Statement
According to a report published by the International Energy Agency(2024), around 139 billion cubic meters (bcm) of natural gas was flared globally; equivalent to the entire annual gas consumption of sub-Saharan Africa, resulting in approximately 500 million tonnes of CO₂ equivalent emissions. Despite growing awareness and international commitments to reduce emissions, gas flaring levels remain persistently high in several countries. 

This project aims to bridge the gap between raw satellite data and actionable insights through visualization and exploratory data analysis. The ultimate goal is to highlight opportunities for sustainable energy practices and contribute to ongoing global reduction efforts.

## 3. Methodology
*   **Data Wrangling:** Initial inspection and cleaning was performed in **Excel**
*   **Database Engineering:** A normalized relational database was designed and implemented in **MySQL**
*   **Data Analysis:** Complex analytical queries were written in **SQL** to aggregate data and uncover trends
*   **Data Visualization:** **Tableau** was incorporated to build an interactive dashboard for exploration and storytelling
*   **Tools:** MySQL, Tableau, Excel, Lucidchart

## 4. Results
### Entity-Relationship Diagram (ERD)
The database is designed with normalization principles to efficiently store and relate data. The schema consists of three main tables: countries, fields and flaring_events linked through foreign keys

### Tableau Dashboard
This interactive dashboard explores global trends, identifies top-flaring countries and operators and analyzes flaring by field type.

## 5.Key Insights 

## 6.Recommendations
*  **Targeted International Policy:** Focus diplomatic and technical assistance efforts on the top-flaring countries identified in the analysis. A one-size-fits-all global approach is less effective than targeted action.
*  **Corporate Accountability:** Investors and advocacy groups should use this data to directly engage with the major flaring operators identified to encourage adoption of best practices and transparency in reporting.
* **Technology for Remote Operations:** The high flaring intensity in offshore fields underscores a need for greater investment in technologies that can capture and utilize gas in remote or offshore environments, where infrastructure is a constraint.
*  **Continuous Monitoring:** Regulators and NGOs should adopt transparent monitoring of progress against flaring reduction commitments like the World Bank's Zero Routine Flaring by 2030 initiative


