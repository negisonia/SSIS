CREATE OR REPLACE FUNCTION test002validateTestData() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT false;
  reportId integer;
  drugid integer;

  restrictionid integer;
  dim_restriction record;
  reportBussinesId varchar DEFAULT 'TEST REPORT 002';
  reportName varchar DEFAULT 'TEST REPORT NAME 002';

  drugIds INTEGER[] := ARRAY[156,160,2182, 3098, 3199, 3237, 3584];
  restrictionsIds INTEGER[]:= ARRAY[809,810,811,812,813,775,776,777,778,840,1865,1867];
  

  reportIndication integer:=7; 	

  
  
  group1Exists boolean DEFAULT false;
  group2Exists boolean DEFAULT false;
  group3Exists boolean DEFAULT false;
  group4Exists boolean DEFAULT false;

  group1Name varchar DEFAULT 'TEST_002_GROUP_1';
  group2Name varchar DEFAULT 'TEST_002_GROUP_2';
  group3Name varchar DEFAULT 'TEST_002_GROUP_3';
  group4Name varchar DEFAULT 'TEST_002_GROUP_4';

  group1Restrictions integer[]:= ARRAY[809,810,811];
  group2Restrictions integer[]:= ARRAY[776,777,778];
  group3Restrictions integer[]:= ARRAY[776,777,778];



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
		
		--VALIDATE THAT THE TEST REPORT RESTRICTIONS IN THE FRONT END DATABASE ARE THE SAME AS ADMIN  DATABASE
		 FOREACH restrictionid IN ARRAY restrictionsIds
		 LOOP
		   IF (SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection  crs WHERE crs.report_id=reportId and crs.dim_criteria_restriction_id=restrictionid) = false) THEN
			select throw_error('TEST REPORT RESTRICTION DOES NOT EXISTS');
			success:=false;
			RETURN success;	  
		  END IF;
		 END LOOP;

		--VALIDATE THAT GROUP1 EXISTS IN FRONT END DATABASE (criterion type must be 3 and restriction type must be 6)
		SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name=group1Name AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=3 and ccs.dim_restriction_type_id=6) INTO group1Exists;		
		IF group1Exists = false THEN
			select throw_error(group1Name || 'GROUP DOES NOT EXISTS');
			success:=false;
			RETURN success;			
		END IF;	

		--VALIDATE THAT GROUP2 EXISTS IN FRONT END DATABASE (criterion type must be 3 and restriction type must be 2)
		SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name=group2Name AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=3 and ccs.dim_restriction_type_id=2) INTO group2Exists;
		IF group2Exists = false THEN
			select throw_error(group2Name || 'GROUP DOES NOT EXISTS');
			success:=false;
			RETURN success;			
		END IF;	


		--VALIDATE THAT GROUP3 EXISTS IN FRONT END DATABASE ( should exists 2 custom groups both with criterion type = 3 and one with restriction type = 2 for Medical and the other restriction type =6 for Pharmacy restrictions )
		IF (SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name=group3Name AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=3 and ccs.dim_restriction_type_id=2) = false) or
		   (SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name=group3Name AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=3 and ccs.dim_restriction_type_id=6) = false)
		 THEN
			select throw_error(group3Name || ' GROUP DOES NOT EXISTS');
			success:=false;
			RETURN success;			
		END IF;	

		--VALIDATE THAT GROUP4 EXISTS IN FRONT END DATABASE (criterion type must be 3 and restriction type must be 6)
		SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name=group4Name AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=3 and ccs.dim_restriction_type_id=6) INTO group4Exists;
		IF group4Exists = false THEN
			select throw_error(group4Name || ' GROUP DOES NOT EXISTS');
			success:=false;
			RETURN success;			
		END IF;	

		IF  (SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name like group4Name || ' - %' AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=5 and ccs.dim_restriction_type_id=6) = false) or
			(SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name like group4Name || ' - %' AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=5 and ccs.dim_restriction_type_id=1) = false)
		THEN
			select throw_error(group4Name || ' GROUP DOES NOT EXISTS');
			success:=false;
			RETURN success;			
		END IF;	


       END IF;

success:=true;
RETURN success;	  
	
END
$$ LANGUAGE plpgsql;