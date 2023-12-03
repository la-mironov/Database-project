-- Экземпляр не может быть более чем у одного читателя (триггер)
CREATE OR REPLACE FUNCTION tf_issuance_single()
RETURNS TRIGGER AS
$BODY$
BEGIN
    if(exists (SELECT iss_id
                FROM issuance AS i
                WHERE i.iss_id <> NEW.iss_id
                    AND i.date_iss < COALESCE(NEW.date_ret, NOW())
                    AND COALESCE(i.date_ret, NOW()) > NEW.date_iss
                )
    )
    then 
        raise exception 'Экземпляр находится у двух читателей';
        return NULL;
    end if;
    return NEW;
END;
$BODY$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS tg_issuance_single_bef_ins_upd ON issuance;
-- Триггер перед обновлением или вставкой каждой строки таблицы issuance
CREATE TRIGGER tg_issuance_single_bef_ins_upd
BEFORE UPDATE OR INSERT ON issuance
FOR EACH ROW
EXECUTE PROCEDURE tf_issuance_single();
--------------------------------------------------------------------------------------
-- Один директор и один главбух для одной библиотеки (триггер)
-- Для всех сотрудников из всех отделов одной библиотеки должен быть один директор и один главбух
-- Срабатывает при обновлении и добавлении в employee (Сотрудник)
CREATE OR REPLACE FUNCTION tf_employee_superiors()
RETURNS TRIGGER AS
$BODY$
DECLARE
    target_post_name CHARACTER(6);
    target_dep_id CHARACTER(6);
    target_lib_id CHARACTER(6);
BEGIN
    -- Вывести ошибку при отсутствии директора и главбуха в должностях
    if(not(exists (SELECT name FROM post WHERE name = 'Директор')
        and exists (SELECT name FROM post WHERE name = 'Главный бухгалтер')))
    then 
        raise exception 'В должностях нет Директора и Главного бухгалтера! Обновите таблицу post или триггер %', TG_NAME;
    end if;

    SELECT name INTO target_post_name FROM post WHERE post_id = NEW.post_id;

    if(target_post_name = 'Директор' or target_post_name = 'Главный бухгалтер')
    then
        target_dep_id = NEW.dep_id;

        SELECT lib_id
        INTO target_lib_id
        FROM department AS d
        WHERE d.dep_id = target_dep_id;

        -- Если существует в сотрудниках из всех отделов определенной библиотеки должность target_post_name
        if(exists( SELECT *
                    FROM employee AS e
                        JOIN department AS d ON e.dep_id = d.dep_id
                        JOIN post AS p ON e.post_id = p.post_id
                    WHERE d.lib_id = target_lib_id
                        AND p.name = target_post_name
                )
        )
        then
            raise exception '% в библиотеке % уже существует!', target_post_name, (SELECT name FROM library WHERE lib_id = target_lib_id);
        end if;

    end if;

    return NEW;
END;
$BODY$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS tg_employee_superiors_bef_ins_upd ON employee;
-- Триггер перед обновлением или вставкой каждой строки таблицы employee
CREATE TRIGGER tg_employee_superiors_bef_ins_upd
BEFORE UPDATE OR INSERT ON employee
FOR EACH ROW
EXECUTE PROCEDURE tf_employee_superiors();

-- Информация о триггерах
SELECT trigger_name, event_manipulation, event_object_table, action_statement, action_orientation, action_timing
FROM information_schema.triggers; 

--------------------------------------------------------------------------------------
-- Сотрудник может быть управляющим только одного отдела (UNIQUE в department для manager_id)
ALTER TABLE ONLY department ADD CONSTRAINT manager_only_one_department UNIQUE(manager_id);
--------------------------------------------------------------------------------------
-- Аналогично для заведующего в читательный зал
ALTER TABLE ONLY reading_room ADD CONSTRAINT manager_only_one_room UNIQUE(manager_id);
