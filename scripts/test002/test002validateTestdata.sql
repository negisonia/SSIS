CREATE OR REPLACE FUNCTION test002validateTestData() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT false;
  reportId integer;
  drugid integer;

  restrictionid integer;
  reportBussinesId varchar DEFAULT 'TEST REPORT 002';
  reportName varchar DEFAULT 'TEST REPORT NAME 002';

  drugIds INTEGER[] := ARRAY[156,160,2182, 3098, 3199, 3237, 3584];
  restrictionsIds INTEGER[]:= ARRAY[775,776,777,778,779,780,781,782,783,784,785,786,787,788,789,790,791,792,793,794,795,796,797,798,799,800,801,802,803,804,805,806,807,808,809,810,811,812,813,814,815,816,817,818,819,820,821,822,823,824,825,826,827,828,829,830,831,832,833,834,835,836,837,838,839,840,841,842,843,844,845,846,847,848,1860,1861,1864,1865,1866,1867,1868,1869,1870,1871,1872,1873,1874,1875,1876,1877,1878,1879,1880,1881,1882,1883,1884,1885,2105,2106,2107,2108,2109,2110,2111,2172,2174,2175];
  

  reportIndication integer:=7; 	

  group1id integer DEFAULT null;	
  group2id integer DEFAULT null;
  group3id integer DEFAULT null;
  
  group1Exists boolean DEFAULT false;
  group2Exists boolean DEFAULT false;
  group3Exists boolean DEFAULT false;

  group1Name varchar DEFAULT 'TEST_002_GROUP_TYPE_1';
  group2Name varchar DEFAULT 'TEST_002_GROUP_TYPE_2';
  group3Name varchar DEFAULT 'TEST_002_GROUP_TYPE_1_2';

  group1Restrictions integer[]:= ARRAY[775,776,777,787,788,789,809,810,811,812,813,821,822,823,846];
  group2Restrictions integer[]:= ARRAY[840,841,842,847,848,1860,1861,1864,1865,1866,1867,1868,1869,1870,1871,1872,1873,1874,1875,1876,1877,1878,1879,1880,1881,1882,1883,1884,1885,2105,2106,2107,2108,2109,2110,2111,2172,2174,2175];
  group3Restrictions integer[]:= ARRAY[775,776,777,787,788,789,809,810,811,840,841,842,847,848,1860,1861,1864,1865,1866];

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

	--VALIDATE CUSTOM GROUP1
		-- VALIDATE GROUP1 EXISTS IN FRONT END WITH ITS VALID DIM CRITERION TYPE (3)
		SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name=group1Name AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=3) INTO group1Exists;		
		IF group1Exists = false THEN
			select throw_error(group1Name || ' DOES NOT EXISTS');
			success:=false;
			RETURN success;			
		END IF;	
	
		--VALIDATE GROUP 1 RESTRICTIONS CONTAINS DIM CRITERION TYPE EQUALS 3
		FOREACH restrictionid IN ARRAY group1Restrictions
		LOOP
		IF ( SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs where ccs.report_id = reportId and ccs.indication_id=reportIndication and ccs.dim_criteria_restriction_id=restrictionid and ccs.dim_criterion_type_id=3) = FALSE) THEN
   		        select throw_error( 'RESTRICTION ' || restrictionid || ' CONTAINS AN INVALID DIM CRITERION TYPE');
			success:=false;
			RETURN success;	
		END IF;
		END LOOP;
	-----------------------------------------------------	

	-- VALIDATE CUSTOM GROUP 2
		-- VALIDATE GROUP2 EXISTS IN FRONT END WITH ITS VALID DIM CRITERION TYPE (3)
		SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name=group2Name AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=3) INTO group2Exists;		
		IF group2Exists = false THEN
			select throw_error(group2Name || ' DOES NOT EXISTS');
			success:=false;
			RETURN success;	
		END IF;	

		--VALIDATE GROUP 2 RESTRICTIONS CONTAINS DIM CRITERION TYPE EQUALS 5
		FOREACH restrictionid IN ARRAY group2Restrictions
		LOOP
		IF ( SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs where ccs.report_id = reportId and ccs.indication_id=reportIndication and ccs.dim_criteria_restriction_id=restrictionid and ccs.dim_criterion_type_id=5) = FALSE) THEN
   		        select throw_error( 'RESTRICTION ' || restrictionid || ' CONTAINS AN INVALID DIM CRITERION TYPE');
			success:=false;
			RETURN success;	
		END IF;
		END LOOP;

	-----------------------------------------------------	

	-- VALIDATE CUSTOM GROUP 3
		-- VALIDATE GROUP3 EXISTS IN FRONT END WITH ITS VALID DIM CRITERION TYPE (5)
		SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name=group3Name AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=3) INTO group3Exists;		
		IF group3Exists = false THEN
			select throw_error(group3Name || ' DOES NOT EXISTS');
			success:=false;
			RETURN success;	
		END IF;	

		--VALIDATE GROUP 3 RESTRICTIONS CONTAINS DIM CRITERION TYPE EQUALS 5
		FOREACH restrictionid IN ARRAY group3Restrictions
		LOOP
		IF ( SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs where ccs.report_id = reportId and ccs.indication_id=reportIndication and ccs.dim_criteria_restriction_id=restrictionid and ccs.dim_criterion_type_id=5) = FALSE) THEN
   		        select throw_error( 'RESTRICTION ' || restrictionid || ' CONTAINS AN INVALID DIM CRITERION TYPE');
			success:=false;
			RETURN success;	
		END IF;
		END LOOP;


END IF;
success:=true;
RETURN success;	  
	

END
$$ LANGUAGE plpgsql;