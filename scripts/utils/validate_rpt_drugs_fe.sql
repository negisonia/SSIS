CREATE OR REPLACE FUNCTION validate_rpt_drug(reportId integer,reportfeId integer)--FRONT END
RETURNS VOID AS $$
DECLARE
  groupRestrictionedDrugs integer[];
  rpt_drug_drugs integer[];
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
END;
$$ LANGUAGE plpgsql;