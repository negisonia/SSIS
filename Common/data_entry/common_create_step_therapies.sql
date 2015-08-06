CREATE OR REPLACE FUNCTION common_create_step_therapies(_new_data_entry_id INTEGER, new_boolean_expression_tree json, new_active BOOLEAN, new_atomic_step_id INTEGER ) --DATA ENTRY
RETURNS INTEGER AS $$
DECLARE
step_therapy_id INTEGER DEFAULT NULL;
existsValue BOOLEAN;
BEGIN

--VALIDATE atomic step id exists
SELECT EXISTS(SELECT 1 FROM atomic_steps ast WHERE ast.id=new_atomic_step_id) INTO existsValue;
IF existsValue IS FALSE THEN
   SELECT throw_error('ATOMIC STEP ID ' || new_atomic_step_id || 'DOES NOT EXISTS');
ELSE
INSERT INTO step_therapies(
            indication_id, drug_id, health_plan_id, data_entry_id, provider_id,
            healthplantype_id, created_at, updated_at, boolean_expression_tree,
            is_active, copiedfromid, atomic_step_id)
    VALUES (NULL, NULL, NULL, _new_data_entry_id, NULL,
            NULL, current_timestamp, current_timestamp, new_boolean_expression_tree,
            new_active, NULL, new_atomic_step_id) RETURNING id INTO step_therapy_id;
            RETURN step_therapy_id;
END IF;


END
$$ LANGUAGE plpgsql;
