CREATE OR REPLACE FUNCTION create_report_restrictions(reportId integer, restrictionIds integer[]) --ADMIN DB
RETURNS boolean AS $$
DECLARE
success boolean DEFAULT false;
reportExists boolean DEFAULT false;
restrictionExists boolean DEFAULT false;
validRestrictionForReport boolean DEFAULT false;
reportCriteriaExists boolean DEFAULT false;
restrictionId integer;
indicationId integer;
BEGIN

SELECT EXISTS(SELECT 1 FROM reports r WHERE r.id=reportId) INTO reportExists;

--VALIDATE THAT THE REPORT ID PASSED AS ARGUMENT EXISTS
IF reportExists =false THEN 
	select throw_error('REPORT ID PASSED AS ARGUMENT DOES NOT EXISTS');	
	success:=false; 
	RETURN success;	
ELSE
	--VALIDATE THAT EACH RESTRICTION PASSED AS ARGUMENT EXISTS
	FOREACH restrictionId IN ARRAY restrictionIds
	LOOP
		SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr.id=restrictionId) INTO restrictionExists;
		IF restrictionExists = false THEN			
			select throw_error('RESTRICTION ID DOES NOT EXISTS');	
			success:=false; 
			RETURN success;	
		END IF;
		
	END LOOP;

	--VALIDATE THAT EACH RESTRICTION INDICATION_ID IS VALID BASED ON THE INDICATION_ID OF THE DRUGS THAT BELONG TO THE REPORT
	--EACH RESTRICTION CONTAINS AN INDICATION_ID , THAT ID MUST BE EQUAL TO ANY INDICATION_ID OF THE REPORT DRUGS (THE RESTRICTION IS VALID FOR ANY OF THE REPORT DRUGS)
	FOREACH restrictionId IN ARRAY restrictionIds
	LOOP		
		SELECT cr.indication_id INTO indicationId FROM criteria_restriction cr WHERE cr.id=restrictionId;--FIND THE RESTRICTION INDICATION_ID
		SELECT EXISTS(SELECT 1 from report_drugs rd WHERE rd.report_id=reportId AND rd.indication_id=indicationId) INTO validRestrictionForReport;--VALIDATE THAT THE RESTRICTION IS VALID BASED ON THE REPORT DRUGS
		IF validRestrictionForReport = false THEN 
		        select throw_error('RESTRICTION NOT VALID FOR REPORT');	
			success:=false; 
			RETURN success;		
		END IF;
	END LOOP;

	--INSERT REPORT RESTRICTIONS
	FOREACH restrictionId IN ARRAY restrictionIds
	LOOP		
		SELECT EXISTS(SELECT 1 FROM report_criterias rc WHERE rc.report_id=reportId AND rc.criteria_restriction_id=restrictionId) INTO reportCriteriaExists;
		IF reportCriteriaExists = false THEN --VALIDATE THAT THE RESTRICTION DOES NOT EXISTS
			INSERT INTO report_criterias (report_id,criteria_restriction_id) VALUES(reportId,restrictionId);
		END IF;
	END LOOP;

END IF;

success:=true;
RETURN success;	
END
$$ LANGUAGE plpgsql;
