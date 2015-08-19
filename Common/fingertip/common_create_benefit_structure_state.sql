CREATE OR REPLACE FUNCTION common_create_benefit_structure_state(benefit_structure_id INTEGER, state_id INTEGER) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
benefit_structure_state_id INTEGER DEFAULT NULL;
BEGIN

SELECT bss.id INTO benefit_structure_state_id FROM benefitstructurecopay bss WHERE bss.benefitstructurefid= benefit_structure_id AND bss.statefid=state_id LIMIT 1;

--VALIDATE IF THE RECORD DOESNT EXISTS
IF benefit_structure_state_id IS NULL THEN

  --INSERT RECORD
  INSERT INTO benefitstructurestate(
              benefitstructurefid, statefid)
      VALUES (benefit_structure_id, state_id);
    
  RETURN benefit_structure_state_id;
ELSE
  RETURN benefit_structure_state_id;
END IF;
END
$$ LANGUAGE plpgsql;
