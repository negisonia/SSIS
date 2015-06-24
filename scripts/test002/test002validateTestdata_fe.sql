CREATE OR REPLACE FUNCTION test002validatetestdata() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT false;
  reportId integer;
  drugid integer;
  restrictionid integer;
  reportBussinesId varchar DEFAULT 'TEST REPORT 002';
  reportName varchar DEFAULT 'TEST REPORT NAME 002';
  drugIds INTEGER[] := ARRAY[156,160,2182, 3098, 3199, 3237, 3584];
  restrictionsIds INTEGER[]:= ARRAY[809,810,811,776,777,778,812,813,775,840,1865,1864,1867,841,842,2111,1882,1881,1880,1869,1860,2106,2172,1861];  
  groups VARCHAR[] :=ARRAY[group1Name,group2Name,group3Name,group4Name,group5Name,group6Name,group7Name,group8Name];

BEGIN

        SELECT validatereport(reportBussinesId,reportName,drugIds,restrictionsIds,groups);

	--GET THE TEST REPORT ID
	SELECT crr.report_id FROM criteria_restriction_reports crr WHERE crr.business_id=reportBussinesId and  crr.report_name=reportName INTO reportId;

	--VALIDATE THAT THE TEST REPORT IS AVAILABLE IN THE FRONT END DATABASE
	IF reportId != null THEN
		--  VALIDATE REPORT GROUPS
		PERFORM test002validategroups(reportId);
       END IF;

success:=true;
RETURN success;	  
	
END
$$ LANGUAGE plpgsql;