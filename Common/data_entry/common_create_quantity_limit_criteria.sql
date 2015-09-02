CREATE OR REPLACE FUNCTION common_create_quantity_limit_criteria(new_quantity_limit_id INTEGER, new_criteria_id INTEGER, new_active BOOLEAN, new_amount_val INTEGER, new_time_val INTEGER, new_amount_type VARCHAR,  new_time_type VARCHAR,new_notes VARCHAR) --DATA ENTRY
RETURNS BOOLEAN AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
BEGIN

  --INSERT QUANTITY LIMIT CRITERIA RECORD
INSERT INTO public.quantity_limit_criteria(
            created_at, updated_at, criterium_id, quantity_limit_id,
            active, amount_val, time_val, amount_type, time_type, is_active,
            copiedfromid, notes)
    VALUES ( current_timestamp, current_timestamp, new_criteria_id, new_quantity_limit_id,
            new_active, new_amount_val, new_time_val, new_amount_type, new_time_type, new_active,
            NULL, new_notes);


success :=TRUE;
return success;
END
$$ LANGUAGE plpgsql;
