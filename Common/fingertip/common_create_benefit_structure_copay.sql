CREATE OR REPLACE FUNCTION common_create_benefit_structure_copay(benefit_structure_id INTEGER, is_active BOOLEAN) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
benefit_structure_copay_id INTEGER DEFAULT NULL;
BEGIN

SELECT bsc.id INTO benefit_structure_copay_id FROM benefitstructurecopay bsc WHERE bsc.benefitstructurefid= benefit_structure_id LIMIT 1;

--VALIDATE IF THE HEALTH PLAN DOESNT EXISTS
IF benefit_structure_copay_id IS NULL THEN   

  --INSERT RECORD
  INSERT INTO benefitstructurecopay(
            benefitstructurefid, pharmacytypefid, copaytypefid, dayssupply, 
            createtimestamp, modifytimestamp, active, source)
    VALUES (benefit_structure_id, 1, 2, NULL, 
            current_timestamp, current_timestamp, (CASE WHEN is_active THEN 1 ELSE 0 END), 'ff');

  RETURN benefit_structure_copay_id;
ELSE
  RETURN benefit_structure_copay_id;
END IF;
END
$$ LANGUAGE plpgsql;

