1--DATA CLEANING WITH EXCELL--




2-- -- CREATING DATABASE-- --
-- CREATE Database Healthcare_db;
-- Use Healthcare_db;




3-- --CREATING TABLE-- --
CREATE TABLE healthanalysis 
			   (ID INT NOT NULL  AUTO_INCREMENT PRIMARY KEY,
               first_name         VARCHAR(255),
			   last_name          VARCHAR(255),
			   age                INT,
			   gender             VARCHAR (255),
               blood_type         VARCHAR(255),
               medical_condition  VARCHAR(255),
               dateofadmission    DATE,
               doctor             VARCHAR(255),
               hospital           VARCHAR(255),
               insurance_provider VARCHAR(255),
               billing_amount     DECIMAL (10,2),
               room_number        INT,
               admission_type     VARCHAR(255),
               discharge_date     DATE,
               medication         VARCHAR(255),
               test_result        VARCHAR(255));




4-- --IMPORTING DATA USING WIZARD--        
       
5-- --CHECKING TABLE AND COLUMNS-- --		
--  SELECT*FROM healthanalysis;
--      SELECT COUNT(*) FROM healthanalysis;


-- 6-EXPLORATORY DATA ANALYSIS(EDA)
-- SELECT 
   ROUND(AVG(age),2)
   FROM healthanalysis;
   
-- SELECT 
   DISTINCT blood_type 
   FROM healthanalysis;
   
-- SELECT 
   DISTINCT medical_condition 
   FROM healthanalysis;
   
-- SELECT 
   DISTINCT insurance_provider 
   FROM healthanalysis;
   
-- SELECT 
   DISTINCT admission_type 
   FROM healthanalysis;
   
-- SELECT 
   DISTINCT medication 
   FROM healthanalysis;
   
-- SELECT 
   DISTINCT test_result 
   FROM healthanalysis;


-- 7-Data Analyst Business Key problems and Answers 
-- My Analysis And Findings
-- Q.1 Write a query for retrieve first and last name of patient for dateofadmission made on "2020-01-21"
-- Q.2 Write a SQL  query for retrieve billing amount where the insurance provider is "Blue cross" and billing amount is more than 10000.00 in the month of Nov 2020.
-- Q.3 Write a SQL query to calculate total (billing_amount) for each insurance provider.
-- Q.4 Write a SQL query to find the avarage age of patient who has "Medicare" insurance.
-- Q.5 Write a SQL query to find highest billing_amount for each insurance provider.
-- Q.6 Write a SQL query to find first and last name and the total number of patient for each medication.
-- Q.7 Write a SQL query to find count of test_result by grouping.Please return the result if test_result normal then "healthy" if the test_result abnormal then "unhealthy" and if the test_result "inconclusive" then "test again"
-- Q.8 Find the top 5 luckiest patient who has the normal test_result and paid minimum billing. 
-- Q.9 Find the count of the patient for each hospital bring the results separetely for " 2020,2021,2022"
-- Q.10 Find the count of patient for each blood_type and add column for blood type compability about which blood type they can receive. 



-- Q.1 Write a query for retrieve first and last name of patient for dateofadmission made on "2020-01-21"
SELECT 
      first_name,
      last_name,
      dateofadmission
FROM healthanalysis
WHERE dateofadmission="2020-01-21";



-- Q.2 Write a SQL  query for retrieve billing amount where the insurance provider is
 "Blue cross" and billing amount is more than 10000.00 in the month of Nov 2020.
 
 SELECT 
       insurance_provider,
       dateofadmission,
       billing_amount 
 FROM healthanalysis
 WHERE insurance_provider="Blue cross"
 AND 
 MONTH(dateofadmission)=11
 AND 
 YEAR(dateofadmission)=2020
 AND 
 billing_amount>=10000.00;
 
 

-- Q.3 Write a SQL query to calculate total (billing_amount) for each insurance provider and ORDER BY DESC.
SELECT 
      insurance_provider,
      SUM(billing_amount) as total_billing_amount
FROM healthanalysis
GROUP BY insurance_provider 
ORDER BY total_billing_amount DESC;


-- Q.4 Write a SQL query to find the avarage age of patient who has "Medicare" insurance.
SELECT 
      AVG(age)
FROM healthanalysis
WHERE insurance_provider='Medicare';



-- Q.5 Write a SQL query to find highest billing_amount for each insurance provider.

WITH cteRowNum AS (
    SELECT  
		insurance_provider,
		billing_amount,
	ROW_NUMBER() OVER(PARTITION BY insurance_provider 
    ORDER BY billing_amount DESC) AS RowNum
	FROM healthanalysis;
)
SELECT  
       insurance_provider,
       billing_amount
FROM cteRowNum
WHERE RowNum in(1)
ORDER BY billing_amount DESC;
    
    
    
    -- Q.6 Write a SQL query to total number of patient for each medication.
SELECT 
       medication,
       COUNT(*) as total_medication_given
FROM healthanalysis
GROUP BY medication ORDER BY total_medication_given DESC;
    
    -- Q.7 Write a SQL query to find count of test_result by grouping.Please return 
       the result if test_result normal then "healthy" if the test_result abnormal
       then "unhealthy" and if the test_result "inconclusive" then "test again"
      
SELECT test_result,
CASE 
WHEN test_result='Normal' THEN 'Healthy'
WHEN test_result='Abnormal' THEN 'Unhealthy'
WHEN test_result='Inconclusive' THEN 'Please Repeat Test'
ELSE '0'
END AS health_status,
COUNT(*)
FROM healthanalysis
GROUP BY test_result;



-- Q.8 Find the top 5 luckiest patient who has the normal test_result and paid minimum billing. 
WITH minbilling AS
(SELECT 
		first_name,
		last_name,
		billing_amount
FROM healthanalysis
WHERE test_result='Normal'
ORDER BY billing_amount ASC 
LIMIT 5)
      
SELECT 
		first_name,
		last_name 
FROM minbilling;
   
   -- Q.9 Find the hospitalization period for each patient.
   SELECT first_name,
          last_name,
		  dateofadmission,
		  discharge_date,
          DATEDIFF(discharge_date,dateofadmission) AS hospitalization_period
   FROM healthanalysis
   ORDER BY first_name ASC;
   
   
   
   
   -- Q.10 Find the count of patient for each blood_type and add column 
	for blood type compability about which blood type they can receive. 
    SELECT first_name,last_name,blood_type,
    CASE 
    WHEN blood_type='B-' THEN '0- AND B-'
    WHEN blood_type='A+' THEN '0+,0-,A+,A-'
    WHEN blood_type='A-' THEN '0- AND A-'
    WHEN blood_type='0+' THEN '0+ AND 0-'
    WHEN blood_type='AB+' THEN 'ALL'
    WHEN blood_type='AB-' THEN '0-,A-,B-,AB-'
    WHEN blood_type='B+' THEN '0+,0-,B+,B-'
    WHEN blood_type='0-+' THEN '0-'
    ELSE 0
    END AS 'CAN RECEIVE FROM THIS GROUPS'
    FROM healthanalysis;
    
    
--End of project 
    
 
   
