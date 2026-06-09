 ## ☄️ Northwind-traders-data-warehouse-and-Sales-analytics-

Welcome to the Northwind Traders and Sales analytics repository.
This project presents a comprehensive end-to-end data warehousing and analytics solution built using SQL Server, ETL pipelines, dimensional modeling, and BI reporting.

### 🎯Business Problem

Northwind Traders generates large volumes of sales, customer, product, and shipping data. However, raw operational data alone does not provide the insights needed to support business decisions.
This project centralizes and transforms data into an analytical warehouse that enables stakeholders to:
- Monitor sales performance
- Analyze customer behavior
- Evaluate product performance
- Track shipping efficiency
- Identify revenue trends
- Support KPI-driven decision making

### 📖Project Overview

This project involves:
- **Data Architecture:** Designing a Modern Data Warehouse Using Medallion Architecture Bronze, Silver, and Gold layers.
- **ETL Pipelines:** Extracting, transforming, and loading data from source systems into the warehouse.
- **Data Modeling:** Developing fact and dimension tables optimized for analytical queries.
- **Analytics & Reporting:** Developing SQL-driven reports and dashboards that transform data into clear, actionable insights.

### 🛠 Skills Demonstrated

**Data Architecture & Engineering**
- Data Warehouse Design
- Medallion Architecture
- ETL Development
- Data Cleansing & Transformation

**Data Modeling**
- Dimensional Modeling
- Star Schema Design
- Fact & Dimension Modeling
- Data Quality Validation

**Business Analytics**
- Sales Performance Analysis
- Customer Analysis
- Product Performance Analysis
- Revenue Trend Analysis

**Reporting & Visualization**
- KPI Development
- Dashboard Design
- Data Storytelling
- Business Reporting

### 🚀 Scope & Technical Specifications
Building the Data Warehouse (Data Engineering)

#### Objective:
Design and implement a modern data warehouse using SQL Server to consolidate hospital encounter data, enabling analytical reporting and data-driven decision-making.

#### Specifications:
- **Data Sources:** Ingest structured data provided as CSV files into a staging layer.
- **Data Quality:** Perform data cleansing, validation, and transformation to resolve inconsistencies and ensure integrity.
- **Data Integration:** Integrate source data into a unified dimensional data model (fact and dimension tables) optimized for analytical queries.
- **Scope:** 
- **Documentation:** Provide comprehensive data model documentation to support business stakeholders and analytics teams.

