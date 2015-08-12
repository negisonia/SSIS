CREATE OR REPLACE FUNCTION restrictions_test_001_validate_test_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  booleanValue BOOLEAN DEFAULT FALSE;
  intValue INTEGER;
BEGIN


--VALIDATE HEALTH PLAN (health_plan_comm) EXISTS AND IS ACTIVE
		SELECT EXISTS (SELECT 1 FROM health_plans h WHERE h.name='health_plan_comm' and h.is_active IS TRUE) INTO booleanValue;
		IF booleanValue IS FALSE THEN
			select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN health_plan_comm DOES NOT EXISTS OR IS INACTIVE');

		ELSE
			--VALIDATE HEALTH PLAN TYPE EXISTS
			SELECT h.health_plan_type_id INTO intValue FROM health_plans h WHERE h.name='health_plan_comm';
			SELECT EXISTS (SELECT 1 FROM health_plan_types hpt WHERE hpt.id=intValue and hpt.is_active IS TRUE and hpt.name='commercial') INTO booleanValue;
			IF booleanValue IS FALSE THEN
				select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN TYPE commercial  DOES NOT EXISTS ');
			END IF;
		END IF;

--VALIDATE HEALTH PLAN EXISTS (health_plan_hix) AND IS ACTIVE
		SELECT EXISTS (SELECT 1 FROM health_plans h WHERE h.name='health_plan_hix' and h.is_active IS TRUE) INTO booleanValue;
		IF booleanValue IS FALSE THEN
			select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN health_plan_hix  DOES NOT EXISTS OR IS INACTIVE');

		ELSE
			--VALIDATE HEALTH PLAN TYPE EXISTS
			SELECT h.health_plan_type_id INTO intValue FROM health_plans h WHERE h.name='health_plan_hix';
			SELECT EXISTS (SELECT 1 FROM health_plan_types hpt WHERE hpt.id=intValue and hpt.is_active IS TRUE and hpt.name='hix') INTO booleanValue;
			IF booleanValue IS FALSE THEN
				select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN TYPE '|| intValue ||' DOES NOT EXISTS ');
			END IF;
		END IF;


--VALIDATE HEALTH PLAN EXISTS AND IS ACTIVE
		SELECT EXISTS (SELECT 1 FROM health_plans h WHERE h.name='health_plan_bcbs' and h.is_active IS TRUE) INTO booleanValue;
		IF booleanValue IS FALSE THEN
			select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN health_plan_bcbs DOES NOT EXISTS OR IS INACTIVE');

		ELSE
			--VALIDATE HEALTH PLAN TYPE EXISTS
			SELECT h.health_plan_type_id INTO intValue FROM health_plans h WHERE h.name='health_plan_bcbs';
			SELECT EXISTS (SELECT 1 FROM health_plan_types hpt WHERE hpt.id=intValue and hpt.is_active IS TRUE and hpt.name='commercial_bcbs') INTO booleanValue;
			IF booleanValue IS FALSE THEN
				select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN TYPE commercial_bcbs DOES NOT EXISTS ');
			END IF;
		END IF;

--VALIDATE HEALTH PLAN health_plan_empl EXISTS AND IS ACTIVE
		SELECT EXISTS (SELECT 1 FROM health_plans h WHERE h.name='health_plan_empl' and h.is_active IS TRUE) INTO booleanValue;
		IF booleanValue IS FALSE THEN
			select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN health_plan_empl DOES NOT EXISTS OR IS INACTIVE');

		ELSE
			--VALIDATE HEALTH PLAN TYPE EXISTS
			SELECT h.health_plan_type_id INTO intValue FROM health_plans h WHERE h.name='health_plan_empl';
			SELECT EXISTS (SELECT 1 FROM health_plan_types hpt WHERE hpt.id=intValue and hpt.is_active IS TRUE and hpt.name='employer') INTO booleanValue;
			IF booleanValue IS FALSE THEN
				select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN TYPE employer DOES NOT EXISTS ');
			END IF;
		END IF;


--VALIDATE HEALTH PLAN EXISTS AND IS ACTIVE
		SELECT EXISTS (SELECT 1 FROM health_plans h WHERE h.name='health_plan_ma' and h.is_active IS TRUE) INTO booleanValue;
		IF booleanValue IS FALSE THEN
			select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN health_plan_ma DOES NOT EXISTS OR IS INACTIVE');

		ELSE
			--VALIDATE HEALTH PLAN TYPE EXISTS
			SELECT h.health_plan_type_id INTO intValue FROM health_plans h WHERE h.name='health_plan_ma';
			SELECT EXISTS (SELECT 1 FROM health_plan_types hpt WHERE hpt.id=intValue and hpt.is_active IS TRUE and hpt.name='medicare_ma') INTO booleanValue;
			IF booleanValue IS FALSE THEN
				select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN TYPE medicare_ma DOES NOT EXISTS ');
			END IF;
		END IF;


