CREATE OR REPLACE FUNCTION clearReportTestData()
  RETURNS boolean AS $$
DECLARE
success boolean DEFAULT false;
reportid integer;
groupid1 integer;
groupid2 integer;
BEGIN

	IF EXISTS(SELECT 1 from reports r where r.business_id='TEST REPORT 001' AND r.name='TEST REPORT NAME 001') THEN
	      SELECT r.id INTO reportid from reports r where r.business_id='TEST REPORT 001' AND r.name='TEST REPORT NAME 001';
	ELSE
	      RAISE NOTICE 'REPORT ID DOES NOT EXISTS';
	      success:=false;
	      RETURN success;
	END IF;

	IF EXISTS(SELECT 1 from custom_criteria_groups ccg  where ccg.name='TEST GROUP 001') THEN
	      SELECT ccg.id INTO groupid1 from custom_criteria_groups ccg  where ccg.name='TEST GROUP 001';
	ELSE
	      RAISE NOTICE 'REPORT GROUP 001 DOES NOT EXISTS';
	      success:=false;
	      RETURN success;
	END IF;

	IF EXISTS(SELECT 1 from custom_criteria_groups ccg  where ccg.name='TEST GROUP 002') THEN
	      SELECT ccg.id INTO groupid2 from custom_criteria_groups ccg  where ccg.name='TEST GROUP 002';
	ELSE
	      RAISE NOTICE 'REPORT GROUP 002 DOES NOT EXISTS';
	      success:=false;
	      RETURN success;
	END IF;
	
	delete from reports r WHERE r.id=reportid;
	delete from report_drugs rd WHERE rd.report_id=reportid;
	delete from report_criterias rc WHERE rc.report_id=reportid;
	delete from report_clients rcl WHERE rcl.report_id=reportid;
	delete from custom_criteria_groups ccg WHERE ccg.id=groupid1 or ccg.id=groupid2;
	delete from custom_criteria_group_criterias ccgc WHERE ccgc.custom_criteria_group_id=groupid1 or ccgc.custom_criteria_group_id=groupid2;
	delete from client_custom_criteria_groups cccg WHERE cccg.custom_criteria_group_id =groupid1 or cccg.custom_criteria_group_id =groupid2;
	
success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;