CREATE OR REPLACE FUNCTION  create_custom_account(account_name varchar, input_client_id INTEGER, provider_ids INTEGER[], health_plan_type_ids INTEGER[], health_plan_ids INTEGER[]) --ADMIN DB
RETURNS integer AS $$
DECLARE
accountExists boolean;
custom_account_id integer;
intvalue integer;
BEGIN

SELECT EXISTS( SELECT 1 FROM custom_accounts c WHERE c.name=account_name) INTO accountExists;

  IF accountExists = false THEN
    INSERT INTO public.custom_accounts(
                name, client_id, custom_account_type_id, created_by_aeuser_id, 
                updated_by_aeuser_id, created_at, updated_at, in_progress_started_at, 
                in_progress_by_aeuser_id)
        VALUES (account_name, input_client_id, 0, 0, 
                0, current_timestamp, current_timestamp, current_timestamp, 
                NULL);
  END IF;

  SELECT c.id INTO custom_account_id FROM custom_accounts c WHERE c.name=account_name;

  --INSERT PROVIDER DATA
  FOREACH intvalue IN ARRAY provider_ids
  LOOP  
    INSERT INTO custom_account_providers(custom_account_id,provider_id) VALUES(custom_account_id,intvalue); 
  END LOOP;  

  --INSERT HEALTH PLAN TYPES DATA
  FOREACH intvalue IN ARRAY health_plan_type_ids
  LOOP  
    INSERT INTO custom_account_provider_plant_types(custom_account_id,health_plan_type_id) VALUES(custom_account_id,intvalue); 
  END LOOP;

  --INSERT HEALTH PLANs DATA
  FOREACH intvalue IN ARRAY health_plan_ids
  LOOP  
    INSERT INTO custom_account_provider_plant_types(custom_account_id,health_plan_id) VALUES(custom_account_id,intvalue); 
  END LOOP;
  
RETURN custom_account_id;  
END
$$ LANGUAGE plpgsql;

