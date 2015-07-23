CREATE OR REPLACE FUNCTION restrictions_test_008_validate_test_data() --DATA WAREHOUSE
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

 valueExists BOOLEAN;

BEGIN

--RETRIEVE PROVIDER IDS
SELECT p.id INTO provider_1_id FROM ff.providers p WHERE p.is_active IS TRUE and p.name='restrictions_provider_1';
SELECT p.id INTO provider_2_id FROM ff.providers p WHERE p.is_active IS TRUE and p.name='restrictions_provider_2';
SELECT p.id INTO provider_3_id FROM ff.providers p WHERE p.is_active IS TRUE and p.name='restrictions_provider_3';
SELECT p.id INTO provider_4_id FROM ff.providers p WHERE p.is_active IS TRUE and p.name='restrictions_provider_4';
SELECT p.id INTO provider_5_id FROM ff.providers p WHERE p.is_active IS TRUE and p.name='restrictions_provider_5';
SELECT p.id INTO provider_6_id FROM ff.providers p WHERE p.is_active IS TRUE and p.name='restrictions_provider_6';
SELECT p.id INTO provider_7_id FROM ff.providers p WHERE p.is_active IS TRUE and p.name='restrictions_provider_7';
SELECT p.id INTO provider_8_id FROM ff.providers p WHERE p.is_active IS TRUE and p.name='restrictions_provider_8';


--VALIDATE PROVIDERS#1
IF provider_1_id IS NULL THEN
   SELECT throw_error('PROVIDER#1 IS MISSING');
ELSE
    --VALIDATE HEALTH PLANS ASSOCIATED TO EACH PROVIDER  ARE CORRECT

    --HEALTH PLAN COMMERCIAL
    SELECT EXISTS(SELECT 1 FROM ff.health_plans hp where hp.name='restrictions_test_hp_commercial_1' and hp.provider_id=provider_1_id) INTO valueExists;
    IF valueExists IS FALSE THEN
        select throw_error('HEALTH PLAN : restrictions_test_05_commercial_1  MISSING');
    END IF;

    --HEALTH PLAN HIX
    SELECT EXISTS(SELECT 1 FROM ff.health_plans hp where hp.name='restrictions_test_hp_hix_1' and hp.provider_id=provider_1_id) INTO valueExists;
    IF valueExists IS FALSE THEN
        select throw_error('HEALTH PLAN : restrictions_test_hp_hix_1 MISSING');
    END IF;

    --HEALTH PLAN STATE
    SELECT EXISTS(SELECT 1 FROM ff.health_plans hp where hp.name='restrictions_test_hp_state_1' and hp.provider_id=provider_1_id) INTO valueExists;
    IF valueExists IS FALSE THEN
        select throw_error('HEALTH PLAN:  restrictions_test_hp_state_1 MISSING');
    END IF;

END IF;

--VALIDATE PROVIDERS#2
IF provider_2_id IS NULL THEN
   SELECT throw_error('PROVIDER#2 IS MISSING');
ELSE
     --HEALTH PLAN UNION
    SELECT EXISTS(SELECT 1 FROM ff.health_plans hp where hp.name='restrictions_test_hp_union_1' and hp.provider_id=provider_2_id) INTO valueExists;
    IF valueExists IS FALSE THEN
        select throw_error('HEALTH PLAN : restrictions_test_hp_union_1  MISSING');
    END IF;
END IF;

--VALIDATE PROVIDERS#3
IF provider_3_id IS NULL THEN
   SELECT throw_error('PROVIDER#3 IS MISSING');
ELSE
    --HEALTH PLAN EMPLOYEER
    SELECT EXISTS(SELECT 1 FROM ff.health_plans hp where hp.name='restrictions_test_hp_employeer_1' and hp.provider_id=provider_3_id) INTO valueExists;
    IF valueExists IS FALSE THEN
        select throw_error('HEALTH PLAN : restrictions_test_hp_employeer_1  MISSING');
    END IF;
END IF;

