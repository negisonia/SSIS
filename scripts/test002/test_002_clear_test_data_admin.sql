CREATE OR REPLACE FUNCTION test_002_clear_test_data()
  RETURNS boolean AS
$BODY$
DECLARE
success boolean DEFAULT false;
reportid integer;
groupid integer;

reportBussinesId varchar DEFAULT 'TEST REPORT 002';
reportName varchar DEFAULT 'TEST REPORT NAME 002';
group1Name varchar :='TEST_002_GROUP_1';
group2Name varchar :='TEST_002_GROUP_2';
group3Name varchar :='TEST_002_GROUP_3';
group4Name varchar :='TEST_002_GROUP_4';
group5Name varchar :='TEST_002_GROUP_5';
group6Name varchar :='TEST_002_GROUP_6';
group7Name varchar :='TEST_002_GROUP_7';
group8Name varchar :='TEST_002_GROUP_8';
BEGIN

	--DELETE REPORT DATA
	IF EXISTS(SELECT 1 from reports r where r.business_id=reportBussinesId AND r.name=reportName) THEN
	        SELECT r.id INTO reportid from reports r where r.business_id=reportBussinesId AND r.name=reportName;
	        delete from reports r WHERE r.id=reportid;
		delete from report_drugs rd WHERE rd.report_id=reportid;
		delete from report_criterias rc WHERE rc.report_id=reportid;
		delete from report_clients rcl WHERE rcl.report_id=reportid;
	ELSE
	      RAISE NOTICE 'REPORT ID DOES NOT EXISTS';	      
	END IF;

	--DELETE CUSTOM GROUP 1
	IF EXISTS(SELECT 1 from custom_criteria_groups ccg  where ccg.name=group1Name) THEN
	      SELECT ccg.id INTO groupid from custom_criteria_groups ccg  where ccg.name=group1Name;
              delete from custom_criteria_groups ccg WHERE ccg.id=groupid;
	      delete from custom_criteria_group_criterias ccgc WHERE ccgc.custom_criteria_group_id=groupid;
	      delete from client_custom_criteria_groups cccg WHERE cccg.custom_criteria_group_id =groupid;
	ELSE
	      RAISE NOTICE 'REPORT % DOES NOT EXISTS',group1Name;	      
	END IF;

	--DELETE CUSTOM GROUP 2
	IF EXISTS(SELECT 1 from custom_criteria_groups ccg  where ccg.name=group2Name) THEN
	      SELECT ccg.id INTO groupid from custom_criteria_groups ccg  where ccg.name=group2Name;
              delete from custom_criteria_groups ccg WHERE ccg.id=groupid;
	      delete from custom_criteria_group_criterias ccgc WHERE ccgc.custom_criteria_group_id=groupid;
	      delete from client_custom_criteria_groups cccg WHERE cccg.custom_criteria_group_id =groupid;
	ELSE
	      RAISE NOTICE 'REPORT % DOES NOT EXISTS',group2Name;	      
	END IF;

	--DELETE CUSTOM GROUP 3
	IF EXISTS(SELECT 1 from custom_criteria_groups ccg  where ccg.name=group3Name) THEN
	      SELECT ccg.id INTO groupid from custom_criteria_groups ccg  where ccg.name=group3Name;
              delete from custom_criteria_groups ccg WHERE ccg.id=groupid;
	      delete from custom_criteria_group_criterias ccgc WHERE ccgc.custom_criteria_group_id=groupid;
	      delete from client_custom_criteria_groups cccg WHERE cccg.custom_criteria_group_id =groupid;
	ELSE
	      RAISE NOTICE 'REPORT % DOES NOT EXISTS',group3Name;	      
	END IF;

	--DELETE CUSTOM GROUP 4
	IF EXISTS(SELECT 1 from custom_criteria_groups ccg  where ccg.name=group4Name) THEN
	      SELECT ccg.id INTO groupid from custom_criteria_groups ccg  where ccg.name=group4Name;
              delete from custom_criteria_groups ccg WHERE ccg.id=groupid;
	      delete from custom_criteria_group_criterias ccgc WHERE ccgc.custom_criteria_group_id=groupid;
	      delete from client_custom_criteria_groups cccg WHERE cccg.custom_criteria_group_id =groupid;
	ELSE
	      RAISE NOTICE 'REPORT % DOES NOT EXISTS',group4Name;	      
	END IF;

	--DELETE CUSTOM GROUP 5
	IF EXISTS(SELECT 1 from custom_criteria_groups ccg  where ccg.name=group5Name) THEN
	      SELECT ccg.id INTO groupid from custom_criteria_groups ccg  where ccg.name=group5Name;
              delete from custom_criteria_groups ccg WHERE ccg.id=groupid;
	      delete from custom_criteria_group_criterias ccgc WHERE ccgc.custom_criteria_group_id=groupid;
	      delete from client_custom_criteria_groups cccg WHERE cccg.custom_criteria_group_id =groupid;
	ELSE
	      RAISE NOTICE 'REPORT % DOES NOT EXISTS',group5Name;	      
	END IF;


	--DELETE CUSTOM GROUP 6
	IF EXISTS(SELECT 1 from custom_criteria_groups ccg  where ccg.name=group6Name) THEN
	      SELECT ccg.id INTO groupid from custom_criteria_groups ccg  where ccg.name=group6Name;
              delete from custom_criteria_groups ccg WHERE ccg.id=groupid;
	      delete from custom_criteria_group_criterias ccgc WHERE ccgc.custom_criteria_group_id=groupid;
	      delete from client_custom_criteria_groups cccg WHERE cccg.custom_criteria_group_id =groupid;
	ELSE
	      RAISE NOTICE 'REPORT % DOES NOT EXISTS',group6Name;	      
	END IF;

	--DELETE CUSTOM GROUP 7
	IF EXISTS(SELECT 1 from custom_criteria_groups ccg  where ccg.name=group7Name) THEN
	      SELECT ccg.id INTO groupid from custom_criteria_groups ccg  where ccg.name=group7Name;
              delete from custom_criteria_groups ccg WHERE ccg.id=groupid;
	      delete from custom_criteria_group_criterias ccgc WHERE ccgc.custom_criteria_group_id=groupid;
	      delete from client_custom_criteria_groups cccg WHERE cccg.custom_criteria_group_id =groupid;
	ELSE
	      RAISE NOTICE 'REPORT % DOES NOT EXISTS',group7Name;	      
	END IF;

	--DELETE CUSTOM GROUP 8
	IF EXISTS(SELECT 1 from custom_criteria_groups ccg  where ccg.name=group8Name) THEN
	      SELECT ccg.id INTO groupid from custom_criteria_groups ccg  where ccg.name=group8Name;
              delete from custom_criteria_groups ccg WHERE ccg.id=groupid;
	      delete from custom_criteria_group_criterias ccgc WHERE ccgc.custom_criteria_group_id=groupid;
	      delete from client_custom_criteria_groups cccg WHERE cccg.custom_criteria_group_id =groupid;
	ELSE
	      RAISE NOTICE 'REPORT % DOES NOT EXISTS',group8Name;	      
	END IF;

	
success:=true;
RETURN success;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION test_001_clear_test_data()
  OWNER TO postgres;
