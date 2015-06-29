CREATE OR REPLACE FUNCTION test_002_validate_test_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT false;
  reportId integer DEFAULT 0;
  reportfeId integer DEFAULT 0;
  drugid integer;
  restrictionid integer;

  reportBussinesId varchar DEFAULT 'TEST REPORT 002';
  reportName varchar DEFAULT 'TEST REPORT NAME 002';
  drugIds INTEGER[] := ARRAY[156,160,2182, 3098, 3199, 3237, 3584];
  health_plan_ids INTEGER[] := ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13];
  restrictionsIds INTEGER[]:= ARRAY[809,810,811,776,777,778,812,813,775,840,1865,1864,1867,841,842,2111,1882,1881,1880,1869,1860,2106,2172,1861]; 

  group1Name varchar DEFAULT 'TEST_002_GROUP_1';
  group2Name varchar DEFAULT 'TEST_002_GROUP_2';
  group3Name varchar DEFAULT 'TEST_002_GROUP_3';
  group4Name varchar DEFAULT 'TEST_002_GROUP_4';
  group5Name varchar DEFAULT 'TEST_002_GROUP_5';
  group6Name varchar DEFAULT 'TEST_002_GROUP_6';
  group7Name varchar DEFAULT 'TEST_002_GROUP_7';
  group8Name varchar DEFAULT 'TEST_002_GROUP_8';

  group1Restrictions INTEGER[]:= ARRAY[809,810,811];
  group2Restrictions INTEGER[]:= ARRAY[776,777,778];
  group3Restrictions INTEGER[]:= ARRAY[812,813,775];
  group4Restrictions INTEGER[]:= ARRAY[840,1865,1867];
  group5Restrictions INTEGER[]:= ARRAY[840,1864,1865,841,842,2111,1882,1881,1880,1869];
  group6Restrictions INTEGER[]:= ARRAY[1860,2106,2172,1861];
  group7Restrictions INTEGER[]:= ARRAY[840,1865,1867];
  group8Restrictions INTEGER[]:= ARRAY[776,809,1860,841];

  groups VARCHAR[] :=ARRAY[group1Name,group2Name,group3Name,group4Name,group5Name,group6Name,group7Name,group8Name];

BEGIN

        --VALIDATE REPORT DATA (DRUGS, RESTRICTIONS, CUSTOM GROUPS, REPORT) EXISTS IN FE DATABASE
        PERFORM validate_report(reportBussinesId,reportName,drugIds,restrictionsIds,groups);

	--GET THE TEST REPORT ID
	SELECT crr.report_id FROM criteria_restriction_reports crr WHERE crr.business_id=reportBussinesId and  crr.report_name=reportName INTO reportId;


	IF reportId <> 0 THEN
                
		--VALIDATE REPORT GROUPS
		PERFORM test_002_validate_groups(reportId);

		------------GROUP 1-----------------
		
               --CREATE STEPS REPORT USING CUSTOM GROUP #1
                SELECT create_restriction_report(reportId,1,2,'national',drugIds,health_plan_ids, NULL, NULL, NULL, group1Restrictions, NULL) INTO reportfeId;
		RAISE NOTICE 'generated report :%',reportfeId;

		--VALIDATE RPT_DRUG FOR REPORT
                PERFORM validate_rpt_drug(reportId,reportfeId);

		------------GROUP 2-----------------
		--CREATE STEPS REPORT USING CUSTOM GROUP #2
                SELECT create_restriction_report(reportId,1,2,'national',drugIds,health_plan_ids, NULL, NULL, NULL, group2Restrictions, NULL) INTO reportfeId;
		RAISE NOTICE 'generated report :%',reportfeId;

		--VALIDATE RPT_DRUG FOR REPORT
                PERFORM validate_rpt_drug(reportId,reportfeId);

		------------GROUP 3-----------------
		--CREATE STEPS REPORT USING CUSTOM GROUP #2
                SELECT create_restriction_report(reportId,1,2,'national',drugIds,health_plan_ids, NULL, NULL, NULL, group3Restrictions, NULL) INTO reportfeId;
		RAISE NOTICE 'generated report :%',reportfeId;

		--VALIDATE RPT_DRUG FOR REPORT
                PERFORM validate_rpt_drug(reportId,reportfeId);

		------------GROUP 4-----------------
		--CREATE STEPS REPORT USING CUSTOM GROUP #4
                SELECT create_restriction_report(reportId,1,2,'national',drugIds,health_plan_ids, NULL, NULL, NULL, group4Restrictions, NULL) INTO reportfeId;
		RAISE NOTICE 'generated report :%',reportfeId;

		--VALIDATE RPT_DRUG FOR REPORT
                PERFORM validate_rpt_drug(reportId,reportfeId);

		------------GROUP 5-----------------
		--CREATE STEPS REPORT USING CUSTOM GROUP #5
                SELECT createRestrictionReport(reportId,1,2,'national',drugIds,health_plan_ids, NULL, NULL, NULL, group5Restrictions, NULL) INTO reportfeId;
		RAISE NOTICE 'generated report :%',reportfeId;

		--VALIDATE RPT_DRUG FOR REPORT
                PERFORM validate_rpt_drug(reportId,reportfeId);

		------------GROUP 5-----------------
		--CREATE STEPS REPORT USING CUSTOM GROUP #6
                SELECT create_restriction_report(reportId,1,2,'national',drugIds,health_plan_ids, NULL, NULL, NULL, group6Restrictions, NULL) INTO reportfeId;
		RAISE NOTICE 'generated report :%',reportfeId;

		--VALIDATE RPT_DRUG FOR REPORT
                PERFORM validate_rpt_drug(reportId,reportfeId);

		------------GROUP 7-----------------
		--CREATE STEPS REPORT USING CUSTOM GROUP #7
                SELECT create_restriction_report(reportId,1,2,'national',drugIds,health_plan_ids, NULL, NULL, NULL, group7Restrictions, NULL) INTO reportfeId;
		RAISE NOTICE 'generated report :%',reportfeId;

		--VALIDATE RPT_DRUG FOR REPORT
                PERFORM validate_rpt_drug(reportId,reportfeId);

		------------GROUP 8-----------------
		--CREATE STEPS REPORT USING CUSTOM GROUP #7
                SELECT create_restriction_report(reportId,1,2,'national',drugIds,health_plan_ids, NULL, NULL, NULL, group8Restrictions, NULL) INTO reportfeId;
		RAISE NOTICE 'generated report :%',reportfeId;

		--VALIDATE RPT_DRUG FOR REPORT
                PERFORM validate_rpt_drug(reportId,reportfeId);
		
       END IF;

success:=true;
RETURN success;	  	
END
$$ LANGUAGE plpgsql;