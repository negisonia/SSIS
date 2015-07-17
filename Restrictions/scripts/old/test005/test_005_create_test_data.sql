CREATE OR REPLACE FUNCTION test_005_create_test_data() --ADMIN DB
RETURNS boolean AS $$
DECLARE
success boolean DEFAULT false;

reportBussinesId varchar DEFAULT 'TEST REPORT 005';
reportName varchar DEFAULT 'TEST REPORT NAME 005';
reportId INTEGER;
reportClientId INTEGER;
reportClientName varchar DEFAULT 'TEST CLIENT 05';
indicationId integer:=7; --Acute Lymphoblastic Leukemia
drugIds INTEGER[] := ARRAY[156,160,2182,3098,3199,3237,3584];
restrictionsIds INTEGER[]:= ARRAY[809,810,811,812,813,814,821,822,823,827,828,829,830,831,832,835,836,837,838,839,843,844,845,775,776,777,778,787,788,789,796,797,798,801,802,803,846];

userEmail varchar DEFAULT 'vsansilvestre@growthaccelerationpartners.com';

group1Name varchar DEFAULT 'TEST_005_GROUP_1';-- this group contains only non step pharmacy restrictons 
group1Restrictions INTEGER[] :=ARRAY[809,810,811,812,813,814,821,822,823,827,828,829,830,831,832,835,836,837,838,839,843,844,845];--restriction type 1


group2Name varchar DEFAULT 'TEST_005_GROUP_2';-- this group only non step medical restrictions
group2Restrictions INTEGER[] :=ARRAY[775,776,777,778,787,788,789,796,797,798,801,802,803];--restriction type 2

group3Name varchar DEFAULT 'TEST_005_GROUP_3';-- this group contains only  non step quantity limit restrictions
group3Restrictions INTEGER[] :=ARRAY[846];--restriction type 4



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

  
success:=true;
RETURN success;

EXCEPTION  when others then
	select throw_error('Error creating test data');	
	RETURN FALSE;

END
$$ LANGUAGE plpgsql;