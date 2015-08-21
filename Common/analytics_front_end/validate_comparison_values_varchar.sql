CREATE OR REPLACE FUNCTION validate_comparison_values_varchar(actual_value varchar, expected_value varchar, error_msg_expected_value VARCHAR)--ANALYTICS FRONT END
RETURNS boolean AS $$
DECLARE

success BOOLEAN:=FALSE;

BEGIN

IF actual_value IS NULL OR actual_value != expected_value THEN
  SELECT throw_error(error_msg_expected_value || concat_ws(' GOT ', expected_value, actual_value));
END IF;

success=true;
return success;

END
$$ LANGUAGE plpgsql;