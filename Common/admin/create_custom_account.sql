CREATE OR REPLACE FUNCTION create_custom_account(account_name varchar, input_client_id INTEGER, provider_ids INTEGER[], health_plan_ids INTEGER[], insert_plan_type_level boolean) --ADMIN DB
RETURNS integer AS $$
DECLARE
accountExists boolean;
new_custom_account_id integer;
intvalue integer;
plan_provider_id integer;
plan_type_id integer;
BEGIN

IF (insert_plan_type_level=TRUE AND array_length(provider_ids,1) >0) OR (array_length(health_plan_ids,1) > 1 AND array_length(provider_ids,1) > 1) OR (insert_plan_type_level=TRUE AND array_length(health_plan_ids,1) =0) THEN
  SELECT throw_error('INVALID PARAMETERS create_custom_account');
END IF;

SELECT EXISTS( SELECT 1 FROM custom_accounts c WHERE c.name=account_name) INTO accountExists;

  IF accountExists = false THEN
    INSERT INTO custom_accounts(
                name, client_id, custom_account_type_id, created_by_aeuser_id, 
                updated_by_aeuser_id, created_at, updated_at, in_progress_started_at, 
                in_progress_by_aeuser_id)
        VALUES (account_name, input_client_id, 0, 0, 
                0, current_timestamp, current_timestamp, current_timestamp, 
                NULL);
  END IF;

  SELECT c.id INTO new_custom_account_id FROM custom_accounts c WHERE c.name=account_name;

  --INSERT PROVIDER DATA
  FOREACH intvalue IN ARRAY provider_ids
  LOOP
    IF (SELECT 1 FROM custom_account_providers where custom_account_id=new_custom_account_id AND provider_id=intvalue) IS NULL THEN
      INSERT INTO custom_account_providers(custom_account_id,provider_id) VALUES(new_custom_account_id,intvalue);
    END IF;
  END LOOP;

  --INSERT HEALTH PLANS DATA
  FOREACH intvalue IN ARRAY health_plan_ids
  LOOP
    SELECT provider_id from health_plan_import where id = intvalue INTO plan_provider_id;
    SELECT health_plan_type_id from health_plan_import where id = intvalue INTO plan_type_id;
    IF insert_plan_type_level IS TRUE THEN
      IF (SELECT 1 FROM custom_account_provider_plant_types where custom_account_id=new_custom_account_id AND provider_id=plan_provider_id AND health_plan_type_id=plan_type_id) IS NULL THEN
        INSERT INTO custom_account_provider_plan_types(custom_account_id, provider_id, health_plan_type_id) VALUES (new_custom_account_id, plan_provider_id, plan_type_id);
      END IF;
    ELSE
      IF (SELECT 1 FROM custom_account_health_plans where custom_account_id=new_custom_account_id AND health_plan_id=intvalue) IS NULL THEN
        INSERT INTO custom_account_health_plans(custom_account_id, health_plan_id) VALUES (new_custom_account_id, intvalue);
      END IF;
    END IF;
  END LOOP;
  
RETURN new_custom_account_id;
END
$$ LANGUAGE plpgsql;

