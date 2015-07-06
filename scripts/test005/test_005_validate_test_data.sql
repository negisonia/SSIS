CREATE OR REPLACE FUNCTION test_005_validate_test_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT false;
  reportId integer DEFAULT 0;
  reportfeId integer DEFAULT 0;
  drugid integer;
  restrictionid integer;
  indicationid integer:=2;
  reportBussinesId varchar DEFAULT 'TEST REPORT 005';
  reportName varchar DEFAULT 'TEST REPORT NAME 005';
  drugIds INTEGER[] := ARRAY[156,160,2182,3098,3199,3237,3584];
  health_plan_ids INTEGER[] := ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13];
  restrictionsIds INTEGER[]:= ARRAY[809,810,811,812,813,814,821,822,823,827,828,829,830,831,832,835,836,837,838,839,843,844,845,775,776,777,778,787,788,789,796,797,798,801,802,803,846]; 
  intvalue integer;


group1Restrictions INTEGER[] :=ARRAY[809,810,811,812,813,814,821,822,823,827,828,829,830,831,832,835,836,837,838,839,843,844,845];--restriction type 1
group2Restrictions INTEGER[] :=ARRAY[775,776,777,778,787,788,789,796,797,798,801,802,803];--restriction type 2
group3Restrictions INTEGER[] :=ARRAY[846];--restriction type 4

BEGIN

        --VALIDATE REPORT DATA (DRUGS, RESTRICTIONS, CUSTOM GROUPS, REPORT) EXISTS IN FE DATABASE
        PERFORM validate_report(reportBussinesId,reportName,drugIds,restrictionsIds,NULL);

	--GET THE TEST REPORT ID
	SELECT crr.report_id FROM criteria_restriction_reports crr WHERE crr.business_id=reportBussinesId and  crr.report_name=reportName INTO reportId;	
	
	IF reportId <> 0 THEN
		
		--VALIDATE TOTAL RESTRICTIONS FOR REPORT
		SELECT COUNT(*) INTO  intvalue FROM criteria_restriction_selection crs where  crs.report_id=reportId and crs.indication_id=indicationid and crs.dim_criterion_type_id=4;
		--WE EXPECT 0 TOTAL RECORDS BASED ON THE RESTRICTION SELECTED
		IF intvalue <> 0 THEN 
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