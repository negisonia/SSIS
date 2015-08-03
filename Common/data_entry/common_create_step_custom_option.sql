CREATE OR REPLACE FUNCTION common_create_step_custom_option(new_custom_option_id INTEGER, new_custom_type VARCHAR) --DATA ENTRY
RETURNS BOOLEAN AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
valueExists BOOLEAN DEFAULT FALSE;
BEGIN

SELECT EXISTS (SELECT 1 FROM step_custom_options sco WHERE sco.customizable_id=new_custom_option_id and sco.customizable_type=new_custom_type LIMIT 1) INTO valueExists;

--VALIDATE IF THE STEP CUSTOM OPTION  ALREADY EXISTS
IF valueExists IS FALSE THEN
  --INSERT STEP CUSTOM OPTION RECORD
  INSERT INTO step_custom_options(customizable_id, customizable_type)
  VALUES (new_custom_option_id, new_custom_type);

END IF;

success :=TRUE;
return success;
END
$$ LANGUAGE plpgsql;
