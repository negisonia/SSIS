CREATE OR REPLACE FUNCTION common_create_indications_step_custom_options(new_indication_id INTEGER, new_step_custom_option_id INTEGER) --DATA ENTRY
RETURNS INTEGER AS $$
DECLARE
booleanValue BOOLEAN DEFAULT FALSE;
indication_step_id INTEGER;

BEGIN

SELECT EXISTS(SELECT 1 FROM indications_step_custom_options i WHERE i.indication_id=new_indication_id AND i.step_custom_option_id= new_step_custom_option_id  LIMIT 1) into booleanValue;

--VALIDATE IF THE INDICATION ALREADY EXISTS
IF booleanValue IS FALSE THEN
  --INSERT INDICATION STEP CUSTOM OPTION RECORD
  INSERT INTO public.indications_step_custom_options(indication_id, step_custom_option_id)
  VALUES (new_indication_id, new_step_custom_option_id) RETURNING id INTO indication_step_id;
  RETURN indication_step_id;
ELSE
  RETURN indication_step_id;
END IF;

END
$$ LANGUAGE plpgsql;
