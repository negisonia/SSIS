CREATE OR REPLACE FUNCTION common_create_pbm_healthplan_pharmacy(new_pbm_specialty_pharmacy_id INTEGER, new_health_plan_id INTEGER, is_active BOOLEAN) --FF_NEW DB
RETURNS BOOLEAN AS $$
DECLARE
record_inserted BOOLEAN DEFAULT NULL;
BEGIN

SELECT TRUE INTO record_inserted FROM pbm_healthplan_pharmacy WHERE healthplanid_fk=new_health_plan_id AND pharmacyid_fk=new_pbm_specialty_pharmacy_id LIMIT 1;

--VALIDATE IF RECORD EXISTS
IF record_inserted IS NULL THEN

  --INSERT RECORD
  INSERT INTO pbm_healthplan_pharmacy(
            healthplanid_fk, pharmacyid_fk, last_update, effective_date, 
            creatorid_fk, create_stamp, modbyid_fk, mod_stamp, active)
    VALUES (new_health_plan_id, new_pbm_specialty_pharmacy_id, NULL, NULL, 
            NULL, NULL, NULL, NULL, CASE when is_active IS TRUE THEN 1 ELSE 0 END) RETURNING TRUE INTO record_inserted;
    
  RETURN record_inserted;
ELSE
  RETURN record_inserted;
END IF;
END
$$ LANGUAGE plpgsql;
