CREATE OR REPLACE FUNCTION common_create_health_plan_county(health_plan_id INTEGER, county_id INTEGER) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
health_plan_county_id INTEGER DEFAULT NULL;
BEGIN

SELECT hpc.id INTO health_plan_county_id FROM healthplancounty hpc WHERE hpc.healthplanfid= health_plan_id AND hpc.countyfid= county_id LIMIT 1;

--VALIDATE IF THE HEALTH PLAN DOESNT EXISTS
IF health_plan_county_id IS NULL THEN   
  --INSERT  HEALTH PLAN RECORD
  INSERT INTO healthplancounty(
            healthplanfid, countyfid)
    VALUES (health_plan_id, county_id) RETURNING id INTO health_plan_county_id;

  RETURN health_plan_county_id;
ELSE
  RETURN health_plan_county_id;
END IF;
END
$$ LANGUAGE plpgsql;

