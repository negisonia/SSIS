CREATE OR REPLACE FUNCTION get_report_active_restrictions(reportid integer,reportfe integer)
RETURNS integer[] AS $$
DECLARE
active_restrictions integer[];
BEGIN
	--THIS FUNCTION RETURNS ALL THE RESTRICTIONS FOR A REPORT THAT APPLY TO THE SELECTED REPORT DRUGS AND CONTAINS LIVES ON IT
	--@TODO currently not filtering by state or county 'national geography assumed'

	--VALIDATE THAT THE REPORT EXISTS
	IF  (SELECT EXISTS( SELECT 1 FROM  criteria_restriction_reports crr WHERE crr.report_id= reportid)) = FALSE THEN
		SELECT throw_error('TEST REPORT DOES NOT EXISTS');
	ELSE
		--FIND ALL THE DRUGS FOR A REPORT  THAT MATCHES A REPORT RESTRICTION (DRUGS THAT HAVE A REPORT RESTRICTION APPLIED TO THEM)
		active_restrictions:= ARRAY(
                SELECT  * FROM (SELECT distinct fp.dim_criteria_restriction_id FROM fact_pharmacy fp 
		inner join criteria_reports_drugs crd on fp.drug_id=crd.drug_id and fp.report_id=reportid and crd.criteria_report_id=reportfe 
                inner join criteria_reports_dim_criteria_restriction crdcr on crdcr.criteria_report_id=crd.criteria_report_id and crdcr.dim_criteria_restriction_id=fp.dim_criteria_restriction_id
               inner join pharmacy_lives pl on pl.health_plan_type_id=fp.health_plan_type_id and pl.provider_id=fp.provider_id and pl.health_plan_id=fp.health_plan_id 
		inner join criteria_reports_health_plan_types crhpt on  crhpt.criteria_report_id = crd.criteria_report_id and crhpt.health_plan_type_id = pl.health_plan_type_id) pharmacy_drugs

               UNION SELECT * FROM (SELECT distinct fm.dim_criteria_restriction_id as medical_restriction FROM fact_medical fm 
		inner join criteria_reports_drugs crd on fm.drug_id=crd.drug_id and fm.report_id=reportid and crd.criteria_report_id=reportfe 
               inner join criteria_reports_dim_criteria_restriction crdcr on crdcr.criteria_report_id=crd.criteria_report_id and crdcr.dim_criteria_restriction_id=fm.dim_criteria_restriction_id
               inner join medical_lives ml on ml.health_plan_type_id=fm.health_plan_type_id and ml.provider_id=fm.provider_id 
	       inner join criteria_reports_health_plan_types crhpt on  crhpt.criteria_report_id = crd.criteria_report_id and crhpt.health_plan_type_id = ml.health_plan_type_id) medical_drugs 
                );		  
		               	
        END IF;

return active_restrictions;	
END
$$ LANGUAGE plpgsql;



