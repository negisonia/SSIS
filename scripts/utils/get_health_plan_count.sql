CREATE OR REPLACE FUNCTION get_health_plan_counts(reportfeid integer,drugid integer)
RETURNS integer AS $$
DECLARE
intvalue integer;
BEGIN
	--THIS FUNCTION RETURNS THE TOTAL HEALTH PLANS FOR A DRUG IN A PARTICULAR REPORT	

	--VALIDATE THAT THE REPORT EXISTS
	IF  (SELECT EXISTS( SELECT 1 FROM  criteria_reports cr WHERE cr.id= reportfeid)) = FALSE THEN
		SELECT throw_error('TEST REPORT DOES NOT EXISTS '|| reportfeid);
	ELSE
		
		SELECT COUNT(*) into  intvalue FROM fact_pharmacy fp 
		inner join criteria_reports c on fp.report_id=c.report_id and c.id=reportfeid
		inner join criteria_reports_drugs crd on fp.drug_id=crd.drug_id and crd.criteria_report_id=c.id
                inner join criteria_reports_dim_criteria_restriction crdcr on crdcr.criteria_report_id=crd.criteria_report_id and crdcr.dim_criteria_restriction_id=fp.dim_criteria_restriction_id     
		inner join criteria_reports_health_plan_types crhpt on crhpt.criteria_report_id=c.id and crhpt.health_plan_type_id=fp.health_plan_type_id
		and crd.drug_id=drugid;
	
        END IF;

return intvalue;	
END
$$ LANGUAGE plpgsql;



