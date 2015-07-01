CREATE OR REPLACE FUNCTION validate_dim_criteria_restriction(indicationid integer, reportid integer, expected_restriction_name varchar, expected_restriction_types integer[]) --FRONT END
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
	SELECT EXISTS(SELECT 1 from criteria_restriction_selection crs where crs.indication_id=indicationid and crs.report_id=reportid and crs.restriction_name=expected_restriction_name and  crs.dim_restriction_type_id=intvalue and  crs.dim_criterion_type_id=4 and  crs.view_type_id=2) INTO value_exists;
	IF value_exists= FALSE THEN
	   SELECT throw_error('EXPECTED DIM CRITERIA RESTRICTION WITH INDICATION ID ='|| indicationid ||' AND RESTRICTION NAME = '|| expected_restriction_name ||' AND  RESTRICTION TYPE '|| intvalue ||' DONT EXISTS');
	END IF;
     END LOOP;  
       
success:=true;
RETURN success;	  	
END
$$ LANGUAGE plpgsql;