CREATE OR REPLACE FUNCTION common_create_criteria_restriction(new_criteria_id INTEGER, new_restriction_id INTEGER) --DATA ENTRY
RETURNS BOOLEAN AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
valueExists BOOLEAN DEFAULT FALSE;
BEGIN

SELECT EXISTS (SELECT 1 FROM criteria_restrictions cr WHERE cr.criterium_id=new_criteria_id AND cr.restriction_id=new_restriction_id LIMIT 1) INTO valueExists;

--VALIDATE IF THE CRITERIA RESTRICTION ALREADY EXISTS
IF valueExists IS FALSE THEN
  --INSERT CRITERIA RESTRICTION RECORD
  INSERT INTO criteria_restrictions(criterium_id, restriction_id)
  VALUES (new_criteria_id, new_restriction_id);
END IF;

success :=TRUE;
return success;
END
$$ LANGUAGE plpgsql;
