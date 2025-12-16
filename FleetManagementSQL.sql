SELECT * FROM fleet_project_datasets.fleet_project_datasets_fixed_new;

#1.	Basic Analysis:
#Total mileage and average efficiency by vehicle make
SELECT 
    make,
    SUM(current_mileage_km) AS Total_mileage,
    Round(AVG(fuel_efficiency_km_l),2) AS Avg_Efficiency
FROM fleet_project_datasets_fixed_new
GROUP BY make
ORDER BY Total_mileage DESC;

# Maintenance cost analysis by vehicle type and age
SELECT 
    vehicle_type,
    CASE 
        WHEN vehicle_age_year < 3 THEN '0–2 Years'
        WHEN vehicle_age_year BETWEEN 3 AND 5 THEN '3–5 Years'
        WHEN vehicle_age_year BETWEEN 6 AND 10 THEN '6–10 Years'
        ELSE '10+ Years'
    END AS age_group,
    ROUND(AVG(annual_maintenance_cost), 2) AS avg_maintenance_cost
FROM fleet_project_datasets_fixed_new
GROUP BY vehicle_type, age_group
ORDER BY vehicle_type, age_group;


# Top performing vehicles by fuel efficiency
SELECT 
    vehicle_id,
     make,
     model,
    ROUND(fuel_efficiency_km_l, 2) AS Fuel_Efficiency
FROM fleet_project_datasets_fixed_new
ORDER BY Fuel_Efficiency DESC
LIMIT 10;

# 2.Advanced Queries (using CTEs and Window Functions):

# Rank vehicles by efficiency within each make
WITH efficiency_rank AS (
    SELECT
        vehicle_id,
        make,
        model,
        fuel_efficiency_km_l,
        RANK() OVER (
            PARTITION BY make
            ORDER BY fuel_efficiency_km_l DESC
        ) AS efficiency_rank
    FROM fleet_project_datasets_fixed_new
)
SELECT *
FROM efficiency_rank
ORDER BY make, efficiency_rank;


# Moving average of maintenance costs (by vehicle over time)
WITH maintenance_cost AS (
    SELECT
        vehicle_id,
        annual_maintenance_cost,
        ROUND(
            AVG(annual_maintenance_cost) OVER (
                PARTITION BY vehicle_id
                ORDER BY date
                ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
            ), 2
        ) AS moving_avg_cost
    FROM fleet_project_datasets_fixed_new
)
SELECT *
FROM maintenance_cost;

# Vehicles with above / below average efficiency
WITH avg_efficiency AS (
    SELECT AVG(fuel_efficiency_km_l) AS avg_eff
    FROM fleet_project_datasets_fixed_new
)
SELECT
    v.vehicle_id,
    v.make,
    v.fuel_efficiency_km_l,
    CASE
        WHEN v.fuel_efficiency_km_l >= a.avg_eff THEN 'Above Average'
        ELSE 'Below Average'
    END AS performance_level
FROM fleet_project_datasets_fixed_new  v
CROSS JOIN avg_efficiency a;

# Age-based efficiency degradation analysis
WITH age_efficiency AS (
    SELECT
        vehicle_age_year,
        ROUND(AVG(fuel_efficiency_km_l), 2) AS avg_efficiency
    FROM fleet_project_datasets_fixed_new
    GROUP BY vehicle_age_year
)
SELECT
    vehicle_age_year,
    avg_efficiency,
    LAG(avg_efficiency) OVER (ORDER BY vehicle_age_year) AS prev_year_efficiency,
    ROUND(
        avg_efficiency -
        LAG(avg_efficiency) OVER (ORDER BY vehicle_age_year),
        2
    ) AS efficiency_drop
FROM age_efficiency;

# Cost-to-mileage ratio comparison
WITH cost_mileage AS (
    SELECT
        vehicle_id,
        ROUND(
            SUM(annual_maintenance_cost) / NULLIF(SUM(current_mileage_km), 0),
            2
        ) AS cost_per_mile
    FROM fleet_project_datasets_fixed_new
    GROUP BY vehicle_id
)
SELECT *
FROM cost_mileage
ORDER BY cost_per_mile DESC;


#3.	Comparative Analysis:
# New vs old vehicle performance comparison
SELECT
    CASE 
        WHEN vehicle_age_year <= 4 THEN 'New'
        ELSE 'Old'
    END AS vehicle_age_group,
    ROUND(AVG(fuel_efficiency_km_l), 2) AS avg_efficiency,
    ROUND(AVG(annual_maintenance_cost), 2) AS avg_maintenance_cost
FROM fleet_project_datasets_fixed_new
GROUP BY vehicle_age_group;



#	Vehicle type efficiency analysis
SELECT
    vehicle_type,
    ROUND(AVG(fuel_efficiency_km_l), 2) AS avg_efficiency,
    ROUND(MAX(fuel_efficiency_km_l), 2) AS max_efficiency,
    ROUND(MIN(fuel_efficiency_km_l), 2) AS min_efficiency
FROM fleet_project_datasets_fixed_new
GROUP BY vehicle_type
ORDER BY avg_efficiency DESC;

#	Maintenance cost trends across different manufacturers
SELECT
    make,
    vehicle_age_months AS month,
    ROUND(SUM(annual_maintenance_cost), 2) AS total_maintenance_cost,
    ROUND(AVG(annual_maintenance_cost), 2) AS avg_maintenance_cost
FROM fleet_project_datasets_fixed_new
GROUP BY make, vehicle_age_months
ORDER BY make, vehicle_age_months;