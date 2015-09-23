CREATE OR REPLACE FUNCTION common_create_pbm_specialty_pharmacy_drugs(new_health_plan_id INTEGER, new_pbm_specialty_pharmacy_id INTEGER, new_drug_id INTEGER) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
pbm_specialty_pharmacy_drugs_id INTEGER DEFAULT NULL;
BEGIN

SELECT id INTO pbm_specialty_pharmacy_drugs_id FROM pbm_specialty_pharmacy_drugs WHERE health_plan_id=new_health_plan_id AND pbm_specialty_pharmacy_id=new_pbm_specialty_pharmacy_id AND drug_id=new_drug_id LIMIT 1;

--VALIDATE IF THE HEALTH PLAN DOESNT EXISTS
IF pbm_specialty_pharmacy_drugs_id IS NULL THEN   

  INSERT INTO pbm_specialty_pharmacy_drugs(
            health_plan_id, pbm_specialty_pharmacy_id, drug_id, created_at, 
            updated_at)
    VALUES (new_health_plan_id, new_pbm_specialty_pharmacy_id, new_drug_id, current_timestamp, 
            current_timestamp) RETURNING id INTO pbm_specialty_pharmacy_drugs_id;
    
  RETURN pbm_specialty_pharmacy_drugs_id;
ELSE
  RETURN pbm_specialty_pharmacy_drugs_id;
END IF;
END
$$ LANGUAGE plpgsql;

