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
  select createreporttestdata() INTO reportId;
  IF reportId > -1 THEN --IF RESULT OF REPORT CREATION WAS SUCCESS THE ID MOST BE GREATER THAN -1
	SELECT createReportClientTestData(reportId) into reportClientId; --CREATE  CLIENT AND REPORT CLIENT
	IF reportClientId > -1 THEN --IF RESULT OF REPORT CLIENT CREATION WAS SUCCESS THE ID MOST BE GREATER THAN -1
		SELECT createreportdrugstestdata(reportId,drugIds,indicationId) into reportDrugsStatus;--ADD DRUGS TO THE CREATED REPORT FOR THE SPECIFIED INDICATION ID
		IF reportDrugsStatus THEN
			SELECT createreportrestrictions(reportId,restrictionsIds) into reportRestrictionsStatus;--CREATE REPORT RESTRICTIONS
			IF reportRestrictionsStatus THEN
				SELECT createreportcriteriagroups(reportId,reportClientId,restrictionsIds,'TEST GROUP 001') into reportCriteriaGroupStatus;--CREATE REPORT CUSTOM CRITERIA  GROUPS
				IF reportCriteriaGroupStatus then
				success:=true;
				ELSE
				 RAISE NOTICE 'ERROR CREATING REPORT CRITERIA GROUPS';	
				 success:=false;
				 RETURN success;
				END IF;
			ELSE
				RAISE NOTICE 'ERROR CREATING REPORT RESTRICTIONS';
				 success:=false;
				 RETURN success;
			END IF;
		ELSE
			RAISE NOTICE 'ERROR CREATING REPORT DRUGS';
			success:=false;
			 RETURN success;
		END IF;

		SELECT createreportdrugstestdata(reportId,drugIds2,indicationId2) into reportDrugsStatus;--ADD DRUGS TO THE REPORT (DIFFERENT INDICATION THAN PREVIOUS DRUGS)
		IF reportDrugsStatus THEN
			SELECT createreportrestrictions(reportId,restrictionsIds2) into reportRestrictionsStatus; --ADD REPORT RESTRICTIONS (RESTRICTIONS THAT MATCHES THE NEW DRUGS INDICATION)
			IF reportRestrictionsStatus THEN
				SELECT createreportcriteriagroups(reportId,reportClientId,restrictionsIds2,'TEST GROUP 002') into reportCriteriaGroupStatus;--CREATE CRITERIA GROUPS FOR THE SECOND GROUP OF RESTRICTIONS
				IF reportCriteriaGroupStatus then
				success:=true;
				ELSE
				 RAISE NOTICE 'ERROR CREATING REPORT CRITERIA GROUPS';	
				 success:=false;
				 RETURN success;
				END IF;
			ELSE
				RAISE NOTICE 'ERROR CREATING REPORT RESTRICTIONS';
				 success:=false;
				 RETURN success;
			END IF;
		ELSE
			RAISE NOTICE 'ERROR CREATING REPORT DRUGS';
			success:=false;
			 RETURN success;
		END IF;
	ELSE
		RAISE NOTICE 'ERROR CREATING REPORT CLIENT';
		success:=false;
		RETURN success;
	END IF;
  ELSE
	RAISE NOTICE 'ERROR CREATING REPORT';
	success:=false;
	RETURN success;
  END IF;

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;