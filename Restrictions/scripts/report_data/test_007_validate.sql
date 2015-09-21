CREATE OR REPLACE FUNCTION restrictions_test_007_validate_test_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;

  provider_1_id INTEGER DEFAULT NULL;
  provider_2_id INTEGER DEFAULT NULL;
  provider_3_id INTEGER DEFAULT NULL;
  provider_4_id INTEGER DEFAULT NULL;
  provider_5_id INTEGER DEFAULT NULL;
  provider_6_id INTEGER DEFAULT NULL;
  provider_7_id INTEGER DEFAULT NULL;
  provider_8_id INTEGER DEFAULT NULL;
  provider_9_id INTEGER DEFAULT NULL;
  provider_10_id INTEGER DEFAULT NULL;

 valueExists BOOLEAN;

BEGIN

--RETRIEVE PROVIDER IDS
SELECT p.id INTO provider_1_id FROM providers p WHERE p.is_active IS TRUE and p.name='provider_1';
SELECT p.id INTO provider_2_id FROM providers p WHERE p.is_active IS TRUE and p.name='provider_2';
SELECT p.id INTO provider_3_id FROM providers p WHERE p.is_active IS TRUE and p.name='provider_3';
SELECT p.id INTO provider_4_id FROM providers p WHERE p.is_active IS TRUE and p.name='provider_4';
SELECT p.id INTO provider_5_id FROM providers p WHERE p.is_active IS TRUE and p.name='provider_5';
SELECT p.id INTO provider_6_id FROM providers p WHERE p.is_active IS TRUE and p.name='provider_6';
SELECT p.id INTO provider_7_id FROM providers p WHERE p.is_active IS TRUE and p.name='provider_7';
SELECT p.id INTO provider_8_id FROM providers p WHERE p.is_active IS TRUE and p.name='provider_8';
SELECT p.id INTO provider_9_id FROM providers p WHERE p.is_active IS TRUE and p.name='provider_9';
SELECT p.id INTO provider_10_id FROM providers p WHERE p.is_active IS TRUE and p.name='provider_10';


--VALIDATE PROVIDERS#1
IF provider_1_id IS NULL THEN
   SELECT throw_error('PROVIDER#1 IS MISSING');
ELSE
    --VALIDATE HEALTH PLANS ASSOCIATED TO EACH PROVIDER  ARE CORRECT

    --HEALTH PLAN COMMERCIAL
    SELECT EXISTS(SELECT 1 FROM health_plans hp where hp.name='health_plan_comm' and hp.provider_id=provider_1_id) INTO valueExists;
    IF valueExists IS FALSE THEN
        select throw_error('HEALTH PLAN : health_plan_comm  MISSING or unexpected provider associated');
    END IF;

    --HEALTH PLAN HIX
    SELECT EXISTS(SELECT 1 FROM health_plans hp where hp.name='health_plan_hix' and hp.provider_id=provider_1_id) INTO valueExists;
    IF valueExists IS FALSE THEN
        select throw_error('HEALTH PLAN : health_plan_hix MISSING or unexpected provider associated');
    END IF;

    --HEALTH PLAN COM 1
    SELECT EXISTS(SELECT 1 FROM health_plans hp where hp.name='health_plan_comm_1' and hp.provider_id=provider_1_id) INTO valueExists;
    IF valueExists IS FALSE THEN
        select throw_error('HEALTH PLAN:  health_plan_comm_1 MISSING or unexpected provider associated');
    END IF;

END IF;

--VALIDATE PROVIDERS#2
IF provider_2_id IS NULL THEN
   SELECT throw_error('PROVIDER#2 IS MISSING');
ELSE
     --HEALTH PLAN UNION
    SELECT EXISTS(SELECT 1 FROM health_plans hp where hp.name='health_plan_union' and hp.provider_id=provider_2_id) INTO valueExists;
    IF valueExists IS FALSE THEN
        select throw_error('HEALTH PLAN : health_plan_union  MISSING or unexpected provider associated');
    END IF;
END IF;

--VALIDATE PROVIDERS#3
IF provider_3_id IS NULL THEN
   SELECT throw_error('PROVIDER#3 IS MISSING');
ELSE
    --HEALTH PLAN EMPLOYEER
    SELECT EXISTS(SELECT 1 FROM health_plans hp where hp.name='health_plan_empl' and hp.provider_id=provider_3_id) INTO valueExists;
    IF valueExists IS FALSE THEN
        select throw_error('HEALTH PLAN : health_plan_empl  MISSING or unexpected provider associated');
    END IF;
END IF;

