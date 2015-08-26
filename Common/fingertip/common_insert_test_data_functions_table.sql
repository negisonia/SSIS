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

PERFORM common_create_test_data_functions('test_data_countries',1);
PERFORM common_create_test_data_functions('test_data_states',2);
PERFORM common_create_test_data_functions('test_data_metro_stat_area',3);
PERFORM common_create_test_data_functions('test_data_parent',4);
PERFORM common_create_test_data_functions('test_data_jcodes',5);
PERFORM common_create_test_data_functions('test_data_drugs',6);
PERFORM common_create_test_data_functions('test_data_drug_jcodes',7);
PERFORM common_create_test_data_functions('test_data_drug_classes',8);
PERFORM common_create_test_data_functions('test_data_drug_drug_classes',9);
PERFORM common_create_test_data_functions('test_data_health_plan_types',10);
PERFORM common_create_test_data_functions('test_data_tiers',11);
PERFORM common_create_test_data_functions('test_data_qualifiers',12);
PERFORM common_create_test_data_functions('test_data_reason_codes',13);
PERFORM common_create_test_data_functions('test_data_provider',14);
PERFORM common_create_test_data_functions('test_data_health_plans',15);
PERFORM common_create_test_data_functions('test_data_formulary_entry',16);
PERFORM common_create_test_data_functions('test_data_counties',17);
PERFORM common_create_test_data_functions('test_data_health_plan_state',18);
PERFORM common_create_test_data_functions('test_data_health_plan_counties',19);
PERFORM common_create_test_data_functions('test_data_health_plan_county_lives',20);
PERFORM common_create_test_data_functions('test_data_health_plan_copay',21);
PERFORM common_create_test_data_functions('test_data_hli_medical_benefit_lives',22);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
