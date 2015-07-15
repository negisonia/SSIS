CREATE OR REPLACE FUNCTION clear_test_data(reportBussinessId varchar,reportName varchar, groupNames varchar[])--ADMIN
  RETURNS boolean AS
$BODY$
DECLARE
success boolean DEFAULT false;
reportid integer;
groupid integer;
groupName varchar;
BEGIN
	IF (reportBussinessId = NULL) or (reportName = NULL) or (groupNames = NULL) THEN
		select throw_error('reportBussinessId , reportName and group names parameters are required');
	END IF;	

	--DELETE REPORT DATA
	IF EXISTS(SELECT 1 from reports r where r.business_id=reportBussinessId AND r.name=reportName) THEN
	        SELECT r.id INTO reportid from reports r where r.business_id=reportBussinessId AND r.name=reportName;
	        delete from reports r WHERE r.id=reportid;
		delete from report_drugs rd WHERE rd.report_id=reportid;
		delete from report_criterias rc WHERE rc.report_id=reportid;
		delete from report_clients rcl WHERE rcl.report_id=reportid;

		FOREACH groupName IN ARRAY groupNames
		LOOP
			--DELETE CUSTOM GROUP 1
			IF EXISTS(SELECT 1 from custom_criteria_groups ccg  where ccg.name=groupName) THEN
			      SELECT ccg.id INTO groupid from custom_criteria_groups ccg  where ccg.name=groupName;
			      delete from custom_criteria_groups ccg WHERE ccg.id=groupid;
			      delete from custom_criteria_group_criterias ccgc WHERE ccgc.custom_criteria_group_id=groupid;
			      delete from client_custom_criteria_groups cccg WHERE cccg.custom_criteria_group_id =groupid;
			ELSE
			      RAISE NOTICE 'REPORT % DOES NOT EXISTS',groupName;	      
			END IF;
		END LOOP;
		
	ELSE
	      RAISE NOTICE 'REPORT ID DOES NOT EXISTS';	      
	END IF;

	
success:=true;
RETURN success;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION test_001_clear_test_data()
  OWNER TO postgres;
