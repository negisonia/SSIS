CREATE OR REPLACE FUNCTION restrictions_test_005_validate_test_data() --FRONT END DB
RETURNS boolean AS $$
DECLARE
success boolean DEFAULT FALSE;

drug_1 INTEGER;
drug_2 INTEGER;
drug_3 INTEGER;
drug_4 INTEGER;
drug_5 INTEGER;
drug_6 INTEGER;
drug_7 INTEGER;
drug_8 INTEGER;
drug_9 INTEGER;
drug_10 INTEGER;
drug_11 INTEGER;

commercial_hpt_id INTEGER;
hix_hpt_id INTEGER;
commercial_bcbs_hpt_id INTEGER;
employer_hpt_id INTEGER;
medicare_ma_hpt_id INTEGER;
medicare_sn_hpt_id INTEGER;
medicare_pdp_hpt_id INTEGER;
state_medicare_hpt_id INTEGER;
dpp_hpt_id INTEGER;
commercial_medicaid_hpt_id INTEGER;
union_hpt_id INTEGER;
municipal_plan_hpt_id INTEGER;
pbm_hpt_id INTEGER;
commercial_inactive_hpt_id INTEGER;


health_plan_commercial INTEGER;
health_plan_hix INTEGER;
health_plan_com_inactive INTEGER;

tier_1 INTEGER;
tier_2 INTEGER;
tier_3 INTEGER;
tier_3p INTEGER;
tier_4 INTEGER;

existsValue BOOLEAN;

BEGIN

--RETRIEVE DRUGS IDS
    SELECT d.id INTO drug_1 FROM drugs d WHERE d.name='drug_1';
    SELECT d.id INTO drug_2 FROM drugs d WHERE d.name='drug_2';
    SELECT d.id INTO drug_3 FROM drugs d WHERE d.name='drug_3';
    SELECT d.id INTO drug_4 FROM drugs d WHERE d.name='drug_4';
    SELECT d.id INTO drug_5 FROM drugs d WHERE d.name='drug_5';
    SELECT d.id INTO drug_6 FROM drugs d WHERE d.name='drug_6';
    SELECT d.id INTO drug_7 FROM drugs d WHERE d.name='drug_7';
    SELECT d.id INTO drug_8 FROM drugs d WHERE d.name='drug_8';
    SELECT d.id INTO drug_9 FROM drugs d WHERE d.name='drug_9';
    SELECT d.id INTO drug_10 FROM drugs d WHERE d.name='drug_10_inactive';
    SELECT d.id INTO drug_11 FROM drugs d WHERE d.name='drug_11_inactive';

	--RETRIEVE HEALTH PLAN TYPES
    SELECT hpt.id FROM health_plan_types hpt WHERE hpt.name='commercial' INTO commercial_hpt_id;
    SELECT hpt.id FROM health_plan_types hpt WHERE hpt.name='hix' INTO hix_hpt_id;
    SELECT hpt.id FROM health_plan_types hpt WHERE hpt.name='commercial_bcbs' INTO commercial_bcbs_hpt_id;
    SELECT hpt.id FROM health_plan_types hpt WHERE hpt.name='employer' INTO employer_hpt_id;
    SELECT hpt.id FROM health_plan_types hpt WHERE hpt.name='medicare_ma' INTO medicare_ma_hpt_id;
    SELECT hpt.id FROM health_plan_types hpt WHERE hpt.name='medicare_sn' INTO medicare_sn_hpt_id;
    SELECT hpt.id FROM health_plan_types hpt WHERE hpt.name='medicare_pdp' INTO medicare_pdp_hpt_id;
    SELECT hpt.id FROM health_plan_types hpt WHERE hpt.name='state_medicare' INTO state_medicare_hpt_id;
    SELECT hpt.id FROM health_plan_types hpt WHERE hpt.name='dpp' INTO dpp_hpt_id;
    SELECT hpt.id FROM health_plan_types hpt WHERE hpt.name='commercial_medicaid' INTO commercial_medicaid_hpt_id;
    SELECT hpt.id FROM health_plan_types hpt WHERE hpt.name='union' INTO union_hpt_id;
    SELECT hpt.id FROM health_plan_types hpt WHERE hpt.name='municipal_plan' INTO municipal_plan_hpt_id;
    SELECT hpt.id FROM health_plan_types hpt WHERE hpt.name='pbm' INTO pbm_hpt_id;
    SELECT hpt.id FROM health_plan_types hpt WHERE hpt.name='commercial_inactive' INTO commercial_inactive_hpt_id;

--RETRIEVE HEALTHPLANS IDS
SELECT hp.id INTO health_plan_commercial FROM health_plans hp where hp.name='health_plan_comm';
SELECT hp.id INTO health_plan_hix FROM health_plans hp where hp.name='health_plan_hix';
SELECT hp.id INTO health_plan_com_inactive FROM health_plans hp where hp.name='health_plan_com_inactive';


