--vu question1
CREATE VIEW ALL_WORKERS AS
SELECT first_name, last_name, age, first_day 
FROM WORKERS_FACTORY_1
UNION ALL
SELECT first_name, last_name, null, start_date
FROM WORKERS_FACTORY_2
WHERE end_date IS NULL
ORDER BY first_day DESC; 



--vu question 2

CREATE  OR REPLACE VIEW ALL_WORKERS_ELAPSED AS
SELECT first_name, last_name, age, first_day, CURRENT_DATE -first_day AS days_elapsed
FROM ALL_WORKERS;

--vu question3

CREATE VIEW BEST_SUPPLIERS AS
SELECT supplier_id, COUNT(*) AS pieces_delivered
FROM SUPPLIERS_BRING_TO_FACTORY_1
GROUP BY supplier_id
UNION ALL
SELECT supplier_id, COUNT(*) AS pieces_delivered
FROM SUPPLIERS_BRING_TO_FACTORY_2
GROUP BY supplier_id
HAVING SUM(quantity) > 1000
ORDER BY pieces_delivered DESC;

-- vu question4


CREATE VIEW ROBOTS_FACTORIES AS
SELECT r.id AS robot_id, rf.factory_id
FROM ROBOTS_FROM_FACTORY rf
JOIN ROBOTS r ON rf.robot_id = r.id;