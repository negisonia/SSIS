CREATE OR REPLACE FUNCTION test_data_restrictions() --DATA ENTRY
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;
BEGIN

--CREATE CRITERIAS
PERFORM common_create_restriction('Diagnosis','PA');
PERFORM common_create_restriction('Diagnosis','Medical');
PERFORM common_create_restriction('Unspecified','PA');
PERFORM common_create_restriction('Unspecified','Medical');
PERFORM common_create_restriction('Exclusion','PA');
PERFORM common_create_restriction('Exclusion','Medical');
PERFORM common_create_restriction('Clinical','PA');
PERFORM common_create_restriction('Clinical','Medical');
PERFORM common_create_restriction('Labs','PA');
PERFORM common_create_restriction('Labs','Medical');
PERFORM common_create_restriction('Age','PA');
PERFORM common_create_restriction('Age','Medical');
PERFORM common_create_restriction('QL','QL');
PERFORM common_create_restriction('PA','PA');
PERFORM common_create_restriction('Medical','Medical');

success=true;
return success;
END
$$ LANGUAGE plpgsql;