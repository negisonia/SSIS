CREATE OR REPLACE FUNCTION test_data_restrictions() --DATA ENTRY
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;
BEGIN

--CREATE CRITERIAS

PERFORM common_create_restriction(1,'PA','PA');
PERFORM common_create_restriction(2,'ST','ST');
PERFORM common_create_restriction(3,'QL','QL');
PERFORM common_create_restriction(4,'Medical','Medical');
PERFORM common_create_restriction(5,'OR','OR');
PERFORM common_create_restriction(6,'Step','PA');
PERFORM common_create_restriction(7,'Diagnosis','PA');
PERFORM common_create_restriction(8,'Exclusion','PA');
PERFORM common_create_restriction(9,'Labs','PA');
PERFORM common_create_restriction(10,'MD','PA');
PERFORM common_create_restriction(11,'Step','Medical');
PERFORM common_create_restriction(12,'Diagnosis','Medical');
PERFORM common_create_restriction(13,'Exclusion','Medical');
PERFORM common_create_restriction(14,'Labs','Medical');
PERFORM common_create_restriction(15,'MD','Medical');
PERFORM common_create_restriction(16,'Unspecified','PA');
PERFORM common_create_restriction(17,'Unspecified','Medical');
PERFORM common_create_restriction(18,'Clinical','PA');
PERFORM common_create_restriction(19,'Clinical','Medical');
PERFORM common_create_restriction(20,'Age','PA');
PERFORM common_create_restriction(21,'Age','Medical');
PERFORM common_create_restriction(22,'Non-Preferred','PA');
PERFORM common_create_restriction(23,'Non-Preferred','Medical');

success=true;
return success;
END
$$ LANGUAGE plpgsql;