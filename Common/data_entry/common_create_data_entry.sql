CREATE OR REPLACE FUNCTION common_create_data_entry(new_indication_id INTEGER, new_provider_id INTEGER, new_health_plan_type_id INTEGER, new_drug_id INTEGER) --DATA ENTRY
RETURNS INTEGER AS $$
DECLARE
data_entry_id INTEGER DEFAULT NULL;
valueExists BOOLEAN DEFAULT FALSE;
BEGIN

  --VALIDATE IF INDICATION EXISTS
  SELECT EXISTS(SELECT 1 FROM indications i WHERE i.id=new_indication_id) INTO valueExists;
  IF valueExists IS FALSE THEN
    select throw_error('INDICATION WITH ID '|| new_indication_id || ' DOES NOT EXISTS');
  END IF;

  --VALIDATE IF PROVIDER EXISTS
  SELECT EXISTS (SELECT 1 FROM ff.providers_import pi WHERE pi.id=new_provider_id) INTO valueExists;
  IF valueExists IS FALSE THEN
      select throw_error('PROVIDER WITH ID '|| new_provider_id || ' DOES NOT EXISTS');
  END IF;

  --VALIDATE IF HEALTH PLAN TYPE EXISTS
  SELECT EXISTS (SELECT 1 FROM ff.health_plan_types_import hpti WHERE hpti.id=new_health_plan_type_id) INTO valueExists;
  IF valueExists IS FALSE THEN
      select throw_error('HEALTH PLAN TYPE WITH ID '|| new_health_plan_type_id || ' DOES NOT EXISTS');
  END IF;


  --VALIDATE IF DRUG EXISTS
  SELECT EXISTS (SELECT 1 FROM ff.drugs_import di WHERE di.id=new_drug_id) INTO valueExists;
  IF valueExists IS FALSE THEN
     select throw_error('DRUG WITH ID '|| new_drug_id ||' DOES NOT EXISTS');
  END IF;


   INSERT INTO data_entries(
               indication_id, provider_id, healthplantype_id, coverage_id,
               drug_id, coverage_limit_id, prior_authorization_id, quantity_limit_id,
               other_restriction_id, created_at, updated_at, step_therapy_id,
               medical_id, copiedfromid)
       VALUES (new_indication_id, new_provider_id, new_health_plan_type_id, NULL,
               new_drug_id, NULL, NULL, NULL,
               NULL, current_timestamp, current_timestamp, NULL,
               NULL, NULL) RETURNING id INTO data_entry_id;
  RETURN data_entry_id;

END
$$ LANGUAGE plpgsql;
