CREATE OR REPLACE FUNCTION test_002_create_test_data() --ADMIN DB
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
restrictionsIds INTEGER[]:= ARRAY[809,810,811,776,777,778,812,813,775,840,1865,1864,1867,841,842,2111,1882,1881,1880,1869,1860,2106,2172,1861];

userEmail varchar DEFAULT 'vsansilvestre@growthaccelerationpartners.com';

--CRITERION TYPES ( CT ): 
--PREDEFINED:    1
--STEPS:         2
--ADMIN PORTAL:  3
--STEP+CUSTOM:   5

group1Name varchar DEFAULT 'TEST_002_GROUP_1';-- this group contains only criterion type 1 pharmacy restrictions (dim_restriction_type_id=1 and dim_criterion_type_id=1)
group1Restrictions INTEGER[] :=ARRAY[809,810,811];
--809 (PHARMACY) CT:1
--810 (PHARMACY) CT:1
--811 (PHARMACY) CT:1



group2Name varchar DEFAULT 'TEST_002_GROUP_2';
group2Restrictions INTEGER[] :=ARRAY[776,777,778];--this group contains only  criterion type 1 medical restrictions (dim_restriction_type_id=2 and dim_criterion_type_id=1)
--776 (Medical) CT:1
--777 (Medical) CT:1
--778 (Medical) CT:1

group3Name varchar DEFAULT 'TEST_002_GROUP_3';--this group contains only criterion type 1 restriction (1 medical and 1 pharmacy restriction  (dim_criterion_type_id=1  (dim_restriction_type_id=2 or dim_restriction_type_id=1))
group3Restrictions INTEGER[] :=ARRAY[812,813,775];
--812 (Pharmacy) CT:1
--813 (Pharmacy) CT:1
--775 (Medical) CT:1

group4Name varchar DEFAULT 'TEST_002_GROUP_4';--this group contains only pharmacy double steps criterias  (dim_restriction_type_id=1 and dim_criterion_type_id=2)
group4Restrictions INTEGER[] :=ARRAY[840,1865,1867];
--840 (Pharmacy) CT:2
--1865 (Pharmacy) CT:2
--1867 (Pharmacy) CT:2

group5Name varchar DEFAULT 'TEST_002_GROUP_5';--this group contains pharmacy mixed(single , double, triple, quadruple) steps criterias
group5Restrictions INTEGER[] :=ARRAY[840,1864,1865,841,842,2111,1882,1881,1880,1869];

group6Name varchar DEFAULT 'TEST_002_GROUP_6';--this group contains  medical Single steps criterias
group6Restrictions INTEGER[] :=ARRAY[1860,2106,2172,1861];

group7Name varchar DEFAULT 'TEST_002_GROUP_7';--this group contains pharmacy and medical Single steps criterias
group7Restrictions INTEGER[] :=ARRAY[840,1865,1867];

group8Name varchar DEFAULT 'TEST_002_GROUP_8';--this group contains pharmacy and medical  standard and steps criterias
group8Restrictions INTEGER[] :=ARRAY[776,809,1860,841];

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

  --CREATE REPORT CUSTOM CRITERIA  GROUP FOR #6
  PERFORM create_report_criteria_groups(reportId,reportClientId,group6Restrictions,group6Name,userEmail);

  --CREATE REPORT CUSTOM CRITERIA  GROUP FOR #7
  PERFORM create_report_criteria_groups(reportId,reportClientId,group7Restrictions,group7Name,userEmail);

  --CREATE REPORT CUSTOM CRITERIA  GROUP FOR #8
  PERFORM create_report_criteria_groups(reportId,reportClientId,group8Restrictions,group8Name,userEmail);
  
success:=true;
RETURN success;

EXCEPTION  when others then
	select throw_error('Error creating test data');	
	RETURN FALSE;

END
$$ LANGUAGE plpgsql;