-- DATA CLEAING

-- FIRST WE ARE LOOKING DUPLICATE


SELECT *
FROM layoffs_staging;

WITH duplicate_CETs AS

(	
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging
) 
SELECT *
FROM duplicate_CETs
WHERE row_num >1;


-- CREATE TEMPORARY TABLE AND INSERT THE SAME VALUES

SELECT *
FROM layoffs_staging2; 

-- CREATE TABLE layoffs_staging2
-- LIKE layoffs_staging ;     SIDAAAN MALOO SAMEEYO WAXAA LAGA SAMEEYAA COPY GA VISUALIZATION KA AH WAXAANA KUDAREENAA COLUMN ROW_NUMBER AH

SELECT *
FROM layoffs_staging2;CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `raw_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- INSERT INTO THE COPY TABLE


INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging;


-- DELETE THE DUPLICATE VALUES

SET SQL_SAFE_UPDATES = 0; -- IF MYSQL UPDATE IS ON USE THIS CODE TO SHUT-DOWN


DELETE
FROM layoffs_staging2
WHERE row_num > 1;


SELECT *
FROM layoffs_staging2
;


-- Standardizing Data 
		-- Sida Data-da loosaxo Row-ga halka uu kabilaabanayo Space haduu kujiro kabixi

SELECT company, TRIM(company)
FROM layoffs_staging2;


UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT country , TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1
;


UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE industry LIKE 'United States%';


SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y') AS Date_Time
From layoffs_staging2;


UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');



-- CHANGE date COLUMN DATETYPE

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;



-- HANDLING THE MISSING , NULL  OR BLANK VALUES

		
        -- FINDING THE NULL VALUE OF INDUSTRY COLUMN
        
        SELECT *
        FROM layoffs_staging2
        WHERE company LIKE 'Bally%';
        
        SELECT *
        FROM layoffs_staging2
        WHERE industry IS NULL OR industry = '';
        
        -- LET ME UPDATE THE BLANK VALUS TO NULL VALUSE
        
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';
        
        
SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    WHERE t1.industry  IS  NULL  
    AND t2.industry IS NOT NULL;


-- UPDATING THE MISSING VALUS OF COLUMN INDUSTRY 

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    SET t1.industry = t2.industry
WHERE t1.industry  IS  NULL  
    AND t2.industry IS NOT NULL; 


-- SELECTING THE MISSING VALUE OF COLUMN total_laid_off AND percentage_laid_off

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- DROPING THE COLUMN THAT WE ADDED THE COPY TABLE


ALTER TABLE layoffs_staging2
DROP COLUMN row_num;












