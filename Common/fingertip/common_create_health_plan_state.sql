CREATE OR REPLACE FUNCTION common_create_health_plan_state(health_plan_id INTEGER, state_id INTEGER) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
health_plan_state_id INTEGER DEFAULT NULL;
BEGIN

SELECT hps.id INTO health_plan_state_id FROM healthplanstate hps WHERE hps.healthplanfid= health_plan_id AND hps.statefid= state_id  LIMIT 1;

--VALIDATE IF THE HEALTH PLAN DOESNT EXISTS
IF health_plan_state_id IS NULL THEN   
  --INSERT  HEALTH PLAN RECORD
  INSERT INTO healthplanstate(
            healthplanfid, statefid)
    VALUES (health_plan_id, state_id) RETURNING id INTO health_plan_state_id;

  RETURN health_plan_state_id;
ELSE
  RETURN health_plan_state_id;
END IF;
END
$$ LANGUAGE plpgsql;

