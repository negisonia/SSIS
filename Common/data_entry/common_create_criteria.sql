CREATE OR REPLACE FUNCTION common_create_criteria(criteria_name VARCHAR, criteria_value_name BOOLEAN, criteria_active BOOLEAN) --DATA ENTRY
RETURNS INTEGER AS $$
DECLARE
criteria_id INTEGER DEFAULT NULL;
BEGIN

SELECT c.id INTO criteria_id FROM criteria c WHERE c.name=criteria_name AND c.value_range=criteria_value_name AND c.active=criteria_active  LIMIT 1;

--VALIDATE IF THE CRITERIA ALREADY EXISTS
IF criteria_id IS NULL THEN
  --INSERT CRITERIA RECORD
  INSERT INTO criteria(name, value_range, active, notes, created_at, updated_at, description, name_no_punc, created_by, updated_by)
  VALUES ( criteria_name, criteria_value_name, criteria_active, NULL, current_timestamp, current_timestamp,NULL, NULL, 1, 1) RETURNING id INTO criteria_id;
  RETURN criteria_id;
ELSE
  RETURN criteria_id;
END IF;

END
$$ LANGUAGE plpgsql;
