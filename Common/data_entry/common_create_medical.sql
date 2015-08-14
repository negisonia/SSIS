CREATE OR REPLACE FUNCTION common_create_medical(new_data_entry_id INTEGER, new_active BOOLEAN, new_atomic_step_id INTEGER) --DATA ENTRY
RETURNS INTEGER AS $$
DECLARE
medical_id INTEGER DEFAULT NULL;
BEGIN

SELECT m.id INTO medical_id FROM medicals m WHERE m.data_entry_id=new_data_entry_id AND m.is_active=new_active  LIMIT 1;

--VALIDATE IF THE CRITERIA ALREADY EXISTS
IF medical_id IS NULL THEN
  --INSERT CRITERIA RECORD
  INSERT INTO medicals(
              date_of_policy, medical_duration, drug_id, data_entry_id,
              created_at, updated_at, indication_id, provider_id, healthplantype_id,
              boolean_expression_tree, duration_unit, active, is_active, copiedfromid,
              atomic_step_id)
      VALUES ( null, null, null, new_data_entry_id,
              current_timestamp, current_timestamp, null, null, null,
              null, null, new_active, new_active,null,
              new_atomic_step_id) RETURNING id INTO medical_id;
  RETURN medical_id;
ELSE
  RETURN medical_id;
END IF;

END
$$ LANGUAGE plpgsql;
