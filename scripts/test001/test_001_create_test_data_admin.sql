CREATE OR REPLACE FUNCTION test_001_create_test_data() --ADMIN DB
RETURNS boolean AS $$
DECLARE
success boolean DEFAULT false;
reportId INTEGER;
reportClientId INTEGER;
reportClientName varchar DEFAULT 'TEST CLIENT 01';
userEmail varchar DEFAULT 'vsansilvestre@growthaccelerationpartners.com';
groupName1 varchar DEFAULT 'TEST GROUP 001';
groupName2 varchar DEFAULT 'TEST GROUP 002';
reportBussinesId varchar DEFAULT 'TEST REPORT 001';
reportName varchar DEFAULT 'TEST REPORT NAME 001';

indicationId integer:=7;
drugIds INTEGER[] := ARRAY[156, 160];
restrictionsIds INTEGER[]:= ARRAY[775,776];

drugIds2 INTEGER[] := ARRAY[2059, 2268];
indicationId2 integer:=6;
restrictionsIds2 INTEGER[]:= ARRAY[706,707];
BEGIN

  --CREATE REPORT AND STORE ID ON REPORTID  VARIABLE FOR FURTHER USAGE
  SELECT create_report(reportBussinesId,reportName) INTO reportId;
  --CREATE  CLIENT AND REPORT CLIENT
  SELECT create_report_client(reportId,reportClientName) INTO reportClientId;
  --ADD DRUGS TO THE CREATED REPORT FOR THE SPECIFIED INDICATION ID
  PERFORM create_report_drugs(reportId,drugIds,indicationId);
  --CREATE REPORT RESTRICTIONS
  PERFORM create_report_restrictions(reportId,restrictionsIds);
  --CREATE REPORT CUSTOM CRITERIA  GROUP
  PERFORM create_report_criteria_groups(reportId,reportClientId,restrictionsIds,groupName1,userEmail);
  --ADD DRUGS TO THE REPORT (DIFFERENT INDICATION THAN PREVIOUS DRUGS)
  PERFORM create_report_drugs(reportId,drugIds2,indicationId2) ;
  --ADD REPORT RESTRICTIONS (RESTRICTIONS THAT MATCHES THE NEW DRUGS INDICATION)
  PERFORM create_report_restrictions(reportId,restrictionsIds2); 
  --CREATE CRITERIA GROUPS FOR THE SECOND GROUP OF RESTRICTIONS
  PERFORM create_report_criteria_groups(reportId,reportClientId,restrictionsIds2,groupName2,userEmail);
  
 
success:=true;
RETURN success;

EXCEPTION  when others then
	select throw_error('Error creating test data');	
	RETURN FALSE;
END
$$ LANGUAGE plpgsql;