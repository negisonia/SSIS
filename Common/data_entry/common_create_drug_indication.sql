CREATE OR REPLACE FUNCTION common_create_drug_indication(new_indication_id INTEGER, new_drug_id INTEGER) --DATA ENTRY
RETURNS BOOLEAN AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
valueExists BOOLEAN DEFAULT FALSE;
BEGIN

SELECT EXISTS (SELECT 1 FROM drug_indications di WHERE di.drug_id=new_drug_id AND di.indication_id=new_indication_id  LIMIT 1) INTO valueExists;

--VALIDATE IF THE DRUG INDICATION ALREADY EXISTS
IF valueExists IS FALSE THEN
  --INSERT COUNTY RECORD
  INSERT INTO drug_indications(drug_id, indication_id)
  VALUES (new_drug_id, new_indication_id);
END IF;

success :=TRUE;
return success;
END
$$ LANGUAGE plpgsql;
