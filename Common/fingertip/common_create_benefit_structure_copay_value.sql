CREATE OR REPLACE FUNCTION common_create_benefit_structure_copay(benefit_structure_copay_id INTEGER, tier_id INTEGER, copay_min NUMERIC, copay_max NUMERIC, coinsurance_min NUMERIC, coinsurance_max NUMERIC, is_active BOOLEAN) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
benefit_structure_copay_id INTEGER DEFAULT NULL;
BEGIN

SELECT bsc.id INTO benefit_structure_copay_id FROM benefitstructurecopay bsc WHERE bsc.benefitstructurefid= benefit_structure_id LIMIT 1;

--VALIDATE IF THE HEALTH PLAN DOESNT EXISTS
IF benefit_structure_copay_id IS NULL THEN   

  --INSERT RECORD
  INSERT INTO benefitstructurecopayvalue(
            benefitstructurecopayfid, tierfid, value, max, percentage, 
            createtimestamp, modifytimestamp, active, source, percentage_max)
    VALUES (benefit_structure_copay_id, tier_id, copay_min, copay_max, coinsurance_min, 
            current_timestamp, current_timestamp, is_active, 'ff', coinsurance_max);
    
  RETURN benefit_structure_copay_id;
ELSE
  RETURN benefit_structure_copay_id;
END IF;
END
$$ LANGUAGE plpgsql;

