CREATE OR REPLACE FUNCTION common_create_atomic_steps(new_label VARCHAR, new_key VARCHAR, new_number_steps INTEGER, new_data_entry_type VARCHAR, new_label_with_sequence VARCHAR) --DATA ENTRY
RETURNS INTEGER AS $$
DECLARE
atomic_step_id INTEGER DEFAULT NULL;
BEGIN

INSERT INTO public.atomic_steps(label, key, number_of_steps, data_entry_type, label_with_seq)
VALUES (new_label, new_key, new_number_steps, new_data_entry_type, new_label_with_sequence) RETURNING id INTO atomic_step_id;
RETURN atomic_step_id;

END
$$ LANGUAGE plpgsql;
