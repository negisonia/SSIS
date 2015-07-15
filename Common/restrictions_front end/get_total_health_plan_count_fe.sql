CREATE OR REPLACE FUNCTION get_total_health_plan_count(reportfeid integer)
RETURNS integer AS $$
DECLARE
intvalue integer;
BEGIN
	--THIS FUNCTION RETURNS THE TOTAL HEALTH PLANS FOR A DRUG IN A PARTICULAR REPORT	

	--VALIDATE THAT THE REPORT EXISTS
	IF  (SELECT EXISTS( SELECT 1 FROM  criteria_reports cr WHERE cr.id= reportfeid)) = FALSE THEN
		SELECT throw_error('TEST REPORT DOES NOT EXISTS '|| reportfeid);
	ELSE
		
		select count (distinct fd.health_plan_id) into intvalue from formulary_detail fd inner join criteria_reports_health_plan_types crhpt on crhpt.health_plan_type_id=fd.health_plan_type_id and crhpt.criteria_report_id=reportfeid 
                inner join criteria_reports_drugs crd on crd.drug_id=fd.drug_id and crd.criteria_report_id=crhpt.criteria_report_id;
	
        END IF;

return intvalue;	
END
$$ LANGUAGE plpgsql;
