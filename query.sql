## створення таблиці смертності
SELECT
`Територіальний розріз` AS region,

SUM(CASE WHEN `Стать` = 'Жінки' THEN `2021` ELSE 0 END) AS deaths_female,

SUM(CASE WHEN `Стать` = 'Чоловіки' THEN `2021` ELSE 0 END) AS deaths_male,

SUM(CASE WHEN `Стать` IN ('Жінки', 'Чоловіки') THEN `2021` ELSE 0 END) AS total_deaths

FROM `my-project-2-495117.test_data_Olga.my_table_death_2021`

WHERE
`Тип місцевості` = 'Загалом'
AND `Періодичність` = 'Річна'
AND `Вік` = 'Усього'
AND `2021` IS NOT NULL

GROUP BY region
ORDER BY total_deaths DESC;

## створення таблиці народжуванності 
SELECT
`Територіальний розріз` AS region,

SUM(CASE WHEN `Стать` = 'Жінки' THEN `2021` ELSE 0 END) AS births_female,
SUM(CASE WHEN `Стать` = 'Чоловіки' THEN `2021` ELSE 0 END) AS births_male,

SUM(CASE WHEN `Стать` IN ('Жінки', 'Чоловіки') THEN `2021` ELSE 0 END) AS total_births_2021

FROM `my-project-2-495117.test_data_Olga.my_table_birth`

WHERE
`_Показник_` = 'Кількість живонароджених'
AND `Вік матері` = 'Усього'
AND `Вік батька` = 'Усього'
AND `Тип місцевості` = 'Загалом'
AND `Періодичність` = 'Річна'
AND `2021` IS NOT NULL

GROUP BY region
ORDER BY total_births_2021 DESC;

## створення таблиці - середньої заробітної плати
SELECT
`Територіальний розріз` AS region,

ROUND((
IFNULL(`2021-M01`, 0) +
IFNULL(`2021-M02`, 0) +
IFNULL(`2021-M03`, 0) +
IFNULL(`2021-M04`, 0) +
IFNULL(`2021-M05`, 0) +
IFNULL(`2021-M06`, 0) +
IFNULL(`2021-M07`, 0) +
IFNULL(`2021-M08`, 0) +
IFNULL(`2021-M09`, 0) +
IFNULL(`2021-M10`, 0) +
IFNULL(`2021-M11`, 0) +
IFNULL(`2021-M12`, 0)
) / 12, 0) AS avg_salary_2021

FROM `my-project-2-495117.test_data_Olga.salary`

WHERE
`_Показник_` LIKE '%заробітн%'
AND `Вид економічної діяльності` = 'Усього'
AND `Періодичність` = 'Місячна'

ORDER BY avg_salary_2021 DESC;

## обєднання всіх таблиць 
CREATE OR REPLACE TABLE `my-project-2-495117.test_data_Olga.final_2021` AS

SELECT
s.region,

s.avg_salary_2021,

d.deaths_female,
d.deaths_male,
d.total_deaths,

b.births_female,
b.births_male,
b.total_births_2021

FROM `my-project-2-495117.test_data_Olga.salary_2021_clean` s

LEFT JOIN `my-project-2-495117.test_data_Olga.deaths_2021_clean` d
ON TRIM(LOWER(s.region)) = TRIM(LOWER(d.region))

LEFT JOIN `my-project-2-495117.test_data_Olga.births_2021_clean` b
ON TRIM(LOWER(s.region)) = TRIM(LOWER(b.region))









