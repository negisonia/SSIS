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
state_geo_type_id CONSTANT INTEGER:=1;

user_id CONSTANT INTEGER:=1;

commercial_hpt INTEGER;
hix_hpt INTEGER;

fe_report_1 INTEGER;
massachusetts_state_id INTEGER;
state_ids INTEGER[];

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

SELECT array(select common_get_table_id_by_name('states','Massachusetts')) INTO state_ids;

--RETRIEVE RESTRICTIONS

SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Medical','Unspecified','Criteria Unspecified') INTO ind1_m_unspecified;
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Medical','Age','criteria_age_1') INTO ind1_m_age_1;
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Medical','ST - Single','custom_option_2') INTO ind1_m_st_custom_option_2;
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Medical','Diagnosis','criteria_diagnosis_3') INTO ind1_m_criteria_diagnosis_3;

--REPORT#1
drugs_array:= ARRAY[drug_1,drug_2];
health_plan_types_array:= ARRAY[commercial_hpt,hix_hpt];
restrictions_array:= ARRAY[ind1_m_unspecified,ind1_m_age_1,ind1_m_st_custom_option_2,ind1_m_criteria_diagnosis_3];
empty_array:= ARRAY[]::integer[];

SELECT create_criteria_report( report1, user_id, criteria_report_type, NULL, state_geo_type_id, TRUE, FALSE, FALSE, drugs_array, health_plan_types_array , 'State', empty_array, NULL, restrictions_array, state_ids, NULL, NULL) INTO fe_report_1;
return fe_report_1;
END
$$ LANGUAGE plpgsql;