--RETRIEVE TIER IDS
SELECT t.id INTO tier_1 FROM tiers t WHERE t.name='tier_1';
SELECT t.id INTO tier_2 FROM tiers t WHERE t.name='tier_2';
SELECT t.id INTO tier_3 FROM tiers t WHERE t.name='tier_3';
SELECT t.id INTO tier_3p FROM tiers t WHERE t.name='tier_3p';
SELECT t.id INTO tier_4 FROM tiers t WHERE t.name='tier_4';

--FORMULARY 1
SELECT EXISTS(SELECT 1 FROM formulary_detail fd WHERE fd.health_plan_id=health_plan_commercial and fd.health_plan_name='health_plan_comm'
              and fd.drug_id=drug_1 and fd.drug_name='drug_1' and fd.health_plan_type_id=commercial_hpt_id and fd.health_plan_type_name='commercial'
              and fd.tier_id=tier_1 and fd.has_quantity_limit IS TRUE and fd.has_prior_authorization IS TRUE and fd.has_step_therapy IS FALSE and fd.has_other_restriction IS FALSE
              and fd.reason_code_code='92' and fd.reason_code_desc='PA required if recommended dose duration exceeded.') INTO existsValue;

IF existsValue IS FALSE THEN
    select throw_error('EXPECTED DATA FOR  FORMULARY#1 IS WRONG');
END IF;


--FORMULARY 2
SELECT EXISTS(SELECT 1 FROM formulary_detail fd WHERE fd.health_plan_id=health_plan_hix and fd.health_plan_name='health_plan_hix'
              and fd.drug_id=drug_2 and fd.drug_name='drug_2' and fd.health_plan_type_id=hix_hpt_id and fd.health_plan_type_name='hix'
              and fd.tier_id=tier_2 and fd.has_quantity_limit IS FALSE and fd.has_prior_authorization IS TRUE and fd.has_step_therapy IS TRUE and fd.has_other_restriction IS FALSE
              and fd.reason_code_code='40' and fd.reason_code_desc='Covered under medical benefit.') INTO existsValue;

IF existsValue IS FALSE THEN
    select throw_error('EXPECTED DATA FOR  FORMULARY#2 IS WRONG');
END IF;

--FORMULARY 3
SELECT EXISTS(SELECT 1 FROM formulary_detail fd WHERE fd.health_plan_id=health_plan_commercial and fd.health_plan_name='health_plan_comm'
              and fd.drug_id=drug_2 and fd.drug_name='drug_2' and fd.health_plan_type_id=commercial_hpt_id and fd.health_plan_type_name='commercial'
              and fd.tier_id=tier_3 and fd.has_quantity_limit IS FALSE and fd.has_prior_authorization IS FALSE and fd.has_step_therapy IS FALSE and fd.has_other_restriction IS FALSE
              and fd.reason_code_code='42' and fd.reason_code_desc='Non-preferred under medical benefit.') INTO existsValue;

IF existsValue IS FALSE THEN
    select throw_error('EXPECTED DATA FOR  FORMULARY#3 IS WRONG');
END IF;


--FORMULARY 4
SELECT EXISTS(SELECT 1 FROM formulary_detail fd WHERE fd.health_plan_id=health_plan_hix and fd.health_plan_name='health_plan_hix'
              and fd.drug_id=drug_1 and fd.drug_name='drug_1' and fd.health_plan_type_id=hix_hpt_id and fd.health_plan_type_name='hix'
              and fd.tier_id=tier_3P and fd.has_quantity_limit IS FALSE and fd.has_prior_authorization IS TRUE and fd.has_step_therapy IS FALSE and fd.has_other_restriction IS FALSE
              and fd.reason_code_code='90' and fd.reason_code_desc='PA not required on initial fill.') INTO existsValue;

IF existsValue IS FALSE THEN
    select throw_error('EXPECTED DATA FOR  FORMULARY#4 IS WRONG');
END IF;


--FORMULARY 5
SELECT EXISTS(SELECT 1 FROM formulary_detail fd WHERE fd.health_plan_id=health_plan_hix and fd.health_plan_name='health_plan_hix'
              and fd.drug_id=drug_3 and fd.drug_name='drug_3' and fd.health_plan_type_id=hix_hpt_id and fd.health_plan_type_name='hix'
              and fd.tier_id=tier_4 and fd.has_quantity_limit IS TRUE and fd.has_prior_authorization IS FALSE and fd.has_step_therapy IS FALSE and fd.has_other_restriction IS FALSE
              and fd.reason_code_code='41' and fd.reason_code_desc='Preferred under medical benefit') INTO existsValue;

IF existsValue IS FALSE THEN
    select throw_error('EXPECTED DATA FOR  FORMULARY#5 IS WRONG');
END IF;


