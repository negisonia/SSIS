CREATE OR REPLACE FUNCTION test_007_validate_test_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  --TEST VARIABLES
  success boolean DEFAULT false;
  reportfeId integer DEFAULT 0;
  intvalue integer; 
  
  --EXPECTED VALUES
  expected_rpt_drug_output VARCHAR:='(%s,ALL,846,2182,24559932,108,0,49430874,0,253,0,Pharmacy,"QL - Quantity Limits",Sprycel,4,QL)';
  
  --ACTUAL VALUES
  actual_rpt_drug_output VARCHAR;

  --TEST DATA
  indicationid integer:=7;
  reportBussinesId varchar DEFAULT 'TEST REPORT 007';
  reportName varchar DEFAULT 'TEST REPORT NAME 007';
  drugIds INTEGER[] := ARRAY[156,160,2182, 3098, 3199, 3237, 3584];
  restrictionsIds INTEGER[]:= ARRAY[775,776,777,778,779,780,781,782,783,784,785,786,787,788,789,790,791,792,793,794,795,796,797,798,799,800,801,802,803,804,805,806,807,808,809,810,811,812,813,814,815,816,817,818,819,820,821,822,823,824,825,826,827,828,829,830,831,832,833,834,835,836,837,838,839,840,841,842,843,844,845,846,847,848,1860,1861,1864,1865,1866,1867,1868,1869,1870,1871,1872,1873,1874,1875,1876,1877,1878,1879,1880,1881,1882,1883,1884,1885,2105,2106,2107,2108,2109,2110,2111,2172,2174,2175];
  
  --expected_drugId INTEGER :=2182; --SELECT distinct fd.drug_id FROM formulary_detail fd WHERE fd.health_plan_type_id=1 and has_quantity_limit = true order by fd.drug_id
  --expected_health_plan_type_id INTEGER := 1;
  --expected_restriction INTEGER := 846;--select * from dim_criteria_restriction d where d.dim_restriction_type_id=4 and d.indication_id=7
  --expected_health_plan_count INTEGER:=108;--select distinct fhp.health_plan_id from fact_health_plan fhp where fhp.dim_criteria_restriction_id=846 and fhp.drug_id=2182 and fhp.health_plan_type_id=1  
  --expected_lives_count INTEGER := 24559932 --SELECT sum(pl.lives) FROM fact_health_plan fhp inner join pharmacy_lives pl on pl.health_plan_type_id=fhp.health_plan_type_id and pl.provider_id=fhp.provider_id and pl.health_plan_id=fhp.health_plan_id and fhp.indication_id=7 and fhp.drug_id=2182 and fhp.health_plan_type_id=1 and fhp.report_id=111 and fhp.dim_criteria_restriction_id=846   
  --expected_provider_count INTEGER :=0;--@TODO
  --expected_total_pharmacy_lives INTEGER := 49430874;--select sum(pl.lives) from dw.pharmacy_lives_import pl where health_plan_type_id=1 
  --extected_total_medical_lives INTEGER := 0;--@TODO
  --extected_total_health_plan_count INTEGER :=253; --select distinct pli.health_plan_id from dw.pharmacy_lives_import pli where  pli.health_plan_type_id=1 
  --extected_total_provider_count INTEGER := 0; --@TODO

BEGIN
        --VALIDATE REPORT DATA (DRUGS, RESTRICTIONS, CUSTOM GROUPS, REPORT) EXISTS IN FE DATABASE
        PERFORM validate_report(reportBussinesId,reportName,drugIds,restrictionsIds,NULL);

	--GET THE TEST REPORT ID
	SELECT crr.report_id FROM criteria_restriction_reports crr WHERE crr.business_id=reportBussinesId and  crr.report_name=reportName INTO intvalue;
	
	IF intvalue <> 0 THEN
		                			
		SELECT create_report(intvalue,1,2,'national', ARRAY[2182],ARRAY[1], NULL, NULL, NULL, ARRAY[846]) INTO reportfeId;
		RAISE NOTICE 'generated report :%',reportfeId;	

		--RUN RPT_DRUG FUNCTION
                SELECT rpt_drug(reportfeId) INTO actual_rpt_drug_output;
                
		IF actual_rpt_drug_output!=format(expected_rpt_drug_output,reportfeId) THEN
			RAISE NOTICE 'ACTUAL:%',actual_rpt_drug_ouput;
			RAISE NOTICE 'EXPECTED:%',expected_rpt_drug_output;
			SELECT throw_error('RPT DRUG FUNCTION VALUES MISMATCH');
		END IF;
		
       END IF;

success:=true;
RETURN success;	  	
END
$$ LANGUAGE plpgsql;