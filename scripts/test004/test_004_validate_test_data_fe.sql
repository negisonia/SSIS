CREATE OR REPLACE FUNCTION test_004_validate_test_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT false;
  reportId integer DEFAULT 0;
  reportfeId integer DEFAULT 0;
  drugid integer;
  restrictionid integer;
  indicationid integer:=2;
  reportBussinesId varchar DEFAULT 'TEST REPORT 004';
  reportName varchar DEFAULT 'TEST REPORT NAME 004';
  drugIds INTEGER[] := ARRAY[832,835,837,841,842,844,846,847,850,871,872,873,874,875,1285,2128,2168,2193,2737,2765,3022,3332,3372,3505,3567,3569,3612,3615];
  health_plan_ids INTEGER[] := ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13];
  restrictionsIds INTEGER[]:= ARRAY[261,262,263,264,265,266,267,1802,289,290,291,293,268,269,270,271,272,1803,1804,1838,260]; 
  intvalue integer;
BEGIN

        --VALIDATE REPORT DATA (DRUGS, RESTRICTIONS, CUSTOM GROUPS, REPORT) EXISTS IN FE DATABASE
        PERFORM validate_report(reportBussinesId,reportName,drugIds,restrictionsIds,NULL);

	--GET THE TEST REPORT ID
	SELECT crr.report_id FROM criteria_restriction_reports crr WHERE crr.business_id=reportBussinesId and  crr.report_name=reportName INTO reportId;	
	
	IF reportId <> 0 THEN

		--VALIDATE DIM_RESTRICTIONS	
		PERFORM validate_dim_criteria_restriction(indicationid,reportId,'Single',ARRAY[1,2,3,6]);
		PERFORM validate_dim_criteria_restriction(indicationid,reportId,'Triple',ARRAY[1,2,3,6]);
		PERFORM validate_dim_criteria_restriction(indicationid,reportId,'Sextuple',ARRAY[1,6]);

		--VALIDATE TOTAL RESTRICTIONS FOR REPORT
		SELECT COUNT(*) INTO  intvalue FROM criteria_restriction_selection crs where  crs.report_id=reportId and crs.indication_id=indicationid and crs.dim_criterion_type_id=4;
		--WE EXPECT 10 TOTAL RECORDS BASED ON THE RESTRICTION SELECTED
		IF intvalue <> 10 THEN 
			SELECT throw_error('UNEXPECTED CRITERIA RESTRICTION RECORD FOUND');
		END IF;						
		
		--SELECT create_report(reportId,1,2,'national',drugIds,health_plan_ids, NULL, NULL, NULL, group1Restrictions) INTO reportfeId;
		--RAISE NOTICE 'generated report :%',reportfeId;		
		
       END IF;

success:=true;
RETURN success;	  	
END
$$ LANGUAGE plpgsql;