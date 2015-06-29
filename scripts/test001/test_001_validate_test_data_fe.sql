CREATE OR REPLACE FUNCTION test_001_validate_test_data()--FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT false;
  reportId integer;
  drugid integer;
  restrictionid integer;
  reportBussinesId varchar DEFAULT 'TEST REPORT 001';
  reportName varchar DEFAULT 'TEST REPORT NAME 001';
  restrictionGroupName varchar DEFAULT 'TEST GROUP 001';
  drugIds INTEGER[] := ARRAY[156, 160];
  restrictionsIds INTEGER[]:= ARRAY[775,776,706,707];
  drugIds2 INTEGER[] := ARRAY[2059, 2268];

  groupExists boolean DEFAULT false;
  group1Restrictions integer[]:= ARRAY[775,776];
  group2Restrictions integer[]:= ARRAY[706,707];

BEGIN
	--GET THE TEST REPORT ID
	SELECT crr.report_id FROM criteria_restriction_reports crr WHERE crr.business_id=reportBussinesId and  crr.report_name=reportName INTO reportId;

	--VALIDATE THAT THE TEST REPORT IS AVAILABLE IN THE FRONT END DATABASE
	IF reportId = null THEN
		SELECT throw_error('TEST REPORT DOES NOT EXISTS');
		success:=false;
		RETURN success;
	ELSE
	
	--VALIDATE THAT THE TEST REPORT DRUGS IN THE FRONT END DATABASE ARE THE SAME AS THE REPORT DRUGS IN THE ADMIN DATABASE
	 FOREACH drugid IN ARRAY drugIds
	 LOOP
	   IF (SELECT EXISTS (SELECT 1 FROM criteria_restriction_drugs crd WHERE crd.report_id=reportId AND crd.drug_id=drugid) = false) THEN
		select throw_error('TEST REPORT DRUG DOES NOT EXISTS');
		success:=false;
		RETURN success;
	   END IF;
	 END LOOP;

	--VALIDATE THAT THE TEST REPORT DRUGS IN THE FRONT END DATABASE ARE THE SAME AS THE REPORT DRUGS IN THE ADMIN DATABASE
	 FOREACH drugid IN ARRAY drugIds2
	 LOOP
	   IF (SELECT EXISTS (SELECT 1 FROM criteria_restriction_drugs crd WHERE crd.report_id=reportId AND crd.drug_id=drugid) = false) THEN
		select throw_error('TEST REPORT DRUG DOES NOT EXISTS');
		success:=false;
		RETURN success;	  
	   END IF;
	 END LOOP;

	--VALIDATE THAT THE TEST REPORT RESTRICTIONS IN THE FRONT END DATABASE ARE THE SAME AS ADMIN  DATABASE
	 FOREACH restrictionid IN ARRAY restrictionsIds
	 LOOP
	   IF (SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection  crs WHERE crs.report_id=reportId and crs.dim_criteria_restriction_id=restrictionid) = false) THEN
		select throw_error('TEST REPORT RESTRICTION DOES NOT EXISTS');
		success:=false;
		RETURN success;	  
	  END IF;
	 END LOOP;

	SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name=restrictionGroupName AND ccs.report_id=reportId) INTO groupExists;
	IF groupExists = false THEN
		select throw_error('TEST REPORT GROUP 1 DOES NOT EXISTS');
		success:=false;
		RETURN success;	
	END IF;

	--SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name='TEST GROUP 002' AND ccs.report_id=reportId) INTO groupExists;
	--IF groupExists = false THEN
	--	RAISE EXCEPTION 'TEST REPORT GROUP 2 DOES NOT EXISTS';
	--	success:=false;
	--	RETURN success;	
	--END IF;

	--VALIDATE THAT THE TEST REPORT GROUP RESTRICTIONS ARE VALID
	 --FOREACH restrictionid IN ARRAY group1Restrictions
	 --LOOP
	   --IF (SELECT EXISTS (SELECT 1 FROM custom_criteron_selection  ccs WHERE ccs.report_id=reportId and ccs.criteria_restriction_name='TEST GROUP 001' and ccs.dim_criteria_restriction_id=restrictionid) = false) THEN
		--RAISE EXCEPTION 'TEST REPORT CRITERIA DOES NOT EXISTS';
		--success:=false;
		--RETURN success;	  
	   --END IF;
	 --END LOOP;

	--VALIDATE THAT THE TEST REPORT GROUP2 RESTRICTIONS ARE VALID
	-- FOREACH restrictionid IN ARRAY group2Restrictions
	-- LOOP
	  -- IF (SELECT EXISTS (SELECT 1 FROM custom_criteron_selection  ccs WHERE ccs.report_id=reportId and ccs.criteria_restriction_name='TEST GROUP 002' and ccs.dim_criteria_restriction_id=restrictionid) = false) THEN
		--RAISE EXCEPTION 'TEST REPORT CRITERIA DOES NOT EXISTS';
		--success:=false;
		--RETURN success;	  
	  -- END IF;
	 --END LOOP;

END IF;
success:=true;
RETURN success;	  
	

END
$$ LANGUAGE plpgsql;