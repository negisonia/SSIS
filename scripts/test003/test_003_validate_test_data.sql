CREATE OR REPLACE FUNCTION test_003_validate_test_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT false;
  reportId integer DEFAULT 0;
  reportfeId integer DEFAULT 0;
  drugid integer;
  restrictionid integer;
  indicationid integer:=7;
  reportBussinesId varchar DEFAULT 'TEST REPORT 003';
  reportName varchar DEFAULT 'TEST REPORT NAME 003';
  drugIds INTEGER[] := ARRAY[156,160,2182, 3098, 3199, 3237, 3584];
  health_plan_ids INTEGER[] := ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13];
  restrictionsIds INTEGER[]:= ARRAY[841,842,1870,1871,1860,1861,2106,2172,848,1883,1884,2175,840,1864,1865,1866,2105,847,1880,1881,1882,1869,1885]; 


BEGIN

        --VALIDATE REPORT DATA (DRUGS, RESTRICTIONS, CUSTOM GROUPS, REPORT) EXISTS IN FE DATABASE
        PERFORM validate_report(reportBussinesId,reportName,drugIds,restrictionsIds,NULL);

	--GET THE TEST REPORT ID
	SELECT crr.report_id FROM criteria_restriction_reports crr WHERE crr.business_id=reportBussinesId and  crr.report_name=reportName INTO reportId;

	
	--VALIDATE DIM_RESTRICTIONS	
	PERFORM validate_dim_criteria_restriction(indicationid,reportId,'Single',ARRAY[1,2,3,6]);
	PERFORM validate_dim_criteria_restriction(indicationid,reportId,'Double',ARRAY[1,2,3,6]);
	PERFORM validate_dim_criteria_restriction(indicationid,reportId,'Triple',ARRAY[1,6]);
	PERFORM validate_dim_criteria_restriction(indicationid,reportId,'Quadruple',ARRAY[1,6]);
	PERFORM validate_dim_criteria_restriction(indicationid,reportId,'Unspecified',ARRAY[3,6]);
	
	IF reportId <> 0 THEN
                			
		--SELECT create_report(reportId,1,2,'national',drugIds,health_plan_ids, NULL, NULL, NULL, group1Restrictions) INTO reportfeId;
		--RAISE NOTICE 'generated report :%',reportfeId;		
		
       END IF;

success:=true;
RETURN success;	  	
END
$$ LANGUAGE plpgsql;