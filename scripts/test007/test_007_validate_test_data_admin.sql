--THIS FUNCTION VALIDATES THE OUTPUT OF THE RPT_DRUG FUNCTION (lives, pharmacy lives, health plan count, providers)
CREATE OR REPLACE FUNCTION test_007_validate_test_data() --FRONT END DB
RETURNS boolean AS $$
DECLARE
  --TEST VARIABLES
  success boolean DEFAULT false;
  reportId integer DEFAULT 0;
  reportfeId integer DEFAULT 0;
  intvalue integer; 
  
  --EXPECTED VALUES
  expected_rpt_drug_01_output VARCHAR:='{"criteria_report_id":%s,"indication_name":"ALL","dim_criteria_restriction_id":846,"drug_id":2182,"lives":24559932,"health_plan_count":108,"provider_count":0,"total_pharmacy_lives":49430874,"total_medical_lives":0,"total_health_plan_count":253,"total_provider_count":0,"benefit_name":"Pharmacy","criteria_restriction_name":"QL - Quantity Limits","drug_name":"Sprycel","dim_restriction_type_id":4,"restriction_name":"QL"}';
  expected_rpt_drug_02_output VARCHAR:='{"criteria_report_id":%s,"indication_name":"ALL","dim_criteria_restriction_id":826,"drug_id":156,"lives":12493312,"health_plan_count":52,"provider_count":0,"total_pharmacy_lives":49430874,"total_medical_lives":0,"total_health_plan_count":253,"total_provider_count":0,"benefit_name":"Pharmacy","criteria_restriction_name":"PA - Diagnosis - Relapsed or refractory disease.","drug_name":"Gleevec","dim_restriction_type_id":1,"restriction_name":"PA - Diagnosis"}';
  expected_rpt_drug_03_output VARCHAR:='{"criteria_report_id":%s,"indication_name":"ALL","dim_criteria_restriction_id":1885,"drug_id":2182,"lives":11120680,"health_plan_count":14,"provider_count":0,"total_pharmacy_lives":49430874,"total_medical_lives":0,"total_health_plan_count":253,"total_provider_count":0,"benefit_name":"Pharmacy","criteria_restriction_name":"ST - Unspecified - Unspecified","drug_name":"Sprycel","dim_restriction_type_id":3,"restriction_name":"ST - Unspecified"}';

  --ACTUAL VALUES
  actual_rpt_drug_output VARCHAR;

  --TEST DATA
  indicationid integer:=7;
  reportBussinesId varchar DEFAULT 'TEST REPORT 007';
  reportName varchar DEFAULT 'TEST REPORT NAME 007';
  drugIds INTEGER[] := ARRAY[156,160,2182, 3098, 3199, 3237, 3584];
  restrictionsIds INTEGER[]:= ARRAY[775,776,777,778,779,780,781,782,783,784,785,786,787,788,789,790,791,792,793,794,795,796,797,798,799,800,801,802,803,804,805,806,807,808,809,810,811,812,813,814,815,816,817,818,819,820,821,822,823,824,825,826,827,828,829,830,831,832,833,834,835,836,837,838,839,840,841,842,843,844,845,846,847,848,1860,1861,1864,1865,1866,1867,1868,1869,1870,1871,1872,1873,1874,1875,1876,1877,1878,1879,1880,1881,1882,1883,1884,1885,2105,2106,2107,2108,2109,2110,2111,2172,2174,2175];
  
