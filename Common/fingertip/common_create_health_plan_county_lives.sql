CREATE OR REPLACE FUNCTION common_create_health_plan_county_lives(health_plan_id INTEGER, state_id INTEGER, county_id INTEGER, msa_id INTEGER, lives_input NUMERIC) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
health_plan_county_life_id INTEGER DEFAULT NULL;
BEGIN

  IF lives_input IS NULL THEN
    select throw_error('common_create_health_plan_county_lives-error: EXPECTED LIVES TO BE NOT NULL');
  ELSIF state_id IS NULL THEN
    select throw_error('common_create_health_plan_county_lives-error: EXPECTED STATE ID TO BE NOT NULL');
  ELSIF county_id IS NULL AND msa_id IS NOT NULL THEN
    select throw_error('common_create_health_plan_county_lives-error: EXPECTED COUNTY ID TO BE NOT NULL WHEN PASSING MSA ID');
  END IF;

SELECT hpcl.id INTO health_plan_county_life_id FROM healthplan_countylives hpcl WHERE hpcl.healthplanfid=health_plan_id AND hpcl.statefid=state_id AND hpcl.lives = lives_input AND
(CASE WHEN county_id IS NULL THEN TRUE ELSE hpcl.countyfid = county_id END) AND (CASE WHEN msa_id IS NULL THEN TRUE ELSE hpcl.metrostatareafid = msa_id END)
LIMIT 1;

--VALIDATE IF THE HEALTH PLAN COUNTY ALREADY EXISTS
IF health_plan_county_life_id IS NULL THEN
  --INSERT HEALTH PLAN COUNTY RECORD
  INSERT INTO healthplan_countylives(
            id, healthplanfid, statefid, countyfid, metrostatareafid, lives, 
            importtypefid, modifytimestamp, modifyuser)
        VALUES (NEXTVAL('health_plan_county_lives_id_seq'), health_plan_id , state_id , county_id, msa_id, lives_input, 
            NULL, NULL, NULL) RETURNING id INTO health_plan_county_life_id;

  RETURN health_plan_county_life_id;
ELSE
  RETURN health_plan_county_life_id;
END IF;

END
$$ LANGUAGE plpgsql;

