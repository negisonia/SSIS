CREATE OR REPLACE FUNCTION test_data_drug_classes() --FF NEW DB
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;
BEGIN

--CREATE DRUG CLASSES
PERFORM common_create_drugclass(TRUE,'drug_class_1');
PERFORM common_create_drugclass(TRUE,'drug_class_2');
PERFORM common_create_drugclass(TRUE,'drug_class_3');

success=true;
return success;
END
$$ LANGUAGE plpgsql;