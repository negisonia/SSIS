CREATE OR REPLACE FUNCTION common_update_data_entry(data_entry_id INTEGER, new_prior_authorization_id INTEGER, new_quantity_limit_id INTEGER, new_other_restriction_id INTEGER, new_step_therapy_id INTEGER, new_medical_id INTEGER) --DATA ENTRY
RETURNS BOOLEAN AS $$
DECLARE
valueExists BOOLEAN DEFAULT FALSE;
success BOOLEAN DEFAULT FALSE;
BEGIN


  --VALIDATE IF DATA ENTRY EXISTS
  SELECT EXISTS ( SELECT 1 FROM data_entries d WHERE d.id=data_entry_id) INTO valueExists;
  IF valueExists IS TRUE THEN
      UPDATE data_entries
       SET prior_authorization_id= CASE WHEN new_prior_authorization_id IS NOT NULL THEN new_prior_authorization_id ELSE prior_authorization_id END,
           quantity_limit_id=CASE WHEN new_quantity_limit_id IS NOT NULL THEN new_quantity_limit_id ELSE quantity_limit_id END,
           other_restriction_id= CASE WHEN new_other_restriction_id IS NOT NULL THEN new_other_restriction_id ELSE other_restriction_id END,
           step_therapy_id=CASE WHEN new_step_therapy_id IS NOT NULL THEN new_step_therapy_id ELSE step_therapy_id END,
           medical_id= CASE WHEN new_medical_id IS NOT NULL THEN new_medical_id ELSE medical_id END;
     WHERE id=data_entry_id;
  ELSE
     select throw_error('data entry does not exists')
  END IF;

success:=TRUE;
return success;

END
$$ LANGUAGE plpgsql;
