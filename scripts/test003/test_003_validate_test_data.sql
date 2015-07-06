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
  intvalue integer;

  group1Restrictions INTEGER[] :=ARRAY[841,842,1870,1871,1860,1861,2106,2172,848,1883,1884,2175];--restriction type 1,2,3
  group2Restrictions INTEGER[] :=ARRAY[840,1864,1865,1866,2105,847];--restriction type 1,2,3
  group3Restrictions INTEGER[] :=ARRAY[1880,1881,1882];--restriction type 1
  group4Restrictions INTEGER[] :=ARRAY[1869];--restriction type 1
  group5Restrictions INTEGER[] :=ARRAY[1885];--restriction type 3
  
BEGIN

        --VALIDATE REPORT DATA (DRUGS, RESTRICTIONS, CUSTOM GROUPS, REPORT) EXISTS IN FE DATABASE
        PERFORM validate_report(reportBussinesId,reportName,drugIds,restrictionsIds,NULL);

	--GET THE TEST REPORT ID
	SELECT crr.report_id FROM criteria_restriction_reports crr WHERE crr.business_id=reportBussinesId and  crr.report_name=reportName INTO reportId;
	
	IF reportId <> 0 THEN

		--VALIDATE DIM_RESTRICTIONS	
		PERFORM validate_dim_criteria_restriction(indicationid,reportId,'Single',ARRAY[1,2,3,6]);
		PERFORM validate_dim_criteria_restriction(indicationid,reportId,'Double',ARRAY[1,2,3,6]);
		PERFORM validate_dim_criteria_restriction(indicationid,reportId,'Triple',ARRAY[1,6]);
		PERFORM validate_dim_criteria_restriction(indicationid,reportId,'Quadruple',ARRAY[1,6]);
		PERFORM validate_dim_criteria_restriction(indicationid,reportId,'Unspecified',ARRAY[3,6]);
	
		--VALIDATE TOTAL RESTRICTIONS FOR REPORT
		SELECT COUNT(*) INTO  intvalue FROM criteria_restriction_selection crs where  crs.report_id=reportId and crs.indication_id=indicationid and crs.dim_criterion_type_id=4;
		--WE EXPECT 10 TOTAL RECORDS BASED ON THE RESTRICTION SELECTED
		IF intvalue <> 14 THEN 
			SELECT throw_error('UNEXPECTED CRITERIA RESTRICTION RECORD FOUND');
		END IF;	
                	
		--GROUP#1 RPT DRUGS VALIDATIONS
		SELECT create_report(reportId,1,2,'national',drugIds,health_plan_ids, NULL, NULL, NULL, group1Restrictions) INTO reportfeId;
		RAISE NOTICE 'generated report :%',reportfeId;		

		--VALIDATE RPT_DRUG FOR REPORT
                PERFORM validate_rpt_drug(reportId,reportfeId);



		-----GROUP#2 RPT DRUGS VALIDATIONS
		SELECT create_report(reportId,1,2,'national',drugIds,health_plan_ids, NULL, NULL, NULL, group2Restrictions) INTO reportfeId;
		RAISE NOTICE 'generated report :%',reportfeId;		

		--VALIDATE RPT_DRUG FOR REPORT
                PERFORM validate_rpt_drug(reportId,reportfeId);



		-----GROUP#3 RPT DRUGS VALIDATIONS
		SELECT create_report(reportId,1,2,'national',drugIds,health_plan_ids, NULL, NULL, NULL, group3Restrictions) INTO reportfeId;
		RAISE NOTICE 'generated report :%',reportfeId;		

		--VALIDATE RPT_DRUG FOR REPORT
                PERFORM validate_rpt_drug(reportId,reportfeId);



		-----GROUP#4 RPT DRUGS VALIDATIONS
		SELECT create_report(reportId,1,2,'national',drugIds,health_plan_ids, NULL, NULL, NULL, group4Restrictions) INTO reportfeId;
		RAISE NOTICE 'generated report :%',reportfeId;		

		--VALIDATE RPT_DRUG FOR REPORT
                PERFORM validate_rpt_drug(reportId,reportfeId);



		-----GROUP#5 RPT DRUGS VALIDATIONS
		SELECT create_report(reportId,1,2,'national',drugIds,health_plan_ids, NULL, NULL, NULL, group5Restrictions) INTO reportfeId;
		RAISE NOTICE 'generated report :%',reportfeId;		

		--VALIDATE RPT_DRUG FOR REPORT
                PERFORM validate_rpt_drug(reportId,reportfeId);
		
       END IF;

success:=true;
RETURN success;	  	
END
$$ LANGUAGE plpgsql;