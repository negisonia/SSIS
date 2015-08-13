CREATE OR REPLACE FUNCTION common_create_atomic_steps(new_label VARCHAR, new_key VARCHAR, new_number_steps INTEGER, new_data_entry_type VARCHAR, new_label_with_sequence VARCHAR) --DATA ENTRY
RETURNS INTEGER AS $$
DECLARE
atomic_step_id INTEGER DEFAULT NULL;
BEGIN

SELECT a.id INTO atomic_step_id FROM atomic_steps a WHERE a.label=new_label and a.key = new_key and a.number_of_steps=new_number_steps and a.data_entry_type=new_data_entry_type and a.new_label_with_sequence=new_label_with_sequence;

IF atomic_step_id IS NULL THEN
    INSERT INTO public.atomic_steps(label, key, number_of_steps, data_entry_type, label_with_seq)
    VALUES (new_label, new_key, new_number_steps, new_data_entry_type, new_label_with_sequence) RETURNING id INTO atomic_step_id;
END IF;

RETURN atomic_step_id;

END
$$ LANGUAGE plpgsql;
