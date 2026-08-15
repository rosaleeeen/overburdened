CREATE DATABASE MiningCapitalProject;
USE MiningCapitalProject;




-- WORK PACKAGES - one row per work pkg
-- =====================================================================
DROP TABLE IF EXISTS work_packages;


/* wbs_code - short id: WP-[][][]
 * wbs_name - human-readable name
 * total_budget - total $ allocated to wpkg
 * schedule_performance_target - how close to 'on schedule' pkg runs
 * cost_performance_target - how close to 'on budget' pkg runs
 * 
 * for (schedule_performance_target, cost_performance_target):
 * 		< 1: below expectations (behind schedule/above budget)
 * 		= 1: perfect performance
 * 		> 1: surpassing expectations (ahead of schedule/below budget) 
 */
CREATE TABLE work_packages (
	wbs_code                     VARCHAR(6)   PRIMARY KEY,			
	wbs_name                     VARCHAR(100) NOT NULL,				 
	total_budget                 INT          NOT NULL,		
	schedule_performance_target  REAL         NOT NULL,	 
	cost_performance_target     REAL          NOT NULL		
);


INSERT INTO work_packages
VALUES 	('WP-100', 'Mine Development', 45000000, 0.98, 1.02),
		('WP-200', 'Process Plant Construction', 390000000, 0.99, 0.97),
		('WP-300', 'Water Treatment Plant', 22000000, 0.96, 1.01),
		('WP-400', 'Tailings Storage Facility', 60000000, 0.78, 0.74),
		('WP-500', 'Underground Development', 80000000, 1.03, 1.01),
		('WP-600', 'Site Infrastructure', 35000000, 0.99, 1.00),
		('WP-700', 'Engineering & Design', 25000000, 0.97, 0.94),
		('WP-800', 'Commisioning', 46300000,	0.65, 1.02),
		('WP-900', 'Camp & Accommodations',	19000000,	1.02, 0.89);




-- TIMELINE - one row per month (24-month project)
-- =====================================================================
DROP TABLE IF EXISTS project_months;


/* month_number = [1, 24]
 * normalised_ weight - distance to midpoint of project
 */
CREATE TABLE project_months (
	month_number      INT PRIMARY KEY,
	normalised_weight REAL 
);


INSERT INTO project_months (month_number) 
VALUES 	(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),
		(13),(14),(15),(16),(17),(18),(19),(20), (21),(22),(23),(24);


WITH raw_weights AS (
	SELECT 
		month_number,
		1.0 - (ABS(month_number - 12.5) / 12.5) AS raw_weight
	FROM project_months
),
totals AS (
	SELECT SUM(raw_weight) AS total_weight 
	FROM raw_weights
)
UPDATE project_months
SET normalised_weight = (
	SELECT r.raw_weight / t.total_weight AS normalised_weight
	FROM raw_weights r, totals t
	WHERE r.month_number = project_months.month_number
);




-- EARNED VALUE MANAGEMENT - one row per (month, wbs_code) 
-- =====================================================================
DROP TABLE IF EXISTS evm_data;

/* month_numbers = [1, 24]
 * wbs_code, wbs_name - structures from work_packages
 * bcws - budgeted cost of work schedule
 * bcwp - budgeted cost of work performed
 * acwp - actual cost of work performed
 */
CREATE TABLE evm_data (
    month_number INT          NOT NULL,
    wbs_code   	 VARCHAR(6)   NOT NULL,
    wbs_name     VARCHAR(100) NOT NULL,
    bcws  			 INT          NOT NULL, 
    bcwp   			 INT          NOT NULL,
    acwp   			 INT          NOT NULL,
    PRIMARY KEY (month_number, wbs_code),
    FOREIGN KEY (wbs_code) REFERENCES work_packages(wbs_code)
);


INSERT INTO evm_data 
WITH monthly_plan AS (
	SELECT
		m.month_number,
		w.wbs_code,
		w.wbs_name,
		w.total_budget * m.normalised_weight AS planned_spend,
		w.schedule_performance_target,
		w.cost_performance_target,
		1 + (RAND() * 8 - 4) / 100.0 AS noise
	FROM project_months m
	INNER JOIN work_packages w
)
SELECT 
	month_number,
	wbs_code,
	wbs_name,
	planned_spend,
	ROUND((planned_spend * schedule_performance_target * noise), 0),
	ROUND((planned_spend * schedule_performance_target * noise) / cost_performance_target, 0)
FROM monthly_plan
ORDER BY month_number, wbs_code;
