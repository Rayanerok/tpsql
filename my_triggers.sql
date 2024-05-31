--Pour cette partie de Triggers  je me suis beaucoup penché sur la documentation sur internet monsieur 


-- Trigger pour intercepter les insertions dans la vue ALL_WORKERS_ELAPSED
CREATE OR REPLACE TRIGGER INSERT_WORKER_ELAPSED_TRIGGER
INSTEAD OF INSERT ON ALL_WORKERS_ELAPSED
FOR EACH ROW
BEGIN
    IF :NEW.factory_id IS NOT NULL THEN
        INSERT INTO WORKERS_FACTORY_1 (first_name, last_name, age, first_day)
        VALUES (:NEW.first_name, :NEW.last_name, :NEW.age, :NEW.start_date);
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Insertion dans ALL_WORKERS_ELAPSED non autorisée.');
    END IF;
END;
/

-- Trigger pour enregistrer la date d'ajout d'un nouveau robot dans la table AUDIT_ROBOT
CREATE OR REPLACE TRIGGER AUDIT_ROBOT_TRIGGER
AFTER INSERT ON ROBOTS
FOR EACH ROW
BEGIN
    INSERT INTO AUDIT_ROBOT (robot_id, added_date)
    VALUES (:NEW.id, SYSDATE);
END;
/

-- Trigger pour empêcher les modifications de données via la vue ROBOTS_FACTORIES si le nombre d'usines ne correspond pas au nombre de tables WORKERS_FACTORY_<N>
CREATE OR REPLACE TRIGGER CHECK_FACTORY_COUNT_TRIGGER
BEFORE INSERT OR UPDATE ON ROBOTS_FACTORIES
FOR EACH ROW
DECLARE
    factory_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO factory_count
    FROM USER_TABLES
    WHERE TABLE_NAME LIKE 'WORKERS_FACTORY\_%';
    
    IF factory_count <> (SELECT COUNT(*) FROM FACTORIES) THEN
        RAISE_APPLICATION_ERROR(-20002, 'Nombre incorrect d''usines dans la base de données.');
    END IF;
END;
/

-- Trigger pour calculer la durée du temps passé dans l'usine lors de l'ajout d'une date de départ pour un travailleur
CREATE OR REPLACE TRIGGER CALCULATE_WORKER_DURATION_TRIGGER
BEFORE UPDATE OF end_date ON WORKERS_FACTORY_2
FOR EACH ROW
BEGIN
    IF :NEW.end_date IS NOT NULL THEN
        :NEW.duration := :NEW.end_date - :OLD.start_date;
    END IF;
END;
/
