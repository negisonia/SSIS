CREATE OR REPLACE FUNCTION test001createReportCriteriaGroups(reportId integer,reportClientiId integer, restrictionIds integer[], groupName varchar)
RETURNS boolean AS $$
DECLARE
success boolean DEFAULT false;
reportExists boolean DEFAULT false;
reportClientExists boolean DEFAULT false;
clientBelongsToReport boolean DEFAULT false;
restrictionExists boolean DEFAULT false;
restictionBelongsToReport boolean DEFAULT false;
groupExists boolean DEFAULT false;
restrictionId integer;
groupId integer;
testUserEmail varchar DEFAULT 'vsansilvestre@growthaccelerationpartners.com';
testMultiIndication boolean DEFAULT false;


BEGIN

SELECT EXISTS(SELECT 1 FROM reports r WHERE r.id=reportId) INTO reportExists;
SELECT EXISTS(SELECT 1 FROM report_clients rc WHERE rc.id=reportClientiId) INTO reportClientExists;
SELECT EXISTS(SELECT 1 FROM report_clients rc WHERE rc.id=reportClientiId AND rc.report_id=reportId) INTO clientBelongsToReport;
SELECT EXISTS(SELECT 1 FROM custom_criteria_groups ccg WHERE ccg.name=groupName) INTO groupExists;

--VALIDATE THAT THE REPORT ID PASSED AS ARGUMENT EXISTS
IF reportExists = false THEN
	RAISE EXCEPTION 'REPORT DOES NOT EXISTS';		
	success:=false; 
	RETURN success;	
ELSE 
	    --VALIDATE THAT THE REPORT CLIENT ID PASSED AS ARGUMENT EXISTS
	    IF reportClientExists = false THEN
		RAISE EXCEPTION 'REPORT CLIENT ID DOES NOT EXISTS';		
		success:=false; 
		RETURN success;	
	    ELSE
		--VALIDATE THAT THE REPORT_CLIENT_ID BELONGS TO THE REPORT
		IF clientBelongsToReport = false THEN
			RAISE EXCEPTION 'CLIENT DOES NOT BELONG TO REPORT';		
			success:=false; 
			RETURN success;	
		ELSE
			--VALIDATE THAT EACH RESTRICTION PASSED AS ARGUMENT EXISTS
			FOREACH restrictionId IN ARRAY restrictionIds
			LOOP
				SELECT EXISTS(SELECT 1 FROM criteria_restriction cr WHERE cr.id=restrictionId) INTO restrictionExists;
				IF restrictionExists = false THEN
					RAISE EXCEPTION 'RESTRICTION ID DOES NOT EXISTS';	
					success:=false; 
					RETURN success;	
				END IF;
				
			END LOOP;

			--VALIDATE THAT EACH RESTRICTION PASSED AS ARGUMENT BELONGS TO THE REPORT (ALREADY ADDED TO THE REPORT)
			FOREACH restrictionId IN ARRAY restrictionIds
			LOOP
				SELECT EXISTS(SELECT 1 FROM report_criterias rc WHERE rc.report_id=reportId AND rc.criteria_restriction_id=restrictionId) INTO restictionBelongsToReport;
				IF restictionBelongsToReport = false THEN
				        RAISE EXCEPTION 'RESTRICTION ID DOES NOT BELONG TO THE REPORT';	
					success:=false; 
					RETURN success;	
				END IF;				
			END LOOP;

			
			IF groupExists = false THEN --IF GROUP DOES NOT EXISTS CREATE IT
           		  INSERT INTO custom_criteria_groups ( name, indication_field_name, is_multi_indication, created_by, created_at, updated_at) VALUES (groupName,'', testMultiIndication, testUserEmail, now(), now()) RETURNING id INTO groupId;
			ELSE --IF THE GROUP EXISTS GET THE ID
			  SELECT ccg.id INTO groupId from custom_criteria_groups ccg WHERE ccg.name=groupName;		                
			END IF;

			--INSERT CLIENT CUSTOM CRITERIA GROUP
			INSERT INTO client_custom_criteria_groups (report_client_id, custom_criteria_group_id, display_order, is_active) VALUES(reportClientiId, groupId,1,true);

			--INSERT EACH RESTRICTION TO THE CUSTOM GROUP
			FOREACH restrictionId IN ARRAY restrictionIds
			LOOP
				IF (SELECT EXISTS (SELECT 1 FROM custom_criteria_group_criterias ccgc WHERE ccgc.custom_criteria_group_id=groupId AND ccgc.criteria_restriction_id=restrictionId) = false) THEN
					INSERT INTO custom_criteria_group_criterias (custom_criteria_group_id,criteria_restriction_id) VALUES(groupId,restrictionId);		
				END IF;
				
			END LOOP;
			
		END IF;
	    
	    END IF;
END IF;

success:=true;
RETURN success;

EXCEPTION  when others then
	RAISE EXCEPTION 'Error creating report criteria groups';	
	RETURN FALSE;

END
$$ LANGUAGE plpgsql;