--VALIDATE HEALTH PLAN EXISTS AND IS ACTIVE
		SELECT EXISTS (SELECT 1 FROM health_plans h WHERE h.name='health_plan_sn' and h.is_active IS TRUE) INTO booleanValue;
		IF booleanValue IS FALSE THEN
			select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN health_plan_sn DOES NOT EXISTS OR IS INACTIVE');

		ELSE
			--VALIDATE HEALTH PLAN TYPE EXISTS
			SELECT h.health_plan_type_id INTO intValue FROM health_plans h WHERE h.name='health_plan_sn';
			SELECT EXISTS (SELECT 1 FROM health_plan_types hpt WHERE hpt.id=intValue and hpt.is_active IS TRUE and hpt.name='medicare_sn') INTO booleanValue;
			IF booleanValue IS FALSE THEN
				select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN TYPE medicare_sn DOES NOT EXISTS ');
			END IF;
		END IF;


--VALIDATE HEALTH PLAN EXISTS AND IS ACTIVE
		SELECT EXISTS (SELECT 1 FROM health_plans h WHERE h.name='health_plan_pdp' and h.is_active IS TRUE) INTO booleanValue;
		IF booleanValue IS FALSE THEN
			select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN health_plan_pdp DOES NOT EXISTS OR IS INACTIVE');

		ELSE
			--VALIDATE HEALTH PLAN TYPE EXISTS
			SELECT h.health_plan_type_id INTO intValue FROM health_plans h WHERE h.name='health_plan_pdp';
			SELECT EXISTS (SELECT 1 FROM health_plan_types hpt WHERE hpt.id=intValue and hpt.is_active IS TRUE and hpt.name='medicare_pdp') INTO booleanValue;
			IF booleanValue IS FALSE THEN
				select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN TYPE medicare_pdp DOES NOT EXISTS ');
			END IF;
		END IF;

--VALIDATE HEALTH PLAN EXISTS AND IS ACTIVE
		SELECT EXISTS (SELECT 1 FROM health_plans h WHERE h.name='health_plan_state' and h.is_active IS TRUE) INTO booleanValue;
		IF booleanValue IS FALSE THEN
			select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN health_plan_state DOES NOT EXISTS OR IS INACTIVE');

		ELSE
			--VALIDATE HEALTH PLAN TYPE EXISTS
			SELECT h.health_plan_type_id INTO intValue FROM health_plans h WHERE h.name='health_plan_state';
			SELECT EXISTS (SELECT 1 FROM health_plan_types hpt WHERE hpt.id=intValue and hpt.is_active IS TRUE and hpt.name='state_medicare') INTO booleanValue;
			IF booleanValue IS FALSE THEN
				select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN TYPE '|| intValue ||' DOES NOT EXISTS ');
			END IF;
		END IF;



--VALIDATE HEALTH PLAN EXISTS AND IS ACTIVE
		SELECT EXISTS (SELECT 1 FROM health_plans h WHERE h.name='health_plan_dpp' and h.is_active IS TRUE) INTO booleanValue;
		IF booleanValue IS FALSE THEN
			select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN health_plan_dpp DOES NOT EXISTS OR IS INACTIVE');

		ELSE
			--VALIDATE HEALTH PLAN TYPE EXISTS
			SELECT h.health_plan_type_id INTO intValue FROM health_plans h WHERE h.name='health_plan_dpp';
			SELECT EXISTS (SELECT 1 FROM health_plan_types hpt WHERE hpt.id=intValue and hpt.is_active IS TRUE and hpt.name='dpp') INTO booleanValue;
			IF booleanValue IS FALSE THEN
				select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN TYPE dpp DOES NOT EXISTS ');
			END IF;
		END IF;

--VALIDATE HEALTH PLAN EXISTS AND IS ACTIVE
		SELECT EXISTS (SELECT 1 FROM health_plans h WHERE h.name='health_plan_com_med' and h.is_active IS TRUE) INTO booleanValue;
		IF booleanValue IS FALSE THEN
			select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN health_plan_com_med DOES NOT EXISTS OR IS INACTIVE');

		ELSE
			--VALIDATE HEALTH PLAN TYPE EXISTS
			SELECT h.health_plan_type_id INTO intValue FROM health_plans h WHERE h.name='health_plan_com_med';
			SELECT EXISTS (SELECT 1 FROM health_plan_types hpt WHERE hpt.id=intValue and hpt.is_active IS TRUE and hpt.name='commercial_medicaid') INTO booleanValue;
			IF booleanValue IS FALSE THEN
				select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN TYPE commercial_medicaid DOES NOT EXISTS ');
			END IF;
		END IF;


