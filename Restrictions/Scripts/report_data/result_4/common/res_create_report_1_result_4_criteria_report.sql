CREATE OR REPLACE FUNCTION res_create_report_1_result_4_criteria_report() --FRONT END
RETURNS INTEGER AS $$
DECLARE

indication_1 INTEGER;

drug_1 INTEGER;
drug_2 INTEGER;

ind1_pa_st_custom_option_1 INTEGER;
ind1_pa_past_custom_option_1 INTEGER;
ind1_pa_st_double_co_1_co_2 INTEGER;
ind1_pa_past_co_1_co_2 INTEGER;
ind1_m_st_custom_option_2 INTEGER;

drugs_array INTEGER[];
health_plan_types_array INTEGER[];
restrictions_array INTEGER[];
empty_array INTEGER[];

report1 INTEGER;
fe_report_1 INTEGER;

criteria_report_type CONSTANT INTEGER:=2;
county_geo_type_id CONSTANT INTEGER:=1;

user_id CONSTANT INTEGER:=1;

commercial_hpt INTEGER;
hix_hpt INTEGER;

massachusetts_state_id integer;
connecticut_state_id integer;
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


--RETRIEVE RESTRICTIONS
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','ST - Single','custom_option_1') INTO ind1_pa_st_custom_option_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA/ST - Single','Fail any one: custom_option_1, custom_option_2') INTO ind1_pa_past_co_1_co_2;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA/ST - Single','custom_option_1') INTO ind1_pa_past_custom_option_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','ST - Double','custom_option_1 AND  custom_option_2') INTO ind1_pa_st_double_co_1_co_2;
SELECT common_get_dim_criteria_restriction(indication_1,'Medical','ST - Single','custom_option_2') INTO ind1_m_st_custom_option_2;


SELECT common_get_table_id_by_name('states','Massachusetts') INTO massachusetts_state_id;
SELECT common_get_table_id_by_name('states','Connecticut') INTO connecticut_state_id;
SELECT array(select id from counties where state_id IN (massachusetts_state_id,connecticut_state_id) and name = 'Middlesex') INTO county_ids;

--REPORT#1
drugs_array:= ARRAY[drug_1,drug_2];
health_plan_types_array:= ARRAY[commercial_hpt,hix_hpt];
restrictions_array:= ARRAY[ind1_pa_st_custom_option_1,ind1_pa_past_co_1_co_2,ind1_pa_past_custom_option_1,ind1_pa_st_double_co_1_co_2,ind1_m_st_custom_option_2];
empty_array:= ARRAY[]::integer[];

SELECT create_criteria_report( report1, user_id , criteria_report_type , NULL, county_geo_type_id, NULL, NULL, NULL,drugs_array, health_plan_types_array, 'County', empty_array, NULL,restrictions_array, NULL, NULL, county_ids) INTO fe_report_1;
return fe_report_1;
END
$$ LANGUAGE plpgsql;