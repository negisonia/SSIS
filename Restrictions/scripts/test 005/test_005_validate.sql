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

 restrictions_test_commercial_id INTEGER;
 restrictions_test_hix_id INTEGER;
 restrictions_test_commercial_bcbs_id INTEGER;
 restrictions_test_employer_id INTEGER;
 restrictions_test_medicare_ma_id INTEGER;
 restrictions_test_medicare_sn_id INTEGER;
 restrictions_test_medicare_pdp_id INTEGER;
 restrictions_test_state_medicare_id INTEGER;
 restrictions_test_dpp_id INTEGER;
 restrictions_test_commercial_medicaid_id INTEGER;
 restrictions_test_union_id INTEGER;
 restrictions_test_municipal_plan_id INTEGER;
 restrictions_test_pbm_id INTEGER;

health_plan1 INTEGER;
health_plan2 INTEGER;
health_plan3 INTEGER;
health_plan4 INTEGER;
health_plan5 INTEGER;
health_plan6 INTEGER;
health_plan7 INTEGER;
health_plan8 INTEGER;
health_plan9 INTEGER;
health_plan10 INTEGER;
health_plan11 INTEGER;
health_plan12 INTEGER;
health_plan13 INTEGER;

tier_1 INTEGER;
tier_2 INTEGER;
tier_3 INTEGER;
tier_3p INTEGER;
tier_4 INTEGER;

booleanValue BOOLEAN;

BEGIN

--RETRIEVE DRUGS IDS
SELECT d.id INTO drug_1 FROM drug d WHERE d.name='restrictions_drug_1';
SELECT d.id INTO drug_2 FROM drug d WHERE d.name='restrictions_drug_2';
SELECT d.id INTO drug_3 FROM drug d WHERE d.name='restrictions_drug_3';
SELECT d.id INTO drug_4 FROM drug d WHERE d.name='restrictions_drug_4';
SELECT d.id INTO drug_5 FROM drug d WHERE d.name='restrictions_drug_5';
SELECT d.id INTO drug_6 FROM drug d WHERE d.name='restrictions_drug_6';
SELECT d.id INTO drug_7 FROM drug d WHERE d.name='restrictions_drug_7';
SELECT d.id INTO drug_8 FROM drug d WHERE d.name='restrictions_drug_8';
SELECT d.id INTO drug_9 FROM drug d WHERE d.name='restrictions_drug_9';
SELECT d.id INTO drug_10 FROM drug d WHERE d.name='restrictions_drug_10';
SELECT d.id INTO drug_11 FROM drug d WHERE d.name='restrictions_drug_11';

--RETRIEVE HEALTHPLAN TYPE IDS
SELECT hpt.id INTO restrictions_test_commercial_id FROM health_plan_types hpt WHERE hpt.name = 'restrictions_test_commercial';
SELECT hpt.id INTO restrictions_test_hix_id FROM health_plan_types hpt WHERE hpt.name = 'restrictions_test_hix';
SELECT hpt.id INTO restrictions_test_commercial_bcbs_id FROM health_plan_types hpt WHERE hpt.name = 'restrictions_test_commercial_bcbs';
SELECT hpt.id INTO restrictions_test_employer_id FROM health_plan_types hpt WHERE hpt.name = 'restrictions_test_employer';
SELECT hpt.id INTO restrictions_test_medicare_ma_id FROM health_plan_types hpt WHERE hpt.name = 'restrictions_test_medicare_ma';
SELECT hpt.id INTO restrictions_test_medicare_sn_id FROM health_plan_types hpt WHERE hpt.name = 'restrictions_test_medicare_sn';
SELECT hpt.id INTO restrictions_test_medicare_pdp_id FROM health_plan_types hpt WHERE hpt.name = 'restrictions_test_medicare_pdp';
SELECT hpt.id INTO restrictions_test_state_medicare_id FROM health_plan_types hpt WHERE hpt.name = 'restrictions_test_state_medicare';
SELECT hpt.id INTO restrictions_test_dpp_id FROM health_plan_types hpt WHERE hpt.name = 'restrictions_test_dpp';
SELECT hpt.id INTO restrictions_test_commercial_medicaid_id FROM health_plan_types hpt WHERE hpt.name = 'restrictions_test_commercial_medicaid';
SELECT hpt.id INTO restrictions_test_union_id FROM health_plan_types hpt WHERE hpt.name = 'restrictions_test_union';
SELECT hpt.id INTO restrictions_test_municipal_plan_id  FROM health_plan_types hpt  WHERE hpt.name = 'restrictions_test_municipal_plan';
SELECT hpt.id INTO restrictions_test_pbm_id  FROM health_plan_types hpt WHERE hpt.name = 'restrictions_test_pbm';

--RETRIEVE HEALTHPLANS IDS
SELECT hp.id INTO health_plan1 FROM health_plans h where h.name='restrictions_test_05_commercial_1';
SELECT hp.id INTO health_plan2 FROM health_plans h where h.name='restrictions_test_05_hix_1';
SELECT hp.id INTO health_plan3 FROM health_plans h where h.name='restrictions_test_05_commercial_2';
SELECT hp.id INTO health_plan4 FROM health_plans h where h.name='restrictions_test_05_hix_2';
SELECT hp.id INTO health_plan5 FROM health_plans h where h.name='restrictions_test_05_hix_3';
SELECT hp.id INTO health_plan6 FROM health_plans h where h.name='restrictions_test_05_hix_4';
SELECT hp.id INTO health_plan7 FROM health_plans h where h.name='restrictions_test_05_commercial_3';
SELECT hp.id INTO health_plan8 FROM health_plans h where h.name='restrictions_test_05_commercial_4';
SELECT hp.id INTO health_plan9 FROM health_plans h where h.name='restrictions_test_05_commercial_5';
SELECT hp.id INTO health_plan10 FROM health_plans h where h.name='restrictions_test_05_commercial_6';
SELECT hp.id INTO health_plan11 FROM health_plans h where h.name='restrictions_test_05_commercial_7';
SELECT hp.id INTO health_plan12 FROM health_plans h where h.name='restrictions_test_05_hix_5';
SELECT hp.id INTO health_plan13 FROM health_plans h where h.name='restrictions_test_05_commercial_8';


--RETRIEVE TIER IDS
SELECT t.id INTO tier_1 FROM tiers t WHERE t.name='restrictions_tier_1';
SELECT t.id INTO tier_2 FROM tiers t WHERE t.name='restrictions_tier_2';
SELECT t.id INTO tier_3 FROM tiers t WHERE t.name='restrictions_tier_3';
SELECT t.id INTO tier_4 FROM tiers t WHERE t.name='restrictions_tier_3p';
SELECT t.id INTO tier_5 FROM tiers t WHERE t.name='restrictions_tier_4';

--FORMULARY 1
SELECT EXISTS(SELECT 1 FROM formulary_detail fd WHERE fd.health_plan_id=health_plan1 and fd.health_plan_name='restrictions_test_05_commercial_1' and fd.drug_id=drug_1 and fd.drug_name='restrictions_drug_1' and fd.health_plan_type_id=restrictions_test_commercial_id and fd.health_plan_type_name='restrictions_test_commercial' and fd.tier_id=tier_1 and fd.has_quantity_limit IS TRUE and fd.has_prior_authorization IS TRUE)


success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;