CREATE OR REPLACE FUNCTION common_create_pbm_specialty_pharmacy_specialization(new_name VARCHAR, is_active BOOLEAN, specialty_pharmacy_id INTEGER, new_description VARCHAR) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
pbm_specialty_pharmacy_specialization_id INTEGER DEFAULT NULL;
BEGIN

SELECT id INTO pbm_specialty_pharmacy_specialization_id FROM pbm_specialty_pharmacy_specialization WHERE description=new_description LIMIT 1;

--VALIDATE IF RECORD EXISTS
IF pbm_specialty_pharmacy_specialization_id IS NULL THEN   

INSERT INTO pbm_specialty_pharmacy_specialization(
            active, pharmacyid_fk, description, url, creatorid_fk, create_stamp, 
            modbyid_fk, mod_stamp)
    VALUES (is_active, specialty_pharmacy_id, new_description, NULL, NULL, NULL, 
            NULL, NULL) RETURNING id INTO pbm_specialty_pharmacy_specialization_id;
    
  RETURN pbm_specialty_pharmacy_specialization_id;
ELSE
  RETURN pbm_specialty_pharmacy_specialization_id;
END IF;
END
$$ LANGUAGE plpgsql;

