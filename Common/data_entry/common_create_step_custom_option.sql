CREATE OR REPLACE FUNCTION common_create_step_custom_option(new_custom_option_id INTEGER, new_custom_type VARCHAR) --DATA ENTRY
RETURNS INTEGER AS $$
DECLARE
custom_option_id INTEGER DEFAULT NULL;
BEGIN
SELECT sco.id INTO custom_option_id FROM step_custom_options sco WHERE sco.customizable_id=new_custom_option_id and sco.customizable_type=new_custom_type LIMIT 1;

--VALIDATE IF THE STEP CUSTOM OPTION  ALREADY EXISTS
IF custom_option_id IS NULL THEN
  --INSERT STEP CUSTOM OPTION RECORD
  INSERT INTO step_custom_options(customizable_id, customizable_type)
  VALUES (new_custom_option_id, new_custom_type) RETURNING id INTO custom_option_id;
  RETURN custom_option_id;
ELSE
  RETURN custom_option_id;
END IF;
END
$$ LANGUAGE plpgsql;
