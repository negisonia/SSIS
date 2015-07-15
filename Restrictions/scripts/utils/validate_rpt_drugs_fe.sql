CREATE OR REPLACE FUNCTION validate_rpt_drug(reportId integer,reportfeId integer)--FRONT END
RETURNS VOID AS $$
DECLARE
  groupRestrictionedDrugs integer[];
  rpt_drug_drugs integer[];
  rpt_drug_restriction_ids integer[];
  expected_restriction_ids integer[];
  aux record;
  intvalue integer;
  intvalue2 integer;
BEGIN

		--VALIDATE DRUGS 
	        --GET THE LIST OF DRUGS ASSOCIATED WITH THE CRITERIA SELECTED (LIST OF REPORT DRUGS THAT CONTAINS A RESTRICTION ON IT)
		groupRestrictionedDrugs :=get_report_restrictioned_drugs(reportId,reportfeId);

		--GET THE LIST OF DRUGS RETURNED BY RPT_DRUG FUNCTION	
		rpt_drug_drugs:=ARRAY(select drug_id from rpt_drug(reportfeId) group by drug_id);

		--COMPARE DRUGS RETURNED BY RPT FUNCTION WITH THE ONES EXPECTED
		IF (array_sort(rpt_drug_drugs) = array_sort(groupRestrictionedDrugs)) = FALSE THEN
			RAISE NOTICE 'RPT_DRUGS: %',rpt_drug_drugs;
			RAISE NOTICE 'EXPECTED DRUGS: %',groupRestrictionedDrugs;
			SELECT throw_error('REPORT DRUGS MISMATCH');
		END IF;


		--VALIDATE RESTRICTIONS
		--GET THE LIST OF RESTRICTIONS  RETURNED BY RPT_DRUG_FUNCTION
		rpt_drug_restriction_ids:=ARRAY(select dim_criteria_restriction_id from rpt_drug(reportfeId) group by dim_criteria_restriction_id);
		--GET EXPECTED LIST OF RESTRICTIONS
		expected_restriction_ids:=get_report_active_restrictions(reportId,reportfeId);

		--COMPARE RPT_DRUGS RESTRICTIONS WITH THE ONES EXPECTED
		IF (array_sort(rpt_drug_restriction_ids) = array_sort(expected_restriction_ids)) = FALSE THEN
			RAISE NOTICE 'RPT_RESTRICTIONS: %',rpt_drug_restriction_ids;
			RAISE NOTICE 'EXPECTED RESTRICTIONS: %',expected_restriction_ids;
			SELECT throw_error('REPORT RESTRICTIONS MISMATCH');
		END IF;

		--VALIDATE HEALTH PLAN COUNT
		FOR aux IN EXECUTE format('select drug_id, SUM(health_plan_count) as total from rpt_drug(%s) group by drug_id',reportfeId)
		LOOP
		  intvalue:= get_health_plan_counts(reportfeId, aux.drug_id);
		  IF aux.total != intvalue THEN	--VALIDATE CURRENT HEALTH PLAN COUNT FOR EACH DRUG IS THE EXPECTED ONE
			--RAISE NOTICE 'UNEXPECTED HEALTH PLAN COUNT FOR DRUG %  REPORT FE ID: %', aux.drug_id,reportfeId;
			select throw_error('error drugid'|| aux.drug_id ||' reportfe' || reportfeId);
		END IF;
		END LOOP;


		--VALIDATE TOTAL HEALTH PLAN COUNT
		select distinct total_health_plan_count into intvalue from rpt_drug(reportfeId) where dim_restriction_type_id != 2;
		intvalue2:= get_total_health_plan_count(reportfeId);
		IF intvalue!=intvalue2 THEN
			select throw_error('TOTAL HEALTH PLAN COUNT MISMATCH: EXPECTED '||intvalue2 || ' ACTUAL: ' || intvalue);
		END IF;



		
END;	
$$ LANGUAGE plpgsql;