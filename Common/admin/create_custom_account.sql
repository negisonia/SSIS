CREATE OR REPLACE FUNCTION  create_custom_account(account_name varchar, input_client_id INTEGER) --ADMIN DB
RETURNS integer AS $$
DECLARE
accountExists boolean;
account_id integer;
BEGIN

SELECT EXISTS( SELECT 1 FROM custom_accounts c WHERE c.name=account_name) INTO accountExists;

  IF accountExists = false THEN
    INSERT INTO public.custom_accounts(
                name, client_id, custom_account_type_id, created_by_aeuser_id, 
                updated_by_aeuser_id, created_at, updated_at, in_progress_started_at, 
                in_progress_by_aeuser_id)
        VALUES (account_name, input_client_id, ?, ?, 
                ?, current_timestamp, current_timestamp, current_timestamp, 
                ?);
  END IF;

  SELECT c.id INTO clientId FROM custom_accounts c WHERE c.name=account_name;
  
RETURN account_id;  
END
$$ LANGUAGE plpgsql;

