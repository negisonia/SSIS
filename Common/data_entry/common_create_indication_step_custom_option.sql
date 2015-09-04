CREATE OR REPLACE FUNCTION common_create_indications_step_custom_options(new_indication_id INTEGER, new_step_custom_option_id INTEGER) --DATA ENTRY
RETURNS BOOLEAN AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
booleanValue BOOLEAN DEFAULT FALSE;
BEGIN

SELECT EXISTS(SELECT 1 FROM indications_step_custom_options i WHERE i.indication_id=new_indication_id AND i.step_custom_option_id= new_step_custom_option_id  LIMIT 1) into booleanValue;

--VALIDATE IF THE INDICATION ALREADY EXISTS
IF booleanValue IS FALSE THEN
  --INSERT INDICATION STEP CUSTOM OPTION RECORD
  INSERT INTO indications_step_custom_options(indication_id, step_custom_option_id)
  VALUES (new_indication_id, new_step_custom_option_id);

END IF;

success:= true;
RETURN success;

END
$$ LANGUAGE plpgsql;
