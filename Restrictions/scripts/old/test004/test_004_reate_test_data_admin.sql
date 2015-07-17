CREATE OR REPLACE FUNCTION test_004_create_test_data() --ADMIN DB
RETURNS boolean AS $$
DECLARE
success boolean DEFAULT false;

reportBussinesId varchar DEFAULT 'TEST REPORT 004';
reportName varchar DEFAULT 'TEST REPORT NAME 004';
reportId INTEGER;
reportClientId INTEGER;
reportClientName varchar DEFAULT 'TEST CLIENT 04';
indicationId integer:=2; --HIV
drugIds INTEGER[] := ARRAY[832,835,837,841,842,844,846,847,850,871,872,873,874,875,1285,2128,2168,2193,2737,2765,3022,3332,3372,3505,3567,3569,3612,3615];
restrictionsIds INTEGER[]:= ARRAY[261,262,263,264,265,266,267,1802,289,290,291,293,268,269,270,271,272,1803,1804,1838,260];

userEmail varchar DEFAULT 'vsansilvestre@growthaccelerationpartners.com';

group1Name varchar DEFAULT 'TEST_004_GROUP_1';-- this group contains only single steps criteria 
group1Restrictions INTEGER[] :=ARRAY[261,262,263,264,265,266,267,1802,289,290,291,293];--restriction type 1,2,3


group2Name varchar DEFAULT 'TEST_004_GROUP_2';-- this group contains only triple steps criteria
group2Restrictions INTEGER[] :=ARRAY[268,269,270,271,272,1803,1804,1838];--restriction type 1,2,3

group3Name varchar DEFAULT 'TEST_004_GROUP_3';-- this group contains only sextuple steps criteria
group3Restrictions INTEGER[] :=ARRAY[260];--restriction type 1



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