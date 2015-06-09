CREATE OR REPLACE FUNCTION test001createtestdata()
RETURNS boolean AS $$
DECLARE
success boolean DEFAULT false;
reportId INTEGER;
reportClientId INTEGER;
reportDrugsStatus boolean DEFAULT FALSE;
reportRestrictionsStatus boolean DEFAULT false;
reportCriteriaGroupStatus boolean DEFAULT false;

indicationId integer:=7;
drugIds INTEGER[] := ARRAY[156, 160];
restrictionsIds INTEGER[]:= ARRAY[775,776];

drugIds2 INTEGER[] := ARRAY[2059, 2268];
indicationId2 integer:=6;
restrictionsIds2 INTEGER[]:= ARRAY[706,707];
BEGIN

  --CREATE REPORT AND STORE ID ON REPORTID  VARIABLE FOR FURTHER USAGE
  select test001createreporttestdata() INTO reportId;
  --CREATE  CLIENT AND REPORT CLIENT
  SELECT test001createReportClientTestData(reportId) into reportClientId;
  --ADD DRUGS TO THE CREATED REPORT FOR THE SPECIFIED INDICATION ID
  SELECT test001createreportdrugstestdata(reportId,drugIds,indicationId) into reportDrugsStatus;
  --CREATE REPORT RESTRICTIONS
  SELECT test001createreportrestrictions(reportId,restrictionsIds) into reportRestrictionsStatus;
  --CREATE REPORT CUSTOM CRITERIA  GROUP
  SELECT test001createreportcriteriagroups(reportId,reportClientId,restrictionsIds,'TEST GROUP 001') into reportCriteriaGroupStatus;
  --ADD DRUGS TO THE REPORT (DIFFERENT INDICATION THAN PREVIOUS DRUGS)
  SELECT test001createreportdrugstestdata(reportId,drugIds2,indicationId2) into reportDrugsStatus;
  --ADD REPORT RESTRICTIONS (RESTRICTIONS THAT MATCHES THE NEW DRUGS INDICATION)
  SELECT test001createreportrestrictions(reportId,restrictionsIds2) into reportRestrictionsStatus; 
  --CREATE CRITERIA GROUPS FOR THE SECOND GROUP OF RESTRICTIONS
  SELECT test001createreportcriteriagroups(reportId,reportClientId,restrictionsIds2,'TEST GROUP 002') into reportCriteriaGroupStatus;
  
  

success:=true;
RETURN success;

EXCEPTION  when others then
	RAISE EXCEPTION 'Error creating test data';	
	RETURN FALSE;
END
$$ LANGUAGE plpgsql;