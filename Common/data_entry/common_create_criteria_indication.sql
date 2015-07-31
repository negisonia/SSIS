CREATE OR REPLACE FUNCTION common_create_criteria_indication(new_criteria_id INTEGER, new_indication_id INTEGER) --DATA ENTRY
RETURNS BOOLEAN AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
valueExists BOOLEAN DEFAULT FALSE;
BEGIN

SELECT EXISTS (SELECT 1 FROM criteria_indications ci WHERE ci.criterium_id=new_criteria_id AND ci.indication_id=new_indication_id LIMIT 1) INTO valueExists;

--VALIDATE IF THE CRITERIA INDICATION ALREADY EXISTS
IF valueExists IS FALSE THEN
  --INSERT CRITERIA INDICATION RECORD
INSERT INTO criteria_indications(criterium_id, indication_id)
VALUES (new_criteria_id, new_indication_id);

END IF;

success :=TRUE;
return success;
END
$$ LANGUAGE plpgsql;
