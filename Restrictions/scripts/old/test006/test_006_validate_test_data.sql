CREATE OR REPLACE FUNCTION test_006_validate_test_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT false;
  reportId integer DEFAULT 0;
  reportfeId integer DEFAULT 0;
  drugid integer;
  restrictionid integer;
  
  indicationid integer:=7;
  indicationid2 integer:=2;
  reportBussinesId varchar DEFAULT 'TEST REPORT 006';
  reportName varchar DEFAULT 'TEST REPORT NAME 006';
  drugIds INTEGER[] := ARRAY[156,160,2182,3098,3199,3237,3584];
  drugIds2 INTEGER[] := ARRAY[832,835,837,841,842,844,846,847,850,871,872,873,874,875,1285,2128,2168,2193,2737,2765,3022,3332,3372,3505,3567,3569,3612,3615];
  health_plan_ids INTEGER[] := ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13];
  restrictionsIds INTEGER[]:= ARRAY[842,1878,1884,1861,1868,2105,847,809,843,845]; 
  restrictionsIds2 INTEGER[]:= ARRAY[265,1802,295,259,1833,233,273,276]; 
  intvalue integer; 
  groupNames varchar[]:= ARRAY['TEST_006_GROUP_1','TEST_006_GROUP_2','TEST_006_GROUP_3'];	

group1Restrictions INTEGER[] :=ARRAY[265,1802,295,842,1878,1861,1884];--restriction type 1,2,3
group2Restrictions INTEGER[] :=ARRAY[259,1833,1868,2105,847];--restriction type 1,2,3
group3Restrictions INTEGER[] :=ARRAY[233,273,276,809,843,845];--restriction type 1

BEGIN

        --VALIDATE REPORT DATA (DRUGS, RESTRICTIONS, CUSTOM GROUPS, REPORT) EXISTS IN FE DATABASE
        PERFORM validate_report(reportBussinesId,reportName,drugIds,restrictionsIds,groupNames);
        PERFORM validate_report(reportBussinesId,reportName,drugIds2,restrictionsIds2,groupNames);

	--GET THE TEST REPORT ID
	SELECT crr.report_id FROM criteria_restriction_reports crr WHERE crr.business_id=reportBussinesId and  crr.report_name=reportName INTO reportId;	
	
	IF reportId <> 0 THEN
		
		--VALIDATE DIM_RESTRICTIONS	
		PERFORM validate_dim_criteria_restriction(indicationid,reportId,'Single',ARRAY[1,2,3,6]);
		PERFORM validate_dim_criteria_restriction(indicationid2,reportId,'Single',ARRAY[1,2,3,6]);
		
		PERFORM validate_dim_criteria_restriction(indicationid,reportId,'Double',ARRAY[1,2,3,6]);
		PERFORM validate_dim_criteria_restriction(indicationid2,reportId,'Double',ARRAY[1,3,6]);
		

		--VALIDATE TOTAL RESTRICTIONS FOR REPORT
		SELECT COUNT(*) INTO  intvalue FROM criteria_restriction_selection crs where  crs.report_id=reportId and crs.indication_id=indicationid and crs.dim_criterion_type_id=4;
		--WE EXPECT 8 TOTAL RECORDS BASED ON THE RESTRICTION SELECTED
		IF intvalue <> 8 THEN 
			SELECT throw_error('UNEXPECTED CRITERIA RESTRICTION RECORD FOUND');
		END IF;	

		SELECT COUNT(*) INTO  intvalue FROM criteria_restriction_selection crs where  crs.report_id=reportId and crs.indication_id=indicationid2 and crs.dim_criterion_type_id=4;
		--WE EXPECT 7 TOTAL RECORDS BASED ON THE RESTRICTION SELECTED
		IF intvalue <> 7 THEN 
			SELECT throw_error('UNEXPECTED CRITERIA RESTRICTION RECORD FOUND');
		END IF;	

		

		--GROUP#1 RPT DRUGS VALIDATIONS
		SELECT create_report(reportId,1,2,'national',drugIds,health_plan_ids, NULL, NULL, NULL, group1Restrictions) INTO reportfeId;
		RAISE NOTICE 'generated report :%',reportfeId;		

		--VALIDATE RPT_DRUG FOR REPORT
                PERFORM validate_rpt_drug(reportId,reportfeId);


		--GROUP#2 RPT DRUGS VALIDATIONS
		SELECT create_report(reportId,1,2,'national',drugIds,health_plan_ids, NULL, NULL, NULL, group2Restrictions) INTO reportfeId;
		RAISE NOTICE 'generated report :%',reportfeId;		

		--VALIDATE RPT_DRUG FOR REPORT
                PERFORM validate_rpt_drug(reportId,reportfeId);


		--GROUP#3 RPT DRUGS VALIDATIONS
		SELECT create_report(reportId,1,2,'national',drugIds,health_plan_ids, NULL, NULL, NULL, group3Restrictions) INTO reportfeId;
		RAISE NOTICE 'generated report :%',reportfeId;		

		--VALIDATE RPT_DRUG FOR REPORT
                PERFORM validate_rpt_drug(reportId,reportfeId);
		
       END IF;

success:=true;
RETURN success;	  	
END
$$ LANGUAGE plpgsql;