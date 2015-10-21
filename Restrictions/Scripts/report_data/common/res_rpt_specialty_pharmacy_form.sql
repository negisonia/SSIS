CREATE OR REPLACE FUNCTION res_rpt_specialty_pharmacy_form(new_report_id INTEGER, new_health_plan_type_id INTEGER, new_provider_id INTEGER, expected_json VARCHAR) --REPORT DATA
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
rpt_specialty_pharmacy_form_output VARCHAR;
BEGIN

--VALIDATE RPT HEALTH PLAN
SELECT array_to_json(array_agg(row_to_json(t)))
from ( SELECT  m.name, m.drug_id, m.url FROM (SELECT distinct spf.specialty_pharmacy_id,sp.name,spf.drug_id,spf.url
FROM (SELECT DISTINCT specialty_pharmacy_id, drug_id FROM specialty_pharmacy_drugs WHERE specialty_pharmacy_drugs.health_plan_id IN
(SELECT health_plans.id FROM health_plans WHERE health_plans.provider_id = new_provider_id AND health_plans.health_plan_type_id = new_health_plan_type_id)
AND specialty_pharmacy_drugs.drug_id IN(SELECT drugs.id FROM drugs WHERE drugs.id IN
(SELECT criteria_reports_drugs.drug_id FROM criteria_reports_drugs WHERE criteria_reports_drugs.criteria_report_id=new_report_id))) q
INNER JOIN specialty_pharmacy_forms spf on q.specialty_pharmacy_id=spf.specialty_pharmacy_id  INNER JOIN specialty_pharmacies sp ON sp.id=spf.specialty_pharmacy_id order by spf.specialty_pharmacy_id,spf.drug_id,spf.url )m )t INTO rpt_specialty_pharmacy_form_output;

IF rpt_specialty_pharmacy_form_output IS DISTINCT FROM expected_json THEN
RAISE NOTICE 'ACTUAL: %s' , rpt_specialty_pharmacy_form_output;
RAISE NOTICE 'EXPECTED: %s', expected_json;
SELECT throw_error('rpt_specialty_pharmacy_form_output : REPORT SPECIALTY FORM OUTPUT MISMATCH');
END IF;

success=true;
return success;
END
$$ LANGUAGE plpgsql;
