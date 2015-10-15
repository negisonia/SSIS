CREATE OR REPLACE FUNCTION res_create_report_1_result_2_criteria_report() --FRONT END
RETURNS INTEGER AS $$
DECLARE

indication_1 INTEGER;

drug_1 INTEGER;
drug_2 INTEGER;


ind1_m_unspecified INTEGER;
ind1_m_age_1 INTEGER;
ind1_m_st_custom_option_2 INTEGER;
ind1_m_criteria_diagnosis_3 INTEGER;


drugs_array INTEGER[];
health_plan_types_array INTEGER[];
restrictions_array INTEGER[];
empty_array INTEGER[];

report1 INTEGER;

criteria_report_type CONSTANT INTEGER:=1;
step_report_type CONSTANT INTEGER:=2;
county_geo_type_id CONSTANT INTEGER:=1;

user_id CONSTANT INTEGER:=1;

commercial_hpt INTEGER;
hix_hpt INTEGER;

fe_report_1 INTEGER;
summary_table_output VARCHAR;
expected_summary_table_output VARCHAR;
massachusetts_state_id INTEGER;
county_ids INTEGER[];

BEGIN

--RETRIEVE HEALTH PLAN TYPES
SELECT common_get_table_id_by_name('health_plan_types','commercial') INTO commercial_hpt;
SELECT common_get_table_id_by_name('health_plan_types','hix') INTO hix_hpt;

--RETRIEVE REPORTS
SELECT ccr.report_id INTO report1 FROM criteria_restriction_reports ccr WHERE ccr.report_name='report_1';

--RETRIEVE INDICATIONS
SELECT common_get_table_id_by_name('indications','indication_1') INTO indication_1;

--RETRIEVE DRUGS
SELECT common_get_table_id_by_name('drugs','drug_1') INTO drug_1;
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2;

SELECT common_get_table_id_by_name('states','Massachusetts') INTO massachusetts_state_id;
SELECT array(select id from counties where state_id=massachusetts_state_id) INTO county_ids;

--RETRIEVE RESTRICTIONS

SELECT common_get_dim_criteria_restriction(indication_1,'Medical','Unspecified','Criteria Unspecified') INTO ind1_m_unspecified;
SELECT common_get_dim_criteria_restriction(indication_1,'Medical','Age','criteria_age_1') INTO ind1_m_age_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Medical','ST - Single','custom_option_2') INTO ind1_m_st_custom_option_2;
SELECT common_get_dim_criteria_restriction(indication_1,'Medical','Diagnosis','criteria_diagnosis_3') INTO ind1_m_criteria_diagnosis_3;

--REPORT#1
drugs_array:= ARRAY[drug_1,drug_2];
health_plan_types_array:= ARRAY[commercial_hpt,hix_hpt];
restrictions_array:= ARRAY[ind1_m_unspecified,ind1_m_age_1,ind1_m_st_custom_option_2,ind1_m_criteria_diagnosis_3];
empty_array:= ARRAY[]::integer[];

--TODO ver como se inserta county info
SELECT create_criteria_report( report1, user_id , criteria_report_type, NULL, county_geo_type_id , NULL, NULL, NULL, drugs_array, health_plan_types_array , 'County',empty_array, NULL, restrictions_array, NULL, NULL,county_ids) INTO fe_report_1;
return fe_report_1;
END
$$ LANGUAGE plpgsql;