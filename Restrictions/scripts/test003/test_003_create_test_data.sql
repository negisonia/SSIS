CREATE OR REPLACE FUNCTION test_003_create_test_data() --ADMIN DB
RETURNS boolean AS $$
DECLARE
success boolean DEFAULT false;

reportBussinesId varchar DEFAULT 'TEST REPORT 003';
reportName varchar DEFAULT 'TEST REPORT NAME 003';
reportId INTEGER;
reportClientId INTEGER;
reportClientName varchar DEFAULT 'TEST CLIENT 02';
indicationId integer:=7; --Acute Lymphoblastic Leukemia
drugIds INTEGER[] := ARRAY[156,160,2182, 3098, 3199, 3237, 3584];
restrictionsIds INTEGER[]:= ARRAY[841,842,1870,1871,1860,1861,2106,2172,848,1883,1884,2175,840,1864,1865,1866,2105,847,1880,1881,1882,1869,1885];

userEmail varchar DEFAULT 'vsansilvestre@growthaccelerationpartners.com';

group1Name varchar DEFAULT 'TEST_003_GROUP_1';-- this group contains only single steps criteria
group1Restrictions INTEGER[] :=ARRAY[841,842,1870,1871,1860,1861,2106,2172,848,1883,1884,2175];--restriction type 1,2,3


group2Name varchar DEFAULT 'TEST_003_GROUP_2';-- this group contains only double steps criteria
group2Restrictions INTEGER[] :=ARRAY[840,1864,1865,1866,2105,847];--restriction type 1,2,3

group3Name varchar DEFAULT 'TEST_003_GROUP_3';-- this group contains only triple steps criteria
group3Restrictions INTEGER[] :=ARRAY[1880,1881,1882];--restriction type 1

group4Name varchar DEFAULT 'TEST_003_GROUP_4';-- this group contains only quadruple steps criteria
group4Restrictions INTEGER[] :=ARRAY[1869];--restriction type 1

group5Name varchar DEFAULT 'TEST_003_GROUP_5';-- this group contains only unspecified steps criteria
group5Restrictions INTEGER[] :=ARRAY[1885];--restriction type 3

BEGIN

  --CREATE REPORT
  select create_report(reportBussinesId,reportName) INTO reportId;

  --CREATE REPORT CLIENT
  SELECT create_report_client(reportId,reportClientName) into reportClientId;

  --ADD DRUGS TO THE CREATED REPORT FOR THE SPECIFIED INDICATION ID
  PERFORM create_report_drugs(reportId,drugIds,indicationId);

  --CREATE REPORT RESTRICTIONS
  PERFORM create_report_restrictions(reportId,restrictionsIds);

--CREATE REPORT CUSTOM CRITERIA  GROUP FOR #1 
  PERFORM create_report_criteria_groups(reportId,reportClientId,group1Restrictions,group1Name,userEmail);

  --CREATE REPORT CUSTOM CRITERIA  GROUP FOR #2 
  PERFORM create_report_criteria_groups(reportId,reportClientId,group2Restrictions,group2Name,userEmail);

  --CREATE REPORT CUSTOM CRITERIA  GROUP FOR #3 
  PERFORM create_report_criteria_groups(reportId,reportClientId,group3Restrictions,group3Name,userEmail);

  --CREATE REPORT CUSTOM CRITERIA  GROUP FOR #4
  PERFORM create_report_criteria_groups(reportId,reportClientId,group4Restrictions,group4Name,userEmail);

  --CREATE REPORT CUSTOM CRITERIA  GROUP FOR #5
  PERFORM create_report_criteria_groups(reportId,reportClientId,group5Restrictions,group5Name,userEmail);
      
success:=true;
RETURN success;

EXCEPTION  when others then
	select throw_error('Error creating test data');	
	RETURN FALSE;

END
$$ LANGUAGE plpgsql;