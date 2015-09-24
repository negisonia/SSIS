CREATE OR REPLACE FUNCTION common_create_pbm_specialty_pharmacy(new_name VARCHAR, is_active BOOLEAN) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
pbm_specialty_pharmacy_id INTEGER DEFAULT NULL;
BEGIN

SELECT id INTO pbm_specialty_pharmacy_id FROM pbm_specialty_pharmacy WHERE name=new_name LIMIT 1;

--VALIDATE IF THE HEALTH PLAN DOESNT EXISTS
IF pbm_specialty_pharmacy_id IS NULL THEN   

  --INSERT  HEALTH PLAN RECORD
  INSERT INTO pbm_specialty_pharmacy(
            active, name, corp_owner, address1, address2, city, state_fk, 
            zip, phone1, fax, email, url_main, creatorid_fk, create_stamp, 
            modbyid_fk, mod_stamp)
    VALUES (CASE when is_active IS TRUE THEN 1 ELSE 0 END, new_name, NULL, NULL, NULL, NULL, NULL, 
            NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
            NULL, NULL) RETURNING id INTO pbm_specialty_pharmacy_id;
    
  RETURN pbm_specialty_pharmacy_id;
ELSE
  RETURN pbm_specialty_pharmacy_id;
END IF;
END
$$ LANGUAGE plpgsql;

