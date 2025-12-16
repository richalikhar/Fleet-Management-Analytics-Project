# Fleet-Management-Analytics-Project
This project focuses on comprehensive vehicle performance analysis using the available fleet dataset. In this data analytics project using Python, SQL, and Power BI to extract meaningful insights about vehicle efficiency, maintenance patterns, and operational performance.
Phase 1 -- Python (ETL and Data Analysis)
Tasks:
1.	Import and Explore Data
o	Load the vehicle dataset using pandas
o	Perform initial data exploration and profiling
2.	Data Cleaning & Transformation
o	Handle missing values and duplicates
o	Fix data types and validate ranges
o	Create calculated columns:
	Vehicle age (from purchase date and year)
	Cost per km (annual_maintenance_cost / current_mileage_km)
	Monthly mileage (current_mileage_km / vehicle_age_months)
	Efficiency category (High/Medium/Low based on fuel_efficiency_km_l)
3.	Data Analysis
o	Vehicle performance by make and model
o	Age vs efficiency correlation analysis
o	Maintenance cost trends by vehicle type
o	Driver performance impact analysis
4.	Data Export
o	Export cleaned dataset for SQL analysis
o	Create summary statistics and insights
Phase 2 -- SQL (Vehicle Performance Analysis)
Database Setup:
•	Create vehicle performance database
•	Import cleaned dataset into SQL tables
Analytical Queries:
1.	Basic Analysis:
o	Total mileage and average efficiency by vehicle make
o	Maintenance cost analysis by vehicle type and age
o	Top performing vehicles by fuel efficiency
2.	Advanced Queries (using CTEs and Window Functions):
o	Rank vehicles by efficiency within each make
o	Calculate moving averages of maintenance costs
o	Identify vehicles with above/below average performance
o	Age-based efficiency degradation analysis
o	Cost-to-mileage ratio comparisons
3.	Comparative Analysis:
o	New vs old vehicle performance comparison
o	Vehicle type efficiency analysis
o	Maintenance cost trends across different manufacturers
Phase 3 -- Power BI (Vehicle Performance Dashboard)
Dashboard Components:
1.	Executive Summary Page:
o	KPI Cards: Total Vehicles, Average Efficiency, Total Mileage, Avg Maintenance Cost
o	Vehicle distribution by type and make
o	Age distribution chart
2.	Performance Analysis Page:
o	Scatter plot: Age vs Fuel Efficiency
o	Bar chart: Average Efficiency by Vehicle Make
o	Line chart: Maintenance Cost vs Mileage
o	Heat map: Performance score distribution
3.	Cost Analysis Page:
o	Maintenance cost by vehicle type
o	Cost per km analysis
o	Driver performance impact on costs
o	Vehicle age vs maintenance cost trend
