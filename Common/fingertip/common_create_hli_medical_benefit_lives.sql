CREATE OR REPLACE FUNCTION common_create_hli_medical_benefit_lives(input_provider_id INTEGER, input_lives INTEGER) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
hli_medical_benefit_life_id;
BEGIN

  --INSERT RECORD
  INSERT INTO hli_medical_benefit_lives(
            hli_medical_benefit_lives_import_id, provider_id, county_id, 
            hli_medical_benefit_design_id, lives_imported, lives_allocated, 
            lives_adjusted, lives, created_at, updated_at)
    VALUES (NULL,input_provider_id, NULL, 
            NULL, NULL, NULL, 
            NULL, input_lives, current_timestamp, current_timestamp) RETURNING id INTO hli_medical_benefit_life_id;
  RETURN hli_medical_benefit_life_id;
ELSE
  RETURN hli_medical_benefit_life_id;
END IF;
END
$$ LANGUAGE plpgsql;

