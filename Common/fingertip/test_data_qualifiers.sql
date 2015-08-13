CREATE OR REPLACE FUNCTION test_data_qualifiers() --FF NEW
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;
BEGIN

--CREATE QUALIFIERS
PERFORM common_create_qualifier(TRUE,'Quantity Limits','QL');
PERFORM common_create_qualifier(TRUE,'Prior Authorization','PA');
PERFORM common_create_qualifier(TRUE,'Step Therapy','ST');
PERFORM common_create_qualifier(TRUE,'Other Restrictions','OR');

success=true;
return success;
END
$$ LANGUAGE plpgsql;