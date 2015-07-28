CREATE OR REPLACE FUNCTION common_create_indication(indication_name VARCHAR, indication_abbreviation VARCHAR) --DATA ENTRY
RETURNS INTEGER AS $$
DECLARE
indication_id INTEGER DEFAULT NULL;
BEGIN

SELECT i.id INTO indication_id FROM indications i WHERE i.name=indication_name OR i.abbreviation=indication_abbreviation  LIMIT 1;

--VALIDATE IF THE INDICATION ALREADY EXISTS
IF indication_id IS NULL THEN
  --INSERT COUNTY RECORD
  INSERT INTO indications(name, created_at, updated_at, abbreviation, name_no_punc)
  VALUES ( indication_name, current_timestamp, current_timestamp, indication_abbreviation, indication_name) RETURNING id INTO indication_id;
  RETURN indication_id;
ELSE
  RETURN indication_id;
END IF;

END
$$ LANGUAGE plpgsql;