--VALIDATE PROVIDERS#4
IF provider_4_id IS NULL THEN
   SELECT throw_error('PROVIDER#4 IS MISSING');
ELSE
   --HEALTH PLAN MUNICIPAL
   SELECT EXISTS(SELECT 1 FROM ff.health_plans hp where hp.name='restrictions_test_hp_municipal_plan_1' and hp.provider_id=provider_4_id) INTO valueExists;
   IF valueExists IS FALSE THEN
       select throw_error('HEALTH PLAN : restrictions_test_hp_municipal_plan_1  MISSING');
   END IF;
END IF;

--VALIDATE PROVIDERS#5
IF provider_5_id IS NULL THEN
   SELECT throw_error('PROVIDER#5 IS MISSING');
ELSE
  --HEALTH PLAN DPP
  SELECT EXISTS(SELECT 1 FROM ff.health_plans hp where hp.name='restrictions_test_hp_dpp_1' and hp.provider_id=provider_5_id) INTO valueExists;
  IF valueExists IS FALSE THEN
      select throw_error('HEALTH PLAN : restrictions_test_hp_dpp_1  MISSING');
  END IF;
END IF;

--VALIDATE PROVIDERS#6
IF provider_6_id IS NULL THEN
   SELECT throw_error('PROVIDER#6 IS MISSING');
ELSE
  --HEALTH PLAN PDP
  SELECT EXISTS(SELECT 1 FROM ff.health_plans hp where hp.name='restrictions_test_hp_pdp_1' and hp.provider_id=provider_6_id) INTO valueExists;
  IF valueExists IS FALSE THEN
      select throw_error('HEALTH PLAN : restrictions_test_hp_pdp_1  MISSING');
  END IF;
END IF;

--VALIDATE PROVIDERS#7
IF provider_7_id IS NULL THEN
   SELECT throw_error('PROVIDER#7 IS MISSING');
ELSE
  --HEALTH PLAN MEDICARE SN
  SELECT EXISTS(SELECT 1 FROM ff.health_plans hp where hp.name='restrictions_test_hp_sn_1' and hp.provider_id=provider_7_id) INTO valueExists;
  IF valueExists IS FALSE THEN
      select throw_error('HEALTH PLAN : restrictions_test_hp_sn_1  MISSING');
  END IF;

    --HEALTH PLAN BCBS
    SELECT EXISTS(SELECT 1 FROM ff.health_plans hp where hp.name='restrictions_test_hp_bcbs_1' and hp.provider_id=provider_7_id) INTO valueExists;
    IF valueExists IS FALSE THEN
        select throw_error('HEALTH PLAN : restrictions_test_hp_bcbs_1  MISSING');
    END IF;

    --HEALTH PLAN MEDICARE MA
    SELECT EXISTS(SELECT 1 FROM ff.health_plans hp where hp.name='restrictions_test_hp_na_1' and hp.provider_id=provider_7_id) INTO valueExists;
    IF valueExists IS FALSE THEN
        select throw_error('HEALTH PLAN : restrictions_test_hp_na_1  MISSING');
    END IF;

    --HEALTH PLAN COMMERCIAL MEDICAID
    SELECT EXISTS(SELECT 1 FROM ff.health_plans hp where hp.name='restrictions_test_hp_commercial_medicaid_1' and hp.provider_id=provider_7_id) INTO valueExists;
    IF valueExists IS FALSE THEN
        select throw_error('HEALTH PLAN : restrictions_test_hp_commercial_medicaid_1  MISSING');
    END IF;

END IF;

--VALIDATE PROVIDERS#8
IF provider_8_id IS NULL THEN
   SELECT throw_error('PROVIDER#8 IS MISSING');
ELSE
  --HEALTH PLAN PBM
  SELECT EXISTS(SELECT 1 FROM ff.health_plans hp where hp.name='restrictions_test_hp_pbm_1' and hp.provider_id=provider_8_id) INTO valueExists;
  IF valueExists IS FALSE THEN
      select throw_error('HEALTH PLAN : restrictions_test_hp_pbm_1  MISSING');
  END IF;
END IF;


success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;