# Healthcare-Data-Analysis


---

**Project Overview**

**Project Title:** Healthcare Data Analysis  
**Level:** Beginner  
**Database:** healthcare_dataset.csv  

This project demonstrates SQL skills and techniques commonly used by data analysts to create, clean, explore, and analyze a healthcare dataset. It involves setting up a database, performing exploratory data analysis (EDA), and drawing insights from healthcare data. The project is ideal for beginners who want to develop solid SQL skills in data analysis.

**Objectives**

1. **Set Up Healthcare Database:** Create and populate a healthcare database with the provided dataset.
2. **Data Cleaning:** Identify and remove records with missing or null values using Excel.
3. **Exploratory Data Analysis (EDA):** Perform basic EDA to understand the dataset’s structure and content.
4. **Business Analysis:** Use SQL to answer specific healthcare-related questions and derive insights from the dataset.

**Project Structure**

1. **Database Setup**

   * **Database Creation:** Start by creating a database named healthcare_db.
   * **Table Creation:** A table named healthanalysis is created to store healthcare data. The table includes the following columns:
     * **Name:** Patient's name.
     * **Age:** Patient's age at admission.
     * **Gender:** Patient's gender (Male/Female).
     * **Blood Type:** Patient’s blood type (e.g., A+, O-, etc.).
     * **Medical Condition:** Primary diagnosis (e.g., Diabetes, Hypertension, Asthma).
     * **Date of Admission:** Date of patient’s admission.
     * **Doctor:** Name of the attending doctor.
     * **Hospital:** Name of the healthcare facility.
     * **Insurance Provider:** Insurance provider (e.g., Aetna, Blue Cross, Medicare).
     * **Billing Amount:** Total billed amount for the patient's care.
     * **Room Number:** Room where the patient stayed.
     * **Admission Type:** Circumstances of the admission (Emergency, Elective, Urgent).
     * **Discharge Date:** Date of patient’s discharge.
     * **Medication:** Prescribed medication (e.g., Aspirin, Ibuprofen).
     * **Test Results:** Results of any medical tests (Normal, Abnormal, Inconclusive).
     
  ```sql

          CREATE Database Healthcare_db;

          CREATE TABLE healthanalysis 
          (ID INT NOT NULL  AUTO_INCREMENT PRIMARY KEY,
          first_name         VARCHAR(50),
	      last_name          VARCHAR(50),
		age                INT,
		gender             VARCHAR (10),
          blood_type         VARCHAR(10),
          medical_condition  VARCHAR(50),
          dateofadmission    DATE,
          doctor             VARCHAR(50),
          hospital           VARCHAR(50),
          insurance_provider VARCHAR(50),
          billing_amount     DECIMAL (10,2),
          room_number        INT,
          admission_type     VARCHAR(50),
          discharge_date     DATE,
          medication         VARCHAR(50),
          test_result        VARCHAR(20);

```
    


2. **Data Exploration & Cleaning**

   * **Spell Checking:** Correct spelling errors in the dataset.
   * **Removing Duplicate Rows:** Eliminate any duplicate entries.
   * **Finding and Replacing Text:** Standardize text fields where necessary.
   * **Removing Spaces and Non-printing Characters:** Clean up text data.
   * **Fixing Numbers and Signs:** Ensure numerical values are formatted correctly.
   * **Fixing Dates and Times:** Correct date and time formats.
   * **Transforming and Rearranging Columns/Rows:** Organize data for easier analysis.
   * **Key exploration steps:**
     * **Record Count:** Total number of records.
     * **Average Patient Age:** Calculate average age of patients.
     * **Blood Type Distribution:** Explore different blood types.
     * **Medical Condition Categories:** Analyze the most common conditions.
     * **Insurance Provider Breakdown:** Distribution of insurance providers.
     * **Admission Types:** Analyze admission types (Emergency, Elective, Urgent).
     * **Medication Types:** Commonly prescribed medications.
     * **Test Results:** Analyze test results (Normal, Abnormal, Inconclusive).

```sql

        SELECT COUNT(*) FROM healthanalysis;

        ROUND(AVG(age),2) FROM healthanalysis;
   
        SELECT DISTINCT blood_type FROM healthanalysis;

        SELECT DISTINCT medical_condition FROM healthanalysis;

        SELECT DISTINCT insurance_provider FROM healthanalysis;

        SELECT DISTINCT admission_type FROM healthanalysis;

        SELECT DISTINCT medication FROM healthanalysis;

        SELECT DISTINCT test_result FROM healthanalysis;


```
    

    
       

