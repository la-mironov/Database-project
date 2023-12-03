-- Экземпляр не может быть более чем у одного читателя (триггер)
CREATE OR REPLACE FUNCTION tf_issuance_single()
RETURNS TRIGGER AS
$BODY$
BEGIN
    if(exists (SELECT iss_id
                FROM issuance AS i
                WHERE i.iss_id <> NEW.iss_id
                    AND i.date_iss < CASE WHEN NEW.date_ret IS NULL
                                        THEN NOW()
                                        ELSE NEW.date_ret
                                        END
                    AND
                    CASE WHEN i.date_ret IS NULL
                        THEN NOW()
                        ELSE i.date_ret
                    END > NEW.date_iss
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

-- Списанных изделий не может быть больше, чем поставленных (триггер)
-- Сотрудник может быть управляющим только одного отдела (UNIQUE в department для manager_id)
-- Аналогично для заведующего в читательный зал
-- Взяли экземпляров не больше, чем в наличии (сложный триггер)
-- Один директор и один главбух для одной библиотеки (триггер)

