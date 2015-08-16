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
       SET prior_authorization_id=new_prior_authorization_id, quantity_limit_id=new_quantity_limit_id,
           other_restriction_id=new_other_restriction_id, step_therapy_id=new_step_therapy_id,
           medical_id=new_medical_id
     WHERE id=data_entry_id;
  ELSE
     select throw_error('data entry does not exists');
  END IF;

success:=TRUE;
return success;

END
$$ LANGUAGE plpgsql;
