CREATE OR REPLACE FUNCTION test002createtestdata() --ADMIN DB
RETURNS boolean AS $$
DECLARE
success boolean DEFAULT false;

reportBussinesId varchar DEFAULT 'TEST REPORT 002';
reportName varchar DEFAULT 'TEST REPORT NAME 002';
reportId INTEGER;
reportClientId INTEGER;
reportClientName varchar DEFAULT 'TEST CLIENT 01';
indicationId integer:=7; --Acute Lymphoblastic Leukemia
drugIds INTEGER[] := ARRAY[156,160,2182, 3098, 3199, 3237, 3584];
restrictionsIds INTEGER[]:= ARRAY[809,775,846,840,1860,847,810,776,841,1861,848];--ALL RESTRICTIONS

userEmail varchar DEFAULT 'vsansilvestre@growthaccelerationpartners.com';

group1Name varchar DEFAULT 'TEST_002_GROUP_TYPE_1';
group1Restrictions INTEGER[] :=ARRAY[809,775,846];--only type 1 dim_criterion_types restrictions

group2Name varchar DEFAULT 'TEST_002_GROUP_TYPE_2';
group2Restrictions INTEGER[] :=ARRAY[840,1860,847];--all type 2 dim_criterion_types restrictions

group3Name varchar DEFAULT 'TEST_002_GROUP_TYPE_1_2';
group3Restrictions INTEGER[] :=ARRAY[810,776,841,1861,848];--type 1 and type 2 dim_criterion_types restrictions

BEGIN

  --CREATE REPORT
  select createreport(reportBussinesId,reportName) INTO reportId;

  --CREATE REPORT CLIENT
  SELECT createReportClient(reportId,reportClientName) into reportClientId;

  --ADD DRUGS TO THE CREATED REPORT FOR THE SPECIFIED INDICATION ID
  PERFORM createreportdrugs(reportId,drugIds,indicationId);

  --CREATE REPORT RESTRICTIONS
  PERFORM createreportrestrictions(reportId,restrictionsIds);
  
  --CREATE REPORT CUSTOM CRITERIA  GROUP FOR #1 DIM CRITERION TYPE
  PERFORM createreportcriteriagroups(reportId,reportClientId,group1Restrictions,group1Name,userEmail);

  --CREATE REPORT CUSTOM CRITERIA  GROUP FOR #2 DIM CRITERION TYPE
  PERFORM createreportcriteriagroups(reportId,reportClientId,group2Restrictions,group2Name,userEmail);

  --CREATE REPORT CUSTOM CRITERIA  GROUP FOR #3 DIM CRITERION TYPE
  PERFORM createreportcriteriagroups(reportId,reportClientId,group3Restrictions,group3Name,userEmail);
 
success:=true;
RETURN success;

EXCEPTION  when others then
	select throw_error('Error creating test data');	
	RETURN FALSE;

END
$$ LANGUAGE plpgsql;