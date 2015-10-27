CREATE OR REPLACE FUNCTION common_insert_test_data_functions_table()--ADMIN
RETURNS boolean AS $$
DECLARE
success boolean DEFAULT false;
BEGIN

DROP TABLE IF EXISTS test_data_functions;
CREATE TABLE test_data_functions
(
  id serial primary key,
  name varchar(255) NOT NULL,
  order_id integer NOT NULL
);

PERFORM common_create_test_data_functions('test_data_azbusinesscenter',1);
PERFORM common_create_test_data_functions('test_data_countries',2);
PERFORM common_create_test_data_functions('test_data_metro_stat_area',3);
PERFORM common_create_test_data_functions('test_data_states',4);
PERFORM common_create_test_data_functions('test_data_counties',5);
PERFORM common_create_test_data_functions('test_data_parent',6);
PERFORM common_create_test_data_functions('test_data_jcodes',7);
PERFORM common_create_test_data_functions('test_data_drugs',8);
PERFORM common_create_test_data_functions('test_data_drug_jcodes',9);
PERFORM common_create_test_data_functions('test_data_drug_classes',10);
PERFORM common_create_test_data_functions('test_data_drug_drug_classes',11);
PERFORM common_create_test_data_functions('test_data_health_plan_types',12);
PERFORM common_create_test_data_functions('test_data_tiers',13);
PERFORM common_create_test_data_functions('test_data_qualifiers',14);
PERFORM common_create_test_data_functions('test_data_reason_codes',15);
PERFORM common_create_test_data_functions('test_data_provider',16);
PERFORM common_create_test_data_functions('test_data_health_plans',17);
PERFORM common_create_test_data_functions('test_data_formulary_entry',18);
PERFORM common_create_test_data_functions('test_data_health_plan_state',19);
PERFORM common_create_test_data_functions('test_data_health_plan_counties',20);
PERFORM common_create_test_data_functions('test_data_health_plan_county_lives',21);
PERFORM common_create_test_data_functions('test_data_health_plan_copay',22);
PERFORM common_create_test_data_functions('test_data_hli_medical_benefit_designs',23);
PERFORM common_create_test_data_functions('test_data_hli_medical_benefit_lives',24);
PERFORM common_create_test_data_functions('test_data_forms',25);
PERFORM common_create_test_data_functions('test_data_specialty_pharmacies',26);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
