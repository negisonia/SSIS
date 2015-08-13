CREATE OR REPLACE FUNCTION common_create_prior_authorization_criteria(new_prior_authorization_id INTEGER, new_criteria_id INTEGER, new_active BOOLEAN, new_criterium_applicable INTEGER, new_value_lower INTEGER, new_value_upper INTEGER) --DATA ENTRY
RETURNS BOOLEAN AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
valueExists BOOLEAN DEFAULT FALSE;
BEGIN

SELECT EXISTS (SELECT 1 FROM prior_authorization_criteria pac WHERE pac.is_active=active  and pac.prior_authorization_id=new_prior_authorization_id and pac.criterium_id=new_criteria_id  LIMIT 1) INTO valueExists;

--VALIDATE IF THE PRIOR AUTHORIZATION CRITERIA ALREADY EXISTS
IF valueExists IS FALSE THEN
  --INSERT PRIOR AUTHORIZATION CRITERIA RECORD
INSERT INTO prior_authorization_criteria(
            value_upper, value_lower, non_fda_approved, created_at, updated_at,
            prior_authorization_id, criterium_id, criterium_applicable, active,
            is_active, copiedfromid)
    VALUES (new_value_upper, new_value_lower, NULL, current_timestamp, current_timestamp,
            new_prior_authorization_id, new_criteria_id, new_criterium_applicable, new_active,new_active,
            NULL);
END IF;

success :=TRUE;
return success;
END
$$ LANGUAGE plpgsql;
