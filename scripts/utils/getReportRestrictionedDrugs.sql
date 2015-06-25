CREATE OR REPLACE FUNCTION getReportRestrictionedDrugs(reportid integer, restrictionsids integer[], drugids integer[])
RETURNS integer[] AS $$
DECLARE
restrictioned_drugs integer[];
intvalue integer;
BEGIN

	--VALIDATE THAT THE REPORT EXISTS
	IF  (SELECT EXISTS( SELECT 1 FROM  criteria_restriction_reports crr WHERE crr.report_id= reportid)) = FALSE THEN
		SELECT throw_error('TEST REPORT DOES NOT EXISTS');
	ELSE
		select distinct crd.drug_id into restrictioned_drugs from fact_pharmacy fp 
						inner join criteria_restriction_drugs crd ON crd.report_id=fp.report_id 
						and crd.drug_id=fp.drug_id 
						and crd.drug_id=ANY(drugids) 
						and fp.report_id=reportid
						and  fp.dim_criteria_restriction_id= ANY(restrictionsids); 		
        END IF;

return restrictioned_drugs;	
END
$$ LANGUAGE plpgsql;

