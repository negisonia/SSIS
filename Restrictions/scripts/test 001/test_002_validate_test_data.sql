CREATE OR REPLACE FUNCTION restrictions_test_002_validate_test_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  booleanValue BOOLEAN DEFAULT FALSE;
  intValue INTEGER;
  textValue VARCHAR;
  health_plans VARCHAR[] := ARRAY['restrictions_test_hp_commercial_1','restrictions_test_hp_hix_1','restrictions_test_hp_bcbs_1','restrictions_test_hp_employeer_1','restrictions_test_hp_na_1','restrictions_test_hp_sn_1','restrictions_test_hp_pdp_1','restrictions_test_hp_state_1','restrictions_test_hp_dpp_1','restrictions_test_hp_commercial_medicaid_1','restrictions_test_hp_union_1','restrictions_test_hp_municipal_plan_1','restrictions_test_hp_pbm_1','restrictions_test_hp_commercial_2','restrictions_test_hp_commercial_3']; 
BEGIN

--ITERATE HEALTHPLAN TYPES
FOREACH textValue IN ARRAY health_plans
LOOP

--INSERT HEALTHPLAN TYPES
CASE textValue 
	WHEN 'restrictions_test_hp_commercial_1' THEN
		--VALIDATE HEALTH PLAN EXISTS AND IS ACTIVE
		SELECT EXISTS (SELECT 1 FROM ff.health_plans h WHERE h.name=textValue and h.is_active IS TRUE) INTO booleanValue;
		IF booleanValue IS FALSE THEN
			select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN ' || textValue || ' DOES NOT EXISTS OR IS INACTIVE');

		ELSE
			--VALIDATE HEALTH PLAN TYPE EXISTS
			SELECT h.health_plan_type_id INTO intValue FROM ff.health_plans h WHERE h.name=textValue;
			SELECT EXISTS (SELECT 1 FROM ff.health_plan_types hpt WHERE hpt.id=intValue and hpt.is_active IS TRUE and hpt.name='restrictions_test_commercial') INTO booleanValue;
			IF booleanValue IS FALSE THEN
				select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN TYPE '|| intValue ||' DOES NOT EXISTS ');
			END IF;
		END IF;			
		
	WHEN 'restrictions_test_hp_hix_1' THEN
		--VALIDATE HEALTH PLAN EXISTS AND IS ACTIVE
		SELECT EXISTS (SELECT 1 FROM ff.health_plans h WHERE h.name=textValue and h.is_active IS TRUE) INTO booleanValue;
		IF booleanValue IS FALSE THEN
			select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN ' || textValue || ' DOES NOT EXISTS OR IS INACTIVE');

		ELSE
			--VALIDATE HEALTH PLAN TYPE EXISTS
			SELECT h.health_plan_type_id INTO intValue FROM ff.health_plans h WHERE h.name=textValue;
			SELECT EXISTS (SELECT 1 FROM ff.health_plan_types hpt WHERE hpt.id=intValue and hpt.is_active IS TRUE and hpt.name='restrictions_test_hix') INTO booleanValue;
			IF booleanValue IS FALSE THEN
				select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN TYPE '|| intValue ||' DOES NOT EXISTS ');
			END IF;
		END IF;	
		
	WHEN 'restrictions_test_hp_bcbs_1' THEN	
		--VALIDATE HEALTH PLAN EXISTS AND IS ACTIVE
		SELECT EXISTS (SELECT 1 FROM ff.health_plans h WHERE h.name=textValue and h.is_active IS TRUE) INTO booleanValue;
		IF booleanValue IS FALSE THEN
			select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN ' || textValue || ' DOES NOT EXISTS OR IS INACTIVE');

		ELSE
			--VALIDATE HEALTH PLAN TYPE EXISTS
			SELECT h.health_plan_type_id INTO intValue FROM ff.health_plans h WHERE h.name=textValue;
			SELECT EXISTS (SELECT 1 FROM ff.health_plan_types hpt WHERE hpt.id=intValue and hpt.is_active IS TRUE and hpt.name='restrictions_test_commercial_bcbs') INTO booleanValue;
			IF booleanValue IS FALSE THEN
				select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN TYPE '|| intValue ||' DOES NOT EXISTS ');
			END IF;
		END IF;	
	
	WHEN 'restrictions_test_hp_employeer_1' THEN	
		--VALIDATE HEALTH PLAN EXISTS AND IS ACTIVE
		SELECT EXISTS (SELECT 1 FROM ff.health_plans h WHERE h.name=textValue and h.is_active IS TRUE) INTO booleanValue;
		IF booleanValue IS FALSE THEN
			select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN ' || textValue || ' DOES NOT EXISTS OR IS INACTIVE');

		ELSE
			--VALIDATE HEALTH PLAN TYPE EXISTS
			SELECT h.health_plan_type_id INTO intValue FROM ff.health_plans h WHERE h.name=textValue;
			SELECT EXISTS (SELECT 1 FROM ff.health_plan_types hpt WHERE hpt.id=intValue and hpt.is_active IS TRUE and hpt.name='restrictions_test_employer') INTO booleanValue;
			IF booleanValue IS FALSE THEN
				select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN TYPE '|| intValue ||' DOES NOT EXISTS ');
			END IF;
		END IF;	
		
	WHEN 'restrictions_test_hp_na_1' THEN	
		--VALIDATE HEALTH PLAN EXISTS AND IS ACTIVE
		SELECT EXISTS (SELECT 1 FROM ff.health_plans h WHERE h.name=textValue and h.is_active IS TRUE) INTO booleanValue;
		IF booleanValue IS FALSE THEN
			select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN ' || textValue || ' DOES NOT EXISTS OR IS INACTIVE');

		ELSE
			--VALIDATE HEALTH PLAN TYPE EXISTS
			SELECT h.health_plan_type_id INTO intValue FROM ff.health_plans h WHERE h.name=textValue;
			SELECT EXISTS (SELECT 1 FROM ff.health_plan_types hpt WHERE hpt.id=intValue and hpt.is_active IS TRUE and hpt.name='restrictions_test_medicare_ma') INTO booleanValue;
			IF booleanValue IS FALSE THEN
				select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN TYPE '|| intValue ||' DOES NOT EXISTS ');
			END IF;
		END IF;	
		
	WHEN 'restrictions_test_hp_sn_1' THEN
		--VALIDATE HEALTH PLAN EXISTS AND IS ACTIVE
		SELECT EXISTS (SELECT 1 FROM ff.health_plans h WHERE h.name=textValue and h.is_active IS TRUE) INTO booleanValue;
		IF booleanValue IS FALSE THEN
			select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN ' || textValue || ' DOES NOT EXISTS OR IS INACTIVE');

		ELSE
			--VALIDATE HEALTH PLAN TYPE EXISTS
			SELECT h.health_plan_type_id INTO intValue FROM ff.health_plans h WHERE h.name=textValue;
			SELECT EXISTS (SELECT 1 FROM ff.health_plan_types hpt WHERE hpt.id=intValue and hpt.is_active IS TRUE and hpt.name='restrictions_test_medicare_sn') INTO booleanValue;
			IF booleanValue IS FALSE THEN
				select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN TYPE '|| intValue ||' DOES NOT EXISTS ');
			END IF;
		END IF;	
	WHEN 'restrictions_test_hp_pdp_1' THEN
		--VALIDATE HEALTH PLAN EXISTS AND IS ACTIVE
		SELECT EXISTS (SELECT 1 FROM ff.health_plans h WHERE h.name=textValue and h.is_active IS TRUE) INTO booleanValue;
		IF booleanValue IS FALSE THEN
			select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN ' || textValue || ' DOES NOT EXISTS OR IS INACTIVE');

		ELSE
			--VALIDATE HEALTH PLAN TYPE EXISTS
			SELECT h.health_plan_type_id INTO intValue FROM ff.health_plans h WHERE h.name=textValue;
			SELECT EXISTS (SELECT 1 FROM ff.health_plan_types hpt WHERE hpt.id=intValue and hpt.is_active IS TRUE and hpt.name='restrictions_test_medicare_pdp') INTO booleanValue;
			IF booleanValue IS FALSE THEN
				select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN TYPE '|| intValue ||' DOES NOT EXISTS ');
			END IF;
		END IF;	
	WHEN 'restrictions_test_hp_state_1' THEN
		--VALIDATE HEALTH PLAN EXISTS AND IS ACTIVE
		SELECT EXISTS (SELECT 1 FROM ff.health_plans h WHERE h.name=textValue and h.is_active IS TRUE) INTO booleanValue;
		IF booleanValue IS FALSE THEN
			select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN ' || textValue || ' DOES NOT EXISTS OR IS INACTIVE');

		ELSE
			--VALIDATE HEALTH PLAN TYPE EXISTS
			SELECT h.health_plan_type_id INTO intValue FROM ff.health_plans h WHERE h.name=textValue;
			SELECT EXISTS (SELECT 1 FROM ff.health_plan_types hpt WHERE hpt.id=intValue and hpt.is_active IS TRUE and hpt.name='restrictions_test_state_medicare') INTO booleanValue;
			IF booleanValue IS FALSE THEN
				select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN TYPE '|| intValue ||' DOES NOT EXISTS ');
			END IF;
		END IF;	
	WHEN 'restrictions_test_hp_dpp_1' THEN
		--VALIDATE HEALTH PLAN EXISTS AND IS ACTIVE
		SELECT EXISTS (SELECT 1 FROM ff.health_plans h WHERE h.name=textValue and h.is_active IS TRUE) INTO booleanValue;
		IF booleanValue IS FALSE THEN
			select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN ' || textValue || ' DOES NOT EXISTS OR IS INACTIVE');

		ELSE
			--VALIDATE HEALTH PLAN TYPE EXISTS
			SELECT h.health_plan_type_id INTO intValue FROM ff.health_plans h WHERE h.name=textValue;
			SELECT EXISTS (SELECT 1 FROM ff.health_plan_types hpt WHERE hpt.id=intValue and hpt.is_active IS TRUE and hpt.name='restrictions_test_dpp') INTO booleanValue;
			IF booleanValue IS FALSE THEN
				select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN TYPE '|| intValue ||' DOES NOT EXISTS ');
			END IF;
		END IF;	
	WHEN 'restrictions_test_hp_commercial_medicaid_1' THEN
		--VALIDATE HEALTH PLAN EXISTS AND IS ACTIVE
		SELECT EXISTS (SELECT 1 FROM ff.health_plans h WHERE h.name=textValue and h.is_active IS TRUE) INTO booleanValue;
		IF booleanValue IS FALSE THEN
			select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN ' || textValue || ' DOES NOT EXISTS OR IS INACTIVE');

		ELSE
			--VALIDATE HEALTH PLAN TYPE EXISTS
			SELECT h.health_plan_type_id INTO intValue FROM ff.health_plans h WHERE h.name=textValue;
			SELECT EXISTS (SELECT 1 FROM ff.health_plan_types hpt WHERE hpt.id=intValue and hpt.is_active IS TRUE and hpt.name='restrictions_test_commercial_medicaid') INTO booleanValue;
			IF booleanValue IS FALSE THEN
				select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN TYPE '|| intValue ||' DOES NOT EXISTS ');
			END IF;
		END IF;	
	WHEN 'restrictions_test_hp_union_1' THEN
		--VALIDATE HEALTH PLAN EXISTS AND IS ACTIVE
		SELECT EXISTS (SELECT 1 FROM ff.health_plans h WHERE h.name=textValue and h.is_active IS TRUE) INTO booleanValue;
		IF booleanValue IS FALSE THEN
			select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN ' || textValue || ' DOES NOT EXISTS OR IS INACTIVE');

		ELSE
			--VALIDATE HEALTH PLAN TYPE EXISTS
			SELECT h.health_plan_type_id INTO intValue FROM ff.health_plans h WHERE h.name=textValue;
			SELECT EXISTS (SELECT 1 FROM ff.health_plan_types hpt WHERE hpt.id=intValue and hpt.is_active IS TRUE and hpt.name='restrictions_test_union') INTO booleanValue;
			IF booleanValue IS FALSE THEN
				select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN TYPE '|| intValue ||' DOES NOT EXISTS ');
			END IF;
		END IF;	
	WHEN 'restrictions_test_hp_municipal_plan_1' THEN
		--VALIDATE HEALTH PLAN EXISTS AND IS ACTIVE
		SELECT EXISTS (SELECT 1 FROM ff.health_plans h WHERE h.name=textValue and h.is_active IS TRUE) INTO booleanValue;
		IF booleanValue IS FALSE THEN
			select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN ' || textValue || ' DOES NOT EXISTS OR IS INACTIVE');

		ELSE
			--VALIDATE HEALTH PLAN TYPE EXISTS
			SELECT h.health_plan_type_id INTO intValue FROM ff.health_plans h WHERE h.name=textValue;
			SELECT EXISTS (SELECT 1 FROM ff.health_plan_types hpt WHERE hpt.id=intValue and hpt.is_active IS TRUE and hpt.name='restrictions_test_municipal_plan') INTO booleanValue;
			IF booleanValue IS FALSE THEN
				select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN TYPE '|| intValue ||' DOES NOT EXISTS ');
			END IF;
		END IF;	
	WHEN 'restrictions_test_hp_pbm_1' THEN
		--VALIDATE HEALTH PLAN EXISTS AND IS ACTIVE
		SELECT EXISTS (SELECT 1 FROM ff.health_plans h WHERE h.name=textValue and h.is_active IS TRUE) INTO booleanValue;
		IF booleanValue IS FALSE THEN
			select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN ' || textValue || ' DOES NOT EXISTS OR IS INACTIVE');

		ELSE
			--VALIDATE HEALTH PLAN TYPE EXISTS
			SELECT h.health_plan_type_id INTO intValue FROM ff.health_plans h WHERE h.name=textValue;
			SELECT EXISTS (SELECT 1 FROM ff.health_plan_types hpt WHERE hpt.id=intValue and hpt.is_active IS TRUE and hpt.name='restrictions_test_pbm') INTO booleanValue;
			IF booleanValue IS FALSE THEN
				select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN TYPE '|| intValue ||' DOES NOT EXISTS ');
			END IF;
		END IF;	
	WHEN 'restrictions_test_hp_commercial_2' THEN	
		--VALIDATE HEALTH PLAN EXISTS AND IS ACTIVE
		SELECT EXISTS (SELECT 1 FROM ff.health_plans h WHERE h.name=textValue and h.is_active IS TRUE) INTO booleanValue;
		IF booleanValue IS TRUE THEN
			select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN ' || textValue || ' SHOULD NOT EXISTS');		
		END IF;	
	WHEN 'restrictions_test_hp_commercial_3' THEN--THIS FAILS ASK IF THIS IS VALID SCENARIO
		--VALIDATE HEALTH PLAN DONT EXISTS
		SELECT EXISTS (SELECT 1 FROM ff.health_plans h WHERE h.name=textValue and h.is_active IS TRUE) INTO booleanValue;
		IF booleanValue IS TRUE THEN
			select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN ' || textValue || ' SHOULD NOT EXISTS');		
		END IF;	
		
	ELSE 
		RAISE NOTICE 'UNEXPECTED HEALTH PLAN TYPE ITERATION';
END CASE;
	
END LOOP;

success:=true;
RETURN success;	  	
END
$$ LANGUAGE plpgsql;