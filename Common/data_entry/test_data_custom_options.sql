CREATE OR REPLACE FUNCTION test_data_custom_options() --DATA ENTRY
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;
BEGIN

--CREATE CUSTOM OPTIONS
PERFORM common_create_custom_option('custom_option_1');
PERFORM common_create_custom_option('custom_option_2');
PERFORM common_create_custom_option('custom_option_3');
PERFORM common_create_custom_option('custom_option_4');

success=true;
return success;
END
$$ LANGUAGE plpgsql;