3. **Data Analysis & Findings**

   The following SQL queries were used to answer specific healthcare-related questions and provide valuable insights:

   **1.** **Write a SQL query to get the first and last names of patients admitted on "2020-01-21".**

   
```sql
     SELECT 
        first_name,
        last_name,
        dateofadmission
     FROM healthanalysis
     WHERE dateofadmission="2020-01-21";
```

   **2.** **Write a SQL query to get the billing amounts for patients with the insurance provider "Blue Cross" where the billing amount is greater 
   than 10,000.00 in November 2020.**

   
```sql
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
```

   **3.** **Write a SQL query to calculate the total billing amount for each insurance provider.**

   
```sql
     SELECT 
           insurance_provider,
           SUM(billing_amount) as total_billing_amount
     FROM healthanalysis
     GROUP BY insurance_provider 
     ORDER BY total_billing_amount DESC;
```

   **4.** **Write a SQL query to find the average age of patients who have "Medicare" as their insurance provider.**

   
```sql
      SELECT 
           AVG(age)
      FROM healthanalysis
      WHERE insurance_provider='Medicare';
```

   **5.** **Write a SQL query to find the highest billing amount for each insurance provider.**

   
```sql
      WITH cteRowNum AS (
      SELECT  
		        insurance_provider,
            billing_amount,
	    ROW_NUMBER() OVER(PARTITION BY insurance_provider 
      ORDER BY billing_amount DESC) AS RowNum
	    FROM healthanalysis;)

      SELECT  
            insurance_provider,
            billing_amount
      FROM cteRowNum
      WHERE RowNum in(1)
      ORDER BY billing_amount DESC;
```

   **6.** **Write a SQL query to get the first and last names of patients, along with a list of all medications they are prescribed (concatenated), and the total count of distinct medications for each patient.**

   
```sql
      SELECT 
            first_name,
            last_name,
            GROUP_CONCAT(DISTINCT medication ORDER BY medication) AS medications,
            COUNT(DISTINCT medication) AS total_medications
     FROM  healthanalysis
     GROUP BY 
             first_name,
             last_name
    ORDER BY 
    first_name, last_name;
```

   **7.** **Write a SQL query to count test results by category. Return the results as "Healthy" for "Normal", "Unhealthy" for "Abnormal", and "Test 
Again" for "Inconclusive".**

   
```sql
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
```

   **8.** **Write a SQL query to find the top 5 "luckiest" patients who had normal test results and paid the minimum billing amounts.**

   
```sql
      WITH RankedPatients AS
    (
    SELECT 
        first_name AS PatientFirstName,
        last_name AS PatientLastName,
        billing_amount AS BillingAmount,
        ROW_NUMBER() OVER (ORDER BY billing_amount ASC) AS RowRank
    FROM healthanalysis
    WHERE test_result = 'Normal'
   )
    SELECT 
        PatientFirstName,
        PatientLastName,
        BillingAmount
    FROM 
    RankedPatients
    WHERE 
    RowRank <= 5
    ORDER BY RowRank;
```

   **9.** **Write a SQL query to count the number of patients for each hospital, broken down by the years 2020, 2021, and 2022.**

   
```sql
      SELECT
           first_name,
           last_name,
           dateofadmission,
           discharge_date,
           DATEDIFF(discharge_date,dateofadmission) AS hospitalization_period
      FROM healthanalysis
      ORDER BY first_name ASC;
```

   **10.** **Write a SQL query to count the number of patients for each blood type, and add a column that shows which blood types they are compatible with for receiving blood.**

```sql
      SELECT
         first_name,    
         last_name,
         blood_type,
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
    
```
   
   

   
```sql
```

**Conclusion**

This project provides a comprehensive introduction to SQL for data analysts, focusing on healthcare data. It covers database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The insights gained from this project can help improve healthcare management by understanding patient demographics and medical conditions. Additionally, the analysis can assist insurance providers in making informed decisions by examining patient demographics, medical conditions, and billing trends.

**How to Use**

1. **Clone the Repository:** Clone this project repository from GitHub.
2. **Set Up the Database:** Run the SQL scripts provided in the healthcare_database_setup.sql file to create and populate the healthcare database.
3. **Run the Queries:** Use the SQL queries provided in the analysis_queries.sql file to analyze the healthcare data.
4. **Explore and Modify:** Feel free to modify the queries to explore other aspects of the healthcare dataset or answer additional healthcare-related questions.

**Author - Kubra DIZLEK**

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

**Stay Updated and Join the Community**

To stay updated on SQL, data analysis, and related insights, follow me on social media:
* **LinkedIn:** Connect with me professionally.
* **ORCID:** Connect for a unique research identifier.

I appreciate your support and am excited to connect with you!

---