BEGIN
        --VALIDATE REPORT DATA INTEGRITY (DRUGS, RESTRICTIONS, CUSTOM GROUPS, REPORT)
        PERFORM validate_report(reportBussinesId,reportName,drugIds,restrictionsIds,NULL);

	--GET THE TEST REPORT ID
	SELECT crr.report_id FROM criteria_restriction_reports crr WHERE crr.business_id=reportBussinesId and  crr.report_name=reportName INTO reportId;
	
	IF reportId <> 0 THEN

	        --QUANTITY LIMIT RESTRICTION  HPT=1  		
               -----------------------------------------------------------	       
			--CREATE REPORT
			SELECT create_report(reportId,1,1,'national', ARRAY[2182],ARRAY[1], NULL, NULL, NULL, ARRAY[846]) INTO reportfeId;  

			--RUN RPT_DRUG FUNCTION
			SELECT to_json(rpt_drug(reportfeId)) INTO actual_rpt_drug_output;
			RAISE  NOTICE 'TEST1: %', actual_rpt_drug_output;
			--VALIDATE REPORT
			IF actual_rpt_drug_output!=format(expected_rpt_drug_01_output,reportfeId) THEN
				RAISE NOTICE 'ACTUAL:%',actual_rpt_drug_output;
				RAISE NOTICE 'EXPECTED:%',expected_rpt_drug_01_output;
				SELECT throw_error('RPT DRUG FUNCTION VALUES MISMATCH');
			END IF;

	        --PRIOR AUTHORIZATION RESTRICTION HPT=1 
               -----------------------------------------------------------
			--CREATE REPORT
			SELECT create_report(reportId,1,1,'national', ARRAY[156],ARRAY[1], NULL, NULL, NULL, ARRAY[826]) INTO reportfeId;  

			--RUN RPT_DRUG FUNCTION
			SELECT to_json(rpt_drug(reportfeId)) INTO actual_rpt_drug_output;
			RAISE  NOTICE 'TEST2: %', actual_rpt_drug_output;
			--VALIDATE REPORT
			IF actual_rpt_drug_output!=format(expected_rpt_drug_02_output,reportfeId) THEN
				RAISE NOTICE 'ACTUAL:%',actual_rpt_drug_output;
				RAISE NOTICE 'EXPECTED:%',expected_rpt_drug_02_output;
				SELECT throw_error('RPT DRUG FUNCTION VALUES MISMATCH');
			END IF;

		--STEP THERAPY RESTRICTION HPT=1 
               -----------------------------------------------------------
			--CREATE REPORT
			SELECT create_report(reportId,1,1,'national', ARRAY[2182],ARRAY[1], NULL, NULL, NULL, ARRAY[1885]) INTO reportfeId;  

			--RUN RPT_DRUG FUNCTION
			SELECT to_json(rpt_drug(reportfeId)) INTO actual_rpt_drug_output;
			RAISE  NOTICE 'TEST3: %', actual_rpt_drug_output;
			--VALIDATE REPORT
			IF actual_rpt_drug_output!=format(expected_rpt_drug_03_output,reportfeId) THEN
				RAISE NOTICE 'ACTUAL:%',actual_rpt_drug_output;
				RAISE NOTICE 'EXPECTED:%',expected_rpt_drug_03_output;
				SELECT throw_error('RPT DRUG FUNCTION VALUES MISMATCH');
			END IF;


		--VALIDATE DRUGS WITH NO RESTRICTION APPLICABLE (zero records retuned)
               -----------------------------------------------------------
                       --CREATE REPORT
			SELECT create_report(reportId,1,1,'national', ARRAY[156],ARRAY[1], NULL, NULL, NULL, ARRAY[775]) INTO reportfeId;  
			
			--RUN RPT_DRUG FUNCTION
			SELECT rpt_drug(reportfeId) INTO actual_rpt_drug_output;
	
			--VALIDATE REPORT
			IF actual_rpt_drug_output != NULL THEN
				RAISE NOTICE 'ACTUAL:%',actual_rpt_drug_output;
				RAISE NOTICE 'EXPECTED:%',NULL;
				SELECT throw_error('RPT DRUG FUNCTION VALUES MISMATCH');
			END IF;

		--VALIDATE RESTRICTIONED DRUGS NOT AVAILABLE IN SELECTED HEALTH PLAN ( restricted drugs no available in select health plan)
               -----------------------------------------------------------
                       --CREATE REPORT
			SELECT create_report(reportId,1,1,'national', ARRAY[2182],ARRAY[2], NULL, NULL, NULL, ARRAY[1882]) INTO reportfeId;  
			
			--RUN RPT_DRUG FUNCTION
			SELECT rpt_drug(reportfeId) INTO actual_rpt_drug_output;

			--VALIDATE REPORT
			IF actual_rpt_drug_output != NULL THEN
				RAISE NOTICE 'ACTUAL:%',actual_rpt_drug_output;
				RAISE NOTICE 'EXPECTED:%',NULL;
				SELECT throw_error('RPT DRUG FUNCTION VALUES MISMATCH');
			END IF;
		
		--VALIDATE SELECTED HEALTH PLAN NOT OPERATING IN SELECTED STATE( selected health plan not operates in selected state zero records returned)
               -----------------------------------------------------------
                       --CREATE REPORT
			SELECT create_report(reportId,1,1,'state', ARRAY[156],ARRAY[3], ARRAY[1], NULL, NULL, ARRAY[1885]) INTO reportfeId;  
			
			--RUN RPT_DRUG FUNCTION
			SELECT rpt_drug(reportfeId) INTO actual_rpt_drug_output;

			--VALIDATE REPORT
			IF actual_rpt_drug_output != NULL THEN
				RAISE NOTICE 'ACTUAL:%',actual_rpt_drug_output;
				RAISE NOTICE 'EXPECTED:%',NULL;
				SELECT throw_error('RPT DRUG FUNCTION VALUES MISMATCH');
			END IF;
       END IF;

success:=true;
RETURN success;	  	
END
$$ LANGUAGE plpgsql;