--VALIDATE PROVIDERS#4
IF provider_4_id IS NULL THEN
   SELECT throw_error('PROVIDER#4 IS MISSING');
ELSE
   --HEALTH PLAN MUNICIPAL
   SELECT EXISTS(SELECT 1 FROM health_plans hp where hp.name='health_plan_mun' and hp.provider_id=provider_4_id) INTO valueExists;
   IF valueExists IS FALSE THEN
       select throw_error('HEALTH PLAN : health_plan_mun  MISSING  or unexpected provider associated');
   END IF;
END IF;

--VALIDATE PROVIDERS#5
IF provider_5_id IS NULL THEN
   SELECT throw_error('PROVIDER#5 IS MISSING');
ELSE
  --HEALTH PLAN DPP
  SELECT EXISTS(SELECT 1 FROM health_plans hp where hp.name='health_plan_dpp' and hp.provider_id=provider_5_id) INTO valueExists;
  IF valueExists IS FALSE THEN
      select throw_error('HEALTH PLAN : health_plan_dpp  MISSING or unexpected provider associated');
  END IF;
END IF;

--VALIDATE PROVIDERS#6
IF provider_6_id IS NULL THEN
   SELECT throw_error('PROVIDER#6 IS MISSING');
ELSE
  --HEALTH PLAN PDP
  SELECT EXISTS(SELECT 1 FROM health_plans hp where hp.name='health_plan_pdp' and hp.provider_id=provider_6_id) INTO valueExists;
  IF valueExists IS FALSE THEN
      select throw_error('HEALTH PLAN : health_plan_pdp  MISSING or unexpected provider associated');
  END IF;
END IF;

--VALIDATE PROVIDERS#7
IF provider_7_id IS NULL THEN
   SELECT throw_error('PROVIDER#7 IS MISSING');
ELSE
  --HEALTH PLAN MEDICARE SN
  SELECT EXISTS(SELECT 1 FROM health_plans hp where hp.name='health_plan_sn' and hp.provider_id=provider_7_id) INTO valueExists;
  IF valueExists IS FALSE THEN
      select throw_error('HEALTH PLAN : health_plan_sn  MISSING or unexpected provider associated');
  END IF;

    --HEALTH PLAN BCBS
    SELECT EXISTS(SELECT 1 FROM health_plans hp where hp.name='health_plan_bcbs' and hp.provider_id=provider_7_id) INTO valueExists;
    IF valueExists IS FALSE THEN
        select throw_error('HEALTH PLAN : health_plan_bcbs  MISSING or unexpected provider associated');
    END IF;

    --HEALTH PLAN MEDICARE MA
    SELECT EXISTS(SELECT 1 FROM health_plans hp where hp.name='health_plan_ma' and hp.provider_id=provider_7_id) INTO valueExists;
    IF valueExists IS FALSE THEN
        select throw_error('HEALTH PLAN : health_plan_ma  MISSING or unexpected provider associated');
    END IF;

    --HEALTH PLAN COMMERCIAL MEDICAID
    SELECT EXISTS(SELECT 1 FROM health_plans hp where hp.name='health_plan_com_med' and hp.provider_id=provider_7_id) INTO valueExists;
    IF valueExists IS FALSE THEN
        select throw_error('HEALTH PLAN : health_plan_com_med  MISSING or unexpected provider associated');
    END IF;

END IF;

--VALIDATE PROVIDERS#8
IF provider_8_id IS NULL THEN
   SELECT throw_error('PROVIDER#8 IS MISSING');
END IF;

--VALIDATE PROVIDERS#9
IF provider_9_id IS NULL THEN
   SELECT throw_error('PROVIDER#9 IS MISSING');
ELSE
 --HEALTH PLAN STATE
 SELECT EXISTS(SELECT 1 FROM health_plans hp where hp.name='health_plan_state' and hp.provider_id=provider_9_id) INTO valueExists;
 IF valueExists IS FALSE THEN
     select throw_error('HEALTH PLAN : health_plan_state  MISSING or unexpected provider associated');
 END IF;
END IF;

--VALIDATE PROVIDERS#10
IF provider_10_id IS  NULL THEN
   SELECT throw_error('PROVIDER#10 IS MISSING');
ELSE
    --HEALTH PLAN BPM
    SELECT EXISTS(SELECT 1 FROM health_plans hp where hp.name='health_plan_pbm' and hp.provider_id=provider_10_id) INTO valueExists;
    IF valueExists IS FALSE THEN
        select throw_error('HEALTH PLAN : health_plan_pbm  MISSING or unexpected provider associated');
END IF;
END IF;


success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;