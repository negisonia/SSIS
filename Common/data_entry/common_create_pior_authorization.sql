CREATE OR REPLACE FUNCTION common_create_prior_authorization(new_data_entry_id INTEGER, new_active BOOLEAN) --DATA ENTRY
RETURNS INTEGER AS $$
DECLARE
prior_authorization_id INTEGER DEFAULT NULL;
BEGIN

SELECT pai.id INTO prior_authorization_id FROM prior_authorizations pai WHERE pai.data_entry_id=new_data_entry_id AND pai.is_active=active LIMIT 1;

--VALIDATE IF THE PRIOR AUTHORIZATION ALREADY EXISTS
IF prior_authorization_id IS NULL THEN
  --INSERT PRIOR AUTHORIZATION RECORD
  INSERT INTO prior_authorizations(
            date_of_policy, pa_duration, drug_id, data_entry_id, created_at, 
            updated_at, indication_id, provider_id, healthplantype_id, boolean_expression_tree, 
            duration_unit, active, is_active, copiedfromid, atomic_step_id)
    VALUES (NULL, NULL, NULL,new_data_entry_id, current_timestamp,
            current_timestamp, NULL, NULL, NULL, NULL,
            NULL, new_active, new_active, NULL, NULL) RETURNING id INTO prior_authorization_id;
  RETURN prior_authorization_id;
ELSE
  RETURN prior_authorization_id;
END IF;

END
$$ LANGUAGE plpgsql;
