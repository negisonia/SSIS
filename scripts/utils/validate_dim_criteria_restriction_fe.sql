CREATE OR REPLACE FUNCTION validate_dim_criteria_restriction(indicationid integer, expected_restriction_name varchar, expected_restriction_types integer[]) --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT false;
  intvalue integer;
  value_exists boolean DEFAULT false;
BEGIN

     --VALIDATE INDICATION IS NOT NULL
     IF indicationid = NULL THEN
	select throw_error('INDICATION ID IS REQUIRED');
     END IF;

     --VALIDATE RESTRICTIONS ARE NOT NULL
     IF expected_restriction_name = NULL THEN
	SELECT throw_error('EXPECTED RESTRICTION NAME IS REQUIRED');
     END IF;	

      --VALIDATE RESTRICTIONS ARE NOT NULL
     IF expected_restriction_types = NULL THEN
	SELECT throw_error('EXPECTED RESTRICTION TYPES ARE REQUIRED');
     END IF;	

     
   
    FOREACH intvalue IN ARRAY expected_restriction_types
     LOOP
	SELECT EXISTS(SELECT 1 from dim_criteria_restriction d where d.indication_id=indicationid and d.restriction_name=expected_restriction_name and d.dim_restriction_type=intvalue and d.dim_criterion_type=4) INTO value_exists
	IF value_exists= FALSE THEN
	   SELECT throw_error('EXPECTED DIM CRITERIA RESTRICTION WITH INDICATION ID ='|| indicationid ||' AND RESTRICTION NAME = '|| expected_restriction_name ||' AND  RESTRICTION TYPE '|| intvalue ||' DONT EXISTS');
	END IF;
     END LOOP;  
       
success:=true;
RETURN success;	  	
END
$$ LANGUAGE plpgsql;