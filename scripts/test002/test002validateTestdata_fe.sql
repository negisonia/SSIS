CREATE OR REPLACE FUNCTION test002validatetestdata() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT false;
  reportId integer DEFAULT 0;
  drugid integer;
  restrictionid integer;
  reportBussinesId varchar DEFAULT 'TEST REPORT 002';
  reportName varchar DEFAULT 'TEST REPORT NAME 002';
  drugIds INTEGER[] := ARRAY[];
  health_plan_ids INTEGER[] := ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13];
  restrictionsIds INTEGER[]:= ARRAY[809,810,811,776,777,778,812,813,775,840,1865,1864,1867,841,842,2111,1882,1881,1880,1869,1860,2106,2172,1861]; 
  custom_restriction_ids INTEGER[];

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

  groupRestrictionedDrugs integer[];
 
  groups VARCHAR[] :=ARRAY[group1Name,group2Name,group3Name,group4Name,group5Name,group6Name,group7Name,group8Name];

BEGIN

        --VALIDATE REPORT DATA (DRUGS, RESTRICTIONS, CUSTOM GROUPS, REPORT) EXISTS IN FE DATABASE
        PERFORM validatereport(reportBussinesId,reportName,drugIds,restrictionsIds,groups);

	RAISE NOTICE '1';
	--GET THE TEST REPORT ID
	SELECT crr.report_id FROM criteria_restriction_reports crr WHERE crr.business_id=reportBussinesId and  crr.report_name=reportName INTO reportId;

	RAISE NOTICE '2%',reportId;

	IF reportId <> 0 THEN
                
        RAISE NOTICE '3';
		--VALIDATE REPORT GROUPS
		PERFORM test002validategroups(reportId);
		RAISE NOTICE '4';

		------------GROUP 1-----------------
		
               --CREATE STEPS REPORT USING CUSTOM GROUP #1
               PERFORM createRestrictionReport(reportId,1,2,'national',drugIds,health_plan_ids, NULL, NULL, NULL, restrictionsIds, NULL);
		RAISE NOTICE '5';
		--GET THE LIST OF DRUGS ASSOCIATED WITH THE CRITERIA SELECTED (LIST OF REPORT DRUGS THAT CONTAINS A RESTRICTION ON IT)
		--groupRestrictionedDrugs = getreportrestrictioneddrugs(reportId,group1Restrictions,drugIds);
		RAISE NOTICE '6';
		foreach drugid in array getreportrestrictioneddrugs(reportId,group1Restrictions,drugIds)
		LOOP
		RAISE NOTICE 'DRUG ID: %',drugid;
		END LOOP;
		

		------------GROUP 2-----------------
			
                --GET CUSTOM RESTRICTION IDS
		--custom_restriction_ids := ARRAY(select distinct c.dim_criteria_restriction_id, c.criteria_restriction_name from custom_criteron_selection c where c.report_id=reportId 
		--and (c.restriction_name=group1Name
		--or c.restriction_name=group2Name
		--or c.restriction_name=group3Name
		--or c.restriction_name=group4Name
		--or c.restriction_name=group5Name
		--or c.restriction_name=group6Name
		--or c.restriction_name=group7Name
		--or c.restriction_name=group8Name));

		--GET CUSTOM RESTRICTION IDS for group 1 (RETURNS AN ARRAY WITH THE RESTRICTION ID OF ALL THE CUSTOM RESTRICTION GROUPS)
		--custom_restriction_ids := ARRAY(select distinct c.dim_criteria_restriction_id from custom_criteron_selection c where c.report_id=reportId and c.restriction_name=group1Name);               

       END IF;

success:=true;
RETURN success;	  	
END
$$ LANGUAGE plpgsql;