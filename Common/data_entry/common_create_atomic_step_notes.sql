CREATE OR REPLACE FUNCTION common_create_atomic_step_notes(new_data_entry_id INTEGER, new_de_type VARCHAR,new_step_custom_option_name VARCHAR, new_position INTEGER, new_step_custom_option_id INTEGER, new_notes VARCHAR) --DATA ENTRY
RETURNS BOOLEAN AS $$
DECLARE
success BOOLEAN;
BEGIN

INSERT INTO atomic_steps_notes(
            de_id, de_type, step_custom_option_name, "position", notes, step_custom_option_id)
    VALUES (new_data_entry_id, new_de_type, new_step_custom_option_name, new_position, new_notes, new_step_custom_option_id);


success := TRUE;
return success;
END
$$ LANGUAGE plpgsql;
