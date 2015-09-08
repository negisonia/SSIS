CREATE OR REPLACE FUNCTION common_create_hli_medical_benefit_designs(input_id INTEGER, input_name varchar)
RETURNS INTEGER AS $$
DECLARE
hli_medical_benefit_designs_id INTEGER DEFAULT NULL;
BEGIN

  INSERT INTO public.hli_medical_benefit_designs(
            id, name, created_at, updated_at, hli_medical_benefit_design_category_id)
    VALUES (input_id, input_name, current_timestamp, current_timestamp, NULL) RETURNING id INTO hli_medical_benefit_designs_id;

  RETURN hli_medical_benefit_designs_id;

END
$$ LANGUAGE plpgsql;

