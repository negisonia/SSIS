CREATE OR REPLACE FUNCTION common_create_custom_option(custom_option_name VARCHAR) --DATA ENTRY
RETURNS INTEGER AS $$
DECLARE
custom_option_id INTEGER DEFAULT NULL;
BEGIN

SELECT co.id INTO custom_option_id FROM custom_options co WHERE co.name=custom_option_name  LIMIT 1;

--VALIDATE IF THE CUSTOM OPTION ALREADY EXISTS
IF custom_option_id IS NULL THEN
  --INSERT CRITERIA RECORD
   INSERT INTO custom_options(
               name)
       VALUES (custom_option_name) RETURNING id INTO custom_option_id;
  RETURN custom_option_id;
ELSE
  RETURN custom_option_id;
END IF;

END
$$ LANGUAGE plpgsql;
