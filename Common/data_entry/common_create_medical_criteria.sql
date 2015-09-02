CREATE OR REPLACE FUNCTION common_create_medical_criteria(new_medical_id INTEGER, new_criteria_id INTEGER, new_active BOOLEAN, new_notes VARCHAR) --DATA ENTRY
RETURNS BOOLEAN AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
valueExists BOOLEAN DEFAULT FALSE;
BEGIN

SELECT EXISTS (SELECT 1 FROM medical_criteria mc WHERE mc.medical_id=new_medical_id and mc.criterium_id = new_criteria_id LIMIT 1) INTO valueExists;

--VALIDATE IF THE MEDICAL CRITERIA ALREADY EXISTS
IF valueExists IS FALSE THEN
  --INSERT MEDICAL CRITERIA CRITERIA RECORD
INSERT INTO public.medical_criteria(
        value_upper, value_lower, non_fda_approved, created_at, updated_at,
        medical_id, criterium_id, criterium_applicable, active, is_active,
        copiedfromid, notes)
VALUES (NULL, NULL, NULL, current_timestamp, current_timestamp,
        new_medical_id, new_criteria_id, 2, new_active,new_active,
        NULL,new_notes);
END IF;

success :=TRUE;
return success;
END
$$ LANGUAGE plpgsql;