### 🏙️ Data Architecture
The data architecture for this project follows Medallion Architecture Bronze, Silver, and Gold layers: 
![Data Architecture](https://github.com/Nyakuni992/Northwind-traders-data-warehouse-and-analytics-/blob/main/docs/Data%20Architecture.drawio.png)
- **Bronze Layer:** Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
- **Silver Layer:** This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.

- **Gold Layer:** Contains business-ready, curated data structured into a star schema to support reporting, analytics, and KPI-driven insights.

### ⭐ Data Model (Star Schema)
![Star Schema](https://github.com/Nyakuni992/Northwind-traders-data-warehouse-and-analytics-/blob/main/docs/Data%20Mart(Star%20Schema).drawio.png)
The Gold Layer follows a Star Schema design, providing a streamlined and high-performance structure for analytics and reporting. Data is organized into a central fact table and related dimension tables, all exposed through SQL views for easy consumption by reporting and BI tools.
- **Fact Table:** gold.fact_orders
- **Dimension Tables:** gold.dim_customers, gold.dim_products, gold.dim_employees, and gold.dim_shippers

### ⚙️ Tech Stack

- Category	Tools
- Database	SQL Server Express
- Query Tool	SSMS
- Data Modeling	Draw.io
- Version Control	Git & GitHub
- Documentation	Notion
- Visualization	Tableau Public
- Data Format	CSV

### 📈 Project Management & Roadmap
This project was managed using a structured SDLC (Software Development Life Cycle) approach. You can view the full project roadmap, task breakdown, and progress tracking on my public Notion page: 🔗 View My Project Roadmap on Notion

Key Milestones Tracked:
- **Requirement Analysis & Design:** Initial scoping and architecture planning.
- **Medallion Pipeline Development:** Granular task tracking for Bronze, Silver, and Gold layer implementations.
- **Quality Assurance:** Dedicated tasks for schema validation and data integrity checks.
- **Quality Assurance:** Dedicated tasks for schema validation and data integrity checks.
- **Documentation & Version Control:** Integrated milestones for Draw.io diagrams and Git commits

### 📊 BI: Analytics & Reporting (Data Analysis)

#### Objective:
Develop a comprehensive analytics and reporting solution that leverages the Northwind Traders data warehouse to track critical business KPIs. Through SQL-based analysis and interactive dashboards, the reporting layer provides insights into revenue growth, customer purchasing patterns, product performance, employee productivity, and shipping operations, supporting data-driven business decision-making.

### 🚀 Getting Started
#### Prerequisites
Database Engine: SQL Server SQL Server Management Studio (SSMS) Tableau Desktop/Public

#### Installation & Setup
1. Clone the Repository
Bash git clone

2. Initialize the Database:
Open SSMS and connect to your local instance. Run the script scripts/bronze/init_database.sql to create the database structure.

3. Ingest Raw Data:
Place the CSV files from the datasets/ folder into your SQL Server's authorized import directory.

4.Execute the scripts/bronze/load_bronze.sql scripts.
5.Run Transformations:
Execute scripts in the silver/ folder, followed by the gold/ folder to build the Galaxy Schema.

5.View Analytics:
Tableau Access: Open the .twbx (Packaged Workbook) located in the reports/ folder.

### 📝 Technical Notes

Tableau Connection: Data was transformed and curated in SQL Server; Gold-layer tables were exported to CSV for visualization in Tableau Public due to the software's connection limitations for local SQL instances.
Data Integrity: The exported CSVs represent the final, cleaned "Gold" layer, ensuring the dashboards reflect the logic applied within the SQL Server environment. Refer to the SQL scripts in reports/export data which correspond exactly to the data structures seen in the Tableau "Data Source" tab.

### 📂 Repository Structure

Northwind Traders and Sales Analytics/
│
├── datasets/                           # Raw datasets used for the project (CSV)
│
├── docs/                               # Project documentation and architecture details
│   ├── etl.drawio                      # Illustrates the various ETL techniques & processes used
│   ├── data_architecture.drawio        # Draw.io file shows the project's architecture
│   ├── data_catalog.md                 # Catalog of datasets, including field descriptions and metadata
│   ├── data_flow.drawio                # Draw.io file for the data flow diagram
│   ├── data_models.drawio              # Draw.io file for data models (star schema)
│   ├── naming-conventions.md           # Consistent naming guidelines for tables, columns, and files
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── bronze/                         # Scripts for extracting and loading raw data
│   ├── silver/                         # Scripts for cleaning and transforming data
│   ├── gold/                           # Scripts for creating analytical models
│
├── reports/                            # THE ANALYTICAL OUTPUT               
│   ├── exported_gold_data              # The CSVs used for Tableau (since SQL connection is limited)
│   ├── kpi_queries.sql                 # Final analytical reports & KPI queries
│   └── tableau dashboards.twbx         # The Packaged Tableau Workbook
│  
│  
├── tests/                              # Data validation & integrity checks
│
├── README.md                           # Project overview and instructions
├── LICENSE                             # License information for the repository
└── .gitignore                          # Files and directories to be ignored by Git

### 🛡️ License
This project is licensed under the MIT License. allowing you to freely use, modify, and share it, provided proper attribution is given.

### 🌟 About Me
Hello! I’m Aramiru Nyakuni Rebecca, a professional accountant transitioning into the field of data analysis. I am dedicated to honing my skills and expertise in data analytics while leveraging data-driven insights and predictive analysis to help organizations achieve their long-term objectives.

### 🤝 Connect With Me
[![Portfolio](https://img.shields.io/badge/Portfolio-Canva-00C4CC?logo=canva&logoColor=white)](https://rebekaharamiru.my.canva.site/portfolio)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/rebecca-aramiru-3a699a12b/)
[![Gmail](https://img.shields.io/badge/Email-Gmail-red?logo=gmail&logoColor=white)](mailto:nyanetah@gmail.com)


