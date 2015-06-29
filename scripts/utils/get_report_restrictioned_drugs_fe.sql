CREATE OR REPLACE FUNCTION get_report_restrictioned_drugs(reportid integer,reportfe integer)
RETURNS integer[] AS $$
DECLARE
restrictioned_drugs integer[];
intvalue integer;
BEGIN

	--VALIDATE THAT THE REPORT EXISTS
	IF  (SELECT EXISTS( SELECT 1 FROM  criteria_restriction_reports crr WHERE crr.report_id= reportid)) = FALSE THEN
		SELECT throw_error('TEST REPORT DOES NOT EXISTS');
	ELSE
		--FIND ALL THE DRUGS FOR A REPORT  THAT MATCHES A REPORT RESTRICTION (DRUGS THAT HAVE A REPORT RESTRICTION APPLIED TO THEM)
		restrictioned_drugs:= ARRAY(
                SELECT  * FROM (SELECT distinct fp.drug_id as pdrug_id FROM fact_pharmacy fp 
		inner join criteria_reports_drugs crd on fp.drug_id=crd.drug_id and fp.report_id=reportid and crd.criteria_report_id=reportfe 
                inner join criteria_reports_dim_criteria_restriction crdcr on crdcr.criteria_report_id=crd.criteria_report_id and crdcr.dim_criteria_restriction_id=fp.dim_criteria_restriction_id) pharmacy_drugs

               UNION SELECT * FROM (SELECT distinct fm.drug_id as mdrug_id FROM fact_medical fm 
		inner join criteria_reports_drugs crd on fm.drug_id=crd.drug_id and fm.report_id=reportid and crd.criteria_report_id=reportfe 
                inner join criteria_reports_dim_criteria_restriction crdcr on crdcr.criteria_report_id=crd.criteria_report_id and crdcr.dim_criteria_restriction_id=fm.dim_criteria_restriction_id) medical_drugs 
                );		  
		               	
        END IF;

return restrictioned_drugs;	
END
$$ LANGUAGE plpgsql;



