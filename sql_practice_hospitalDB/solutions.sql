-- (1) Show first name, last name, and gender of patients whose gender is 'M'

SELECT
	first_name,
    last_name,
    gender
FROM patients
	WHERE gender = 'M'

-- (2) Show first name and last name of patients who does not have allergies. (null)

SELECT
	first_name,
    last_name
FROM patients
	WHERE allergies IS NULL

-- (3) Show first name of patients that start with the letter 'C'

SELECT
	first_name
FROM patients
	WHERE first_name LIKE 'C%'

-- (4) Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)

SELECT
	first_name,
    last_name
FROM patients
	WHERE weight between 100 AND 120

-- (5) Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'

UPDATE patients SET allergies = 'NKA' WHERE allergies IS NULL

-- (6) Show first name and last name concatinated into one column to show their full name.

SELECT
	CONCAT(first_name," ",last_name)
FROM patients

-- (7) Show first name, last name, and the full province name of each patient.

select
	p.first_name,
    p.last_name,
    pn.province_name
FROM patients p
	INNER JOIN province_names pn ON p.province_id = pn.province_id

-- (8) Show how many patients have a birth_date with 2010 as the birth year.

SELECT
	count(*)
FROM patients
	WHERE YEAR(birth_date) = 2010

-- (9) Show the first_name, last_name, and height of the patient with the greatest height.

SELECT
	first_name,
    last_name,
    MAX(height)
FROM patients

-- (10) Show all columns for patients who have one of the following patient_ids: 1,45,534,879,1000

SELECT
	*
FROM patients
	WHERE patient_id IN(1,45,534,879,1000)


-- (11) Show the total number of admissions 

SELECT
	COUNT(*)
FROM admissions

-- (12) Show all the columns from admissions where the patient was admitted and discharged on the same day.

SELECT
	*
FROM admissions
	WHERE admission_date = discharge_date    

-- (13) Show the patient id and the total number of admissions for patient_id 579. 

SELECT
	patient_id,
    COUNT(*)
FROM admissions
	WHERE patient_id = 579    

-- (14) Based on the cities that our patients live in, show unique cities that are in province_id 'NS'. 

SELECT
	pn.province_name
FROM patients p
	INNER JOIN province_names pn ON p.province_id = pn.province_id
    WHERE pn.province_id = 'NS'     

-- (15) Write a query to find the first_name, last name and birth date of patients who has height greater than 160 and weight greater than 70   

SELECT
	first_name, 
    last_name,
    birth_date
FROM patients
	WHERE height > 160 and weight > 70   

-- (16) Write a query to find list of patients first_name, last_name, and allergies where allergies are not null and are from the city of 'Hamilton' 

SELECT
	first_name,
    last_name,
    allergies
from patients
	WHERE allergies IS NOT NULL AND city = 'Hamilton' 

-- (17) Show unique birth years from patients and order them by ascending.  

SELECT
	DISTINCT year(birth_date)
FROM patients
	ORDER BY year(birth_date) ASC  

-- (18) Show unique first names from the patients table which only occurs once in the list. For example, if two or more people are named 'John' in the first_name column then don't include their name in the output list. If only 1 person is named 'Leo' then include them in the output.  

SELECT
	first_name
FROM patients
	GROUP BY first_name
	HAVING COUNT(first_name) = 1   

-- (19) Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.  

SELECT
	patient_id,
    first_name
FROM patients
	WHERE first_name LIKE 's%s' 
    AND LENGTH(first_name) >= 6
	
-- (20) Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'. Primary diagnosis is stored in the admissions table.

SELECT
	p.patient_id,
    p.first_name,
    p.last_name
FROM patients p
	INNER JOIN admissions ad ON p.patient_id = ad.patient_id
    WHERE ad.diagnosis = 'Dementia'