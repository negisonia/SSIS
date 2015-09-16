CREATE OR REPLACE FUNCTION common_create_drug_class_indication(new_indication_id INTEGER, new_drug_class_id INTEGER) --DATA ENTRY
RETURNS BOOLEAN AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
valueExists BOOLEAN DEFAULT FALSE;

BEGIN
SELECT EXISTS (SELECT 1 FROM drugclass_indications dci WHERE dci.drug_class_id=new_drug_class_id AND dci.indication_id=new_indication_id  LIMIT 1) INTO valueExists;
--VALIDATE IF THE DRUG CLASS INDICATION ALREADY EXISTS
IF valueExists IS FALSE THEN
  --INSERT DRUG CLASS INDICATION RECORD
 INSERT INTO drugclass_indications(drug_class_id, indication_id)
 VALUES (new_drug_class_id, new_indication_id);
END IF;

success:=TRUE;
return success;
END
$$ LANGUAGE plpgsql;
