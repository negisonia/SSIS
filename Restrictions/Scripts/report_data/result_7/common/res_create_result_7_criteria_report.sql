CREATE OR REPLACE FUNCTION res_create_result_7_criteria_report() --FRONT END
RETURNS INTEGER AS $$
DECLARE

indication_1 INTEGER;

report1 INTEGER;
commercial_hpt INTEGER;
hix_hpt INTEGER;

pharmacy_criteria INTEGER;
medical_criteria INTEGER;

drugs_array INTEGER[];
health_plan_types_array INTEGER[];
restrictions_array INTEGER[];
empty_array INTEGER[];
county_ids INTEGER[];

userid CONSTANT INTEGER:=0;
criteria_report_type CONSTANT INTEGER:=2;
geo_type_id CONSTANT INTEGER:=4;
fe_report_1 INTEGER;
state_ids INTEGER[];

BEGIN

--RETRIEVE HEALTH PLAN TYPES
SELECT array(select id from health_plan_types h where h.name = 'commercial' or h.name='hix'  or h.name='medicare_ma' or h.name= 'employer') INTO health_plan_types_array;

--RETRIEVE REPORTS
SELECT ccr.report_id INTO report1 FROM criteria_restriction_reports ccr WHERE ccr.report_name='report_1';

--RETRIEVE INDICATIONS
SELECT common_get_table_id_by_name('indications','indication_1') INTO indication_1;

--RETRIEVE DRUGS
SELECT array(SELECT id FROM drugs d WHERE d.name='drug_1' or d.name='drug_2') INTO drugs_array;

--RETRIEVE RESTRICTIONS
select common_get_dim_criteria_restriction(indication_1,'Pharmacy',4,6,'Single - Single', 'Single') INTO pharmacy_criteria;
select common_get_dim_criteria_restriction(indication_1,'Medical',4,2,'Single - Single', 'Single') INTO medical_criteria;

restrictions_array:= ARRAY[pharmacy_criteria,medical_criteria];
empty_array:= ARRAY[]::integer[];

SELECT create_criteria_report( report1, userid , criteria_report_type , NULL, geo_type_id, FALSE, FALSE, FALSE, drugs_array, health_plan_types_array,'National', empty_array, NULL, restrictions_array,NULL, NULL, NULL) INTO fe_report_1;
return fe_report_1;

END
$$ LANGUAGE plpgsql;