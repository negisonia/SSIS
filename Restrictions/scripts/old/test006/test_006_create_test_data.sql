CREATE OR REPLACE FUNCTION test_006_create_test_data() --ADMIN DB
RETURNS boolean AS $$
DECLARE
success boolean DEFAULT false;

reportBussinesId varchar DEFAULT 'TEST REPORT 006';
reportName varchar DEFAULT 'TEST REPORT NAME 006';
reportId INTEGER;
reportClientId INTEGER;
reportClientName varchar DEFAULT 'TEST CLIENT 06';
indicationId integer:=7; --Acute Lymphoblastic Leukemia
drugIds INTEGER[] := ARRAY[156,160,2182,3098,3199,3237,3584];
restrictionsIds INTEGER[]:= ARRAY[842,1878,1884,1861,1868,2105,847,809,843,845];

indicationId2 integer:=2; --HVS
drugIds2 INTEGER[] := ARRAY[832,835,837,841,842,844,846,847,850,871,872,873,874,875,1285,2128,2168,2193,2737,2765,3022,3332,3372,3505,3567,3569,3612,3615];
restrictionsIds2 INTEGER[]:= ARRAY[265,1802,295,259,1833,233,273,276];


userEmail varchar DEFAULT 'vsansilvestre@growthaccelerationpartners.com';

group1Name varchar DEFAULT 'TEST_006_GROUP_1';-- this group contains only single step restrictons  for indication 7 and indication 2
group1Restrictions INTEGER[] :=ARRAY[265,1802,295,842,1878,1861,1884];--restriction type 1,2,3
--265 HIV  Pharmacy PA/ST single RT 1
--1802 HIV Medical ST-Single RT 2
--295 HIV Pharmacy ST-Single RT 3
--842 ACU pharmacy PA/ST Single RT 1
--1878 ACU pharmacy PA/ST Single RT 1
--1861 ACU medical ST-Single RT 2
--1884 ACU pharmacy ST-Single RT 3


group2Name varchar DEFAULT 'TEST_006_GROUP_2';-- this group contains only double step restrictons  for indication 7 and indication 2
group2Restrictions INTEGER[] :=ARRAY[259,1833,1868,2105,847];--restriction type 1,2,3
--259 HIV pharmacy PA/ST DOUBLE RT 1
--1833 HIV pharmacy ST -DOUBLE RT 3
--1868 ACU pharmacy PA/ST DOUBLE RT 1
--2105 ACU medical ST- DOUBLE RT 2
--847 ACU pharmacy ST-Double RT 3

group3Name varchar DEFAULT 'TEST_006_GROUP_3';-- this group contains only  non step restrictions  for indication 7 and indication 2
group3Restrictions INTEGER[] :=ARRAY[233,273,276,809,843,845];--restriction type 1
--233 HIV pharmacy RT1 (non step)
--273 HIV pharmacy RT1 (non step)
--236 HIV pharmacy RT1 (non step)
--809 ACU pharmacy RT1 (non step)
--843 ACU pharmacy RT1 (non step)
--845 ACU pharmacy RT1 (non step)

BEGIN
  --CREATE REPORT
  select create_report(reportBussinesId,reportName) INTO reportId;

  --CREATE REPORT CLIENT
  SELECT create_report_client(reportId,reportClientName) into reportClientId;

  --ADD DRUGS TO THE CREATED REPORT FOR THE SPECIFIED INDICATION ID
  PERFORM create_report_drugs(reportId,drugIds,indicationId);
  PERFORM create_report_drugs(reportId,drugIds2,indicationId2);

  --CREATE REPORT RESTRICTIONS
  PERFORM create_report_restrictions(reportId,restrictionsIds);
  PERFORM create_report_restrictions(reportId,restrictionsIds2);

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