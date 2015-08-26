CREATE OR REPLACE FUNCTION common_create_benefit_structure_copay_value(benefit_structure_copay_id INTEGER, tier_id INTEGER, copay_min NUMERIC, copay_max NUMERIC, coinsurance_min NUMERIC, coinsurance_max NUMERIC, is_active BOOLEAN) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
benefit_structure_copay_value_id INTEGER DEFAULT NULL;
BEGIN

SELECT bsc.id INTO benefit_structure_copay_value_id FROM benefitstructurecopayvalue bsc WHERE bsc.benefitstructurecopayfid= benefit_structure_copay_id LIMIT 1;

--VALIDATE IF THE HEALTH PLAN DOESNT EXISTS
IF benefit_structure_copay_value_id IS NULL THEN   

  --INSERT RECORD
  INSERT INTO benefitstructurecopayvalue(
            benefitstructurecopayfid, tierfid, value, max, percentage, 
            createtimestamp, modifytimestamp, active, source, percentage_max)
    VALUES (benefit_structure_copay_id, tier_id, copay_min, copay_max, coinsurance_min, 
            current_timestamp, current_timestamp, (CASE WHEN is_active THEN 1 ELSE 0 END), 'ff', coinsurance_max) RETURNING id INTO benefit_structure_copay_value_id;
    
  RETURN benefit_structure_copay_value_id;
ELSE
  RETURN benefit_structure_copay_value_id;
END IF;
END
$$ LANGUAGE plpgsql;

