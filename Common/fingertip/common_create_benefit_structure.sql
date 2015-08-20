CREATE OR REPLACE FUNCTION common_create_benefit_structure(health_plan_id INTEGER, is_active BOOLEAN) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
benefit_structure_id INTEGER DEFAULT NULL;
benefit_plan_name VARCHAR;
BEGIN

SELECT bs.id INTO benefit_structure_id FROM benefitstructure bs WHERE bs.healthplanfid= health_plan_id LIMIT 1;

--VALIDATE IF THE HEALTH PLAN DOESNT EXISTS
IF benefit_structure_id IS NULL THEN   
  SELECT healthplan.name from healthplan where healthplan.id = health_plan_id INTO benefit_plan_name;

  --INSERT  HEALTH PLAN RECORD
  INSERT INTO benefitstructure(
            healthplanfid, benefitplanname, benefitplanurl, medicarecontractid, 
            deductible, coveragegap, catastrophiccoverage, comments, createtimestamp, 
            modifytimestamp, createdby, modifiedby, active, premium, source, 
            cms_plan_id, specialty_copay_min, specialty_copay_max, specialty_coinsurance_min, 
            specialty_coinsurance_max, medical_benefit_coinsurance_min, medical_benefit_coinsurance_max, 
            medical_benefit_copay_min, medical_benefit_copay_max)
    VALUES (health_plan_id, benefit_plan_name, NULL, NULL, 
            NULL, NULL, NULL, NULL, current_timestamp, 
            current_timestamp, NULL, NULL, (CASE WHEN is_active THEN 1 ELSE 0 END), NULL, 'ff', 
            NULL, NULL, NULL, NULL, 
            NULL, NULL, NULL, 
            NULL, NULL) RETURNING id INTO benefit_structure_id;
    
  RETURN benefit_structure_id;
ELSE
  RETURN benefit_structure_id;
END IF;
END
$$ LANGUAGE plpgsql;