--FORMULARY 6
SELECT EXISTS(SELECT 1 FROM formulary_detail fd WHERE fd.health_plan_id=health_plan_hix and fd.health_plan_name='health_plan_hix'
              and fd.drug_id=drug_4 and fd.drug_name='drug_4' and fd.health_plan_type_id=hix_hpt_id and fd.health_plan_type_name='hix'
              and fd.tier_id=tier_4 and fd.has_quantity_limit IS FALSE and fd.has_prior_authorization IS FALSE and fd.has_step_therapy IS TRUE and fd.has_other_restriction IS TRUE
              and fd.reason_code_code='60' and fd.reason_code_desc='Age restriction, PA may be required.') INTO existsValue;

IF existsValue IS FALSE THEN
    select throw_error('EXPECTED DATA FOR  FORMULARY#6 IS WRONG');
END IF;

--FORMULARY 7
SELECT EXISTS(SELECT 1 FROM formulary_detail fd WHERE fd.health_plan_id=health_plan_commercial and fd.health_plan_name='health_plan_comm'
              and fd.drug_id=drug_5 and fd.drug_name='drug_5' and fd.health_plan_type_id=commercial_hpt_id and fd.health_plan_type_name='commercial'
              and fd.tier_id=tier_4 and fd.has_quantity_limit IS FALSE and fd.has_prior_authorization IS FALSE and fd.has_step_therapy IS FALSE and fd.has_other_restriction IS FALSE
              and fd.reason_code_code='42' and fd.reason_code_desc='Non-preferred under medical benefit.') INTO existsValue;

IF existsValue IS FALSE THEN
    select throw_error('EXPECTED DATA FOR  FORMULARY#7 IS WRONG');
END IF;

--FORMULARY 8
SELECT EXISTS(SELECT 1 FROM formulary_detail fd WHERE fd.health_plan_id=health_plan_commercial and fd.health_plan_name='health_plan_comm'
              and fd.drug_id=drug_6 and fd.drug_name='drug_6' and fd.health_plan_type_id=commercial_hpt_id and fd.health_plan_type_name='commercial'
              and fd.tier_id=tier_4 and fd.has_quantity_limit IS TRUE and fd.has_prior_authorization IS TRUE and fd.has_step_therapy IS FALSE and fd.has_other_restriction IS FALSE
              and fd.reason_code_code IS NULL and fd.reason_code_desc IS NULL) INTO existsValue;

IF existsValue IS FALSE THEN
    select throw_error('EXPECTED DATA FOR  FORMULARY#8 IS WRONG');
END IF;

--FORMULARY 9
SELECT EXISTS(SELECT 1 FROM formulary_detail fd WHERE fd.health_plan_id=health_plan_commercial and fd.health_plan_name='health_plan_comm'
              and fd.drug_id=drug_7 and fd.drug_name='drug_7' and fd.health_plan_type_id=commercial_hpt_id and fd.health_plan_type_name='commercial'
              and fd.tier_id=tier_4 and fd.has_quantity_limit IS FALSE and fd.has_prior_authorization IS FALSE and fd.has_step_therapy IS FALSE and fd.has_other_restriction IS FALSE
              and fd.reason_code_code IS NULL and fd.reason_code_desc IS NULL) INTO existsValue;

IF existsValue IS FALSE THEN
    select throw_error('EXPECTED DATA FOR  FORMULARY#9 IS WRONG');
END IF;

--FORMULARY 10
SELECT EXISTS(SELECT 1 FROM formulary_detail fd WHERE fd.health_plan_id=health_plan_com_inactive and fd.health_plan_name='health_plan_com_inactive' and fd.drug_id=drug_2 and fd.tier_id=tier_3p) INTO existsValue;

IF existsValue IS TRUE THEN
    select throw_error('FORMULARY#10 SHOULD NOT EXISTS');
END IF;

--FORMULARY 11
SELECT EXISTS(SELECT 1 FROM formulary_detail fd WHERE fd.health_plan_id=health_plan_com_inactive and fd.health_plan_name='health_plan_com_inactive' and fd.drug_id=drug_1 and fd.tier_id=tier_1) INTO existsValue;

IF existsValue IS TRUE THEN
    select throw_error('FORMULARY#11 SHOULD NOT EXISTS');
END IF;


--FORMULARY 12
SELECT EXISTS(SELECT 1 FROM formulary_detail fd WHERE fd.health_plan_id=health_plan_hix and fd.health_plan_name='health_plan_hix' and fd.drug_id=drug_11 and fd.tier_id=tier_2) INTO existsValue;

IF existsValue IS TRUE THEN
    select throw_error('FORMULARY#12 SHOULD NOT EXISTS');
END IF;

--FORMULARY 13
SELECT EXISTS(SELECT 1 FROM formulary_detail fd WHERE fd.health_plan_id=health_plan_commercial and fd.health_plan_name='health_plan_comm' and fd.drug_id=drug_11 and fd.tier_id=tier_4) INTO existsValue;

IF existsValue IS TRUE THEN
    select throw_error('FORMULARY#13 SHOULD NOT EXISTS');
END IF;

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;