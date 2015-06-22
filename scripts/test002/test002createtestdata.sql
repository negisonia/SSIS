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
restrictionsIds INTEGER[]:= ARRAY[809,810,811,812,813,775,776,777,778,840,1865,1867];

userEmail varchar DEFAULT 'vsansilvestre@growthaccelerationpartners.com';

--CRITERION TYPES: 
--PREDEFINED:    1
--STEPS:         2
--ADMIN PORTAL:  3
--STEP+CUSTOM:   5

group1Name varchar DEFAULT 'TEST_002_GROUP_1';-- this group contains only type 1 pharmacy restrictions (dim_restriction_type_id=1 and dim_criterion_type_id=1)
group1Restrictions INTEGER[] :=ARRAY[809,810,811];
--809 (PHARMACY) CT:1
--810 (PHARMACY) CT:1
--811 (PHARMACY) CT:1



group2Name varchar DEFAULT 'TEST_002_GROUP_2';
group2Restrictions INTEGER[] :=ARRAY[776,777,778];--this group contains only type 1 medical restrictions (dim_restriction_type_id=2 and dim_criterion_type_id=1)
--776 (Medical) CT:1
--777 (Medical) CT:1
--778 (Medical) CT:1

group3Name varchar DEFAULT 'TEST_002_GROUP_3';--this group contains only type 1 medical and pharmacy restrictions  (dim_criterion_type_id=1 and (dim_restriction_type_id=2 or dim_restriction_type_id=1))
group3Restrictions INTEGER[] :=ARRAY[812,813,775];
--812 (Pharmacy) CT:1
--813 (Pharmacy) CT:1
--775 (Medical) CT:1

group4Name varchar DEFAULT 'TEST_002_GROUP_4';--this group contains only pharmacy steps criterias  (dim_restriction_type_id=1 and dim_criterion_type_id=2)
group4Restrictions INTEGER[] :=ARRAY[840,1865,1867];
--840 (Pharmacy) CT:2
--1865 (Pharmacy) CT:2
--1867 (Pharmacy) CT:2


BEGIN

  --CREATE REPORT
  select createreport(reportBussinesId,reportName) INTO reportId;

  --CREATE REPORT CLIENT
  SELECT createReportClient(reportId,reportClientName) into reportClientId;

  --ADD DRUGS TO THE CREATED REPORT FOR THE SPECIFIED INDICATION ID
  PERFORM createreportdrugs(reportId,drugIds,indicationId);

  --CREATE REPORT RESTRICTIONS
  PERFORM createreportrestrictions(reportId,restrictionsIds);
  
  --CREATE REPORT CUSTOM CRITERIA  GROUP FOR #1 
  PERFORM createreportcriteriagroups(reportId,reportClientId,group1Restrictions,group1Name,userEmail);

  --CREATE REPORT CUSTOM CRITERIA  GROUP FOR #2 
  PERFORM createreportcriteriagroups(reportId,reportClientId,group2Restrictions,group2Name,userEmail);

  --CREATE REPORT CUSTOM CRITERIA  GROUP FOR #3 
  PERFORM createreportcriteriagroups(reportId,reportClientId,group3Restrictions,group3Name,userEmail);

  --CREATE REPORT CUSTOM CRITERIA  GROUP FOR #4
  PERFORM createreportcriteriagroups(reportId,reportClientId,group4Restrictions,group4Name,userEmail);
  
success:=true;
RETURN success;

EXCEPTION  when others then
	select throw_error('Error creating test data');	
	RETURN FALSE;

END
$$ LANGUAGE plpgsql;