--VALIDATE HEALTH PLAN EXISTS AND IS ACTIVE
		SELECT EXISTS (SELECT 1 FROM health_plans h WHERE h.name='health_plan_union' and h.is_active IS TRUE) INTO booleanValue;
		IF booleanValue IS FALSE THEN
			select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN health_plan_union DOES NOT EXISTS OR IS INACTIVE');

		ELSE
			--VALIDATE HEALTH PLAN TYPE EXISTS
			SELECT h.health_plan_type_id INTO intValue FROM health_plans h WHERE h.name='health_plan_union';
			SELECT EXISTS (SELECT 1 FROM health_plan_types hpt WHERE hpt.id=intValue and hpt.is_active IS TRUE and hpt.name='union') INTO booleanValue;
			IF booleanValue IS FALSE THEN
				select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN TYPE union DOES NOT EXISTS ');
			END IF;
		END IF;

--VALIDATE HEALTH PLAN EXISTS AND IS ACTIVE
		SELECT EXISTS (SELECT 1 FROM health_plans h WHERE h.name='health_plan_mun' and h.is_active IS TRUE) INTO booleanValue;
		IF booleanValue IS FALSE THEN
			select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN health_plan_mun DOES NOT EXISTS OR IS INACTIVE');

		ELSE
			--VALIDATE HEALTH PLAN TYPE EXISTS
			SELECT h.health_plan_type_id INTO intValue FROM health_plans h WHERE h.name='health_plan_mun';
			SELECT EXISTS (SELECT 1 FROM health_plan_types hpt WHERE hpt.id=intValue and hpt.is_active IS TRUE and hpt.name='municipal_plan') INTO booleanValue;
			IF booleanValue IS FALSE THEN
				select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN TYPE municipal_plan DOES NOT EXISTS ');
			END IF;
		END IF;

--VALIDATE HEALTH PLAN EXISTS AND IS ACTIVE
		SELECT EXISTS (SELECT 1 FROM health_plans h WHERE h.name='health_plan_pbm' and h.is_active IS TRUE) INTO booleanValue;
		IF booleanValue IS FALSE THEN
			select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN health_plan_pbm DOES NOT EXISTS OR IS INACTIVE');

		ELSE
			--VALIDATE HEALTH PLAN TYPE EXISTS
			SELECT h.health_plan_type_id INTO intValue FROM health_plans h WHERE h.name='health_plan_pbm';
			SELECT EXISTS (SELECT 1 FROM health_plan_types hpt WHERE hpt.id=intValue and hpt.is_active IS TRUE and hpt.name='pbm') INTO booleanValue;
			IF booleanValue IS FALSE THEN
				select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN TYPE pbm DOES NOT EXISTS ');
			END IF;
		END IF;

--VALIDATE HEALTH PLAN EXISTS AND IS ACTIVE
		SELECT EXISTS (SELECT 1 FROM health_plans h WHERE h.name='health_plan_comm_1' and h.is_active IS TRUE) INTO booleanValue;
		IF booleanValue IS FALSE THEN
			select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN health_plan_comm_1 DOES NOT EXISTS OR IS INACTIVE');

		ELSE
			--VALIDATE HEALTH PLAN TYPE EXISTS
			SELECT h.health_plan_type_id INTO intValue FROM health_plans h WHERE h.name='health_plan_comm_1';
			SELECT EXISTS (SELECT 1 FROM health_plan_types hpt WHERE hpt.id=intValue and hpt.is_active IS TRUE and hpt.name='commercial') INTO booleanValue;
			IF booleanValue IS FALSE THEN
				select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN TYPE commercial DOES NOT EXISTS ');
			END IF;
		END IF;

--VALIDATE HEALTH PLAN EXISTS AND IS ACTIVE
		SELECT EXISTS (SELECT 1 FROM health_plans h WHERE h.name='health_plan_comm_2' and h.is_active IS TRUE) INTO booleanValue;
		IF booleanValue IS TRUE THEN
			select throw_error('test_001_validate_test_data-error: EXPECTED HEALTH PLAN health_plan_comm_2 SHOULD NOT EXISTS');
		END IF;


success:=true;
RETURN success;	  	
END
$$ LANGUAGE plpgsql;