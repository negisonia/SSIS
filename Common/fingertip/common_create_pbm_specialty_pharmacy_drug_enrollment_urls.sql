CREATE OR REPLACE FUNCTION common_create_pbm_specialty_pharmacy_drug_enrollment_urls(new_pbm_specialty_pharmacy_id INTEGER, new_drug_id INTEGER, new_url varchar) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
pbm_specialty_pharmacy_drug_enrollment_urls_id INTEGER DEFAULT NULL;
BEGIN

SELECT id INTO pbm_specialty_pharmacy_drug_enrollment_urls_id FROM pbm_specialty_pharmacy_drug_enrollment_urls WHERE pbm_specialty_pharmacy_id=new_pbm_specialty_pharmacy_id AND drug_id=new_drug_id AND url=new_url LIMIT 1;

--VALIDATE IF THE HEALTH PLAN DOESNT EXISTS
IF pbm_specialty_pharmacy_drug_enrollment_urls_id IS NULL THEN

  --INSERT RECORD
  INSERT INTO pbm_specialty_pharmacy_drug_enrollment_urls(
            pbm_specialty_pharmacy_id, drug_id, url, created_at, updated_at)
    VALUES (new_pbm_specialty_pharmacy_id, new_drug_id, new_url, current_timestamp, current_timestamp) RETURNING id INTO pbm_specialty_pharmacy_drug_enrollment_urls_id;
    
  RETURN pbm_specialty_pharmacy_drug_enrollment_urls_id;
ELSE
  RETURN pbm_specialty_pharmacy_drug_enrollment_urls_id;
END IF;
END
$$ LANGUAGE plpgsql;

