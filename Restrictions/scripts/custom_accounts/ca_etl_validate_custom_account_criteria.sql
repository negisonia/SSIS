CREATE OR REPLACE FUNCTION ca_etl_validate_custom_account_criteria(ca_id integer, provider_names varchar[], health_plan_names varchar[], health_plan_table_name varchar, provider_table_name varchar) --Data Warehouse
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  plan_name VARCHAR;
  provider_name varchar;
  prov_id INTEGER;
  plan_id INTEGER;
  plan_type_id INTEGER;
  client_id INTEGER;
  booleanValue boolean;
BEGIN

    FOREACH provider_name IN ARRAY provider_names
    LOOP
      SELECT common_get_table_id_by_name(provider_table_name, provider_name) INTO prov_id;

      SELECT EXISTS (SELECT 1 FROM admin.custom_account_providers cap WHERE cap.custom_account_id = ca_id AND cap.provider_id = prov_id) INTO booleanValue;
      IF booleanValue IS FALSE THEN
        select throw_error('ca_etl_test-error: EXPECTED Provider ' || provider_name || ' to be associated with custom account ' || ca_id);
      END IF;

    END LOOP;

    FOREACH plan_name IN ARRAY health_plan_names
    LOOP
      SELECT common_get_table_id_by_name(health_plan_table_name, plan_name) INTO plan_id;

      SELECT EXISTS (SELECT 1 FROM admin.custom_account_health_plans cahp WHERE cahp.custom_account_id = ca_id AND cahp.health_plan_id = plan_id) INTO booleanValue;
      IF booleanValue IS FALSE THEN
        select throw_error('ca_etl_test-error: EXPECTED Plan ' || plan_name || ' to be associated with CUSTOM ACCOUNT ' || ca_id);
      END IF;

      EXECUTE 'SELECT provider_id from ' || health_plan_table_name || ' where id = ''' || plan_id || ''' LIMIT 1' INTO prov_id;
      EXECUTE 'SELECT health_plan_type_id from ' || health_plan_table_name || ' where id = ''' || plan_id || ''' LIMIT 1' INTO plan_type_id;

      SELECT EXISTS (SELECT 1 FROM admin.custom_account_provider_plant_types cappt WHERE cappt.custom_account_id = ca_id AND cappt.health_plan_type_id = plan_type_id AND cappt.provider_id = prov_id) INTO booleanValue;
      IF booleanValue IS FALSE THEN
        select throw_error('ca_etl_test-error: WRONG PLAN TYPE AND PROVIDER ASSOCIATION FOR CUSTOM ACCOUNT ' || ca_id || ' PLAN TYPE ' || plan_type_id ||' PROVIDER ' || prov_id);
      END IF;

    END LOOP;
    

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
