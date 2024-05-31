-- Fonction 1: GET_NB_WORKERS

CREATE OR REPLACE FUNCTION GET_NB_WORKERS(FACTORY_NUMBER NUMBER) RETURN NUMBER AS
    nb_workers NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO nb_workers
    FROM ALL_WORKERS
    WHERE factory_id = FACTORY_NUMBER;
    
    RETURN nb_workers;
END;
-- Fonction 2: GET_NB_BIG_ROBOTS
CREATE OR REPLACE FUNCTION GET_NB_BIG_ROBOTS RETURN NUMBER AS
    nb_big_robots NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO nb_big_robots
    FROM ROBOTS_FACTORIES rf
    JOIN ROBOTS r ON rf.robot_id = r.id
    WHERE r.pieces > 3
      AND rf.factory_id = FACTORY_NUMBER; -- vérifie  pour quelle usine ces robots ont été assemblés( partie réaliser avec un camarades)
    RETURN nb_big_robots;
END;

-- Fonction 3: GET_BEST_SUPPLIER
CREATE OR REPLACE FUNCTION GET_BEST_SUPPLIER RETURN VARCHAR2(100) AS
    best_supplier VARCHAR2(100);
BEGIN
    SELECT name
    INTO best_supplier
    FROM (
        SELECT name, SUM(quantity) AS total_pieces
        FROM (
            SELECT name, quantity
            FROM SUPPLIERS_BRING_TO_FACTORY_1
            UNION ALL
            SELECT name, quantity
            FROM SUPPLIERS_BRING_TO_FACTORY_2
        )
        GROUP BY name
        ORDER BY total_pieces DESC 
    )
    WHERE ROWNUM = 1;
    
    RETURN best_supplier;
END;

-- Fonction 4: GET_OLDEST_WORKER ( Pour ce fonction j'ai pas pu la faire tous seul)
CREATE OR REPLACE FUNCTION GET_OLDEST_WORKER RETURN NUMBER AS
    oldest_worker_id NUMBER;
BEGIN
    SELECT id
    INTO oldest_worker_id
    FROM (
        SELECT id, start_date
        FROM ALL_WORKERS
        ORDER BY start_date ASC
    )
    WHERE ROWNUM = 1;
    
    RETURN oldest_worker_id;
END;

----------------------------------------
--Partie Procedures

-- Création de la procédure SEED_DATA_WORKERS(réaliser avec de l'aide sur internet)
CREATE OR REPLACE PROCEDURE SEED_DATA_WORKERS(NB_WORKERS NUMBER, FACTORY_ID NUMBER) AS
BEGIN
    FOR i IN 1..NB_WORKERS LOOP
        INSERT INTO WORKERS_FACTORY_1 (first_name, last_name, age, first_day)
        VALUES ('worker_f_' || i, 'worker_l_' || i, FLOOR(DBMS_RANDOM.VALUE(20, 60)), 
                TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2065-01-01','J'), TO_CHAR(DATE '2070-01-01','J'))), 'J'));
    END LOOP;
END;
/

-- Création de la procédure ADD_NEW_ROBOT
CREATE OR REPLACE PROCEDURE ADD_NEW_ROBOT(MODEL_NAME VARCHAR2(50)) AS
BEGIN
    INSERT INTO ROBOTS (model)
    VALUES (MODEL_NAME);
END;
/

-- Création de la procédure SEED_DATA_SPARE_PARTS
CREATE OR REPLACE PROCEDURE SEED_DATA_SPARE_PARTS(NB_SPARE_PARTS NUMBER) AS
BEGIN
    FOR i IN 1..NB_SPARE_PARTS LOOP
        INSERT INTO SPARE_PARTS (ID, COLOR, NAME)
        VALUES (i, 'random_color', 'spare_part_' || i);
    END LOOP;
END;
/
